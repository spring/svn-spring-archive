/*
 * CChannel.java
 *
 * Created on 07 April 2007, 18:22
 */

package aflobby;

import aflobby.UI.CChatLogFormatter;
import aflobby.framework.CEvent;
import aflobby.helpers.CStringHelper;
import aflobby.UI.CUISettings;
import aflobby.UI.CUserSettings;
import aflobby.framework.IModule;
import java.awt.Color;
import java.awt.Component;
import java.awt.EventQueue;
import java.awt.Image;
import java.awt.event.KeyEvent;
import java.io.File;
import java.io.IOException;
import java.lang.reflect.InvocationTargetException;
import java.net.URL;
import java.text.DateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TreeMap;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
import javax.swing.JList;
import javax.swing.ListCellRenderer;
import javax.swing.SwingUtilities;

/**
 *
 * @author  Tom
 */
public class CChannel extends javax.swing.JPanel implements IModule{

    public boolean scroll = false;
    public String lastsent = "";
    public String Channel = "";
    public LMain LM;
    public boolean inchannel = true;
    //private boolean wipenext;
    public static ImageIcon[] ranks = null;
    public static ImageIcon[] smallranks = null;
    public static TreeMap<String, ImageIcon> flags = new TreeMap<String,ImageIcon>();
    
    FileHandler txtLog = null;
    Logger logger = null;
    
    public static ImageIcon GetFlagIcon(String flag){
        if(flag == null){
            //
            return null;
        }
        
        if(flags.containsKey(flag)){
        
            ImageIcon i = flags.get(flag);
            return i;
        }else{
            String path = Misc.GetAbsoluteLobbyFolderPath() + "images/flags/"
                    + flag + ".png";
            ImageIcon i = new ImageIcon(path);
            flags.put(flag, i);
            return i;
        }
    }
    
    /** Creates new form CChannel */
    public CChannel() {
        chatpanel = new aflobby.UI.CChatPanel();
        if (ranks == null) {
            
            // load rank images
            ranks = new ImageIcon[7];
            for (int i = 0; i < 7; i++) {
                String path = Misc.GetAbsoluteLobbyFolderPath() +
                        "images/ranks/" + i + ".png";
                ranks[i] = new ImageIcon(path); //createImageIcon(path);//contents[i].toURI ().toString ());
            }
            
            // load the smaller rank images
            smallranks = new ImageIcon[7];
            for (int i = 0; i < 7; i++) {
                String path = Misc.GetAbsoluteLobbyFolderPath() +
                        "images/ranks_small/" + i + ".png";
                smallranks[i] = new ImageIcon(path); //createImageIcon(path);//contents[i].toURI ().toString ());
            }
            
            //java.io.Folder f;// = =FolderMisc.GetLobbyFolderPath ()+"/images/smileys/";
            //
        }
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                initComponents();
                chatpanel.SetForeColour(messageinput.getForeground());
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }

    public void Init(LMain L, final String channel) {
        
        LM = L;
        
        Channel = channel;
        inchannel = true;
        
        chatpanel.LM = L;
        
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                if(     Channel.equalsIgnoreCase("main") ||
                        Channel.equalsIgnoreCase("news") ||
                        Channel.equalsIgnoreCase("newbies"))
                {
                    channelPrivateLabel.setText("public channel");
                }
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
        
        try {

            File log = new File(Misc.GetAbsoluteLobbyFolderPath() + "logs/");
            if (!log.canRead()) {
                log.mkdir();
            }
            txtLog = new FileHandler(Misc.GetAbsoluteLobbyFolderPath() +
                    "logs/" + channel + ".txt", true);
            txtLog.setFormatter(new CChatLogFormatter());
            logger = Logger.getLogger("channel." + channel);
            logger.setLevel(Level.INFO);
            logger.addHandler(txtLog);
            
            Date today;
            String dateOut;
            DateFormat formatter;

            formatter = DateFormat.getDateTimeInstance(DateFormat.FULL,
                                   DateFormat.LONG);
            today = new Date();
            dateOut = formatter.format(today);

            logger.info("logging started at "+dateOut + " " + Locale.getDefault());
            /*CEvent e = new CEvent ();
            e.data = new String[2];
            e.data[1] = Channel;
            e.data[0] = "channel_release_events";
            e.a = this;
            LM.NewGUIEvent (e);*/
        } catch (IOException ex) {
            Logger.getLogger(CChannel.class.getName()).log(Level.SEVERE, null, ex);
        } catch (SecurityException ex) {
            Logger.getLogger(CChannel.class.getName()).log(Level.SEVERE, null, ex);
        }
        
        /*CEvent e = new CEvent ();
        e.data = new String[2];
        e.data[1] = Channel;
        e.data[0] = "channel_release_events";
        e.a = this;
        LM.NewGUIEvent (e);*/
    }

/*{"afro","asdf","beta","cesure","coffee","cool","crazy","evil","flour",
    "freak","happy","headbash","notfuneh","puke","redface","soldier","spammer",
    "stunned","thumbup","toothy4","twisted","yay"};*/
    
    public static ImageIcon adminimg = null;
    public static ImageIcon botimg = null;
    
    class PlayerListRenderer extends JLabel implements ListCellRenderer {
        
        
        public PlayerListRenderer() {
            setOpaque(true);
            setHorizontalAlignment(LEFT);
            setVerticalAlignment(TOP);
            if(CChannel.adminimg == null){
                URL h = this.getClass().getResource("/images/admin.png");
                CChannel.adminimg = new ImageIcon(h);
            }
            if(CChannel.botimg == null){
                URL h = this.getClass().getResource("/images/bot/32.png");
                CChannel.botimg = new ImageIcon(
                        new ImageIcon(h).getImage().getScaledInstance(20, 20, 0));
            }
        }

        /*
         * This method finds the image and text corresponding
         * to the selected value and returns the label, set up
         * to display the text and image.
         */
        public Component getListCellRendererComponent(JList list, Object value,
                int index, boolean isSelected, boolean cellHasFocus) {
            //Get the selected index. (The index param isn't
            //always valid, so just use the value.)
            String selectedValue = (String) value; //((Integer)value).intValue ();
            if (isSelected) {
                setBackground(list.getSelectionBackground());//etBackground()); //.brighter()); //list.getSelectionBackground ());
                setForeground(list.getSelectionForeground());
            } else {
                setBackground(list.getBackground());
//                setForeground(list.getForeground());
                /*if (index % 2 == 0) {
                    setBackground(list.getBackground());
                } else {
                    setBackground(list.getBackground().darker()); //brighter ());
                    setFont(CUISettings.GetFont(12, true));
                }*/
                if (LM.playermanager.GetPlayerInGame(selectedValue) == false) {
                    setForeground(list.getForeground());
                } else {
                    setForeground(new Color(181, 203, 255));
                }
            }
            CPlayer p = LM.playermanager.GetPlayer(selectedValue);
            if (p != null) {
                ImageIcon icon = null;
                if(Misc.getAccessFromStatus(p.getStatus()) >0){
                    icon = CChannel.adminimg;
                    icon.setImageObserver(list);
                } else if(Misc.getBotModeFromStatus(p.getStatus())){
                    icon = CChannel.botimg;
                    icon.setImageObserver(list);
                } else{
                    int playerrank = Misc.getRankFromStatus(p.getStatus());
                    //Set the icon and text.  If icon was null, say so.
                    icon = ranks[playerrank];
                    icon.setImageObserver(list);
                }
                
                setIcon(icon);
                
            }
            //if (icon != null) {
            String t = selectedValue;
            if (LM.playermanager.GetPlayerInGame(selectedValue)) {
                t += " (ingame)";
            }
            setText(t);
            setFont(list.getFont());
            //}// else {
            //    setUhOhText (pet + " (no image available)",
            //        list.getFont ());
            //}
            return this;
        }
    }

    /** Returns an ImageIcon, or null if the path was invalid. 
     * @param path 
     * @return 
     */
    protected ImageIcon createImageIcon(String path) {
        ///URL imgURL;// = new URL();//CChannel.class.getResource (path);
        if (path == null) {
            return null;
        }
        return new ImageIcon(new ImageIcon(path).getImage().getScaledInstance(
                18, 18, Image.SCALE_REPLICATE));
//        if (imgURL != null) {
//            ImageIcon i =
//            return i;
//        } else {
//            System.err.println ("Couldn't find file: " + path);
//            return null;
//        }
    }

    class getinputtext implements Runnable {

        public String text = "";

        public void run() {
            text = messageinput.getText();
        }
    }

    //String temporary;
    private void SendMessage() {
        //System.out.println ("CChannel::SendMessage");
        String[] lines;
        if (EventQueue.isDispatchThread()) {
            lines = messageinput.getText().split("\n");
        } else {
            getinputtext getTextFieldText = new getinputtext();
            try {
                SwingUtilities.invokeAndWait(getTextFieldText);
            } catch (InvocationTargetException ex) {
                ex.printStackTrace();
                return;
            } catch (InterruptedException ex) {
                ex.printStackTrace();
                return;
            }
            lines = getTextFieldText.text.split("\n");
        }

        /*Runnable getTextFieldText = new Runnable () {
        public void run () {
        temporary = ;
        }
        };
        try {
        SwingUtilities.invokeAndWait (getTextFieldText);
        } catch (InvocationTargetException ex) {
        ex.printStackTrace ();
        } catch (InterruptedException ex) {
        ex.printStackTrace ();
        }*/
        //lines = temporary.split ("\n");
        for (int n = 0; n < lines.length; n++) {
            String k = lines[n];
            if (k.trim().equalsIgnoreCase("")) {
                continue;
            }
            if (LM.command_handler.ExecuteCommand(lines[n])) {
                continue;
            }
            String[] command = k.split(" ");
            if (k.length() > 1020) {
                LM.Toasts.AddMessage("error: a message cannot contain in" +
                        " excess of 1,024 characters, the message was blocked" +
                        " to prevent a server ban");
            }
            if (command[0].equalsIgnoreCase("/me")) {
                LM.protocol.SendTraffic("SAYEX " + Channel + " " + Misc.makeSentence(command, 1));
            } else {
                LM.protocol.SendTraffic("SAY " + Channel + " " + k);
            }
        }
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                messageinput.setText("");
                messageinput.grabFocus();
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }

    public void ExitChannel() {
        //if(LM == null) return;
        LM.protocol.LeaveChannel(Channel, "user left channel");
        inchannel = false;

        ClearPlayers();
        CEvent e = new CEvent(CEvent.CHANNELCLOSED + " " + Channel);
        LM.core.NewGUIEvent(e);

        //LM = null;
        //jast.cancel ();
        //jast.purge ();
        //this.messageswindow = "";
//        doc.notify ();
        //this.setVisible (false);
        //cv.tabpane.remove (this);
    }

    //JChat.scrollRectToVisible(
    //                new Rectangle(0,JChat.getHeight()-2,1,1));
    //public boolean scrollbottom=false;
    public void AddMessage(final String s) {
        //String q =
        if (chatpanel != null) {
            chatpanel.AddMessage(s);
        }
    }

    public void SetMessageWindow(final String s) {
        if (!inchannel) {
            return;
        }
        chatpanel.SetContents(s);
    }

    public void Update() {
        if (!inchannel) {
            return;
        }
        if (chatpanel != null) {
            chatpanel.Update();
        }
    }

    public void NewEvent(final CEvent e) {
        if (e.IsEvent("SAID")) {
            if (e.data[1].equalsIgnoreCase(Channel)) {
                // Add!!!!!
                final String time = CStringHelper.getHTMLTimestamp();
                final String Msg = CStringHelper.getChatHTML(Misc.makeSentence(e.data, 3),false);
                final String User = CStringHelper.getUserChatHTML(e.data[2]);
                logger.info(CStringHelper.getTimestamp()+"<" + e.data[2] + "> "
                        + Misc.makeSentence(e.data, 3));


                Runnable doWorkRunnable = new Runnable() {

                    public void run() {
                        if (MultiLineMenuItem.isSelected()) {
                            if (lastsent.equalsIgnoreCase(User.trim()) == false) {
                                AddMessage(User+"<br>" + time + Msg);
                                lastsent = User.trim();
                            } else {
                                AddMessage(time + Msg);
                            }
                        } else {
                            AddMessage(time + User + Msg);
                        }
                        if (!chatpanel.isShowing()) {
                            CEvent e2 = new CEvent(CEvent.CHANNELUNREAD + " "
                                    + Channel);
                            LM.core.NewGUIEvent(e2);
                        }
                    }
                };
                SwingUtilities.invokeLater(doWorkRunnable);
            }
        } else if (e.IsEvent("SAIDEX")) {
            if (e.data[1].equalsIgnoreCase(Channel)) {
                // Add!!!!! SAIDEX main w00t heheh
                String time = CStringHelper.getHTMLTimestamp();
                final String msg = CStringHelper.getChatHTML(e.data[2] + " " + 
                        Misc.makeSentence(e.data, 3),true);
                AddMessage(time + msg);
                logger.info(CStringHelper.getTimestamp()+"*" + e.data[2] + " " + 
                        Misc.makeSentence(e.data, 3));
                lastsent = e.data[2];
                Runnable doWorkRunnable = new Runnable() {

                    public void run() {
                        if (!isShowing()) {
                            CEvent e2 = new CEvent(CEvent.CHANNELUNREAD + " " + Channel);
                            LM.core.NewGUIEvent(e2);
                        }
                    }
                };
                SwingUtilities.invokeLater(doWorkRunnable);
            }
        } else if (e.IsEvent("LEFT")) {
            // Add!!!!!
            if (e.data[1].equalsIgnoreCase(Channel)) {
                if (e.data[2].equalsIgnoreCase(LM.protocol.GetUsername())) {
                    logger.info("Logging Ended");
                    logger.info("\n");
                } else {
                    logger.info(e.data[2] + " left channel: " + 
                            Misc.makeSentence(e.data, 3));
                    lastsent = "";
                }
                RemovePlayer(e.data[2], Misc.makeSentence(e.data, 3));
            }
            //lastsent="";
        } else if (e.IsEvent("JOINED")) {
            if (e.data[1].equalsIgnoreCase(Channel)) {
                logger.info("User " + e.data[2] + " joined");
                lastsent = "";
                AddPlayer(e.data[2], false);
            }
            //lastsent="";
        } else if (e.IsEvent("CLIENTS")) {
            // Add!!!!!
            if (e.data[1].equalsIgnoreCase(Channel)) {
                for (int c = 2; c < e.data.length; c++) {
                    //listModel.addElement(e.data[c]);
                    AddPlayer(e.data[c], true);
                }
            }
        } else if (e.IsEvent("CHANNELTOPIC")) {
            // Add!!!!!
            if (e.data[1].equalsIgnoreCase(Channel)) {
                //Integer x = new Integer(e.data[3]);
                Date topicset = new Date(Long.parseLong(e.data[3]));
                String topic = Misc.toHTML(Misc.makeSentence(e.data, 4));
                topic = topic.replaceAll("\\\\n", "<br>");
                topic = aflobby.UI.CChatPanel.ParseChatText(topic);
                topic = "<font face=\"Bitstream Vera Sans Mono, Andale Mono, " +
                        "Consolas, Courier New, Courier, Monospace\" size=\"3\">" +
                        "Topic : <br>" + topic + "<br> set by :" + e.data[2] + 
                        " on " + topicset.toString() + "</font><br>";
                
                if (chatpanel != null) {
                    chatpanel.AddRawHTML(topic);
                }
                logger.info("TOPIC: " + Misc.makeSentence(e.data, 4));
                lastsent = "";
            }
            //lastsent="";
        } else if (e.IsEvent("CHANNELMESSAGE")) {
            // Add!!!!!
            if (e.data[1].equalsIgnoreCase(Channel)) {
                logger.info("ChannelMessage : " + Misc.makeSentence(e.data, 2));
                AddMessage("<font face=\"Arial, Helvetica, sans-serif\" " +
                        "size=\"3\" color=\"" + ColourHelper.ColourToHex(Color.BLUE)
                        + "\"><b>ChannelMessage : " + Misc.toHTML(Misc.makeSentence(e.data, 2))
                        + "</b></font>");
            }
        } else if (e.data[0].equalsIgnoreCase("FORCELEAVECHANNEL")) {
            if (e.data[1].equalsIgnoreCase(Channel)) {
                //if(e.data[2].equalsIgnoreCase (e.connection.username)){
                // We've been kicked, oh noes!!!!! Close the window and show a message in the message window!!!!'
                logger.info("You got kicked from " + this.Channel + " reason:: "
                        + Misc.makeSentence(e.data, 3));
                LM.Toasts.AddMessage("You got kicked from " + this.Channel + 
                        " reason:: " + Misc.makeSentence(e.data, 3));
                ExitChannel();
                logger.info("Logging Ended");
                logger.info("\n");
                //}else{
                //    // Thank god, it was a different user who got kicked! Display a nice blue message to celebrate
                //    AddMessage ("<font face=\"Arial, Helvetica, sans-serif\" size=\"3\" color=\"333399\"><b>User got kicked! : " +e.data[2]+" reason: "+Misc.makeSentence (e.data,3)+"</b></font>");
                //}
            }
        }
    }

    void RemovePlayer(final String player, final String reason) {

        //final 
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                CPlayer p = LM.playermanager.GetPlayer(player);
                playerTablePanel.RemovePlayer(p);
                
                if (FilJoin.isSelected() == false) {
                    String r = "";
                    if (reason.equalsIgnoreCase("") == false) {
                        r = " reason: " + reason;
                    }
                    AddMessage("<font face=\"Arial, Helvetica, sans-serif\" " +
                            "size=\"3\" color=\"996699\"><b> " + player + " has" +
                            " Left #" + Channel + " " + r + "</b></font>");
                }
                
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }

    void ClearPlayers() {
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                playerTablePanel.ClearPlayers();
                //jList1.removeAll ();
            }
            
            //listModel.clear ();
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }

    void AddPlayer(final String player, final boolean JustJoined) {
        //this.jList1.setListData ();
        //players.add (player);
        //players.add (player);
        //if(players.isEmpty ()){
        //    jList1.add (player);
        //}else{
//        final Object[] o = players.toArray ().clone ();
//        Arrays.sort (o,new Comparer ());
        
        //final 
        //if (p != null) {
            Runnable doWorkRunnable = new Runnable() {

                public void run() {
                    CPlayer p = LM.playermanager.GetPlayer(player);
                    playerTablePanel.AddPlayer(p);

                    if (!JustJoined) {
                        if (FilJoin.isSelected() == false) {
                        
                            String flag=" ";
                            if(Boolean.valueOf(CUserSettings.GetValue("ui.channelview.userjoinflags", "false"))){
                                flag = p.GetFlagHTML();
                            }
                            if(Boolean.valueOf(CUserSettings.GetValue("ui.channelview.userjoinranks", "false"))){
                                flag += p.GetRankHTML();
                            }
                            AddMessage("<font face=\"Arial, Helvetica, " +
                                    "sans-serif\" size=\"3\" color=\"00AA22\">" +
                                    "<b> " + flag + " " + player + " has Joined" +
                                    " #" + Channel + "</b></font>");
                        }
                    }
                
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
        //}
        
    }
    //}

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        optionsPopupMenu = new javax.swing.JPopupMenu();
        MultiLineMenuItem = new javax.swing.JCheckBoxMenuItem();
        ClearChatMenuItem = new javax.swing.JMenuItem();
        jSplitPane2 = new javax.swing.JSplitPane();
        jPanel2 = new javax.swing.JPanel();
        jScrollPane3 = new javax.swing.JScrollPane();
        messageinput = new javax.swing.JTextArea();
        jButton3 = new javax.swing.JButton();
        JAutoScrollToggle = new javax.swing.JToggleButton();
        FilJoin = new javax.swing.JToggleButton();
        smileybox = new aflobby.UI.CSmileyCombo();
        jSplitPane1 = new javax.swing.JSplitPane();
        jPanel5 = new javax.swing.JPanel();
        jButton1 = new javax.swing.JButton();
        jButton2 = new javax.swing.JButton();
        channelPrivateLabel = new javax.swing.JLabel();
        jButton5 = new javax.swing.JButton();
        playerTablePanel = new aflobby.UI.CPlayerTablePanel();
        playerTablePanel.LM = LM;
        chatpanel = new aflobby.UI.CChatPanel();

        MultiLineMenuItem.setSelected(Boolean.parseBoolean(CUserSettings.GetValue("ui.chat.multiline", "true")));
        java.util.ResourceBundle bundle = java.util.ResourceBundle.getBundle("aflobby/languages"); // NOI18N
        MultiLineMenuItem.setText(bundle.getString("CChannel.MultiLineMenuItem.text")); // NOI18N
        MultiLineMenuItem.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/multi_line.gif"))); // NOI18N
        MultiLineMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                MultiLineMenuItemActionPerformed(evt);
            }
        });
        optionsPopupMenu.add(MultiLineMenuItem);

        ClearChatMenuItem.setComponentPopupMenu(optionsPopupMenu);
        ClearChatMenuItem.setText(bundle.getString("CChannel.ClearChatMenuItem.text")); // NOI18N
        ClearChatMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ClearChatMenuItemActionPerformed(evt);
            }
        });
        optionsPopupMenu.add(ClearChatMenuItem);

        addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentResized(java.awt.event.ComponentEvent evt) {
                formComponentResized(evt);
            }
            public void componentShown(java.awt.event.ComponentEvent evt) {
                formComponentShown(evt);
            }
        });
        addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                formFocusGained(evt);
            }
        });

        jSplitPane2.setDividerLocation(jSplitPane2.getHeight()-200);
        jSplitPane2.setDividerSize(8);
        jSplitPane2.setOrientation(javax.swing.JSplitPane.VERTICAL_SPLIT);
        jSplitPane2.setResizeWeight(0.95);
        jSplitPane2.setOneTouchExpandable(true);

        jScrollPane3.setBackground(new java.awt.Color(255, 255, 255));

        messageinput.setColumns(20);
        messageinput.setFont(CUISettings.GetFont(12,false));
        messageinput.setLineWrap(true);
        messageinput.setRows(1);
        messageinput.setWrapStyleWord(true);
        messageinput.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                messageinputKeyPressed(evt);
            }
        });
        jScrollPane3.setViewportView(messageinput);

        jButton3.setFont(CUISettings.GetFont(12,false));
        jButton3.setText(bundle.getString("CChannel.jButton3.text")); // NOI18N
        jButton3.setMargin(new java.awt.Insets(3, 6, 3, 6));
        jButton3.setNextFocusableComponent(messageinput);
        jButton3.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jButton3MousePressed(evt);
            }
        });

        JAutoScrollToggle.setFont(CUISettings.GetFont(12,false));
        JAutoScrollToggle.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/downarrow.gif"))); // NOI18N
        JAutoScrollToggle.setSelected(true);
        JAutoScrollToggle.setText(bundle.getString("CChannel.JAutoScrollToggle.text")); // NOI18N
        JAutoScrollToggle.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                JAutoScrollToggleMousePressed(evt);
            }
        });
        JAutoScrollToggle.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                JAutoScrollToggleActionPerformed(evt);
            }
        });

        FilJoin.setFont(CUISettings.GetFont(12,false));
        FilJoin.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/filter.gif"))); // NOI18N
        FilJoin.setText(bundle.getString("CChannel.FilJoin.text")); // NOI18N

        smileybox.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        smileybox.setMaximumSize(new java.awt.Dimension(32767, 20));
        smileybox.setMinimumSize(new java.awt.Dimension(51, 20));

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(FilJoin)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(JAutoScrollToggle)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(smileybox, javax.swing.GroupLayout.PREFERRED_SIZE, 179, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addContainerGap())
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                        .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 765, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 53, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(12, 12, 12))))
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(FilJoin, javax.swing.GroupLayout.PREFERRED_SIZE, 24, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(JAutoScrollToggle, javax.swing.GroupLayout.PREFERRED_SIZE, 24, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(smileybox, javax.swing.GroupLayout.PREFERRED_SIZE, 24, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 40, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 61, Short.MAX_VALUE))
                .addContainerGap())
        );

        jPanel2Layout.linkSize(javax.swing.SwingConstants.VERTICAL, new java.awt.Component[] {FilJoin, JAutoScrollToggle, smileybox});

        smileybox.Init(messageinput);

        jSplitPane2.setRightComponent(jPanel2);

        jSplitPane1.setDividerLocation(jSplitPane1.getWidth()-150);
        jSplitPane1.setDividerSize(8);
        jSplitPane1.setResizeWeight(0.95);
        jSplitPane1.setAutoscrolls(true);
        jSplitPane1.setContinuousLayout(true);
        jSplitPane1.setOneTouchExpandable(true);

        jPanel5.setMaximumSize(new java.awt.Dimension(500, 32767));

        jButton1.setFont(CUISettings.GetFont(12,false));
        jButton1.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/close_orange.gif"))); // NOI18N
        jButton1.setText(bundle.getString("CChannel.jButton1.text")); // NOI18N
        jButton1.setToolTipText(bundle.getString("CChannel.jButton1.toolTipText")); // NOI18N
        jButton1.setBorder(new javax.swing.border.LineBorder(new java.awt.Color(255, 0, 0), 2, true));
        jButton1.setFocusPainted(false);
        jButton1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jButton1MouseReleased(evt);
            }
        });

        jButton2.setFont(CUISettings.GetFont(12,false));
        jButton2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/comment_new.gif"))); // NOI18N
        jButton2.setText(bundle.getString("CChannel.jButton2.text")); // NOI18N
        jButton2.setToolTipText(bundle.getString("CChannel.jButton2.toolTipText")); // NOI18N
        jButton2.setFocusPainted(false);
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        channelPrivateLabel.setText(bundle.getString("CChannel.channelPrivateLabel.text")); // NOI18N

        jButton5.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/cog.png"))); // NOI18N
        jButton5.setText(bundle.getString("CChannel.jButton5.text")); // NOI18N
        jButton5.setToolTipText(bundle.getString("CChannel.jButton5.toolTipText")); // NOI18N
        jButton5.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jButton5MousePressed(evt);
            }
        });
        jButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton5ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout playerTablePanelLayout = new javax.swing.GroupLayout(playerTablePanel);
        playerTablePanel.setLayout(playerTablePanelLayout);
        playerTablePanelLayout.setHorizontalGroup(
            playerTablePanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 293, Short.MAX_VALUE)
        );
        playerTablePanelLayout.setVerticalGroup(
            playerTablePanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 393, Short.MAX_VALUE)
        );

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel5Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(playerTablePanel, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel5Layout.createSequentialGroup()
                        .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 70, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton5, javax.swing.GroupLayout.PREFERRED_SIZE, 27, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(channelPrivateLabel, javax.swing.GroupLayout.DEFAULT_SIZE, 135, Short.MAX_VALUE)))
                .addContainerGap())
        );

        jPanel5Layout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {jButton2, jButton5});

        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jButton2, javax.swing.GroupLayout.DEFAULT_SIZE, 26, Short.MAX_VALUE)
                    .addComponent(jButton5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButton1, javax.swing.GroupLayout.DEFAULT_SIZE, 25, Short.MAX_VALUE)
                    .addComponent(channelPrivateLabel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(playerTablePanel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addContainerGap())
        );

        jPanel5Layout.linkSize(javax.swing.SwingConstants.VERTICAL, new java.awt.Component[] {jButton1, jButton2, jButton5});

        jSplitPane1.setRightComponent(jPanel5);

        chatpanel.LM = LM;

        javax.swing.GroupLayout chatpanelLayout = new javax.swing.GroupLayout(chatpanel);
        chatpanel.setLayout(chatpanelLayout);
        chatpanelLayout.setHorizontalGroup(
            chatpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 523, Short.MAX_VALUE)
        );
        chatpanelLayout.setVerticalGroup(
            chatpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 447, Short.MAX_VALUE)
        );

        jSplitPane1.setLeftComponent(chatpanel);

        jSplitPane2.setLeftComponent(jSplitPane1);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSplitPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 848, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jSplitPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 561, Short.MAX_VALUE)
        );
    }// </editor-fold>//GEN-END:initComponents

    // </editor-fold>
    // </editor-fold>
// </editor-fold>
    //Point prevsize = new Point();
private void formComponentResized(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_formComponentResized
            // TODO add your handling code here:
            /*int new_width = getWidth();
            int new_height = getHeight();
            prevsize.setLocation(new_width, new_height);*/
}//GEN-LAST:event_formComponentResized

    private void JAutoScrollToggleActionPerformed (java.awt.event.ActionEvent evt) {//GEN-FIRST:event_JAutoScrollToggleActionPerformed
        chatpanel.SetAutoScroll(JAutoScrollToggle.isSelected());
    }//GEN-LAST:event_JAutoScrollToggleActionPerformed

    private void jButton2ActionPerformed (java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        String s = aflobby.UI.CUserSettings.GetStartScript();
        if (s.trim().equals("")) {
            s += System.getProperty ("line.separator");
        }
        s += "/join ";
        s += Channel;
        aflobby.UI.CUserSettings.SaveStartScript(s);
        AddMessage("<font face=\"Arial, Helvetica, sans-serif\" size=\"3\" " +
                "color=\"00AA22\"><b> channel added to startup list</b></font>");

        CEvent e = new CEvent(CEvent.LOGONSCRIPTCHANGE);
        LM.core.NewGUIEvent(e);
    }//GEN-LAST:event_jButton2ActionPerformed

    private void formComponentShown (java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_formComponentShown
        CEvent e = new CEvent(CEvent.CHANNELREAD + " " + Channel);
        if (LM != null) {
            LM.core.NewGUIEvent(e);
        }
    }//GEN-LAST:event_formComponentShown

    private void jButton1MouseReleased (java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton1MouseReleased
        this.ExitChannel();
    }//GEN-LAST:event_jButton1MouseReleased

    private void jButton3MousePressed (java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton3MousePressed
        SendMessage();
    }//GEN-LAST:event_jButton3MousePressed

    private void messageinputKeyPressed (java.awt.event.KeyEvent evt) {//GEN-FIRST:event_messageinputKeyPressed
        if (evt.getKeyCode() == KeyEvent.VK_ENTER) {
            if (evt.isShiftDown()) {
                return;
            }
            SendMessage();
        }
    }//GEN-LAST:event_messageinputKeyPressed

    private void JAutoScrollToggleMousePressed (java.awt.event.MouseEvent evt) {//GEN-FIRST:event_JAutoScrollToggleMousePressed
//
        /*if(JAutoScrollToggle.isSelected ()){
        jast.schedule (jas,
        1000,        //initial delay
        100);  //subsequent rate
        } else{
        jast.cancel ();
        }*/
    }//GEN-LAST:event_JAutoScrollToggleMousePressed

    private void formFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_formFocusGained
        messageinput.requestFocus();
    }//GEN-LAST:event_formFocusGained

    private void jButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton5ActionPerformed

    }//GEN-LAST:event_jButton5ActionPerformed

    private void jButton5MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton5MousePressed
        optionsPopupMenu.show(jButton5, jButton5.getHeight(), 0);
    }//GEN-LAST:event_jButton5MousePressed

    private void ClearChatMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ClearChatMenuItemActionPerformed
        chatpanel.ClearContents();
    }//GEN-LAST:event_ClearChatMenuItemActionPerformed

    private void MultiLineMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_MultiLineMenuItemActionPerformed
        CUserSettings.PutValue("ui.chat.multiline",
                String.valueOf(MultiLineMenuItem.isSelected()));
    }//GEN-LAST:event_MultiLineMenuItemActionPerformed

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JMenuItem ClearChatMenuItem;
    private javax.swing.JToggleButton FilJoin;
    private javax.swing.JToggleButton JAutoScrollToggle;
    private javax.swing.JCheckBoxMenuItem MultiLineMenuItem;
    private javax.swing.JLabel channelPrivateLabel;
    private aflobby.UI.CChatPanel chatpanel;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton5;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JSplitPane jSplitPane1;
    private javax.swing.JSplitPane jSplitPane2;
    private javax.swing.JTextArea messageinput;
    private javax.swing.JPopupMenu optionsPopupMenu;
    private aflobby.UI.CPlayerTablePanel playerTablePanel;
    private aflobby.UI.CSmileyCombo smileybox;
    // End of variables declaration//GEN-END:variables

    public void Init(LMain L) {

    }

    public void NewGUIEvent(CEvent e) {

    }

    public void OnRemove() {

    }

}