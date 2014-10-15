/*
 * Created on 2005.6.16
 *
 * TODO To change the template for this generated file go to
 * Window - Preferences - Java - Code Style - Code Templates
 * 
 *
 * ---- CHANGELOG ----
 * *** 0.16 ***
 * * added new host option - diminishing metal maker returns
 * * switched to Webnet77's ip-to-country database, which seems to be more frequently 
 *   updated: http://software77.net/cgi-bin/ip-country/geo-ip.pl
 * * added "locked" parameter to UPDATEBATTLEINFO command   
 * * added "multiplayer replays" support
 * *** 0.152 ***
 * * fixed small bug with server not updating rank when maximum level has been reached
 * * added ban list
 * *** 0.151 ***
 * * added OFFERUPDATEEX command
 * * added country code support 
 * * added simple protection against rank exploiters
 * * added cpu info (LOGIN command now requires additional parameter)
 * * limited usernames/passwords to 20 chars
 * *** 0.141 ***
 * * fixed issue with server not notifying users about user's rank on login
 * * added command: CHANNELTOPIC
 * *** 0.14 ***
 * * added FORCETEAMCOLOR command
 * * fixed bug which allowed users to register accounts with username/password containing
 *   chars from 43 to 57 (dec), which should be numbers (the correct number range is 48 
 *   to 57). Invalid chars are "+", ",", "-", "." and "/".
 * * added ranking system  
 * *** 0.13 ***
 * * added AI support
 * * added KICKUSER command (admins only)
 * * fixed bug when server did not allow client to change its ally number if someone
 *   else used it, even if that was only a spectator.
 * * added away status bit  
 * * fixed bug when server denied join request to battle, if there were maxplayers+1 players
 *   already in the battle.
 * * added new commands: SERVERMSG, SERVERMSGBOX, REQUESTUPDATEFILE, GETFILE
 * * added some admin commands
 * * changed registration process so that now you can't register username which is same
 *   as someone elses, if we ignore case. Usernames are still case-sensitive though.  
 *
 * ---- NOTES ----
 * 
 * * Client may participate in only one battle at the same time. If he is hosting a battle,
 *   he may not participate in other battles at the same time. Server checks for that 
 *   automatically.
 *   
 * * Lines sent and received may be of any length. I've tested it with 600 KB long strings
 *   and it worked in both directions. Nevertheless, commands like "CLIENTS" still try to
 *   divide data into several lines, just to make sure client will receive it. Since delphi
 *   lobby client now supports lines of any length, dividing data into several lines is not
 *   needed anymore. Nevertheless I kept it just in case, to be compatible with other clients 
 *   which may emerge in the future. I don't divide data when sending info on battles
 *   and clients in battles. This lines may get long, but not longer than a couple of hundreds
 *   of bytes (they should always be under 1 KB in length).
 *   
 * * Sentences must be separated by TAB characters. This also means there should be no TABs
 *   present in your sentences, since TABs are delimiters. That is why you should always
 *   replace any TABs with spaces (2 or 8 usually).
 *   
 * * Syncing works by clients comparing host's hash code with their own. If the two codes
 *   match, client should update his battle status and so telling other clients in the battle
 *   that he is synced (or unsynced otherwise). Hash code comes from hashing mod's file 
 *   and probably all the dependences too.
 * 
 * * Try not to edit account file manually! If you do, don't forget that access numbers
 *   must be in binary form!
 * 
 * * Team colors are currently set by players, perhaps it would be better if only host would
 *   be able to change them?
 * 
 * 
 * 
 * ---- LINKS ----
 *  
 * Great article on how to handle network timeouts in Java: http://www.javacoffeebreak.com/articles/network_timeouts/
 * 
 * Another one on network timeouts and alike: http://www.mindprod.com/jgloss/socket.html
 * 
 * Great article on thread synchronization: http://today.java.net/pub/a/today/2004/08/02/sync1.html
 * 
 * Throwing exceptions: http://java.sun.com/docs/books/tutorial/essential/exceptions/throwing.html
 * 
 * Sun's tutorial on sockets: http://java.sun.com/docs/books/tutorial/networking/sockets/
 * 
 * How to redirect program's output by duplicating handles in windows' command prompt: http://www.microsoft.com/resources/documentation/windows/xp/all/proddocs/en-us/redirection.mspx
 * 
 * How to get local IP address (like "192.168.1.1" and not "127.0.0.1"): http://forum.java.sun.com/thread.jspa?threadID=619056&messageID=3477258 
 * 
 * IP-to-country database: http://ip-to-country.webhosting.info
 * 
 * Another set of 232 country flags: http://www.ip2location.com/free.asp
 * 
 * 
 * 
 * 
 * ---- PROTOCOL ----
 * 
 * This is a simple text protocol in a "human readable form". I decided for text protocol since
 * it's easier to debug and implement on the client side. It does require some more overhead,
 * but since server and clients do not communicate much anyway, this is not an issue. What 
 * really eats the bandwidth is the game itself, not lobby.
 * 
 * Single word arguments are separated by spaces, "sentences" (a sentence is a series of words
 * separated by spaces, denoting a single argument) are separated by TABs. Don't forget
 * to replace any TABs in your sentences with spaces! If you don't, your command is invalid
 * and will not be read correctly by server.
 * 
 * A client must maintain a constant connection with server, that is if no data is to be
 * transfered, client must send a PING command to the server on regular intervals. This
 * ensures server to properly detect any network timeouts/disconnects. Server will automatically
 * disconnect a client if no data has been received from it within a certain time period.
 * Client should send some data at least on half of that interval.
 * 
 * Whether battle is in progress or not, clients may find out by monitoring battle's founder
 * status. If his status changes to "in game", battle's status is also "in game".
 * 
 * Client's status and battle status are assumed to be 0 if not said otherwise. Each client
 * should assume that every other client's status and battle status are 0 if not stated
 * otherwise by the server. So when client joines the server, he is notified about statuses
 * of only those users, who have status or battle status different from 0. This way we also 
 * save some bandwidth (although that is not really an issue here. If we were worried about
 * this protocol taking up too much bandwidth, we wouldn't use text protocol, now would we?).
 * 
 * I use two terms for "clients": a client and an user. At first user was considered to
 * be a registered client, that is client who is logged-in. I started to mix the two 
 * expressions after a while but that should not confuse you.
 * 
 * Most of the commands that notify about some changes are forwarded to the source of the 
 * change too. For example: When client sends MYBATTLESTATUS command, server sends
 * CLIENTBATTLESTATUS command to all users in the battle, including the client who sent
 * MYBATTLESTATUS command. This is a good practice, because this way client can synchronize his 
 * local status with server's after server has actually updated his status (serves also as
 * confirmation).
 * 
 * All commands except for some admin specific commands are listed here. See tryToExecCommand
 * method for those.
 * 
 * Legend:
 * - {} = sentence = several words (at least one!) separated by space characters
 * - {} {} ... = two or more sentences. They are separated by TAB characters.
 * - words are always separated by space characters.
 * 
 * List of commands:
 * 
 * * PING
 * Sent by client to server. Client should send this command on every few seconds to maintain
 * constant connection to server. Server will assume timeout occured if it does not hear from
 * client for more than x seconds.
 * 
 * * PONG
 * Sent by server to client who sent a PING command.
 * 
 * * REGISTER username password
 * Sent by client who hasn't logged in yet. If server is in LAN mode, this command will
 * be ignored.
 * 
 * * REGISTRATIONDENIED {reason}
 * Sent by server to client who just sent REGISTER command, if registration has been refused.
 * 
 * * REGISTRATIONACCEPTED 
 * Sent by server to client who just sent REGISTER command, if registration has been accepted.
 * 
 * * LOGIN username password cpu
 * Sent by client when he is trying to log on the server. Server may respond with ACCEPTED
 * or DENIED command. CPU is an integer denoting the speed of client's processor in MHz (or
 * equivalent if AMD). Client should leave this value at 0 if it can't figure out
 * its CPU speed.
 * 
 * * ACCEPTED username
 * Sent by server to the client if login was successful.
 * 
 * * DENIED {reason}
 * Sent by server if login failed.
 *
 * * MOTD {message}
 * Sent by server after client has successfully logged in. Server can send multiple MOTD
 * commands (each MOTD corresponds to one line, for example).
 * 
 * * SERVERMSG {message}
 * This is a message sent by server.
 *
 * * ADDUSER username country cpu
 * Sent by server to client telling him new user joined a server. Client should add this
 * user to his clients list which he must maintain while he is connected to the server.
 * Server will send multiple commands of this kind once client logs in, sending him the list
 * of all users currently connected.
 * See login command for CPU field description.
 * Country is a two-character country code based on ISO 3166.  
 * 
 * * REMOVEUSER username
 * Sent by server to client telling him a user disconnected from server. Client should
 * remove this user from his clients list which he must maintain while he is connected
 * to the server.
 *
 * * JOIN channame
 * - Sent by client trying to join the channel.
 * - Sent by server to a client who has successfully joined a channel.
 * 
 * * CHANNELS
 * Sent by client when requesting channels list
 * 
 * * CHANNELS {channels}
 * Sent by server when sending channels list to client. This command is very similar to
 * CLIENTS command (in structure), so see notes for CLIENTS command too!
 * 
 * * JOINFAILED channame {reason}
 * Sent by server if joining a channel failed for some reason. Server MUST provide a reason
 * as a third argument to this command! Reason may be composed of several words seperated by a
 * space character.
 * 
 * * CHANNELTOPIC channame {topic}
 * Sent by server to client who just joined the channel, if some topic is set for this channel.
 * 
 * * CHANNELTOPIC channame {topic}
 * Sent by privileged user who is trying to change channel's topic. Use * as topic if you wish
 * to disable it.
 * 
 * * CLIENTS channame {clients}
 * Sent by server to a client who just joined the channel. WARNING: Multiple commands of this
 * kind can be sent in a row. Server takes the list of client in a channel and separates
 * it into several lines and sends each line seperately. This ensures no line is too long,
 * because client may have some limit set on the maximum length of the line and it could
 * ignore it if it was too long. WARNING 2: The client itself (his username) is sent in this
 * list too! So when client receives JOIN command he should not add his name in the clients
 * list of a channel - he should wait for CLIENTS command which will contain his name too
 * and he will add himself then automatically.
 *  
 * * JOINED channame username
 * Sent by server to all clients in a channel (except the new client) when a new client 
 * joined a channel.
 * 
 * * LEAVE channame
 * Sent by client when he is trying to leave a channel. When client is disconnected, he is
 * automatically removed from all channels.
 * 
 * * LEFT channame username
 * Sent by server to all clients in a channel when some client left a channel.
 * WARNING: Server does not send this command to a client that has just left a channel,
 * because there is no need to (client who has left the channel knows that he left,
 * it was he who told us that that)!
 * 
 * * SAY channame {message}
 * Sent by client when he is trying to say something in a specific channel. Client must
 * first join the channel before he can receive or send messages to channel.
 * 
 * * SAID channame username {message}
 * Sent by server when one of the clients in the channel sent a message to it.
 * 
 * * SAYEX channame {message}
 * Sent by any client when he is trying to say something in "/me" irc style.
 * 
 * * SAIDEX channame username {message}
 * Sent by server when client said something using SAYEX command.
 * 
 * * SAYPRIVATE username {message}
 * - Sent by client when he is trying to send a private message to some other client.
 * - Sent by server to a client who just sent SAYPRIVATE command to server. This way client
 *   can verify that server did get his message and that receiver will get it too.
 * 
 * * SAIDPRIVATE username {message}
 * Sent by server when some client sent this client a private message.
 * 
 * * OPENBATTLE type password port maxplayers startingmetal startingenergy maxunits startpos gameendcondition limitdgun diminishingMMs hashcode rank {map} {title} {modname}
 * Sent by client. The client becomes a founder of this battle, if successful. Client
 * is notified about its success via OPENBATTLE/OPENBATTLEFAILED commands sent by server.
 * "startpos" can be only 0, 1 or 2 (0=fixed, 1=random, 2=choose).
 * "gameendcondition" can only be 0 or 1 (0=game continues, 1=game ends /if commander dies/)
 * Password must be "*" if founder does not wish to have password-protected game.
 * Hashcode is a signed 32-bit integer.
 * "type" can be 0 or 1 (0 = normal battle, 1 = battle replay)
 * 
 * * OPENBATTLE BATTLE_ID
 * Sent by server to a client who previously sent OPENBATTLE command to server, if client's
 * request to open new battle has been approved. If server rejected client's request, he
 * is notified via OPENBATTLEFAILED command. Server first sends BATTLEOPENED command, then
 * OPENBATTLE command (this is important - client must have the battle in his battle list
 * before he receives OPENBATTLE command!).
 * 
 * * BATTLEOPENED BATTLE_ID type founder IP port maxplayers passworded rank {mapname} {title} {modname}
 * Sent by server to all registered users, when a new battle has been opened.
 * Series of BATTLEOPENED commands are sent to user when he logs in (for each battle
 * one command).
 * Use Battle.createBattleOpenedCommand method to create this command in a String.
 * "passworded" is a boolean and must be "0" or "1" and not "true" or "false" as it
 * is default in Java! Use Misc.strToBool and Misc.boolToStr methods to convert from
 * one to another.
 * "type" can be 0 or 1 (0 = normal battle, 1 = battle replay)
 * 
 * * BATTLECLOSED BATTLE_ID
 * Sent by server when founder has closed a battle (or if he was disconnected).
 * 
 * * JOINBATTLE BATTLE_ID password*
 * Sent by a client trying to join a battle. Password is an optional parameter.
 * 
 * * JOINBATTLE BATTLE_ID startingmetal startingenery maxunits startpos gameendcondition limitdgun diminishingMMs hashcode
 * Sent by server telling the client that he has just joined the battle successfully.
 * Server will also send a series of CLIENTBATTLESTATUS commands after this command,
 * so that user will get the battle statuses of all the clients in the battle.
 * Limitdgun is a boolean (0 or 1).
 * DiminishingMMs is a boolean (0 or 1).
 * Hashcode is a signed 32-bit integer.
 * 
 * * JOINEDBATTLE BATTLE_ID username
 * Sent by server to all clients when a new client joined a battle.
 * 
 * * LEFTBATTLE BATTLE_ID username
 * Sent by server to all users when client left a battle (or got disconnected from server).
 * 
 * * LEAVEBATTLE
 * Sent by the client when he leaves a battle. Also sent by a founder of the battle when he
 * closes the battle.
 * 
 * * JOINBATTLEFAILED {reason}
 * Sent by server to user who just tried to join a battle but has been rejected by server.
 * 
 * * OPENBATTLEFAILED {reason}
 * Sent by server to user who just tried to open(=host) a new battle and was rejected by
 * the server.
 * 
 * * UPDATEBATTLEINFO BATTLE_ID SpectatorCount locked {mapname}
 * Sent by server to all registered clients telling them 
 * some of the parameters of the battle changed. Battle's inside 
 * changes, like starting metal, energy, starting position etc., are sent only to clients 
 * participating in the battle via UPDATEBATTLEDETAILS command.
 * "locked" is a boolean (0 or 1). Note that when client creates a battle, server assumes
 * it is unlocked. Client must make sure it actually is.
 * Note: assume that spectator count is 0 if battle type is 0 (normal battle) and
 * 1 if battle type is 1 (battle replay), as founder of the battle is automatically set
 * as spectator in that case.
 * 
 * * UPDATEBATTLEINFO SpectatorCount locked {mapname}
 * Sent by the founder of the battle telling the server some of the "outside" parameters
 * of the battle changed. "mapname" should NOT contain file extension. 
 * "locked" is a boolean (0 or 1). Note that when client creates a battle, server assumes
 * it is unlocked. Client must make sure it actually is.
 * 
 * * UPDATEBATTLEDETAILS startingmetal startingenergy maxunits startpos gameendcondition limitdgun diminishingMMs
 * Sent by server to all clients participating in a battle when some of the battle's "inside"
 * parameters change. See also UPDATEBATTLEINFO command!
 * "startpos" can only be 0, 1 or 2 (0=fixed, 1=random, 2=choose).
 * "gameendcondition" can only be 0 or 1 (0=game continues, 1=game ends /if commander dies/)
 * 
 * * UPDATEBATTLEDETAILS startingmetal startingenergy maxunits startpos gameendcondition limitdgun diminishingMMs
 * Seny by founder of the battle to server telling him some of the "inside" parameteres
 * of the battle changed. Even if only one of the parameters changed, all must be sent.
 * This does create some more overhead, but it simplifies the communication between server
 * and clients and vice-versa. Since this command is not often used and it is only sent
 * to clients parcticipating in the battle, this does not raise a problem.
 * 
 * * SAYBATTLE {message}
 * Sent by client who is participating in a battle to server, who forwards this message
 * to all other clients in the battle. BATTLE_ID is not required since every user can 
 * participate in only one battle at the time. If user is not participating in the battle,
 * this command is ignored and is considered invalid. 
 * 
 * * SAIDBATTLE username {message}
 * Sent by server to all clients participating in a battle when client sent a message
 * to it using SAYBATTLE command. BATTLE_ID is not required since every client knows in 
 * which battle he is participating in, since every client may participate in only one 
 * battle at the time. If client is not participating in a battle, he should ignore 
 * this command or raise an error (this should never happen!).
 * 
 * * SAYBATTLEEX {message}
 * Sent by any client participating in a battle when he wants to say something in "/me" irc style.
 * Server can forge this command too (for example when founder of the battle kicks a user, server
 * uses SAYBATTLEEX saying founder kicked user). 
 * 
 * * SAIDBATTLEEX username {message}
 * Sent by server to all clients participating in a battle when client used SAYBATTLEEX command.
 * See SAYBATTLEEX for more info.
 * 
 * * MYSTATUS status
 * Sent by client to server telling him his status changed. Each bit has its meaning:
 * b0 = in game (0 - normal, 1 - in game)
 * b1 = away status (0 - normal, 1 - away) 
 * b2-b4 = rank (see Account class implementation for description of rank) - client is not 
 *         allowed to change rank bits himself (only server may set them).
 * Client must check founder's status to see if battle is "in game".
 * 
 * * CLIENTSTATUS username status
 * Sent by server to all registered clients indicating that client's status changed.
 * See MYSTATUS command for possible values of status parameter.
 * 
 * * MYBATTLESTATUS battlestatus
 * Sent by a client to the server telling him his status in the battle changed. 
 * "battlestatus" is an integer but with limited range: 0..2147483647 (use signed int and
 * consider only positive values and zero). Number is sent as text. Each bit has its meaning:
 * b0 = side (0=arm, 1=core)
 * b1 = ready (0=not ready, 1=ready)
 * b2..b5 = team no. (from 0 to 15. b2 is LSB, b5 is MSB)
 * b6..b9 = ally team no. (from 0 to 15. b6 is LSB, b9 is MSB)
 * b10 = mode (0 = spectator, 1 = normal player)
 * b11..b17 = handicap (7-bit number. Must be in range 0..100). Note: Only host can 
 *             change handicap values of the players in the battle (with HANDICAP command).
 *             These 7 bits are always ignored in this command. They can only be changed
 *             using HANDICAP command.
 * b18..b21 = team color index (currently only valid is 0..9, as defined in TAPallete.cpp)
 * b22..b23 = sync status (0 = unknown, 1 = synced, 2 = unsynced)            
 * b24..b31 = undefined (reserved for future use)
 * 
 * * CLIENTBATTLESTATUS username battlestatus
 * Sent by server to users participating in a battle when one of the clients changes his
 * battle status. See MYBATTLESTATUS command for possible values of battlestatus parameter. 
 * 
 * * REQUESTBATTLESTATUS
 * Sent by server to user who just opened a battle or joined one. When client receives this
 * command, he must send MYBATTLESTATUS command to the server so that server can synchronize
 * battle status with user's. This command is sent after all CLIENTBATTLESTATUS commands for
 * all clients have been sent. This way user can choose suitable team, ally and color numbers
 * since he knows battle statuses of other clients. 
 * 
 * * HANDICAP username value
 * Sent by founder of the battle changing username's handicap value (of his battle status). 
 * Only founder can change other users handicap values (even they themselves can't change it).
 * 
 * * KICKFROMBATTLE username
 * Sent by founder of the battle when he kicks the client out of the battle. Server will notify
 * client with FORCEQUITBATTLE command about it.
 * 
 * * FORCEQUITBATTLE
 * Sent by server to client for whom founder requested kick with KICKFROMBATTLE command. 
 * Client should immediately disconnect from the battle.
 * 
 * * FORCETEAMNO username teamno
 * Sent by founder of battle when he is trying to force some other client's team number
 * to <teamno>. Server will update client's battle status automatically. 
 * 
 * * FORCEALLYNO username teamno
 * Sent by founder of battle when he is trying to force some other client's ally number
 * to <allyno>. Server will update client's battle status automatically. 
 * 
 * * FORCETEAMCOLOR username colorindex
 * Sent by founder of battle when he is trying to force some other clients' team color
 * to <colorindex>. Server will update client's battle status automatically.
 *   
 * * DISABLEUNITS unitname1 unitname2 ...
 * - Sent by founder of the battle to server telling him he disabled one or more units.
 *   At least one unit name must be passed as an argument.
 * - Sent by server to all clients in the battle except for the founder, notifying them
 *   some units have been added to disabled units list.
 * 
 * * ENABLEUNITS unitname1 unitname2 ...
 * - Sent by founder of the battle to server telling him he enabled one or more previous
 *   disabled units. At least one unit name must be passed as an argument.
 * - Sent by server to all clients in the battle except for the founder, notifying them
 *   some units have been removed from disabled units list.  
 * 
 * * ENABLEALLUNITS
 * - Sent by founder of the battle to server telling him he enabled ALL units and so clearing
 *   the disabled units list.
 * - Sent by server to all clients in the battle except for the founder, telling them that
 *   disabled units list has been cleared.
 *   
 * * RING username
 * - Sent by client (currently only privileged client) to server  
 *   when trying to play a "ring" sound to username.
 * - Sent by server to client telling him username just rang (client should play
 *   the "ring" sound once he gets this command).
 *    
 * * REDIRECT ipddress
 * Sent by server when in "redirection mode". When client connects, server will send him
 * only this message and disconnect the socket immediately. Client should connect to <ipaddress>
 * in that case. This command may be useful when official server address changes, so that 
 * clients are automatically redirected to the new one.
 * 
 * * BROADCAST {message}
 * Sent by server when urgent message has to be delivered to all users.
 * 
 * * ADDBOT BATTLE_ID name owner battlestatus {AIDLL}
 * Sent by server. BATTLE_ID is there just to help client verify that
 * the bot is meant for his battle.
 * 
 * * ADDBOT name battlestatus {AIDLL}
 * Sent by client
 * 
 * * REMOVEBOT name
 * Sent by client.
 * 
 * * REMOVEBOT BATTLE_ID name
 * Sent by server. BATTLE_ID is there just to help client verify that
 * the bot is meant for his battle.
 * 
 * * UPDATEBOT BATTLE_ID name battlestatus
 * Sent by server. BATTLE_ID is there just to help client verify that
 * the bot is meant for his battle.
 * 
 * * UPDATEBOT name battlestatus
 * Sent by client (only bot owner and battle host can update bot)
 * 
 * * ADDSTARTRECT allyno left top right bottom
 * - Sent by host of the battle adding a start rectangle for allyno. See client implementation
 *   and Spring docs for more info on this one.
 * - Sent by server to clients participating in a battle (except for the host).  
 * 
 * * REMOVESTARTRECT allyno
 * - Sent by host of the battle removing a start rectangle for allyno. See client implementation
 *   and Spring docs for more info on this one.
 * - Sent by server to clients participating in a battle (except for the host).
 * 
 */

/**
 * @author Betalord
 *
 * TODO To change the template for this generated type comment go to
 * Window - Preferences - Java - Code Style - Code Templates
 */

import java.util.*;
import java.io.*;
import java.net.*;

public class TASServer {
	
	static final String VERSION = "0.16";
	static byte DEBUG = 1; // 0 - no verbose, 1 - normal verbose, 2 - extensive verbose
	static String MOTD = "Enjoy your stay :-)";
	static long upTime;
	static final String MOTD_FILENAME = "motd.txt";
	static final String BAN_LIST_FILENAME = "banlist.txt";
	static final String ACCOUNTS_INFO_FILEPATH = "accounts.txt";
	static final int SERVER_PORT = 8200; // default server port
	static final int TIMEOUT_LENGTH = 30000; // in miliseconds
	static boolean LAN_MODE = false;
	static boolean redirect = false; // if true, server is redirection clients to new IP
	static String redirectToIP = ""; // new IP to which clients are redirected if (redirected==true)
	static Timer saveAccountsInfoTimer = new Timer(false);
	static long saveAccountInfoInterval = 1000 * 60 * 60; // in miliseconds
	
	static Vector accounts = new Vector();
	static Vector clients = new Vector();
	static Vector channels = new Vector();
	static Vector battles = new Vector();
	static Vector banList = new Vector(); // list of banned IPs
	static ServerSocket serverSocket = null;
	
	static Vector archiveList = new Vector();
	static final int UPLOAD_FILE_PACKET_SIZE = 1024; // file packet length when sending file to client (in bytes)
	static final int MAX_DOWNLOAD_RATE = 1024 * 128; // the maximum download rate per client (in bytes per second)
	
	
	/* reads MOTD from disk (if file is found) */
	private static void readMOTD()
	{
		String newMOTD = ""; 
		try {
			BufferedReader in = new BufferedReader(new FileReader(MOTD_FILENAME));
			String line;
            while ((line = in.readLine()) != null) {
            	newMOTD = newMOTD.concat(line + '\n');
	        }
            in.close();
		} catch (IOException e) {
			System.out.println("Couldn't find " + MOTD_FILENAME + ". Using default MOTD");
			return ;
		}
		MOTD = newMOTD;
	}

	private static void readBanList(String filename)
	{
		banList.clear();
		try {
			BufferedReader in = new BufferedReader(new FileReader(filename));
			String line;
            while ((line = in.readLine()) != null) {
            	banList.add(line);
	        }
            in.close();
		} catch (IOException e) {
			System.out.println("Couldn't find " + filename + ". Ban list is empty.");
			return ;
		}
		System.out.println("Ban list loaded from: " + filename + ".");
	}
	
	private static boolean writeBanList(String filename)
	{
		try {
			PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(filename)));			

			for (int i = 0; i < banList.size(); i++)
			{
				out.println((String)banList.get(i));
			}
			
			out.close();
			
		} catch (IOException e) {
			System.out.println("IOException error while trying to write ban list to " + filename + "!");
			return false;
		}
		
		return true;
	}	
	
	public static boolean banned(String IP) {
		for (int i = 0; i < banList.size(); i++)
			if (((String)banList.get(i)).equals(IP)) return true;
		return false;	
	}
	
	/* (re)loads accounts information from disk */
	private static boolean readAccountsInfo()
	{
		try {
			BufferedReader in = new BufferedReader(new FileReader(ACCOUNTS_INFO_FILEPATH));

			accounts.clear();
			
			String line;
			String tokens[];
			
            while ((line = in.readLine()) != null) {
            	if (line.equals("")) continue;
            	tokens = line.split(" ");
            	if (tokens.length != 3) continue; // this should not happen! If it does, we simply ignore this line.
            	addAccount(new Account(tokens[0], tokens[1], Integer.parseInt(tokens[2], 2)));
	           }
            
            in.close();
			
		} catch (IOException e) {
			// catch possible io errors from readLine()
			System.out.println("IOException error while trying to update accounts info from " + ACCOUNTS_INFO_FILEPATH + "! Skipping ...");
			return false;
		}
		
		System.out.println(accounts.size() + " accounts information read from " + ACCOUNTS_INFO_FILEPATH);
		
		return true;
	}
	
	private static boolean writeAccountsInfo()
	{
		try {
			PrintWriter out = new PrintWriter(new BufferedWriter(new FileWriter(ACCOUNTS_INFO_FILEPATH)));			

			for (int i = 0; i < accounts.size(); i++)
			{
				out.println(accounts.get(i).toString());
			}
			
			out.close();
			
		} catch (IOException e) {
			System.out.println("IOException error while trying to write accounts info to " + ACCOUNTS_INFO_FILEPATH + "!");
			return false;
		}
		
		System.out.println(accounts.size() + " accounts information written to " + ACCOUNTS_INFO_FILEPATH + ".");
		
		return true;
	}
	
	private static boolean removeAccount(String username) {
		int accIndex = getAccountIndex(username);
		if (accIndex == -1) return false;
		Account acc = (Account)accounts.get(accIndex);
		if (acc == null) return false;
		
		accounts.remove(accIndex);
		
		// if any user is connected to this account, kick him:
		for (int j = 0; j < clients.size(); j++) {
			if (((Client)clients.get(j)).account.user.equals(username)) {
				killClient((Client)clients.get(j));
			}
		}
		
		return true;
	}
	
	private static boolean addAccount(Account acc) {
		if (!Misc.isValidName(acc.user)) return false;
		if (!Misc.isValidName(acc.pass)) return false;
		
		for (int i = 0; i < accounts.size(); i++) {
			if (((Account)accounts.get(i)).user.equals(acc.user)) return false;
		}
		
		accounts.add(acc);
		return true;
	}
	
	private static Account findAccount(String username) {
		for (int i = 0; i < accounts.size(); i++)
			if (((Account)accounts.get(i)).user.equals(username)) return (Account)accounts.get(i);
		return null;
	}
	
	private static Account findAccountNoCase(String username) {
		for (int i = 0; i < accounts.size(); i++)
			if (((Account)accounts.get(i)).user.equalsIgnoreCase(username)) return (Account)accounts.get(i);
		return null;
	}
	
	private static void closeServerAndExit() {
		System.out.println("Closing server ...");
		
	    try {
			if (serverSocket != null) serverSocket.close();
			if (!LAN_MODE) saveAccountsInfoTimer.cancel();
        } catch (IOException e) {
            System.err.println("Error while trying to close server socket!");
        }		
		
		System.exit(0);
	}
	
	private static boolean startServer(int port) {
		try {
			serverSocket = new ServerSocket(port);
		} catch (IOException e) {
		    System.out.println("Could not listen on port: " + port);
		    return false;
		}
		
		System.out.println("Port " + port + " opened\n" +
				 "Listening for connections ...");
		return true;
	}
	
	private static Account verifyLogin(String user, String pass) {
		for (int i = 0; i < accounts.size(); i++) 
			if (((Account)accounts.get(i)).user.equals(user))
				if (((Account)accounts.get(i)).pass.equals(pass)) { 
					return (Account)accounts.get(i); 					
				} else break;
		
		return null;
	}
	
	private static boolean isUserAlreadyLoggedIn(Account acc) {
		for (int i = 0; i < clients.size(); i++) {
			if (((Client)clients.get(i)).account.user.equals(acc.user)) return true;
		}
		return false;
	}
	
	/* returns index of the channel with ChanName name or -1 if channel does not exist */
	private static int getChannelIndex(String chanName) {
		for (int i = 0; i < channels.size(); i++) {
			if (((Channel)channels.get(i)).name.equals(chanName)) return i;
		}
		return -1;
	}
	
	/* joins a clients to a channel with chanName name. If channel with that name
	 * does not exist, it is created. Method returns channel as a result. If client is
	 * already in the channel, it returns null as a result. */
	private static Channel joinChannel(String chanName, Client client) {
		int i = getChannelIndex(chanName);
		if (i == -1) {
			channels.add(new Channel(chanName));
			i = channels.size()-1; 
		} 
		else if (((Channel)channels.get(i)).isClientInThisChannel(client)) return null;
		
		((Channel)channels.get(i)).addClient(client);
		return (Channel)channels.get(i);
	}
	
	/* removes user from a channel and sends messages to all other clients in a channel.
	 * If this was the last client in the channel, then channel is removed from channels list. */
	private static boolean leaveChannelAndNotifyAll(Channel chan, Client client) {
		boolean result = chan.removeClient(client);
		
		if (result) {
			if (chan.clients.size() == 0) channels.remove(chan); // since channel is empty there is no point in keeping it in a channels list. If we would keep it, the channels list would grow larger and larger in time. We don't want that!
			else for (int i = 0; i < chan.clients.size(); i++) ((Client)chan.clients.get(i)).sendLine("LEFT " + chan.name + " " + client.account.user);
		} 
		
		return result;
	}
	
	/* sends information on all clients in a channel (and the topic if it is set) to the client */
	private static boolean sendChannelInfoToClient(Channel chan, Client client) {
		// it always sends info about at least one client - the one to whom this list must be sent
		String s = "CLIENTS " + chan.name;
		int c = 0;
		
		for (int j = 0; j < chan.clients.size(); j++) {
			s = s.concat(" " + ((Client)chan.clients.get(j)).account.user);
			c++;
			if (c > 10) { // 10 is the maximum number of users in a single line
				client.sendLine(s);
				s = "CLIENTS " + chan.name;
				c = 0;
			}
		}
		if (c > 0) {
			client.sendLine(s);
		}
			
		// send the topic:
		if (chan.isTopicSet()) client.sendLine("CHANNELTOPIC " + chan.name + " " + chan.getTopic());
		
		return true;
	}
	
	/* sends a list of all opened channels to client */
	private static boolean sendChannelListToClient(Client client) {
		if (channels.size() == 0) return true; // nothing to send
		
		String s = "CHANNELS";
		int c = 0;
		
		for (int j = 0; j < channels.size(); j++) {
			s = s.concat(" " + ((Channel)channels.get(j)).name);
			c++;
			if (c > 10) { // 10 is the maximum number of users in a single line
				client.sendLine(s);
				s = "CHANNELS ";
				c = 0;
			}
		}
		if (c > 0) {
			client.sendLine(s);
		}
			
		return true;
	}
	
	private static void sendToAllRegisteredUsers(String s) {
		for (int i = 0; i < clients.size(); i++) {
			if (((Client)clients.get(i)).account.accessLevel() < 1) continue;
			((Client)clients.get(i)).sendLine(s);
		}
	}
	
	/* sends text to all registered users except for the client */
	private static void sendToAllRegisteredUsersExcept(Client client, String s) {
		for (int i = 0; i < clients.size(); i++) {
			if (((Client)clients.get(i)).account.accessLevel() < 1) continue;
			if (((Client)clients.get(i)) == client) continue; 
			((Client)clients.get(i)).sendLine(s);
		}
	}
	
	private static void notifyClientsOfNewClientInChannel(Channel chan, Client client) {
		for (int i = 0; i < chan.clients.size(); i++) {
			if (((Client)chan.clients.get(i)).equals(client)) continue;
			((Client)chan.clients.get(i)).sendLine("JOINED " + chan.name + " " + client.account.user);
		}
	}
	
	/* notifies client of all statuses, including his own (but only if they are different from 0) */
	private static void sendInfoOnStatusesToClient(Client client) {
		for (int i = 0; i < clients.size(); i++) {
			if (((Client)clients.get(i)).account.accessLevel() < 1) continue;
			if (((Client)clients.get(i)).status != 0) // only send it if not 0. User assumes that every new user's status is 0, so we don't need to tell him that explicitly.
				client.sendLine("CLIENTSTATUS " + ((Client)clients.get(i)).account.user + " " + ((Client)clients.get(i)).status);
		}
			
	}
	
	/* notifies all registered clients (including this client) of the client's new status */
	private static void notifyClientsOfNewClientStatus(Client client) {
		for (int i = 0; i < clients.size(); i++) {
			if (((Client)clients.get(i)).account.accessLevel() < 1) continue;
			((Client)clients.get(i)).sendLine("CLIENTSTATUS " + client.account.user + " " + client.status);
		}
			
	}
	
	/* sends a list of all users connected to the server to client (this list includes
	 * the client itself, assuming he is already logged in and on the list) */
	private static void sentListOfAllUsersToClient(Client client) {
		for (int i = 0; i < clients.size(); i++) {
			if (((Client)clients.get(i)).account.accessLevel() < 1) continue;
			client.sendLine("ADDUSER " + ((Client)clients.get(i)).account.user + " " + ((Client)clients.get(i)).country + " " + ((Client)clients.get(i)).cpu);
		}
	}
	
	/* notifies all registered clients of a new client who just logged in. The new client
	 * is not notified (he is already notified by other method) */
	private static void notifyClientsOfNewClientOnServer(Client client) {
		for (int i = 0; i < clients.size(); i++) {
			if (((Client)clients.get(i)).account.accessLevel() < 1) continue;
			if ((Client)clients.get(i) == client) continue;
			((Client)clients.get(i)).sendLine("ADDUSER " + client.account.user + " " + client.country + " " + client.cpu);
		}
	}
	
	/*------------------------------------ BATTLE RELATED ------------------------------------*/
	
	private static void closeBattleAndNotifyAll(Battle battle) {
		for (int i = 0; i < battle.clients.size(); i++)
			((Client)battle.clients.get(i)).battleID = -1;
		battle.founder.battleID = -1;
		sendToAllRegisteredUsers("BATTLECLOSED " + battle.ID);
		battles.remove(battle);
	}
	
	/* Removes client from a battle and notifies everyone. Also automatically checks if 
	 * client is a founder and closes the battle in that case. All client's bots in this
	 * battle are removed as well. */	
	private static boolean leaveBattle(Client client, Battle battle) {
		if (battle.founder == client) closeBattleAndNotifyAll(battle);
		else {
			if (client.battleID != battle.ID) return false;
			if (!battle.removeClient(client)) return false;
			client.battleID = -1;
			battle.removeClientBots(client);
			sendToAllRegisteredUsers("LEFTBATTLE " + battle.ID + " " + client.account.user);
		}
		
		return true;
	}
	
	/* The client who just joined the battle is also notified (he should also be notified
	 * with JOINBATTLE command. See protocol description) */
	private static void notifyClientsOfNewClientInBattle(Battle battle, Client client) {
		for (int i = 0; i < clients.size(); i++)  {
			if (((Client)clients.get(i)).account.accessLevel() < 1) continue;
			((Client)clients.get(i)).sendLine("JOINEDBATTLE " + battle.ID + " " + client.account.user);
		}
	}
	
	private static void sendInfoOnBattlesToClient(Client client) {
		for (int i = 0; i < battles.size(); i++) {
			Battle bat = (Battle)battles.get(i);
			client.sendLine(bat.createBattleOpenedCommand());
			// we have to send UPDATEBATTLEINFO command too in order to tell the user how many spectators are in the battle, for example.
			client.sendLine("UPDATEBATTLEINFO " + bat.ID + " " + bat.spectatorCount() + " " + Misc.boolToStr(bat.locked) + " " + bat.mapName);
			for (int j = 0; j < bat.clients.size(); j++) {
				client.sendLine("JOINEDBATTLE " + bat.ID + " " + ((Client)bat.clients.get(j)).account.user);
			}
		}
	}
	
	/*------------------------------------ MISCELLANEOUS ------------------------------------*/
	
	private static Battle getBattle(int BattleID) {
		for (int i = 0; i < battles.size(); i++)
			if (((Battle)battles.get(i)).ID == BattleID) return (Battle)battles.get(i);
		return null;	
	}
	
	private static int getIndexOfClient(String user) {
		if (user.equals("")) return -1;
		for (int i = 0; i < clients.size(); i++) 
			if (((Client)clients.get(i)).account.user.equals(user)) return i;
		return -1;
	}
	
	private static Client getClient(String username) {
		for (int i = 0; i < clients.size(); i++)
			if (((Client)clients.get(i)).account.user.equals(username)) return (Client)clients.get(i);
		return null;	
	}

	private static int getAccountIndex(String username) {
		for (int i = 0; i < accounts.size(); i++)
			if (((Account)accounts.get(i)).user.equals(username)) return i;
		return -1;
	}
	
	private static Account getAccount(String username) {
		for (int i = 0; i < accounts.size(); i++)
			if (((Account)accounts.get(i)).user.equals(username)) return (Account)accounts.get(i);
		return null;
	}
	
	/* Sends "message of the day" (MOTD) to client */
	private static boolean sendMOTDToClient(Client client) {
		client.sendLine("MOTD Welcome, " + client.account.user + "!");
		client.sendLine("MOTD There are currently " + (clients.size()-1) + " clients connected"); // -1 is because we shouldn't count the client to which we are sending MOTD
		client.sendLine("MOTD to server talking in " + channels.size() + " open channels and");
		client.sendLine("MOTD participating in " + battles.size() + " battles.");
		client.sendLine("MOTD Server's uptime is " + Misc.timeToDHM(System.currentTimeMillis() - upTime) + ".");
		client.sendLine("MOTD");
		String[] sl = MOTD.split("\n");
		for (int i = 0; i < sl.length; i++) {
			client.sendLine("MOTD " + sl[i]);
		}

		return true;
	}
	
	/* the next method is synchronized so that only one ClientThread can call it at the same time.
	 * This is very important as other critical methods are called from within this method
	 * (I left those methods un-synchronized, because they get called ONLY by this method,
	 * which is synchronized).
	 */
	public static synchronized boolean tryToExecCommand(String command, Client client) {
		String[] commands = command.split(" ");
		commands[0] = commands[0].toUpperCase();
		
		if (DEBUG > 1) 
			if (client.account.accessLevel() != 0) System.out.println("[<-" + client.account.user + "]" + " \"" + command + "\"");
			else System.out.println("[<-" + client.IP + "]" + " \"" + command + "\"");
		
		
		if (commands[0].equals("PING")) {
			//***if (client.account.accessLevel() < 1) return false;
		
			client.sendLine("PONG");
		}
		if (commands[0].equals("REGISTER")) {
			if (commands.length != 3) {
				client.sendLine("REGISTRATIONDENIED Bad command arguments");
				return false;
			}
						
			if (client.account.accessLevel() != 0) { // only clients which aren't logged-in can register
				client.sendLine("REGISTRATIONDENIED You are already logged-in, no need to register new account");
				return false;
			}
			
			if (LAN_MODE) { // no need to register account in LAN mode since it accepts any username
				client.sendLine("REGISTRATIONDENIED Can't register in LAN-mode. Login with any username and password to proceed");
				return false;
			}
			
			if ((!Misc.isValidName(commands[1])) || (!Misc.isValidName(commands[2]))) {
				client.sendLine("REGISTRATIONDENIED Invalid username/password");
				return false;
			}
			
			if (commands[1].length() > 20) {
				client.sendLine("REGISTRATIONDENIED Too long username");
				return false;
			}
			
			if (commands[2].length() > 20) {
				client.sendLine("REGISTRATIONDENIED Too long password");
				return false;
			}
			 
			Account acc = findAccountNoCase(commands[1]);
			if (acc != null) {
				client.sendLine("REGISTRATIONDENIED Account already exists");
				return false;
			}
			
			acc = new Account(commands[1], commands[2], Account.getNormalAccess());
			accounts.add(acc);
			writeAccountsInfo(); // let's save new accounts info to disk
			client.sendLine("REGISTRATIONACCEPTED");
		}
		else if (commands[0].equals("UPTIME")) {
			if (client.account.accessLevel() < 1) return false;
			if (commands.length != 1) return false;
			
			client.sendLine("SERVERMSG Server's uptime is " + Misc.timeToDHM(System.currentTimeMillis() - upTime));
		}
		/* some admin specific commands: */
		else if (commands[0].equals("KICKUSER")) {
			if (client.account.accessLevel() < 3) return false;
			if (commands.length != 2) return false;
			
			Client target = getClient(commands[1]);
			if (target == null) return false;
			killClient(target);
		}
		else if (commands[0].equals("REMOVEACCOUNT")) {
			if (client.account.accessLevel() < 3) return false;
			if (commands.length != 2) return false;
			
			if (!removeAccount(commands[1])) return false;
			writeAccountsInfo(); // let's save new accounts info to disk
		}
		else if (commands[0].equals("STOPSERVER")) {
			if (client.account.accessLevel() < 3) return false;
			
			if (!LAN_MODE) writeAccountsInfo();
			
			closeServerAndExit();
		}
		else if (commands[0].equals("WRITEACCOUNTSINFO")) {
			if (client.account.accessLevel() < 3) return false;
			
			writeAccountsInfo();
			client.sendLine("SERVERMSG Accounts info successfully saved to disk");
		}
		else if (commands[0].equals("CHANGEACCOUNTPASS")) {
			if (client.account.accessLevel() < 3) return false;
			if (commands.length != 3) return false;
			
			Account acc = getAccount(commands[1]);
			if (acc == null) return false; 
			if (!Misc.isValidName(commands[2])) return false;
			
			acc.pass = commands[2];
			
			writeAccountsInfo(); // save changes
		}
		else if (commands[0].equals("CHANGEACCOUNTACCESS")) {
			if (client.account.accessLevel() < 3) return false;
			if (commands.length != 3) return false;

			int value;
			try {
				value = Integer.parseInt(commands[2]); 
			} catch (NumberFormatException e) {
				return false; 
			}
			
			Account acc = getAccount(commands[1]);
			if (acc == null) return false; 
			
			acc.access = value;
			
			writeAccountsInfo(); // save changes
			 // just in case if rank changed:
			client.status = Misc.setRankToStatus(client.status, client.account.getRank());
			notifyClientsOfNewClientStatus(client);
		}
		else if (commands[0].equals("GETACCOUNTACCESS")) {
			if (client.account.accessLevel() < 3) return false;
			if (commands.length != 2) return false;

			Account acc = getAccount(commands[1]);
			if (acc == null) return false;
			
			client.sendLine("SERVERMSG " + commands[1] + "'s access code is " + acc.access);
		}
		else if (commands[0].equals("REDIRECT")) {
			if (client.account.accessLevel() < 3) return false;
			if (commands.length != 2) return false;

			redirectToIP = commands[1];
			redirect = true;
			sendToAllRegisteredUsers("BROADCAST " + "Server has entered redirection mode");
		}
		else if (commands[0].equals("BROADCAST")) {
			if (client.account.accessLevel() < 3) return false;
			if (commands.length < 2) return false;

			sendToAllRegisteredUsers("BROADCAST " + Misc.makeSentence(commands, 1));
		}
		else if (commands[0].equals("BROADCASTEX")) {
			if (client.account.accessLevel() < 3) return false;
			if (commands.length < 2) return false;

			sendToAllRegisteredUsers("SERVERMSGBOX " + Misc.makeSentence(commands, 1));
		}
		else if (commands[0].equals("REDIRECTOFF")) {
			if (client.account.accessLevel() < 3) return false;
			if (commands.length != 2) return false;

			redirect = false;
			sendToAllRegisteredUsers("BROADCAST " + "Server has left redirection mode");
		}
		else if (commands[0].equals("GETACCOUNTCOUNT")) {
			if (client.account.accessLevel() < 3) return false;
			if (commands.length != 1) return false;

			client.sendLine("SERVERMSG " + accounts.size());
		}
		else if (commands[0].equals("FINDACCOUNT")) {
			if (client.account.accessLevel() < 3) return false;
			if (commands.length != 2) return false;
			
			int index = getAccountIndex(commands[1]);
			
			client.sendLine("SERVERMSG " + commands[1] + "'s account index: " + index);
		}
		else if (commands[0].equals("FINDIP")) {
			if (client.account.accessLevel() < 3) return false;
			if (commands.length != 2) return false;
			
			boolean found = false;
			for (int i = 0; i < clients.size(); i++)
				if (((Client)clients.get(i)).IP.equals(commands[1])) {
					found = true;
					client.sendLine("SERVERMSG " + commands[1] + " is bound to: "+ ((Client)clients.get(i)).account.user);
				}
				
			if (!found) client.sendLine("SERVERMSG No client is using IP: " + commands[1]);
		}
		else if (commands[0].equals("GETACCOUNTINFO")) {
			if (client.account.accessLevel() < 3) return false;
			if (commands.length != 2) return false;
			
			int index;
			try {
				index = Integer.parseInt(commands[1]); 
			} catch (NumberFormatException e) {
				return false; 
			}
			if (index >= accounts.size()) return false;

			client.sendLine("SERVERMSG " + "Account #" + index + " info: " + ((Account)accounts.get(index)).user + " " + ((Account)accounts.get(index)).pass + " " + ((Account)accounts.get(index)).access);
		}
		else if (commands[0].equals("FORGEMSG")) {
			/* this is a command used only for debugging purposes. It sends the string
			 * to client specified as first argument. */
			if (client.account.accessLevel() < 3) return false;
			if (commands.length < 3) return false;
			
			Client targetClient = getClient(commands[1]);
			if (targetClient == null) return false;
			
			targetClient.sendLine(Misc.makeSentence(commands, 2));
		}
		else if (commands[0].equals("GETIP")) {
			if (client.account.accessLevel() < 3) return false;
			if (commands.length != 2) return false;
		
			Client targetClient = getClient(commands[1]);
			if (targetClient == null) return false;
			
			client.sendLine("SERVERMSG " + targetClient.account.user + "'s IP is " + targetClient.IP);
		}
		else if (commands[0].equals("FORCECLOSEBATTLE")) {
			if (client.account.accessLevel() < 3) return false;
			if (commands.length != 2) return false;

			int battleID;
			try {
				battleID = Integer.parseInt(commands[1]); 
			} catch (NumberFormatException e) {
				client.sendLine("SERVERMSG Invalid BattleID!");
				return false; 
			}
			
			Battle bat = getBattle(battleID);
			if (bat == null) {
				client.sendLine("SERVERMSG Error: unknown BATTLE_ID!");
				return false;
			}
			
			closeBattleAndNotifyAll(bat);
			
		}
		else if (commands[0].equals("BANLISTADD")) {
			if (client.account.accessLevel() < 3) return false;
			if (commands.length != 2) return false;

			banList.add(commands[1]);
			writeBanList(BAN_LIST_FILENAME);
			
			client.sendLine("SERVERMSG IP " + commands[1] + " has been added to ban list. Use KICKUSER to kick user from server.");
		}
		else if (commands[0].equals("BANLISTREMOVE")) {
			if (client.account.accessLevel() < 3) return false;
			if (commands.length != 2) return false;

			int index;
			boolean found = false;
			while (true) {
				for (int i = 0; i < banList.size(); i++) 
					if (((String)banList.get(i)).equals(commands[1])) {
						found = true;
						banList.remove(i);
						continue;
					}
				break;	
			}
			writeBanList(BAN_LIST_FILENAME);

			if (found) client.sendLine("SERVERMSG IP " + commands[1] + " has been removed from ban list.");
			else client.sendLine("SERVERMSG IP " + commands[1] + " couldn't be found in ban list!");
		}
		else if (commands[0].equals("BANLIST")) {
			if (client.account.accessLevel() < 3) return false;
			if (commands.length != 1) return false;

			if (banList.size() == 0) client.sendLine("SERVERMSG Ban list is empty!");
			else {
				client.sendLine("SERVERMSG Ban list (" + banList.size() + " entries):");
				for (int i = 0; i < banList.size(); i++)
					client.sendLine("SERVERMSG * " + (String)banList.get(i));
				client.sendLine("SERVERMSG End of ban list.");
			}
		}
		else if (commands[0].equals("CHANNELS")) {
			if (client.account.accessLevel() < 1) return false;
			
			sendChannelListToClient(client);
		}
		else if (commands[0].equals("REQUESTUPDATEFILE")) {
			//***if (client.account.accessLevel() > 0) return false;
			if (commands.length != 2) return false;
			
			String version = commands[1];
			
			if (version.equals("0.12")) {
				client.sendLine("SERVERMSGBOX Your lobby client is outdated! Please update from: http://taspring.clan-sy.com/download.php");
				killClient(client);
				return false;
			} else if (version.equals("0.121")) {
				client.sendLine("SERVERMSGBOX Your lobby client is outdated! Please update from: http://taspring.clan-sy.com/download.php");
				killClient(client);
				return false;
			} else if (version.equals("test")) {
				int index = getArchiveFileIndex("test.jpg");
				if (index == -1) {
					client.sendLine("SERVERMSGBOX No update available for your version of lobby. See official spring web site to get the latest lobby client!");
					killClient(client);
					return false;
				}
				client.sendLine("OFFERUPDATE " + ((ArchiveFile)archiveList.get(index)).getFileSize() + " " + ((ArchiveFile)archiveList.get(index)).getFilename() + "\t" + "This is only a test. It is not an executable file, it is a simple .jpg picture which is harmless. Note: All files are checked for viruses and are considered to be safe.");
			} else if (version.equals("test2")) {
				int index = getArchiveFileIndex("test2.jpg");
				if (index == -1) {
					client.sendLine("SERVERMSGBOX No update available for your version of lobby. See official spring web site to get the latest lobby client!");
					killClient(client);
					return false;
				}
				client.sendLine("OFFERUPDATE " + ((ArchiveFile)archiveList.get(index)).getFileSize() + " " + ((ArchiveFile)archiveList.get(index)).getFilename() + "\t" + "This is only a test. It is not an executable file, it is a simple .jpg picture which is harmless. Note: All files are checked for viruses and are considered to be safe.");
			} else if (version.equals("0.13")) {
				int index = getArchiveFileIndex("patch_013_0141.exe");
				if (index == -1) {
					client.sendLine("SERVERMSGBOX No update available for your version of lobby. See official spring web site to get the latest lobby client!");
					killClient(client);
					return false;
				}
				client.sendLine("OFFERUPDATE " + ((ArchiveFile)archiveList.get(index)).getFileSize() + " " + ((ArchiveFile)archiveList.get(index)).getFilename() + "\t" + "This is an update from version 0.13 to 0.141. Please update your client immediately. After you have run the patch file you must close TASClient.exe in order for the changes to take effect. Note: All files are checked for viruses and are considered to be safe.");
			} else if (version.equals("0.14")) {
				int index = getArchiveFileIndex("patch_014_0141.exe");
				if (index == -1) {
					client.sendLine("SERVERMSGBOX No update available for your version of lobby. See official spring web site to get the latest lobby client!");
					killClient(client);
					return false;
				}
				client.sendLine("OFFERUPDATE " + ((ArchiveFile)archiveList.get(index)).getFileSize() + " " + ((ArchiveFile)archiveList.get(index)).getFilename() + "\t" + "This is a \"hotfix\" which fixes a problem with 0.14 client. Please update your client immediately. After you have run the patch file you must close TASClient.exe in order for the changes to take effect. Note: All files are checked for viruses and are considered to be safe.");
			} else if (version.equals("0.15")) {
				int index = getArchiveFileIndex("patch_015_0151.exe");
				if (index == -1) {
					client.sendLine("SERVERMSGBOX No update available for your version of lobby. Please download the latest update from the Spring web site.");
					killClient(client);
					return false;
				}
				client.sendLine("OFFERUPDATE " + ((ArchiveFile)archiveList.get(index)).getFileSize() + " " + ((ArchiveFile)archiveList.get(index)).getFilename() + "\t" + "This is a \"hotfix\" which fixes several issues with 0.15 client. Please update your client immediately. Note: All files are checked for viruses and are considered to be safe.");
			} else { // unknown client version
				client.sendLine("SERVERMSGBOX No update available for your version of lobby. See official spring web site to get the latest lobby client!");
				killClient(client);
			}
		
			//*** not implemented yet;

		}
		else if (commands[0].equals("GETFILE")) {
			if (commands.length < 2) return false;
			
			String filename = Misc.makeSentence(commands, 1);
			
			if (client.sendingFile) {
				//*** should I instead use SERVERMSGBOX?
				client.sendLine("GEFILEFAILED " + "You are not allowed to make multiple file requests at the same time!");
				return false;
			}
			 
			int index = getArchiveFileIndex(filename);
			if (index == -1) {
				client.sendLine("GEFILEFAILED " + "File could not be found on the server: " + filename);
				return false;
			}
			 
			new SendFileThread(client, (ArchiveFile)archiveList.get(index), 3).start();
		}
		else if (commands[0].equals("CANCELTRANSFER")) {
			if (commands.length != 1) return false;
			client.cancelTransfer = true; // signal the SendFileThread that it should stop sending the file
		}
		else if (commands[0].equals("LOGIN")) {
			if (client.account.accessLevel() != 0) {
				client.sendLine("DENIED Already logged in");
				return false; // user with accessLevel > 0 cannot re-login
			}
			
			if (commands.length != 4) {
				client.sendLine("DENIED Bad command arguments");
				return false;
			}
			
			int cpu;
			try {
				cpu = Integer.parseInt(commands[3]); 
			} catch (NumberFormatException e) {
				client.sendLine("DENIED <cpu> field should be an integer");
				return false; 
			}
			
			if (!LAN_MODE) { // "normal", non-LAN mode
				Account acc = verifyLogin(commands[1], commands[2]);
				if (acc == null) {
					client.sendLine("DENIED Bad username/password");
					return false;
				}
				if (!isUserAlreadyLoggedIn(acc)) {
					client.account = acc;
				} else {
					client.sendLine("DENIED Already logged in");
					return false;
				}
				if (banned(client.IP)) {
					client.sendLine("DENIED You are banned from this server! Contact server administrator.");
					return false;
				}
				// everything is OK, let's update client's rank:
				client.status = Misc.setRankToStatus(client.status, client.account.getRank());
			} else { // LAN_MODE == true
				Account acc = findAccount(commands[1]);
				if (acc != null) {
					client.sendLine("DENIED Player with same name already logged in");
					return false;
				}
				acc = new Account(commands[1], commands[2], Account.getPrivilegedAccess());
				accounts.add(acc);
				client.account = acc;
			}
			
			client.status = Misc.setRankToStatus(client.status, client.account.getRank());
			client.cpu = cpu;
			
			// do the notifying and all: 
			client.sendLine("ACCEPTED " + client.account.user);
			sendMOTDToClient(client);
			sentListOfAllUsersToClient(client);
			sendInfoOnBattlesToClient(client);
			sendInfoOnStatusesToClient(client);
			notifyClientsOfNewClientOnServer(client);

			// we have to notify everyone about client's status to let them know about his rank:
			notifyClientsOfNewClientStatus(client);
			
			if (DEBUG > 0) System.out.println("User just logged in: " + client.account.user);
		}
		else if (commands[0].equals("JOIN")) {
			if (commands.length < 2) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (!Misc.isValidName(commands[1])) {
				client.sendLine("JOINFAILED " + commands[1] + " Bad channel name!");
				return false;
			}
			
			Channel chan = joinChannel(commands[1], client);
			if (chan == null) {
				client.sendLine("JOINFAILED " + commands[1] + " Already in the channel!");
				return false;
			}
			client.sendLine("JOIN " + commands[1]);
			sendChannelInfoToClient(chan, client);
			notifyClientsOfNewClientInChannel(chan, client);
		}
		else if (commands[0].equals("LEAVE")) {
			if (commands.length < 2) return false;
			if (client.account.accessLevel() < 1) return false;
			
			int i = getChannelIndex(commands[1]);
			if (i == -1) return false;
			
			leaveChannelAndNotifyAll((Channel)channels.get(i), client);
		}
		else if (commands[0].equals("CHANNELTOPIC")) {
			if (commands.length < 3) return false;
			if (client.account.accessLevel() < 2) return false;
			
			int i = getChannelIndex(commands[1]);
			if (i == -1) return false;
			
			if (!((Channel)channels.get(i)).setTopic(Misc.makeSentence(commands, 2))) {
				client.sendLine("SERVERMSG You've just disabled the topic for channel #" + ((Channel)channels.get(i)).name);	
			} else {
				client.sendLine("SERVERMSG You've just changed the topic for channel #" + ((Channel)channels.get(i)).name);				
				((Channel)channels.get(i)).sendLineToClients("CHANNELTOPIC " + ((Channel)channels.get(i)).name + " " + ((Channel)channels.get(i)).getTopic());
			}
		}
		else if (commands[0].equals("SAY")) {
			if (commands.length < 3) return false;
			if (client.account.accessLevel() < 1) return false;
			
			int i = getChannelIndex(commands[1]);
			if (i == -1) return false;
			
			String s = Misc.makeSentence(commands, 2);
			((Channel)channels.get(i)).sendLineToClients("SAID " + ((Channel)channels.get(i)).name + " " + client.account.user + " " + s);
		}
		else if (commands[0].equals("SAYEX")) {
			if (commands.length < 3) return false;
			if (client.account.accessLevel() < 1) return false;
			
			int i = getChannelIndex(commands[1]);
			if (i == -1) return false;
			
			String s = Misc.makeSentence(commands, 2);
			((Channel)channels.get(i)).sendLineToClients("SAIDEX " + ((Channel)channels.get(i)).name + " " + client.account.user + " " + s);
		}
		else if (commands[0].equals("SAYPRIVATE")) {
			if (commands.length < 3) return false;
			if (client.account.accessLevel() < 1) return false;
			
			int i = getIndexOfClient(commands[1]);
			if (i == -1) return false;
			
			String s = Misc.makeSentence(commands, 2);
			((Client)clients.get(i)).sendLine("SAIDPRIVATE " + client.account.user + " " + s);
			client.sendLine(command); // echo the command. See protocol description!
		}
		else if (commands[0].equals("JOINBATTLE")) {
			if (commands.length < 2) return false; // requires 1 or 2 arguments (password is optional)
			if (client.account.accessLevel() < 1) return false;
			
			int battleID;
			
			try {
				battleID = Integer.parseInt(commands[1]); 
			} catch (NumberFormatException e) {
				client.sendLine("JOINBATTLEFAILED " + "No battle ID!");
				return false; 
			}
			
			if (client.battleID != -1) { // can't join a battle if already participating in another battle
				client.sendLine("JOINBATTLEFAILED " + "Cannot participate in multiple battles at the same time!");
				return false; 
			}
			
			Battle bat = getBattle(battleID);
			
			if (bat == null) { 
				client.sendLine("JOINBATTLEFAILED " + "Invalid battle ID!");
				return false; 
			}
			
			if (bat.restricted()) {
				if (commands.length < 3) {
					client.sendLine("JOINBATTLEFAILED " + "Password required");
					return false; 
				}
				
				if (!bat.password.equals(commands[2])) {
					client.sendLine("JOINBATTLEFAILED " + "Invalid password");
					return false; 
				}
			}

			// do the actually joining and notifying:
			client.battleStatus = 0; // reset client's battle status
			client.battleID = battleID;
			bat.addClient(client);
		 	client.sendLine("JOINBATTLE " + bat.ID + " " + bat.metal + " " + bat.energy + " " + bat.units + " " + bat.startPos + " " + bat.gameEndCondition + " " + Misc.boolToStr(bat.limitDGun)+ " " + Misc.boolToStr(bat.diminishingMMs) + " " + bat.hashCode); // notify client that he has successfully joined the battle
			notifyClientsOfNewClientInBattle(bat, client);
			bat.notifyOfBattleStatuses(client);
			bat.sendBotListToClient(client);
			
			client.sendLine("REQUESTBATTLESTATUS");
			bat.sendDisabledUnitsListToClient(client);
			bat.sendStartRectsListToClient(client);
			
			if (bat.type == 1) bat.sendScriptToClient(client);

		}
		else if (commands[0].equals("LEAVEBATTLE")) {
			if (commands.length != 1) return false;
			if (client.account.accessLevel() < 1) return false;

			if (client.battleID == -1) return false;
			Battle bat = getBattle(client.battleID);
			if (bat == null) {
				System.out.println("Serious error occured: Invalid battle ID. Server will now exit!");
				closeServerAndExit();
			}
			leaveBattle(client, bat); // automatically checks if client is a founder and closes battle
		}
		else if (commands[0].equals("OPENBATTLE")) {
			if (client.account.accessLevel() < 1) return false;
			Battle bat = Battle.createBattleFromString(command, client);
			if (bat == null) {
				client.sendLine("OPENBATTLEFAILED " + "Invalid command format or bad arguments");
				return false;
			}
			battles.add(bat);
			client.battleStatus = 0; // reset client's battle status
			client.battleID = bat.ID;
			sendToAllRegisteredUsers(bat.createBattleOpenedCommand());
			client.sendLine("OPENBATTLE " + bat.ID); // notify client that he successfully opened a new battle
			client.sendLine("REQUESTBATTLESTATUS");
		}		
		else if (commands[0].equals("MYBATTLESTATUS")) {
			if (commands.length != 2) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;

			Battle bat = getBattle(client.battleID);
			if (bat == null) return false;
			
			int newStatus;
			try {
				newStatus = Integer.parseInt(commands[1]);
			} catch (NumberFormatException e) {
				return false; 
			}
			// update new battle status. Note: we ignore handicap value as it can be changed only by founder with HANDICAP command!
			client.battleStatus = Misc.setHandicapOfBattleStatus(newStatus, Misc.getHandicapFromBattleStatus(client.battleStatus));
			
			// if game is full or game type is "battle replay", force player's mode to spectator:
			if ((bat.clients.size()+1-bat.spectatorCount() > bat.maxPlayers) || (bat.type == 1)) {
				client.battleStatus = Misc.setModeOfBattleStatus(client.battleStatus, 0);
			}
			// if player has chosen team number which is already used by some other player/bot,
			// force his ally number and team color to be the same as of that player/bot:
			if (bat.founder != client)
				if ((Misc.getTeamNoFromBattleStatus(bat.founder.battleStatus) == Misc.getTeamNoFromBattleStatus(client.battleStatus)) && (Misc.getModeFromBattleStatus(bat.founder.battleStatus) != 0)) {
					client.battleStatus = Misc.setAllyNoOfBattleStatus(client.battleStatus, Misc.getAllyNoFromBattleStatus(bat.founder.battleStatus));
					client.battleStatus = Misc.setTeamColorOfBattleStatus(client.battleStatus, Misc.getTeamColorFromBattleStatus(bat.founder.battleStatus));
				} 
			for (int i = 0; i < bat.clients.size(); i++)
				if (((Client)bat.clients.get(i)) != client)
					if ((Misc.getTeamNoFromBattleStatus(((Client)bat.clients.get(i)).battleStatus) == Misc.getTeamNoFromBattleStatus(client.battleStatus)) && (Misc.getModeFromBattleStatus(((Client)bat.clients.get(i)).battleStatus) != 0)) {
						client.battleStatus = Misc.setAllyNoOfBattleStatus(client.battleStatus, Misc.getAllyNoFromBattleStatus(((Client)bat.clients.get(i)).battleStatus));
						client.battleStatus = Misc.setTeamColorOfBattleStatus(client.battleStatus, Misc.getTeamColorFromBattleStatus(((Client)bat.clients.get(i)).battleStatus));
						break;
					}
			for (int i = 0; i < bat.bots.size(); i++)
				if (Misc.getTeamNoFromBattleStatus(((Bot)bat.bots.get(i)).battleStatus) == Misc.getTeamNoFromBattleStatus(client.battleStatus)) {
					client.battleStatus = Misc.setAllyNoOfBattleStatus(client.battleStatus, Misc.getAllyNoFromBattleStatus(((Bot)bat.bots.get(i)).battleStatus));
					client.battleStatus = Misc.setTeamColorOfBattleStatus(client.battleStatus, Misc.getTeamColorFromBattleStatus(((Bot)bat.bots.get(i)).battleStatus));
					break;
				}
					
			bat.notifyClientsOfBattleStatus(client);
		}
		else if (commands[0].equals("MYSTATUS")) {
			if (commands.length != 2) return false;
			if (client.account.accessLevel() < 1) return false;
			
			int newStatus;
			try {
				newStatus = Integer.parseInt(commands[1]);
			} catch (NumberFormatException e) {
				return false; 
			}

			// we must preserve rank bits (client is not allowed to change them himself):
			int tmp = Misc.getRankFromStatus(client.status);
			int tmp2 = Misc.getInGameFromStatus(client.status);
			client.status = Misc.setRankToStatus(newStatus, tmp);
			if (Misc.getInGameFromStatus(client.status) != tmp2) {
				// user changed his in-game status.
				if (tmp2 == 0) { // client just entered game
					if ((client.battleID != -1) && (getBattle(client.battleID).clients.size() > 0))
							client.inGameTime = System.currentTimeMillis();
					else client.inGameTime = 0; // we won't update clients who play by themselves (or with bots), since some try to exploit the system by leaving computer alone in-battle for hours to increase their ranks
				} else { // back from game
					if (client.inGameTime != 0) { // we won't update clients who play by themselves (or with bots), since some try to exploit the system by leaving computer alone in-battle for hours to increase their ranks 
						int diff = new Long((System.currentTimeMillis() - client.inGameTime) / 60000).intValue(); // in minutes
						if (client.account.addMinsToInGameTime(diff)) {
							client.status = Misc.setRankToStatus(client.status, client.account.getRank());
						}
					}
				}
			}
			notifyClientsOfNewClientStatus(client);
		}
		else if (commands[0].equals("SAYBATTLE")) {
			if (commands.length < 2) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			Battle bat = getBattle(client.battleID);
			if (bat == null) return false;
			
			bat.sendToAllClients("SAIDBATTLE " + client.account.user + " " + Misc.makeSentence(commands, 1));
		}
		else if (commands[0].equals("SAYBATTLEEX")) {
			if (commands.length < 2) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			Battle bat = getBattle(client.battleID);
			if (bat == null) return false;
			
			bat.sendToAllClients("SAIDBATTLEEX " + client.account.user + " " + Misc.makeSentence(commands, 1));
		}
		else if (commands[0].equals("UPDATEBATTLEINFO")) {
			if (commands.length < 4) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			Battle bat = getBattle(client.battleID);
			if (bat == null) return false;
			if (bat.founder != client) return false; // only founder may change battle parameters!
			
			int spectatorCount = 0;
			boolean locked;
			try {
				spectatorCount = Integer.parseInt(commands[1]);
				locked = Misc.strToBool(commands[2]);
			} catch (NumberFormatException e) {
				return false; 
			}
			
			bat.mapName = Misc.makeSentence(commands, 3);
			bat.locked = locked;
			sendToAllRegisteredUsers("UPDATEBATTLEINFO " + bat.ID + " " + spectatorCount + " " + Misc.boolToStr(bat.locked) + " " + bat.mapName);
		}
		else if (commands[0].equals("UPDATEBATTLEDETAILS")) {
			if (commands.length != 8) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			Battle bat = getBattle(client.battleID);
			if (bat == null) return false;
			if (bat.founder != client) return false; // only founder may change battle parameters!

			int metal;
			int energy;
			int units;
			int startPos;
			int gameEndCondition;
			boolean limitDGun;
			boolean diminishingMMs;
			try {
				metal = Integer.parseInt(commands[1]);
				energy = Integer.parseInt(commands[2]);
				units = Integer.parseInt(commands[3]); 
				startPos = Integer.parseInt(commands[4]);
				gameEndCondition = Integer.parseInt(commands[5]);
				limitDGun = Misc.strToBool(commands[6]);
				diminishingMMs = Misc.strToBool(commands[7]);
			} catch (NumberFormatException e) {
				return false; 
			}
			if ((startPos < 0) || (startPos > 2)) return false;
			if ((gameEndCondition < 0) || (gameEndCondition > 1)) return false;
			
			
			bat.metal = metal;
			bat.energy = energy;
			bat.units = units;
			bat.startPos = startPos;
			bat.gameEndCondition = gameEndCondition;
			bat.limitDGun = limitDGun;
			bat.diminishingMMs = diminishingMMs;
			bat.sendToAllClients("UPDATEBATTLEDETAILS " + bat.metal + " " + bat.energy + " " + bat.units + " " + bat.startPos + " " + bat.gameEndCondition + " " + Misc.boolToStr(bat.limitDGun) + " " + Misc.boolToStr(bat.diminishingMMs));
		}
		else if (commands[0].equals("HANDICAP")) {
			if (commands.length != 3) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			Battle bat = getBattle(client.battleID);
			if (bat == null) return false;
			if (bat.founder != client) return false; // only founder can change handicap value of another user
			
			int value;
			try {
				value = Integer.parseInt(commands[2]);
			} catch (NumberFormatException e) {
				return false; 
			}
			if ((value < 0) || (value > 100)) return false;

			int tmp = getIndexOfClient(commands[1]);
			if (tmp == -1) return false;
			Client targetClient = (Client)clients.get(tmp);
			
			if (!bat.isClientInBattle(targetClient)) return false;
			
			targetClient.battleStatus = Misc.setHandicapOfBattleStatus(targetClient.battleStatus, value); 
			bat.notifyClientsOfBattleStatus(targetClient);
		}
		else if (commands[0].equals("KICKFROMBATTLE")) {
			if (commands.length != 2) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			Battle bat = getBattle(client.battleID);
			if (bat == null) return false;
			if (bat.founder != client) return false; // only founder can kick other clients
			
			int tmp = getIndexOfClient(commands[1]);
			if (tmp == -1) return false;
			Client targetClient = (Client)clients.get(tmp);
			
			if (!bat.isClientInBattle(targetClient)) return false;
			bat.sendToAllClients("SAIDBATTLEEX " + client.account.user + " kicked " + targetClient.account.user + " from battle");
			targetClient.sendLine("FORCEQUITBATTLE");
		}
		else if (commands[0].equals("FORCETEAMNO")) {
			if (commands.length != 3) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			Battle bat = getBattle(client.battleID);
			if (bat == null) return false;
			if (bat.founder != client) return false; // only founder can force team/ally numbers
			
			int value;
			try {
				value = Integer.parseInt(commands[2]);
			} catch (NumberFormatException e) {
				return false; 
			}
			if ((value < 0) || (value > 9)) return false;
			
			int tmp = getIndexOfClient(commands[1]); 
			if (tmp == -1) return false;
			Client targetClient = (Client)clients.get(tmp);
			
			if (!bat.isClientInBattle(targetClient)) return false;
			
			targetClient.battleStatus = Misc.setTeamNoOfBattleStatus(targetClient.battleStatus, value);
			bat.notifyClientsOfBattleStatus(targetClient); 
		}
		else if (commands[0].equals("FORCEALLYNO")) {
			if (commands.length != 3) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			Battle bat = getBattle(client.battleID);
			if (bat == null) return false;
			if (bat.founder != client) return false; // only founder can force team/ally numbers
			
			int value;
			try {
				value = Integer.parseInt(commands[2]);
			} catch (NumberFormatException e) {
				return false; 
			}
			if ((value < 0) || (value > 9)) return false;
			
			int tmp = getIndexOfClient(commands[1]); 
			if (tmp == -1) return false;
			Client targetClient = (Client)clients.get(tmp);
			
			if (!bat.isClientInBattle(targetClient)) return false;
			
			targetClient.battleStatus = Misc.setAllyNoOfBattleStatus(targetClient.battleStatus, value);
			bat.notifyClientsOfBattleStatus(targetClient); 
		}		
		else if (commands[0].equals("FORCETEAMCOLOR")) {
			if (commands.length != 3) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			Battle bat = getBattle(client.battleID);
			if (bat == null) return false;
			if (bat.founder != client) return false; // only founder can force team color change
			
			int value;
			try {
				value = Integer.parseInt(commands[2]);
			} catch (NumberFormatException e) {
				return false; 
			}
			if ((value < 0) || (value > 9)) return false;
			
			int tmp = getIndexOfClient(commands[1]); 
			if (tmp == -1) return false;
			Client targetClient = (Client)clients.get(tmp);
			
			if (!bat.isClientInBattle(targetClient)) return false;
			
			targetClient.battleStatus = Misc.setTeamColorOfBattleStatus(targetClient.battleStatus, value);
			bat.notifyClientsOfBattleStatus(targetClient); 
		}		
		else if (commands[0].equals("ADDBOT")) {
			if (commands.length < 4) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			
			Battle bat = getBattle(client.battleID);
			if (bat == null) {
				System.out.println("Serious error occured: Invalid battle ID. Server will now exit!");
				closeServerAndExit();
			}
			
			int value;
			try {
				value = Integer.parseInt(commands[2]); 
			} catch (NumberFormatException e) {
				return false; 
			}
			
			if (!Misc.isValidName(commands[1])) {
				client.sendLine("SERVERMSGBOX Bad bot name. Try another!");
				return false;
			}
			
			if (bat.getBot(commands[1]) != -1) {
				client.sendLine("SERVERMSGBOX Bot name already assigned. Choose another!");
				return false;
			}

			Bot bot = new Bot(commands[1], client.account.user, Misc.makeSentence(commands, 3), value);
			bat.bots.add(bot);
			
			bat.sendToAllClients("ADDBOT " + bat.ID + " " + bot.name + " " + client.account.user + " " + bot.battleStatus + " " + bot.AIDll);
			
		}
		else if (commands[0].equals("REMOVEBOT")) {
			if (commands.length != 2) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			
			Battle bat = getBattle(client.battleID);
			if (bat == null) {
				System.out.println("Serious error occured: Invalid battle ID. Server will now exit!");
				closeServerAndExit();
			}
			
			int index = bat.getBot(commands[1]);
			if (index == -1) return false;
			
			Bot bot = (Bot)bat.bots.get(index);
			bat.bots.remove(index);
			
			bat.sendToAllClients("REMOVEBOT " + bat.ID + " " + bot.name);
		}
		else if (commands[0].equals("UPDATEBOT")) {
			if (commands.length != 3) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			
			Battle bat = getBattle(client.battleID);
			if (bat == null) {
				System.out.println("Serious error occured: Invalid battle ID. Server will now exit!");
				closeServerAndExit();
			}
			
			int index = bat.getBot(commands[1]);
			if (index == -1) return false;
			
			Bot bot = (Bot)bat.bots.get(index);

			int value;
			try {
				value = Integer.parseInt(commands[2]); 
			} catch (NumberFormatException e) {
				return false; 
			}
			
			// only bot owner and battle host are allowed to update bot: 
			if (!((client.account.user.equals(bot.ownerName)) || (client.account.user.equals(bat.founder.account.user)))) return false; 
					
			bot.battleStatus = value;

			//*** add: force ally and color number if someone else is using his team number already 
			
			bat.sendToAllClients("UPDATEBOT " + bat.ID + " " + bot.name + " " + bot.battleStatus);
		}
		else if (commands[0].equals("DISABLEUNITS")) {
			if (commands.length < 2) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			Battle bat = getBattle(client.battleID);
			if (bat == null) return false;
			if (bat.founder != client) return false; // only founder can disable/enable units

			// let's check if client didn't double the data (he shouldn't, but we can't
			// trust him, so we will check ourselves):
			for (int i = 1; i < commands.length; i++) {
				if (bat.getUnitIndexInDisabledList(commands[i]) != -1) continue;
				bat.disabledUnits.add(commands[i]);
			}
			
			bat.sendToAllExceptFounder(command);
		}		
		else if (commands[0].equals("ENABLEUNITS")) {
			if (commands.length < 2) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			Battle bat = getBattle(client.battleID);
			if (bat == null) return false;
			if (bat.founder != client) return false; // only founder can disable/enable units

			int tmp;
			for (int i = 1; i < commands.length; i++) {
				tmp = bat.getUnitIndexInDisabledList(commands[i]);
				if (tmp == -1) continue; // let's just ignore this unit
				bat.disabledUnits.remove(tmp);
			}
			
			bat.sendToAllExceptFounder(command);
		}		
		else if (commands[0].equals("ENABLEALLUNITS")) {
			if (commands.length != 1) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			Battle bat = getBattle(client.battleID);
			if (bat == null) return false;
			if (bat.founder != client) return false; // only founder can disable/enable units

			bat.disabledUnits.clear();
			
			bat.sendToAllExceptFounder(command);
		}		
		else if (commands[0].equals("RING")) {
			if (commands.length != 2) return false;
			if (client.account.accessLevel() < 2) return false;
			
			Client targetClient = getClient(commands[1]);
			if (targetClient == null) return false;
			
			targetClient.sendLine("RING " + client.account.user);
		}
		else if (commands[0].equals("ADDSTARTRECT")) {
			if (commands.length != 6) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			
			Battle bat = getBattle(client.battleID);
			if (bat == null) {
				System.out.println("Serious error occured: Invalid battle ID. Server will now exit!");
				closeServerAndExit();
			}
			
			if (bat.founder != client) return false;

			int allyno, left, top, right, bottom;
			try {
				allyno = Integer.parseInt(commands[1]);
				left = Integer.parseInt(commands[2]);
				top = Integer.parseInt(commands[3]);
				right = Integer.parseInt(commands[4]);
				bottom = Integer.parseInt(commands[5]);
			} catch (NumberFormatException e) {
				client.sendLine("SERVERMSG Serious error: inconsistent data (" + commands[0] + " command). You will now be disconnected ...");
				killClient(client);
				return false; 
			}
			
			if (bat.startRects[allyno].enabled) {
				client.sendLine("SERVERMSG Serious error: inconsistent data (" + commands[0] + " command). You will now be disconnected ...");
				killClient(client);
				return false; 
			}
			
			bat.startRects[allyno].enabled = true;
			bat.startRects[allyno].left = left;
			bat.startRects[allyno].top = top;
			bat.startRects[allyno].right = right;
			bat.startRects[allyno].bottom = bottom;
			
			bat.sendToAllExceptFounder("ADDSTARTRECT " + allyno + " " + left + " " + top + " " + right + " " + bottom);
		}		
		else if (commands[0].equals("REMOVESTARTRECT")) {
			if (commands.length != 2) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			
			Battle bat = getBattle(client.battleID);
			if (bat == null) {
				System.out.println("Serious error occured: Invalid battle ID. Server will now exit!");
				closeServerAndExit();
			}
			
			if (bat.founder != client) return false;

			int allyno;
			try {
				allyno = Integer.parseInt(commands[1]);
			} catch (NumberFormatException e) {
				client.sendLine("SERVERMSG Serious error: inconsistent data (" + commands[0] + " command). You will now be disconnected ...");
				killClient(client);
				return false; 
			}
			
			if (!bat.startRects[allyno].enabled) {
				client.sendLine("SERVERMSG Serious error: inconsistent data (" + commands[0] + " command). You will now be disconnected ...");
				killClient(client);
				return false; 
			}
			
			bat.startRects[allyno].enabled = false;
		
			bat.sendToAllExceptFounder("REMOVESTARTRECT " + allyno);
		}		
		else if (commands[0].equals("SCRIPTSTART")) {
			if (commands.length != 1) return false;
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			
			Battle bat = getBattle(client.battleID);
			if (bat == null) {
				System.out.println("Serious error occured: Invalid battle ID. Server will now exit!");
				closeServerAndExit();
			}
			
			bat.tempReplayScript = new Vector();
		}				
		else if (commands[0].equals("SCRIPT")) {
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			
			Battle bat = getBattle(client.battleID);
			if (bat == null) {
				System.out.println("Serious error occured: Invalid battle ID. Server will now exit!");
				closeServerAndExit();
			}
			
			bat.tempReplayScript.add(Misc.makeSentence(commands, 1));
		}				
		else if (commands[0].equals("SCRIPTEND")) {
			if (client.account.accessLevel() < 1) return false;
			
			if (client.battleID == -1) return false;
			
			Battle bat = getBattle(client.battleID);
			if (bat == null) {
				System.out.println("Serious error occured: Invalid battle ID. Server will now exit!");
				closeServerAndExit();
			}
			
			bat.replayScript = bat.tempReplayScript;
			bat.sendScriptToAllExceptFounder();
		}				
		else {
			// unknown command!
			return false;
		}
		
		return true;
		
	}
	
	/* this method disconnects and removes client from clients Vector. 
	 * Also cleans up after him (channels, battles) and notifies other
	 * users of his departure */
	public static synchronized boolean killClient(Client client) {
		int index = clients.indexOf(client);
		if (index == -1) return false;

		client.disconnect();
		/* We have to remove client from all channels. This is O(n*m) (n - number of channels,
		 * m - average number of users in a channel) operation since
		 * we don't keep a list of all the channels client is in. We do this because
		 * it is much more simple and we don't care much about speed since this method
		 * is called very seldom.
		 *  */
		
		int lastSize = channels.size();
		int pos = 0;
		while (pos < channels.size())
		{
			leaveChannelAndNotifyAll((Channel)channels.get(pos), client);
			if (channels.size() < lastSize) {
				lastSize = channels.size();
			} else pos++;
		}; /* why did we have to check the channels.size()? Because when we removed a client
		     from a channel, channel may have been removed from channels list, if the client
		     was the last client in the channel. That is why we must check the size (if we
		     would use simple for loop, we could get ArrayOutOfBounds exception!) */ 
	
		if (client.battleID != -1) {
			Battle bat = getBattle(client.battleID);
			if (bat == null) {
				System.out.println("Serious error occured: Invalid battle ID. Server will now exit!");
				closeServerAndExit();
			}
			leaveBattle(client, bat); // automatically checks if client is a founder and closes battle
		}
		
		clients.remove(index);
		if (client.account.accessLevel() != 0) {
			sendToAllRegisteredUsers("REMOVEUSER " + client.account.user);
			if (DEBUG > 0) System.out.println("Registered user killed: " + client.account.user);
		} else {
			if (DEBUG > 0) System.out.println("Unregistered user killed");
		}

		if (LAN_MODE) {
			accounts.remove(client.account);
		}
		
		return true;
	}
	
	public static boolean redirectAndKill(Socket socket) {
		if (!redirect) return false;
		try {
			(new PrintWriter(socket.getOutputStream(), true)).println("REDIRECT " + redirectToIP);
			socket.close();
		} catch (Exception e) {
			return false;
		}
		return true;
	}
	
	/* returns -1 if file does not exist */
	public static int getArchiveFileIndex(String filename) {
		for (int i = 0; i < archiveList.size(); i++)
			if (((ArchiveFile)archiveList.get(i)).getFilename().equals(filename)) return i; 
		return -1;
	}

	public static void readArchiveList() {
		archiveList.clear();
		
	    FilenameFilter filter = new FilenameFilter() {
	        public boolean accept(File dir, String name) {
	            return !name.startsWith(".");
	        }
	    };
	    
	    File dir = new File("./files");
	    
	    String[] children = dir.list(filter);
	    
	    if (children == null) {
	        // Either dir does not exist or is not a directory
	    } else {
	        for (int i = 0; i < children.length; i++) {
	            // Get filename of file or directory
	        	archiveList.add(new ArchiveFile(children[i]));
	        	System.out.println("* File added to archive: " + children[i]);
	        }
	    }		
	}	
	
	public static void main(String[] args) {

		int port = SERVER_PORT;

		// process command line arguments:
		try {
			String s;
			for (int i = 0; i < args.length; i++)
				if (args[i].charAt(0) == '-') {
					s = args[i].substring(1).toUpperCase();
					if (s.equals("PORT")) {
						int p = Integer.parseInt(args[i+1]);
						if ((p < 1) || (p > 65535)) throw new IOException();
						port = p;
						i++; // we must skip port number parameter in the next iteration
					}
					else if (s.equals("LAN")) {
						LAN_MODE = true;						
					}
					else if (s.equals("DEBUG")) {
						int level = Integer.parseInt(args[i+1]);											
						if ((level < 0) || (level > 127)) throw new IOException();
						DEBUG = (byte)level;
						i++;  // we must skip debug level parameter in the next iteration
					}
					else throw new IOException();
				} else throw new IOException();
			
		} catch (Exception e) {
			System.out.println("Bad arguments. Usage:");
			System.out.println("");
			System.out.println("-PORT [number]");
			System.out.println("  Server will host on port [number]. If command is omitted,\n" +
							   "  default port will be used.");
			System.out.println("");
			System.out.println("-LAN");
			System.out.println("  Server will run in \"LAN mode\", meaning any user can login as\n" +
							   "  long as he uses unique username (password is ignored).\n" +
							   "  Note: Server will accept users from outside the local network too.");
			System.out.println("");
			System.out.println("-DEBUG [number]");
			System.out.println("   Use 0 for no verbose, 1 for normal and 2 for extensive verbose.");
			System.out.println("");
			
			closeServerAndExit();
		}

		System.out.println("TASServer " + VERSION + " started on " + Misc.easyDateFormat("yyyy.MM.dd 'at' hh:mm:ss z"));
		
		// read accounts information:
		if (!LAN_MODE) {
			readAccountsInfo();
			//writeAccountsInfo();
			readBanList(BAN_LIST_FILENAME);
		} else {
			System.out.println("LAN mode enabled");
		}
		
		readMOTD();
		upTime = System.currentTimeMillis();
			if (!IP2Country.initializeAll("IpToCountry.csv")) {		
			System.out.println("Unable to find <IP2Country> file. Skipping ...");			
		} else {
			System.out.println("<IP2Country> loaded.");
		}
		
		if (!LAN_MODE) {
			System.out.println("Reading archive list ...");
			readArchiveList();
		}
		
		// start server:
		if (!startServer(port)) closeServerAndExit();
		
		// start timer which saves accounts info to disk on regular intervals:
/*
		if (!LAN_MODE) {
			saveAccountsInfoTimer.schedule(new TimerTask() {
	            public void run() {
	            	writeAccountsInfo();
	                System.out.println("Accounts info saved to disk due to schedule");
	            }
			}, saveAccountInfoInterval, saveAccountInfoInterval);
					
		}
*/		
		// main loop:
        while (true) {
        	
        	Socket socket = null;
        	
        	try {
            	socket = serverSocket.accept();
            	socket.setSoTimeout(TIMEOUT_LENGTH);
            	//*** socket.setKeepAlive(true);
            	//*** socket.setTcpNoDelay(true);
        	} catch (IOException e) {
        		break;
        	}
        	
        	if (redirect) {
        		if (DEBUG > 0) System.out.println("Client redirected to " + redirectToIP + ": " + socket.getInetAddress().getHostAddress());
        		redirectAndKill(socket);
        		continue;
        	}
        	
        	Client client = new Client(socket);
        	synchronized(clients) {
        		clients.add(client);
        	}
        	new ClientThread(client).start();
        	if (DEBUG > 0) System.out.println("New client connected: " + client.IP);
        	
        }
        System.out.println("Server closed!");
        
/*        if (!LAN_MODE) saveAccountsInfoTimer.cancel();  */
	
	}
}
