/*
 * CPrivateMsgWindow.java
 *
 * Created on 27 May 2006, 21:57
 */

package aflobby;

import aflobby.helpers.CStringHelper;
import aflobby.UI.CUISettings;
import java.awt.Color;
import java.awt.event.KeyEvent;
import java.io.File;
import java.io.IOException;
import java.util.HashMap;
import java.util.logging.FileHandler;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.Action;
import javax.swing.SwingUtilities;
import javax.swing.text.JTextComponent;

/**
 *
 * @author  AF
 */

public class CPrivateMsgWindow extends javax.swing.JFrame {

    public LMain LM;
    public CPlayer player;
    public boolean opened = false;
    public java.awt.Point origin = new java.awt.Point();
    public String lastsent = "";
    FileHandler txtLog = null;
    Logger logger = null;
    private HashMap actions;

    /**
     * Creates new form CPrivateMsgWindow
     */
    public CPrivateMsgWindow() {
        chat = new aflobby.CChatPanel();
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                initComponents();
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }

    public void Init(LMain L, CPlayer p) {
        //
        LM = L;
        player = p;
        chat.Init(L);
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                setTitle(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CPrivateMessageWindow.PM_:") + player.name);
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);

        if (Misc.getInGameFromStatus(player.getStatus()) == 1) {
            ingame = true;
        } else {
            ingame = false;
        }
        try {

            File log = new File(Misc.GetAbsoluteLobbyFolderPath() + "logs/pm/");
            if (!log.canRead()) {
                log.mkdir();
            }
            txtLog = new FileHandler(Misc.GetAbsoluteLobbyFolderPath() + "logs/pm/" + p.name + ".txt", true);
            txtLog.setFormatter(new CChatLogFormatter());
            logger = Logger.getLogger("privatemsg." + p.name);
            logger.setLevel(Level.INFO);
            logger.addHandler(txtLog);
            logger.info("\n");
            logger.info("\n");
            logger.info("logging started");
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
    }

    public void SendMessage() {
        if (LM.protocol.Connected()) {
            //
            Runnable doWorkRunnable = new Runnable() {

                public void run() {
                    //
                    String[] lines = MsgText.getText().split("\n");
                    for (int n = 0; n < lines.length; n++) {
                        String[] command = lines[n].split(" ");
                        //if(command[0].equalsIgnoreCase ("/me")){
                        //LM.protocol.SendTraffic ("SAYPRIVEX " + player.name + " " + Misc.makeSentence (command,1));
                        //}else{
                        LM.protocol.SendTraffic("SAYPRIVATE " + player.name + " " + lines[n]);
                        String Msg = lines[n];
                        Msg = Misc.toHTML(Msg);
                        String time = "<font face=\"Arial, Helvetica, sans-serif\" size=\"3\" color=\"" + ColourHelper.ColourToHex(CTextColours.GetColor("timestamps", ""+Color.gray.getRGB())) + "\">[" + Misc.easyDateFormat("hh:mm:ss") + "] </font>";
                        if (jToggleButton1.isSelected()) {
                            if (lastsent.equalsIgnoreCase(LM.protocol.GetUsername().trim()) == false) {//
                                Add("<font face=\"Arial, Helvetica, sans-serif\" size=\"3\"><b><i>" + LM.protocol.GetUsername() + " " + java.util.ResourceBundle.getBundle("aflobby/languages").getString("CPrivateMessageWindow._says:") + time + "<font face=\"Arial, Helvetica, sans-serif\" size=\"3\">" + Msg + "</font>");
                                lastsent = LM.protocol.GetUsername().trim();
                            } else {//<b><i>
                                Add(time + "<font face=\"Arial, Helvetica, sans-serif\" size=\"3\">" + Msg + "</font>");
                            }
                        } else {//<b><i>
                            Add(time + "<font face=\"Arial, Helvetica, sans-serif\" size=\"3\">" + LM.protocol.GetUsername() + java.util.ResourceBundle.getBundle("aflobby/languages").getString("CPrivateMessageWindow._says:") + Msg + "</font>");
                        }
                        //logger.info("<"+LM.protocol.GetUsername()+"> "+Msg);
                        //}
                    }




                    /*if(chat.GetAutoScroll ()){
                    for(int n = 0; n <lines.length; n++){
                    String command[] = lines[n].split (" ");
                    if(command[0].equalsIgnoreCase ("/me")){
                    Add (player.name + " " + Misc.makeSentence (command,1));
                    }else{
                    if(lastsent.equals (LM.protocol.GetUsername ())==false){
                    Add (LM.protocol.GetUsername () + " Says:\n   " + lines[n]);
                    lastsent=LM.protocol.GetUsername ();
                    }else if(lastsent.equals (LM.protocol.GetUsername ())){
                    Add ("   " + lines[n]);
                    }
                    }
                    }
                    }else{
                    for(int n = 0; n <lines.length; n++){
                    Add (LM.protocol.GetUsername () + " Says:\n   " + lines[n]);
                    }
                    lastsent=LM.protocol.GetUsername ();
                    }*/
                    //lastsent=1;
                    MsgText.setText("");
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
        }
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jSplitPane1 = new javax.swing.JSplitPane();
        jPanel2 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        MsgText = new javax.swing.JTextArea();
        jButton1 = new javax.swing.JButton();
        jToggleButton1 = new javax.swing.JToggleButton();
        cSmileyCombo1 = new aflobby.UI.CSmileyCombo();
        /*
        chat = new aflobby.CChatPanel();
        */

        setIconImage(CUISettings.GetWindowIcon());
        addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                formMousePressed(evt);
            }
        });
        addMouseMotionListener(new java.awt.event.MouseMotionAdapter() {
            public void mouseDragged(java.awt.event.MouseEvent evt) {
                formMouseDragged(evt);
            }
        });

        jSplitPane1.setBorder(null);
        jSplitPane1.setDividerLocation(200);
        jSplitPane1.setDividerSize(8);
        jSplitPane1.setOrientation(javax.swing.JSplitPane.VERTICAL_SPLIT);
        jSplitPane1.setResizeWeight(0.9);

        MsgText.setColumns(20);
        MsgText.setFont(new java.awt.Font("Arial", 0, 12));
        MsgText.setLineWrap(true);
        MsgText.setRows(2);
        MsgText.setNextFocusableComponent(jButton1);
        MsgText.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                MsgTextKeyPressed(evt);
            }
        });
        jScrollPane1.setViewportView(MsgText);

        java.util.ResourceBundle bundle = java.util.ResourceBundle.getBundle("aflobby/languages"); // NOI18N
        jButton1.setText(bundle.getString("Send")); // NOI18N
        jButton1.setMargin(new java.awt.Insets(2, 8, 2, 8));
        jButton1.setNextFocusableComponent(MsgText);
        jButton1.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                jButton1MousePressed(evt);
            }
        });

        jToggleButton1.setFont(new java.awt.Font("Arial", 0, 11));
        jToggleButton1.setSelected(true);
        jToggleButton1.setText(bundle.getString("Accumulate_messages")); // NOI18N

        cSmileyCombo1.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                        .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 340, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 78, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(jPanel2Layout.createSequentialGroup()
                        .addComponent(jToggleButton1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(cSmileyCombo1, javax.swing.GroupLayout.PREFERRED_SIZE, 161, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jToggleButton1)
                    .addComponent(cSmileyCombo1, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 43, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 63, Short.MAX_VALUE))
                .addContainerGap())
        );

        cSmileyCombo1.Init(MsgText);

        jSplitPane1.setBottomComponent(jPanel2);

        chat.setAutoscrolls(true);
        jSplitPane1.setLeftComponent(chat);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 448, Short.MAX_VALUE)
            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(layout.createSequentialGroup()
                    .addGap(0, 0, 0)
                    .addComponent(jSplitPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 448, Short.MAX_VALUE)
                    .addGap(0, 0, 0)))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 313, Short.MAX_VALUE)
            .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(layout.createSequentialGroup()
                    .addGap(0, 0, 0)
                    .addComponent(jSplitPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 313, Short.MAX_VALUE)
                    .addGap(0, 0, 0)))
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

    private void MsgTextKeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_MsgTextKeyPressed

        if (evt.getKeyCode() == KeyEvent.VK_ENTER) {
            if (evt.isShiftDown()) {
                return;
            }
            SendMessage();
        }
    }//GEN-LAST:event_MsgTextKeyPressed

    private void formMouseDragged(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMouseDragged
        java.awt.Point p = getLocation();
        setLocation(p.x + evt.getX() - origin.x, p.y + evt.getY() - origin.y);
    }//GEN-LAST:event_formMouseDragged

    private void formMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_formMousePressed
        origin.x = evt.getX();
        origin.y = evt.getY();
    }//GEN-LAST:event_formMousePressed

    private void jButton1MousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton1MousePressed
// TODO add your handling code here:
        SendMessage();
    }//GEN-LAST:event_jButton1MousePressed

    /**
     * @param args the command line arguments
     */
    public static void main(String[] args) {
        java.awt.EventQueue.invokeLater(new Runnable() {

            public void run() {
                new CPrivateMsgWindow().setVisible(false);
            }
        });
    }

    @SuppressWarnings("unchecked")
    private void createActionTable(JTextComponent textComponent) {
        actions = new HashMap();
        Action[] actionsArray = textComponent.getActions();
        for (int i = 0; i < actionsArray.length; i++) {
            Action a = actionsArray[i];
            actions.put(a.getValue(Action.NAME), a);
        }
    }

    private Action getActionByName(String name) {
        return (Action) (actions.get (name));
    }

    public void Add(String s) {
        logger.info(s);
        chat.AddMessage(s);
    }

    public void Update() {
        //
    }

    public void Open() {
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                if(!isVisible()){
                    setVisible(true);
                }
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }

    public void Hide() {
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                setVisible(false);
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }
    public boolean ingame = false;

    public void NewEvent(CEvent e) {
        if (e.data[0].equals("REMOVEUSER")) {
            if (e.data[1].equals(player.name)) {
                Add(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CPrivateMessageWindow.user_disconnected_at_") + Misc.easyDateFormat("hh:mm:ss"));
            }
        } else if (e.data[0].equalsIgnoreCase("CLIENTBATTLESTATUS")) {
            if (player.name.equals(e.data[1])) {
                if (!ingame) {
                    if (Misc.getInGameFromStatus(Integer.parseInt(e.data[2])) == 1) {
                        Add(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CPrivateMessageWindow.user_ingame_at_") + Misc.easyDateFormat("hh:mm:ss"));
                        ingame = true;
                    }
                } else {
                    if (Misc.getInGameFromStatus(Integer.parseInt(e.data[2])) == 0) {
                        Add(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CPrivateMessageWindow.user_left_game_at_") + Misc.easyDateFormat("hh:mm:ss"));
                        ingame = false;
                    }
                }
            }
        } else if (e.data[0].equals("SAIDPRIVATE")) {
            if (e.data[1].equalsIgnoreCase(player.name)) {
                Open();
                //URL r = getClass ().getResource ("/");
                //if(r != null){
                new AePlayWave(Misc.GetAbsoluteLobbyFolderPath() + "sounds/question.wav").start();

                String time = CStringHelper.getHTMLTimestamp();
                String Msg = CStringHelper.getChatHTML(Misc.makeSentence(e.data, 2),false);
                String User = CStringHelper.getUserChatHTML(e.data[1]);

                if (chat.GetAutoScroll()) {
                    if (lastsent.equalsIgnoreCase(User.trim()) == false) {
                        Add(User +" "+ java.util.ResourceBundle.getBundle("aflobby/languages").getString("CPrivateMessageWindow._says:") +"<br>"+ time + Msg);
                        lastsent = User.trim();
                    } else {
                        Add(time + Msg);
                    }
                } else {
                    Add(time + User + " " + Msg);
                }


                //}
                /*if(jToggleButton1.isSelected ()==true){
                if(lastsent==0){
                Add (e.data[1] + " Says:\n   " + Misc.makeSentence (e.data,2));
                lastsent=2;
                }else if(lastsent==1){
                Add (e.data[1] + " Says:\n   " +Misc.makeSentence (e.data,2));
                lastsent=2;
                }else{
                Add ("   " + Misc.makeSentence (e.data,2));
                lastsent=2;
                }
                }else{
                Add (player.name + " Says:\n   " +Misc.makeSentence (e.data,2));
                lastsent=2;
                }*/
            }
        } else if (e.data[0].equals("SAIDPRIVEX")) {
            if (e.data[1].equals(player.name)) {
                Open();
                Add(player.name + " " + Misc.makeSentence(e.data, 2));
            }
        } else if (e.data[0].equals("ACCEPTED")) {
            Add(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CPrivateMessageWindow.logged_in_at_") + Misc.easyDateFormat("hh:mm:ss"));
        } else if (e.IsEvent(CEvent.LOGGEDOUT) || e.IsEvent(CEvent.LOGOUT)) {
            Add(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CPrivateMessageWindow.logged_out_at_") + Misc.easyDateFormat("hh:mm:ss"));
        }
    }

    public void NewGUIEvent(CEvent e) {
        if (e.data[0].equals("OPENPRIV")) {
            if (e.data[1] == null) {
                return;
            }
            if (e.data[1].equalsIgnoreCase(player.name)) {
                Open();
            }
        }
    }
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JTextArea MsgText;
    private aflobby.UI.CSmileyCombo cSmileyCombo1;
    private aflobby.CChatPanel chat;
    private javax.swing.JButton jButton1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JSplitPane jSplitPane1;
    private javax.swing.JToggleButton jToggleButton1;
    // End of variables declaration//GEN-END:variables
}
