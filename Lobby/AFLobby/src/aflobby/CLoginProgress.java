/*
 * JLoginPogress.java
 *
 * Created on 12 February 2007, 00:26
 */

package aflobby;

import aflobby.framework.CEvent;
import aflobby.UI.CUISettings;
import aflobby.UI.CUserSettings;
import aflobby.UI.CView;
import aflobby.protocol.tasserver.CTASServerProtocol;
import javax.swing.SwingUtilities;

/**
 *
 * @author  Tom J. Nowell (AF)
 */
public class CLoginProgress extends CView {

    //public int interested = 0;
    /**
     * Creates new form JLoginPogress
     * @param L
     */
    public CLoginProgress(LMain L) {
        LM = L;
        initComponents();
        setTitle("Loginprogress");
        UserTitle = "Login Progress";
        if (Boolean.valueOf(CUserSettings.GetValue("autologin", "false"))) {
            if(Main.ignoreautologin){
                return;
            }

            String protocol = CUserSettings.GetValue("lastprotocol");
            if (protocol.equalsIgnoreCase("TASServer v0.33")) {
                LM.protocol = new CTASServerProtocol();
                LM.core.AddModule(LM.protocol);
                LM.protocol.Init(LM);
            } else {
                LM.Toasts.AddMessage(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CLoginPanel.unsupported_protocol"));
                return;
            }
            boolean sha = Boolean.valueOf(CUserSettings.GetValue("lastloginsha", "false"));
            LoginTask LT = new LoginTask(LM,sha);
            LT.server = CUserSettings.GetValue("lastserver");
            LT.port = Integer.parseInt(CUserSettings.GetValue("lastserverport","8200"));
            LT.username = CUserSettings.GetValue("lastloginname");

            LT.password = CUserSettings.GetValue("lastpassword");
            LT.lp = this;
            LT.start();
        }
    }

    @Override
    public void Update() {
        //
    }

    //public void ValidatePanel(){
    //    validate();
    //    LM.DoValidate();
    //}
    @Override
    public void NewEvent(CEvent e) {
        if (e.IsEvent("LOGININFOEND") == true) {
            Runnable doWorkRunnable = new Runnable() {

                public void run() {
                    progressmessage.setText("logged in showing UI");
                    progressbar.setValue(95);
                    progressbar.setIndeterminate(false);
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
            
            LM.protocol.SendTraffic("SAYPRIVATE []Avalon AFLobby " + CUpdateChecker.AFLobbyVersion + " reporting");
            //LM.connection.SendLine ("JOIN aflobby AFL");
            LM.protocol.JoinChannel("aflobby", null);
            LM.protocol.SendTraffic("SAYEX aflobby is running aflobby " + CUpdateChecker.AFLobbyVersion);
            LM.DoValidate();
            LM.RemoveView(this);
        } else if (e.IsEvent(CEvent.CONNECTED)) {
            Runnable doWorkRunnable = new Runnable() {

                public void run() {
                    progressmessage.setText("connected logging in");
                    progressbar.setValue(80);
                    progressbar.setIndeterminate(false);
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
        } else if (e.IsEvent("ACCEPTED")) {
            Runnable doWorkRunnable = new Runnable() {

                public void run() {
                    progressmessage.setText("logged in, setting up lobby");
                    progressbar.setValue(90);
                    progressbar.setIndeterminate(false);
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
        } else if (e.IsEvent(CEvent.LOGINPROGRESS)) {
            dmessage = Misc.makeSentence(e.data, 2);
            dprogress = Integer.parseInt(e.data[1]);
            Runnable doWorkRunnable = new Runnable() {

                public void run() {
                    progressmessage.setText(dmessage);
                    progressbar.setValue(dprogress);
                    progressbar.setIndeterminate(false);
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
        } else if (e.IsEvent(CEvent.FAILEDCONNECTION) || e.IsEvent(CEvent.DISCONNECTED) || e.IsEvent(CEvent.DISCONNECTUNKNOWNHOST)) {
            if (LM.ViewExists("LoginPanel") == false) {
                CLoginPanel LP = new CLoginPanel(LM);
                LM.AddView(LP, true);
            } else {
                LM.SetFocus("LoginPanel");
            }
            LM.DoValidate();
            LM.RemoveView(this);
        }
    }
    String dmessage;
    Integer dprogress;

    @Override
    public void NewGUIEvent(CEvent e) {
        if (e.IsEvent(CEvent.LOGINPROGRESS)) {
            dmessage = Misc.makeSentence(e.data, 2);
            dprogress = Integer.parseInt(e.data[1]);
            Runnable doWorkRunnable = new Runnable() {

                public void run() {
                    progressmessage.setText(dmessage);
                    progressbar.setValue(dprogress);
                    progressbar.setIndeterminate(false);
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
        } else if (e.IsEvent(CEvent.DISCONNECT)) {
            LM.RemoveView(getTitle());
        }
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        progressmessage = new javax.swing.JLabel();
        progressbar = new javax.swing.JProgressBar();
        jLabel1 = new javax.swing.JLabel();
        jProgressBar1 = new javax.swing.JProgressBar();

        setMinimumSize(new java.awt.Dimension(840, 570));
        setPreferredSize(new java.awt.Dimension(840, 570));

        progressmessage.setFont(CUISettings.GetFont(12,false));
        progressmessage.setHorizontalAlignment(javax.swing.SwingConstants.LEFT);
        progressmessage.setText("Setting up UnitSync");
        progressmessage.setAlignmentX(0.5F);

        progressbar.setFont(CUISettings.GetFont(12,false));
        progressbar.setValue(5);
        progressbar.setFocusable(false);
        progressbar.setIndeterminate(true);

        jLabel1.setFont(jLabel1.getFont().deriveFont(jLabel1.getFont().getSize()+10f));
        jLabel1.setText("Progress");

        jProgressBar1.setIndeterminate(true);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel1, javax.swing.GroupLayout.DEFAULT_SIZE, 830, Short.MAX_VALUE)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addComponent(progressbar, javax.swing.GroupLayout.DEFAULT_SIZE, 820, Short.MAX_VALUE)
                        .addContainerGap())
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(progressmessage, javax.swing.GroupLayout.DEFAULT_SIZE, 760, Short.MAX_VALUE)
                        .addGap(70, 70, 70))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jProgressBar1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addContainerGap(684, Short.MAX_VALUE))))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap(224, Short.MAX_VALUE)
                .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 43, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGap(18, 18, 18)
                .addComponent(progressmessage)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(progressbar, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jProgressBar1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(223, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents
    // Variables declaration - do not modify
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JLabel jLabel1;
    private javax.swing.JProgressBar jProgressBar1;
    private javax.swing.JProgressBar progressbar;
    public javax.swing.JLabel progressmessage;
    // End of variables declaration//GEN-END:variables
}