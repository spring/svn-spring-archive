/*
 * CEvent.java
 *
 * Created on 27 May 2006, 21:20
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package org.darkstars.battlehub.framework;

/**
 *
 * @author AF
 */

public class CEvent {
    
    
    @Deprecated public final static String DISCONNECT = "DISCONNECT";
    
    @Deprecated public final static String FAILEDCONNECTION = "FAILEDCONNECTION";
    
    @Deprecated public final static String CONNECTED = "connected";
    @Deprecated public final static String DISCONNECTED = "DISCONNECTED";
    @Deprecated public final static String DISCONNECTUNKNOWNHOST = "UNKNOWN_HOST";
    
    @Deprecated public final static String LOGOUT = "LOGOUT";
    @Deprecated public final static String LOGGEDOUT = "LOGGEDOUT";
    @Deprecated public final static String LOGINPROGRESS = "PROGRESS";
    
    @Deprecated public final static String OPENPRIVATEMSG = "OPENPRIV";
    
    @Deprecated public final static String TOGGLERAWTRAFFIC ="TOGGLETRAFFIC";
    
    @Deprecated public final static String NEWUSRADDED = "NEWUSRADDED";
    
    
    
    @Deprecated public final static String CHANNELJOINED ="channeljoined";
    @Deprecated public final static String CHANNELCLOSED ="channelclose";
    @Deprecated public final static String CHANNELREAD ="channeltabread";
    @Deprecated public final static String CHANNELUNREAD ="channeltabunread";
    
    @Deprecated public final static String LOGONSCRIPTCHANGE ="logonscriptchange";
    
    @Deprecated public final static String CONTENTREFRESH = "contentrefresh";
    
    @Deprecated public final static String EXITEDBATTLE = "exitedbattle";
    @Deprecated public final static String ADDEDBATTLE = "addedbattle";
    
    @Deprecated public final static String BATTLEINFO_CHANGED ="battleinfo_changed";
    
    
    
    public String[] data;
    public String dataLine;
    public String parameters="";
    public Object object;
    private boolean valid = true;
    private boolean consumable = false;
    
    private IModule source = null;
    
    private int messageChannel = 0;
    
    /**
     * Creates a new instance of CEvent. A default value of 0 is used for the
     * missing messageChannel parameters, and the event is also set of
     * non-consumable by default.
     *
     * @param s a message or line of server traffic
     */
    public CEvent (final String s) {
        Init(s,false,0);
    }
    
    /**
     * Creates a new instance of CEvent. A default value of 0 is used for the
     * missing messageChannel parameters
     * 
     * @param s a message or line of server traffic
     * @param isConsumable a boolean signifying if this message or event can be
     * 'consumed' preventing further distribution
     */
    public CEvent (final String s, final boolean isConsumable) {
        Init(s,isConsumable,0);
    }
    
    /**
     * 
     * @param s a message or line of server traffic
     * @param isConsumable a boolean signifying if this message or event can be
     * 'consumed' preventing further distribution
     * @param messageChannel an integer representing the 'channel' this message 
     * will be sent along, only objects implementing IModule that listen to that
     * channel will recieve this message.
     */
    public CEvent (final String s, final boolean isConsumable, int messageChannel) {
        Init(s,isConsumable,messageChannel);
    }
    
    /**
     * Initializes this object. Should be called from one of the CEvent
     * constructors. This is basically a helper method to prevent code
     * replication in the constructors.
     * 
     * @param s a line of data, usually a message or piece of server traffic
     * @param isConsumable a boolean signifying if this message or event can be
     * 'consumed' preventing further distribution
     * @param messageChannel an integer representing the 'channel' this message 
     * will be sent along, only objects implementing IModule that listen to that
     * channel will recieve this message.
     */
    public void Init(final String s, final boolean isConsumable, final int messageChannel){
        //
        this.messageChannel = messageChannel;
        dataLine = s;
        consumable = isConsumable;
        data = s.split (" ");
        
        if(data.length >1){
            parameters = s.substring(data[0].length()+1);
        } else{
            parameters = s;
        }
    }
    
    /**
     * A helper method to make long if else statements easier to read
     * 
     * @param s The event type to be checked against
     * @return a boolean value indicating if this event is of that type
     */
    public boolean IsEvent (String s){
        if(data == null){
            return false;
        }
        return s.equalsIgnoreCase (data[0]);
    }
    
    /**
     * 
     * @return
     */
    public boolean IsValid(){
        return valid;
    }
    
    /**
     * 
     */
    public void InValidate(){
        valid = false;
    }
    
    /**
     * 
     * @return
     */
    public boolean IsConsumable(){
        return consumable;
    }
    
    /**
     * Consumes this event or message, preventing further distribution. This
     * call is pretty much the same as InValidate and only exists in order to
     * make code clearer.
     * 
     * I would expect the hotspot compiler to optimize this
     * method out after an initial call.
     * 
     * @see CEvent.InValidate()
     */
    public void Consume(){
        //
        InValidate();
    }
    
    /**
     * 
     * @param m
     */
    public void SetSource(IModule m){
        //
        source = m;
    }
    
    /**
     * 
     * @return
     */
    public IModule GetSource(){
        //
        return source;
    }
    
    /**
     * Retrieves the whole string component of this message as a single string 
     * value. This does not serialize the whole object into a string, and if
     * this message does not contain a string value then no string will be
     * returned.
     * 
     * The intended use of this method is for when further parsing of a line of
     * traffic from the server is needed, such as when tab delimeters are used.
     * 
     * @return A string containing the original string data value passed 
     * unparsed
     */
    public String GetDataLine(){
        return dataLine;
    }
    
    /**
     * Retrieves a data field from the data string at the given index. This
     * method however does nto check if the given index is out of bounds or not,
     * so please do a check on the FieldCount method in order to handle this 
     * correctly and safely.
     * 
     * @param index The index of the requested data object
     * @return The data at the requested index
     * 
     * @see FieldCount()
     */
    public String GetData(int index){
        //
        return data[index];
    }
    
    /**
     * Retrieves the number of fields in this message. This includes all the
     * parameters and the initial command value
     * 
     * @return an integer signifying the number of data fields
     */
    public int FieldCount(){
        //
        return data.length;
    }
    
    /**
     * This event will only be recieved by objects implementing the IModule 
     * #interface that register to listen for channels indicated by an integer 
     * value. This method returns the channel this message ro event is intended
     * for.
     * 
     * @return The message channel this event/message is intended for
     */
    public int GetMessageChannel(){
        //
        return messageChannel;
    }
    
}
