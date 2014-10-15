#!/usr/bin/env python
# -*- coding: UTF-8 -*-

#======================================================
 #            net_client.py
 #
 #  Sat July 23 18:07 2005
 #  Copyright  2005  Josh Mattila
 #
 #  Other authors may add their names above!
 #
 #  jm6.linux@gmail.com
#======================================================
 
#
 #  This program is free software; you can redistribute it and/or modify
 #  it under the terms of the GNU General Public License as published by
 #  the Free Software Foundation; either version 2 of the License, or
 #  (at your option) any later version.
 #
 #  This program is distributed in the hope that it will be useful,
 #  but WITHOUT ANY WARRANTY; without even the implied warranty of
 #  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 #  GNU Library General Public License for more details.
 #
 #  You should have received a copy of the GNU General Public License
 #  along with this program; if not, write to the Free Software
 #  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
#

import os,wx,misc,socket,threading,Queue,time,md5,base64


from GLOBAL import *

class pingTimer(wx.Timer):

    m_client = None

    def Notify(self):
        self.m_client.sendPing()
        
    def UpdateClient(self, cl):
        self.m_client = cl
        
class recvTimer(wx.Timer):

    m_client = None

    def Notify(self):
        self.m_client.receiveData()
        
    def UpdateClient(self, cl):
        self.m_client = cl

class client:
    
    client_connected = False
    client_ip = ""
    client_status = 0           # see MYSTATUS command for actual values of status
    client_battleStatus = 0     # see MYBATTLESTATUS command for actual values of battleStatus
    client_battleID = 0         # battle ID in which client is participating. Must be -1 if not participating in any battle.
    client_inGameTime = 0
    client_country = ""
    client_cpu = 0              # in MHz if possible, or in MHz*1.4 if AMD. 0 means the client cant figure out its CPU speed.

    server_address = ""
    server_port = 0
    server_timeout = 30         # In seconds
    server_pingrate = 10        # The rate at which pings are sent in seconds
    server_pings_sent = 0       # The number of pings sent since a PONG message has been received

    client_username = ""
    client_password = ""
    client_cpu = 0
    client_localIP = ""

    receivingFile = False       # true if we are sending some file to this client
    cancelTransfer = False      # we use it to signal the SendFileThread to stop sending file
    recvThread_running = False
    
    client_socket = None
    client_messageQueue = None
    client_sendQueue = None
    
    client_recvTimer = None
    client_pingTimer = None
    
    last_command = ""
    
    parent_window = None
    
    count_send = 0
    count = 0



# __init__() =======================================================================================
# ==================================================================================================
#  The function that initializes the network connection/socket with
#  the spring server.  It takes two arguments that only exist for
#  convenience.  In almost all cases, it is much better to use the
#  built-in config.Read() command to get usernames and passwords.
# ==================================================================================================
    def __init__(self, parent, username="", password=""):

        # Initialize variables
        config = wx.Config().Get()
        
        self.server_address = str(config.Read("/Global/SpringServer"))
        self.server_port = config.ReadInt("/Global/SpringServerPort")
        
        self.client_messageQueue = Queue.Queue()
        self.client_sendQueue = Queue.Queue()
        
        self.client_pingTimer = pingTimer()
        self.client_pingTimer.UpdateClient(self)
        
        self.client_recvTimer = recvTimer()
        self.client_recvTimer.UpdateClient(self)
        
        self.client_socket = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            
        self.parent_window = parent
        self.client_localIP = "*"
        
        #Get the correct username from the right place
        if not config.Read("/Player/Name") == "" and username == "":
            self.client_username = config.Read("/Player/Name")
            
        elif not username == "":
            self.client_username = username.rstrip("\n")
            
        else:
            #Cant find the username anywhere, Finally just ask for it using a dialog
            getuser = wx.TextEntryDialog(parent, "Enter your username to connect to " + self.server_address + ":", "Enter username", "", wx.OK|wx.CANCEL)
            choice = getuser.ShowModal()
            
            if choice == wx.ID_OK:
            
                if getuser.GetValue() != "":
                
                    self.client_username = getuser.GetValue().rstrip("\n")
                    #config.Write("/Player/Name", self.client_username)

                    getuser.Close(True)
                
                else:
                    misc.CreateMessageBox(parent, MSGBOX_ERROR, "Username entered is invalid.\nYou will be unable to join the server without a username.")
                    getuser.Close(True)
                    return None
                    
            else:
                getuser.Close(True)
                return None
        
        #Get the correct password from the right place
        u = md5.new(password).digest()
        encoded_pass = base64.encodestring(u)
        
        if password != "":
            self.client_password = encoded_pass.rstrip("\n")
            
        elif config.ReadBool("/Player/RememberPass") == True and config.Read("/Player/Password") != "":
            self.client_password = config.Read("/Player/Password")
            
        else:
        
            #Cant find the password anywhere, Finally just ask for it using a dialog
            getpass = wx.TextEntryDialog(parent, "Enter your password to connect to " + self.server_address + "\nwith username '" + self.client_username + "':", "Enter password", "", wx.OK|wx.CANCEL|wx.TE_PASSWORD)
            choice = getpass.ShowModal()
            
            if choice == wx.ID_OK:
            
                if not getpass.GetValue() == "":
                    u = md5.new(getpass.GetValue()).digest()
                    encoded_dialog_pass = base64.encodestring(u)
                    
                    self.client_password = encoded_dialog_pass.rstrip("\n")
                    getpass.Close(True)
                else:
                    misc.CreateMessageBox(parent, MSGBOX_ERROR, "Password entered is invalid.\nYou will be unable to join the server without a valid password.")
                    getpass.Close(True)
                    return None
                    
            else:
                getpass.Close(True)
                return None
        
# /end __init__() ==================================================================================





# connect() ========================================================================================
# ==================================================================================================
#  The function that connects the socket with the spring
#  master server.  Placing this here ensures that only
#  initialization goes in the __init__() function.
# ==================================================================================================
    def connect(self):  
        try:
            self.client_socket.connect((self.server_address, self.server_port))
            self.parent_window.debug_handler.output("Connected to '" + self.server_address + "' on port " + str(self.server_port) + ".", DEBUG_USELESS)

            
        except socket.error, msg:
            self.client_socket.close()
            self.parent_window.debug_handler.output(str(msg[1]), DEBUG_CRITICAL)
            return False
        
        # Try to recieve the first chunk of data from the server
        try:
            if self.isConnectionAlive(): 
                print("Server: " + self.client_socket.recv(15))
        except socket.error, msg:
            self.client_socket.close()
            self.parent_window.debug_handler.output(str(msg[1]), DEBUG_CRITICAL)
            return False
             
        self.client_connected = True
        self.parent_window.onConnect()
        self.receive_increment = 0
        return self.client_connected

# /end connect() ====================================================================================


# reLogin() ========================================================================================
# ==================================================================================================
#  The function that logs into the server
#  after some operation of being connected
#  has occured.
# ==================================================================================================
    def reLogin(self):  
        self.send("LOGIN", self.client_username + " " + self.client_password + " " + str(self.client_cpu) + " " + self.client_localIP + "\tOmni " + self.parent_window.omni_version)

# /end reLogin() ====================================================================================



  #==========================================================================================================
  #==========================================================================================================
  #=========================================NET RECV=========================================================
  #==========================================================================================================
  #==========================================================================================================
  
  
  
# receiveData() ======================================================================================
# ==================================================================================================
# The message loop that recieves network messages from the server.

    def receiveData(self):
        if self.isConnectionAlive():
                data = "d"
                new_data = ""
                while data != "":
                    data = ""
                    try:
                        self.client_socket.setblocking(0)
                        data = self.client_socket.recv(512)
                        new_data = new_data + data
                        self.client_socket.setblocking(1)
                    except socket.error, msg:
                        if msg[0] != 11 and msg[0] != 10035:
                            self.parent_window.debug_handler.output("Error occured when receiving data from the socket. " + str(msg), DEBUG_USELESS)
                    
                if new_data != "":
                    self.parseCommand(new_data)
                    
                while 1:
                    try: 
                        cmdToBeProcessed = self.client_messageQueue.get(False)
                        self.processCommand(cmdToBeProcessed)  
                    except:
                        break   
                if self.receive_increment > 4:
                    while 1:
                        try: 
                            cmdToSend = self.client_sendQueue.get(False)
                            self.sendData(cmdToSend)  
                        except:
                            break  
                        
                self.receive_increment += 1
                    
# /end receiveData() =================================================================================






  #==========================================================================================================
  #==========================================================================================================
  #====================================PING RELATED==========================================================
  #==========================================================================================================
  #==========================================================================================================
  
  
  
# sendPing() =======================================================================================
# ==================================================================================================
# The keep alive loop that sends ping commands to the server
# to keep the connection alive.

    def sendPing(self):
        if self.server_pings_sent >= (self.server_timeout / self.server_pingrate):
            self.parent_window.debug_handler.output("Server has timed out.", DEBUG_ERROR)
            self.disconnect("force")
            
        if self.isConnectionAlive():
            self.send("PING")
            self.server_pings_sent += 1

        
# /end sendPing() ==================================================================================




# onPongReceived() =================================================================================
# ==================================================================================================
# When a PONG command is recieved from the server,
# this function is called.

    def onPongReceived(self):
        self.server_pings_sent = 0

        
# /end onPongReceived() ============================================================================





  #==========================================================================================================
  #==========================================================================================================
  #=======================================CONTROL FUNCTIONS==================================================
  #==========================================================================================================
  #==========================================================================================================


# start() ==========================================================================================
# ==================================================================================================
# Connects to the spring server and starts the networking
# helper threads.

    def start(self):
        self.connect()
        self.client_recvTimer.Start(100, wx.TIMER_CONTINUOUS)
        
# /end start() =====================================================================================



# startPing() ======================================================================================
# ==================================================================================================
#  Starts the timer that pings the server to show that its still alive.

    def startPing(self):
        self.client_pingTimer.Start(self.server_pingrate * 1000, wx.TIMER_CONTINUOUS)
        
# /end startPing() =================================================================================




# isConnectionAlive() ==============================================================================
# ==================================================================================================
#  Starts the networking loop in a separate thread.

    def isConnectionAlive(self):
        if self.client_connected == True:
            try:
                tmp = self.client_socket.getpeername()
            except socket.error, msg:
                if msg[0] == 107:
                    self.disconnect("force")
                    return False
                print(str(msg))
                return False
                
            return True
        else:
            return False
        
# /end isConnectionAlive() =========================================================================



# disconnect() =====================================================================================
# ==================================================================================================
#  Stops the thread from running forcefully.

    def disconnect(self, disconnect):
        self.client_connected = False
        
        self.client_pingTimer.Stop()
        self.parent_window.debug_handler.output("pingTimer stopped.", DEBUG_USELESS)

        self.client_socket.close()
        self.parent_window.debug_handler.output("Socket closed.", DEBUG_USELESS)

        
        self.parent_window.updateConnectionStatus(False)
        self.parent_window.onDisconnect(disconnect)
# /end disconnect() ================================================================================





# send() ===========================================================================================
# ==================================================================================================
#  Puts a command in the send queue where it it emptied at regular intervals.

    def send(self, command, args=""):
        if not command == "" and args != "":
            self.client_sendQueue.put(command + " " + args + "\n")
        elif not command == "" and args == "":
            self.client_sendQueue.put(command + "\n")
                
# /end send() ======================================================================================





# sendData() =======================================================================================
# ==================================================================================================
#  Sends a command to the server.

    def sendData(self, command):
        self.client_socket.setblocking(0)
        
        if not command == "":
        
            try:
                bytes_sent = self.client_socket.send(command)
                while bytes_sent < len(command):
                    bytes_sent = self.client_socket.send(command)
                self.parent_window.debug_handler.output("[<-] \"" + command[0:len(command)-1] + "\"", DEBUG_USELESS)
            except socket.error, msg:
                if msg[0] == 107:
                    self.disconnect("force")
                    return False
                self.parent_window.debug_handler.output("Error sending data! " + str(msg), DEBUG_ERROR)

        self.client_socket.setblocking(1)
                
# /end sendData() ==================================================================================



# clearPingQueue() =================================================================================
# ==================================================================================================
#  Stops the thread from running forcefully.

    def clearPingQueue(self):
        queue_empty = False
        
        while not queue_empty:
            try:
                tmp = self.client_pingQueue.get(False)
            except:
                break
        
# /end clearPingQueue() ============================================================================




  #==========================================================================================================
  #==========================================================================================================
  #=========================================COMMAND FUNCTIONS================================================
  #==========================================================================================================
  #==========================================================================================================



# parseCommand() ===================================================================================
# ==================================================================================================
# Parses commands recieved from the server.

    def parseCommand(self, command, retry=False):
        
        #used for the main loop that parses each individual command
        increment = 0

        if retry == False:
            commands_parsed = command.split("\n")
        else:
            if len(command) == 1:
                commands_parsed = command
                print(command)
                tmp_str = self.last_command + commands_parsed
                cmd_parsed = tmp_str.split(" ")
                
                self.lookupCommand(cmd_parsed, True)
                return True
            else:
                print("ERROR ERRROR: " + command)
                return False
        
        while len(commands_parsed) > increment:
        
            if commands_parsed[increment] == "":
                increment += 1
                #break out of the loop because this command is empty
                if not len(commands_parsed) > increment:
                    break
        
            cmd_parsed = commands_parsed[increment].split(" ")
            
            #if for some reason the split function returns an empty string
            if cmd_parsed == "":
                cmd_parsed = commands_parsed[increment]
            
            
            if commands_parsed[len(commands_parsed) - 1] != "" and increment == len(commands_parsed) - 1:
               
                if len(cmd_parsed) > 0:
                    sentence = cmd_parsed[0]
                    
                    for x in cmd_parsed[1:]:
                        sentence =  sentence + " " + x
                else:
                    sentence = ""
                self.parent_window.debug_handler.output("part 1: " + sentence, DEBUG_USELESS)    
                self.last_command = sentence
                self.lookupCommand(cmd_parsed, True)
                return False
                
            if cmd_parsed[0] != "":
                self.lookupCommand(cmd_parsed)
                
            increment += 1
        
# /end parseCommand() ==============================================================================




# lookupCommand() ==================================================================================
# ==================================================================================================
# Passes data to the queue, and performs special
# analysis of certain commands that cannot fail
# to be processed.  (Such as ADDUSER)

    def lookupCommand(self, command, retry=False):
    
        if len(command) > 0:
            cmd_sentence = command[0]
            
            for x in command[1:]:
                cmd_sentence =  cmd_sentence + " " + x
        else:
            cmd_sentence = ""
                
        if command[0] == "PONG":
            self.client_messageQueue.put(command)
        elif command[0] == "AGREEMENT":
            self.client_messageQueue.put(command)
        elif command[0] == "AGREEMENTEND":
            self.client_messageQueue.put(command)
        elif command[0] == "REGISTRATIONDENIED":
            self.client_messageQueue.put(command)
        elif command[0] == "REGISTRATIONACCEPTED":
            self.client_messageQueue.put(command)
        elif command[0] == "ACCEPTED":
            self.client_messageQueue.put(command)
        elif command[0] == "DENIED":
            self.client_messageQueue.put(command)
        elif command[0] == "MOTD":
            self.client_messageQueue.put(command)
        elif command[0] == "SERVERMSG":
            self.client_messageQueue.put(command)
        elif command[0] == "ADDUSER":
            self.client_messageQueue.put(command)
        elif command[0] == "REMOVEUSER":
            self.client_messageQueue.put(command)
        elif command[0] == "JOIN":
            self.client_messageQueue.put(command)
        elif command[0] == "CHANNELS":
            #Support for old CHANNELS command
            self.client_messageQueue.put(command)
        elif command[0] == "CHANNEL":
            self.client_messageQueue.put(command)
        elif command[0] == "ENDOFCHANNELS":
            self.client_messageQueue.put(command)
        elif command[0] == "JOINFAILED":
            self.client_messageQueue.put(command)
        elif command[0] == "CHANNELTOPIC":
            self.client_messageQueue.put(command)
        elif command[0] == "CLIENTS":
            self.client_messageQueue.put(command)
        elif command[0] == "JOINED":
            self.client_messageQueue.put(command)
        elif command[0] == "LEFT":
            self.client_messageQueue.put(command)
        elif command[0] == "SAID":
            self.client_messageQueue.put(command)
        elif command[0] == "SAIDEX":
            self.client_messageQueue.put(command)
        elif command[0] == "SAYPRIVATE":
            self.client_messageQueue.put(command)
        elif command[0] == "SAIDPRIVATE":
            self.client_messageQueue.put(command)
        elif command[0] == "OPENBATTLE":
            self.client_messageQueue.put(command)
        elif command[0] == "BATTLEOPENED":
            self.client_messageQueue.put(command)
        elif command[0] == "BATTLECLOSED":
            self.client_messageQueue.put(command)
        elif command[0] == "JOINBATTLE":
            self.client_messageQueue.put(command)
        elif command[0] == "JOINEDBATTLE":
            self.client_messageQueue.put(command)
        elif command[0] == "LEFTBATTLE":
            self.client_messageQueue.put(command)
        elif command[0] == "JOINBATTLEFAILED":
            self.client_messageQueue.put(command)
        elif command[0] == "OPENBATTLEFAILED":
            self.client_messageQueue.put(command)
        elif command[0] == "UPDATEBATTLEINFO":
            self.client_messageQueue.put(command)
        elif command[0] == "UPDATEBATTLEDETAILS":
            self.client_messageQueue.put(command)
        elif command[0] == "SAIDBATTLE":
            self.client_messageQueue.put(command)
        elif command[0] == "SAIDBATTLEEX":
            self.client_messageQueue.put(command)
        elif command[0] == "CLIENTSTATUS":
            self.client_messageQueue.put(command)
        elif command[0] == "CLIENTBATTLESTATUS":
            self.client_messageQueue.put(command)
        elif command[0] == "REQUESTBATTLESTATUS":
            self.client_messageQueue.put(command)
        elif command[0] == "FORCEQUITBATTLE":
            self.client_messageQueue.put(command)
        elif command[0] == "DISABLEUNITS":
            self.client_messageQueue.put(command)
        elif command[0] == "ENABLEUNITS":
            self.client_messageQueue.put(command)
        elif command[0] == "ENABLEALLUNITS":
            self.client_messageQueue.put(command)
        elif command[0] == "RING":
            self.client_messageQueue.put(command)
        elif command[0] == "REDIRECT":
            self.client_messageQueue.put(command)
        elif command[0] == "BROADCAST":
            self.client_messageQueue.put(command)
        elif command[0] == "ADDBOT":
            self.client_messageQueue.put(command)
        elif command[0] == "REMOVEBOT":
            self.client_messageQueue.put(command)
        elif command[0] == "UPDATEBOT":
            self.client_messageQueue.put(command)
        elif command[0] == "ADDSTARTRECT":
            self.client_messageQueue.put(command)
        elif command[0] == "REMOVESTARTRECT":
            self.client_messageQueue.put(command)
        elif command[0] == "TASServer":
            pass
        else:
        
            #Command doesn't exist or can't be parsed
            #(also if the command is being passed from process command
            #just to see if it works)
            
            if retry == True:
                self.parent_window.debug_handler.output("Failed to parse command " + command[0] + " from the server.", SERVER_LOW)
                return False
                
            self.parent_window.debug_handler.output("part 2: " + cmd_sentence, DEBUG_USELESS)
            
            if self.last_command != "" and self.last_command != cmd_sentence.rstrip():
                tmp_cmd = self.last_command + cmd_sentence + "\n"
                self.parseCommand(tmp_cmd, False)
                self.last_command = ""
                return True
            print("last_command: \"" + self.last_command + "\"")
            print("cmd_sentence.rstrip(): \"" + cmd_sentence.rstrip() + "\"")
            
        if cmd_sentence != "":
            self.parent_window.debug_handler.output("[->] \"" + cmd_sentence + "\"", SERVER_USELESS)
        

# /end lookupCommand() ============================================================================





# processCommand() =================================================================================
# ==================================================================================================
# Sends each command to its own appropriate
# callback function that is most likely in
# gui_lobby.py

    def processCommand(self, command):
        
        if len(command) > 1:
            cmd_sentence = command[1]
            
            for x in command[2:]:
                cmd_sentence =  cmd_sentence + " " + x
        else:
            cmd_sentence = ""
            
            
        #==================================================
        #Login Stuff
        #==================================================
        if command[0] == "PONG":
            self.onPongReceived()
            self.parent_window.updateConnectionStatus(True)
        elif command[0] == "CHANNELTOPIC":
            if len(command) > 2:
                cmd_sentence = command[2]
                
                for x in command[3:]:
                    cmd_sentence =  cmd_sentence + " " + x
            else:
                cmd_sentence = ""

            tmp_list = [command[1], cmd_sentence]
            self.parent_window.onChannel_Topic(tmp_list)

        elif command[0] == "REGISTRATIONDENIED":
            self.parent_window.debug_handler.output("Server: Registration denied. " + cmd_sentence, DEBUG_ERROR)
            self.disconnect("server")
        elif command[0] == "REGISTRATIONACCEPTED":
            self.parent_window.debug_handler.output("Server: Registration accepted.", SERVER_HIGH)
            self.reLogin()
        elif command[0] == "AGREEMENT":
            self.parent_window.onAddAgreement(cmd_sentence)
        elif command[0] == "AGREEMENTEND":
            self.parent_window.agreement.updateAgreement()
        elif command[0] == "ACCEPTED":
            self.startPing()
            self.parent_window.onLogin()
        elif command[0] == "DENIED":
            self.parent_window.debug_handler.output("Server: Login denied. " + cmd_sentence, DEBUG_ERROR)
            self.disconnect("server")
        elif command[0] == "MOTD":
            self.parent_window.onMOTDRecieve(cmd_sentence)
            self.parent_window.updateConnectionStatus(True)
        elif command[0] == "SERVERMSG":
            self.parent_window.debug_handler.output("Server:" + cmd_sentence, SERVER_HIGH)
        elif command[0] == "REDIRECT":
            pass
        elif command[0] == "BROADCAST":
            pass
            
            
        #==================================================
        #Lobby Stuff
        #==================================================
        elif command[0] == "CHANNELS":
            self.parent_window.onChannel_ReceiveChannels(command[1:])
        elif command[0] == "CHANNEL":
            self.parent_window.onChannel_Receive(command[1:])
        elif command[0] == "ENDOFCHANNELS":
            self.parent_window.onChannel_EndChannels()
        elif command[0] == "JOIN":
            self.parent_window.onChannel_Joined(command[1])
        elif command[0] == "CLIENTS":
            self.parent_window.onClientListReceive(command[1:])
        elif command[0] == "JOINED":
            self.parent_window.onNewUserJoin(command[1:])
        elif command[0] == "JOINFAILED":
            self.parent_window.debug_handler.output("Server: Join channel error, " + cmd_sentence, DEBUG_ERROR)
        elif command[0] == "ADDUSER": 
            if len(command[1:]) >= 4:
                self.parent_window.onNewUserLogin(command[1:])
            else:
                self.parent_window.debug_handler.output("Invalid ADDUSER command, \"" + cmd_sentence + "\"", DEBUG_USELESS)
        elif command[0] == "REMOVEUSER":
            self.parent_window.onUserDisconnect(command[1]) 
        elif command[0] == "LEFT":
            self.parent_window.onUserLeaves(command[1:]) 
        elif command[0] == "SAID":   
            self.parent_window.onSaid(command[1:]) 
        elif command[0] == "SAIDEX":
            self.parent_window.onSaidEx(command[1:]) 
        elif command[0] == "CLIENTSTATUS":
            if len(command[1:]) == 2:
                self.parent_window.onClientStatus(command[1:])  
            else:
                self.parent_window.debug_handler.output("Invalid CLIENTSTATUS command, \"" + cmd_sentence + "\"", DEBUG_USELESS)
             
        elif command[0] == "SAYPRIVATE":
            self.parent_window.onSayPrivate(command[1:])
        elif command[0] == "SAIDPRIVATE":
            self.parent_window.onSaidPrivate(command[1:])
        elif command[0] == "RING":
            pass
            

        #==================================================
        #Battle Stuff
        #==================================================
        elif command[0] == "BATTLEOPENED":
            if len(command[1:]) >= 12:
                self.parent_window.onBattle_Open(cmd_sentence)
            else:
                self.parent_window.debug_handler.output("Invalid BATTLEOPENED command, \"" + cmd_sentence + "\"", DEBUG_USELESS)
        elif command[0] == "JOINEDBATTLE":
            self.parent_window.onBattle_Joined(command[1:])
        elif command[0] == "LEFTBATTLE":
            self.parent_window.onBattle_Leave(command[1:])
        elif command[0] == "BATTLECLOSED":
            self.parent_window.onBattle_Closed(command[1])
        elif command[0] == "JOINBATTLE":
            self.parent_window.onBattle_Join(command[1:])
        elif command[0] == "JOINBATTLEFAILED":
            self.parent_window.debug_handler.output("Server: Join battle error, " + cmd_sentence, DEBUG_ERROR)
        elif command[0] == "SAIDBATTLE":
            self.parent_window.onBattle_Said(command)
        elif command[0] == "SAIDBATTLEEX":
            self.parent_window.onBattle_SaidEx(command)
        elif command[0] == "OPENBATTLE":
            pass
        elif command[0] == "OPENBATTLEFAILED":
            pass
        elif command[0] == "UPDATEBATTLEINFO":
            pass
        elif command[0] == "UPDATEBATTLEDETAILS":
            pass
        elif command[0] == "CLIENTBATTLESTATUS":
            self.parent_window.onBattle_ClientStatus(command[1:])
        elif command[0] == "REQUESTBATTLESTATUS":
            self.parent_window.onBattle_RequestStatus()
        elif command[0] == "FORCEQUITBATTLE":
            pass
        elif command[0] == "ADDSTARTRECT":
            pass
        elif command[0] == "REMOVESTARTRECT":
            pass
            
        #==================================================
        #Bots and Units
        #==================================================
        elif command[0] == "DISABLEUNITS":
            pass
        elif command[0] == "ENABLEUNITS":
            pass
        elif command[0] == "ENABLEALLUNITS":
            pass
        elif command[0] == "ADDBOT":
            pass
        elif command[0] == "REMOVEBOT":
            pass
        elif command[0] == "UPDATEBOT":
            pass

# /end processCommand() ===========================================================================



