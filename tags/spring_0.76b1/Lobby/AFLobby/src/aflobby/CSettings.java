/*
 * CSettings.java
 *
 * Created on 14 September 2007, 09:47
 */

package aflobby;

import aflobby.UI.CUISettings;
import aflobby.UI.CUserSettings;
import aflobby.UI.CView;
import java.awt.Color;
import java.io.File;
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import javax.swing.JFileChooser;
import javax.swing.ListModel;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;

/**
 * This panel class contains settings and options controls for the user to modify
 * the lobby with, such as highlighted keywords in chat or tab row
 * placements.
 * @author  AF-StandardUsr
 */
public class CSettings extends CView {
    /**
     * A file chooser for picking out unitsync/spring/etc
     */
    public final JFileChooser fc = new JFileChooser();
    
    public CSettings(){
        this.setTitle("CSettings");
        
        
        initComponents();
        
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                //setVisible(true);
                fc.setCurrentDirectory(null);
                autologincheckbox.setVisible(true);
                backButton.setVisible(false);
                String[] strings = CUserSettings.GetValue("ui.texthighlights").split(",");
                CVectorListModel v = (CVectorListModel) Highlights.getModel();
                for (String s : strings) {
                    v.addElement(s);
                }
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }
    
    /** Creates a new CSettings form. This form can be displayed on tis own as
     * other CView classes in the main window or it can be embedded inside
     * another component as a panel.
     *
     * If embedding inside a panel add it to LMain event handling by using
     * AddNonDispView() instead of AddView()
     *
     * @param LM - a reference to the LMain object used as the root object in
     * the lobby heirarchy.
     *
     * @param fullview - a boolean representing wether this form will be shown
     * inside another form or as a complete page. A true value will show a "back
     * to menu" button that changes the current view to the splash screen. This
     * could cause errors if set to true if displayed inside another view such
     * as inside a tab control
     */
    public CSettings(LMain LM, final boolean fullview) {
        this.LM = LM;
        this.setTitle("CSettings");
        
        
        Runnable doWorkRunnable1 = new Runnable() {
            public void run() {
                initComponents();
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable1);
        
        
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                //setVisible(true);
                fc.setCurrentDirectory(null);
                autologincheckbox.setVisible(!fullview);
                backButton.setVisible(fullview);
                String[] strings = CUserSettings.GetValue("ui.texthighlights").split(",");
                CVectorListModel v = (CVectorListModel) Highlights.getModel();
                for (String s : strings) {
                    v.addElement(s);
                }
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }

    /**
     * Retrieves the chat word highlights from the UI and saves them to the
     * settings class
     */
    public void SetHighlights() {
        String h = "";
        ListModel m = Highlights.getModel();
        for (int i = 0; i < m.getSize(); i++) {
            String s = (String) m.getElementAt(i);
            if(s == null){
                continue;
            }
            if(s.trim().equals("")){
                continue;
            }
            h += s;
            if (i + 1 != m.getSize()) {
                h += ",";
            }
        }
        CUserSettings.PutValue("ui.texthighlights", h);
    }

    /**
     * Handles new GUI Events dispatched from the LMain class.
     * @param e - a gui CEvent object 
     */
    @Override
    public void NewGUIEvent(final CEvent e) {
        // do GUI stuff
        if (e.IsEvent(CEvent.LOGONSCRIPTCHANGE)) {
            Runnable doWorkRunnable = new Runnable() {

                public void run() {
                    String s = aflobby.UI.CUserSettings.GetStartScript();
                    CLogonScriptText.setText(s);
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
        }
    }
    public Color GetTextColour(String t, Color def){
        if(t != null){
            if(t.equals("")==false){
                return Color.decode(t);
            }
        }
        return def;
    }
    public void RedrawTextPreview(){
        // draw the text preview
        String s = (String) this.TextColourCombo.getSelectedItem();
        if(s == null ){
            return;
        }
        String mc = CUserSettings.GetValue("textcolours."+s,"");
        TextColourPanel.setBackground(GetTextColour(mc,Color.black));
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        buttonGroup1 = new javax.swing.ButtonGroup();
        buttonGroup2 = new javax.swing.ButtonGroup();
        settingsTabPane = new javax.swing.JTabbedPane();
        MainTab = new javax.swing.JScrollPane();
        jPanel4 = new javax.swing.JPanel();
        jLabel7 = new javax.swing.JLabel();
        jButton9 = new javax.swing.JButton();
        jLabel8 = new javax.swing.JLabel();
        jButton12 = new javax.swing.JButton();
        jLabel9 = new javax.swing.JLabel();
        jButton13 = new javax.swing.JButton();
        jButton14 = new javax.swing.JButton();
        jButton15 = new javax.swing.JButton();
        jButton16 = new javax.swing.JButton();
        jLabel10 = new javax.swing.JLabel();
        jLabel11 = new javax.swing.JLabel();
        jLabel13 = new javax.swing.JLabel();
        jLabel16 = new javax.swing.JLabel();
        FilePathsPanel = new javax.swing.JPanel();
        jLabel2 = new javax.swing.JLabel();
        jButton6 = new javax.swing.JButton();
        jLabel3 = new javax.swing.JLabel();
        jButton7 = new javax.swing.JButton();
        unitsyncpathlabel = new javax.swing.JLabel();
        springpathlabel = new javax.swing.JLabel();
        jButton8 = new javax.swing.JButton();
        SettingsPathLabel = new javax.swing.JLabel();
        jLabel17 = new javax.swing.JLabel();
        jButton17 = new javax.swing.JButton();
        SingleplayerLabel = new javax.swing.JLabel();
        jLabel4 = new javax.swing.JLabel();
        jLabel21 = new javax.swing.JLabel();
        jLabel22 = new javax.swing.JLabel();
        GlestLabel = new javax.swing.JLabel();
        jButton19 = new javax.swing.JButton();
        OnLoginPanel = new javax.swing.JPanel();
        jScrollPane7 = new javax.swing.JScrollPane();
        CLogonScriptText = new javax.swing.JTextPane();
        jButton2 = new javax.swing.JButton();
        jButton3 = new javax.swing.JButton();
        jLabel20 = new javax.swing.JLabel();
        autologincheckbox = new javax.swing.JCheckBox();
        InterfacePane = new javax.swing.JScrollPane();
        jPanel1 = new javax.swing.JPanel();
        jRadioButton1 = new javax.swing.JRadioButton();
        jRadioButton2 = new javax.swing.JRadioButton();
        jRadioButton3 = new javax.swing.JRadioButton();
        jRadioButton4 = new javax.swing.JRadioButton();
        jLabel12 = new javax.swing.JLabel();
        jRadioButton5 = new javax.swing.JRadioButton();
        jRadioButton6 = new javax.swing.JRadioButton();
        jRadioButton7 = new javax.swing.JRadioButton();
        jLabel1 = new javax.swing.JLabel();
        jCheckBox1 = new javax.swing.JCheckBox();
        BattlePositionCheckBox = new javax.swing.JCheckBox();
        jCheckBox2 = new javax.swing.JCheckBox();
        jCheckBox3 = new javax.swing.JCheckBox();
        HighlightPane = new javax.swing.JScrollPane();
        jPanel8 = new javax.swing.JPanel();
        jScrollPane3 = new javax.swing.JScrollPane();
        Highlights = new javax.swing.JList();
        jLabel14 = new javax.swing.JLabel();
        NewHighlightEntry = new javax.swing.JTextField();
        jButton1 = new javax.swing.JButton();
        jButton4 = new javax.swing.JButton();
        jButton5 = new javax.swing.JButton();
        jLabel15 = new javax.swing.JLabel();
        jScrollPane1 = new javax.swing.JScrollPane();
        jPanel2 = new javax.swing.JPanel();
        TextColourCombo = new javax.swing.JComboBox();
        jScrollPane2 = new javax.swing.JScrollPane();
        jEditorPane1 = new javax.swing.JEditorPane();
        jLabel18 = new javax.swing.JLabel();
        jButton18 = new javax.swing.JButton();
        TextColourPanel = new javax.swing.JPanel();
        jLabel19 = new javax.swing.JLabel();
        LadderPane = new javax.swing.JPanel();
        jLabel5 = new javax.swing.JLabel();
        ladderPassBox = new javax.swing.JTextField();
        jButton10 = new javax.swing.JButton();
        jButton11 = new javax.swing.JButton();
        jLabel26 = new javax.swing.JLabel();
        jLabel27 = new javax.swing.JLabel();
        backButton = new javax.swing.JButton();
        jLabel6 = new javax.swing.JLabel();

        settingsTabPane.setFont(CUISettings.GetFont(12,false));

        jLabel7.setFont(jLabel7.getFont().deriveFont(jLabel7.getFont().getSize()+7f));
        jLabel7.setText("Please Choose an option below or to the left, changes are saved automatically");

        jButton9.setText("Set up Paths");
        jButton9.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton9ActionPerformed(evt);
            }
        });

        jLabel8.setText("<html>Set up the location of unitsync and spring<br>\nThese are needed to start and use spring in AFLobby");

        jButton12.setText("Initial Commands");
        jButton12.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton12ActionPerformed(evt);
            }
        });

        jLabel9.setText("<html>Set up AFLobby to join channels, message people,<br> and do other things when you log in");

        jButton13.setText("Interface Settings");
        jButton13.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton13ActionPerformed(evt);
            }
        });

        jButton14.setText("Chat Highlighting");
        jButton14.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton14ActionPerformed(evt);
            }
        });

        jButton15.setText("Ladder Settings");
        jButton15.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton15ActionPerformed(evt);
            }
        });

        jButton16.setText("Spring Settings");
        jButton16.setEnabled(CUserSettings.GetValue("settings.command", "").equals("")==false);
        jButton16.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton16ActionPerformed(evt);
            }
        });

        jLabel10.setText("<html>Change AFLobbys theme, re-arrange tabs,<br>the battle list, and customize other controls");

        jLabel11.setText("<html>Set up and control ladder game integration, to play<br> against other ranked players");

        jLabel13.setText("<html>Start Settings++ and change springs graphics, screen resolution, <br>and other engine related settings");

        jLabel16.setText("<html>Highlight words and phrases in<br>conversations in different colours");

        javax.swing.GroupLayout jPanel4Layout = new javax.swing.GroupLayout(jPanel4);
        jPanel4.setLayout(jPanel4Layout);
        jPanel4Layout.setHorizontalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel7, javax.swing.GroupLayout.DEFAULT_SIZE, 791, Short.MAX_VALUE)
                    .addGroup(jPanel4Layout.createSequentialGroup()
                        .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(jButton16, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButton15, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButton14, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButton12, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jButton9, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 171, Short.MAX_VALUE)
                            .addComponent(jButton13, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jLabel13, javax.swing.GroupLayout.DEFAULT_SIZE, 433, Short.MAX_VALUE)
                            .addComponent(jLabel11, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel16, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel10, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel9, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel8, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))))
                .addContainerGap())
        );

        jPanel4Layout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {jButton12, jButton13, jButton14, jButton15, jButton16, jButton9});

        jPanel4Layout.setVerticalGroup(
            jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel4Layout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addComponent(jLabel7, javax.swing.GroupLayout.PREFERRED_SIZE, 42, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButton9, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel8, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButton12, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel9, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButton13, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel10, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButton14, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel16, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButton15, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel11, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel4Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jButton16, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel13, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(218, Short.MAX_VALUE))
        );

        jPanel4Layout.linkSize(javax.swing.SwingConstants.VERTICAL, new java.awt.Component[] {jButton12, jButton13, jButton14, jButton15, jButton16, jButton9});

        MainTab.setViewportView(jPanel4);

        settingsTabPane.addTab("Overview", MainTab);

        FilePathsPanel.setEnabled(!Misc.isWindows());

        jLabel2.setText("UnitSync");

        jButton6.setText("Browse");
        jButton6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton6ActionPerformed(evt);
            }
        });

        jLabel3.setText("Spring");

        jButton7.setText("Browse");
        jButton7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton7ActionPerformed(evt);
            }
        });

        unitsyncpathlabel.setText(CUserSettings.GetValue("unitsyncpath", ""));

        springpathlabel.setText(CUserSettings.GetValue("springpath", ""));

        jButton8.setText("Browse");
        jButton8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton8ActionPerformed(evt);
            }
        });

        SettingsPathLabel.setText(CUserSettings.GetValue("settings.command", ""));

        jLabel17.setText("Spring Settings");

        jButton17.setText("Browse");
        jButton17.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton17ActionPerformed(evt);
            }
        });

        SingleplayerLabel.setText(CUserSettings.GetValue("singleplayer.command", ""));

        jLabel4.setText("Single Player");

        jLabel21.setFont(jLabel21.getFont().deriveFont(jLabel21.getFont().getStyle() | java.awt.Font.BOLD, jLabel21.getFont().getSize()+4));
        jLabel21.setText("When you've set the paths, restart aflobby for the changes to take effect.");

        jLabel22.setText("Glest");

        GlestLabel.setText(CUserSettings.GetValue("singleplayer.command", ""));

        jButton19.setText("Browse");
        jButton19.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton19ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout FilePathsPanelLayout = new javax.swing.GroupLayout(FilePathsPanel);
        FilePathsPanel.setLayout(FilePathsPanelLayout);
        FilePathsPanelLayout.setHorizontalGroup(
            FilePathsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(FilePathsPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(FilePathsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                    .addComponent(jLabel21, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, FilePathsPanelLayout.createSequentialGroup()
                        .addGroup(FilePathsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jLabel2, javax.swing.GroupLayout.DEFAULT_SIZE, 118, Short.MAX_VALUE)
                            .addComponent(jLabel3, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel17, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel22, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(FilePathsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(springpathlabel, javax.swing.GroupLayout.PREFERRED_SIZE, 524, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(unitsyncpathlabel, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.PREFERRED_SIZE, 524, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(SettingsPathLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 524, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(SingleplayerLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 524, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(GlestLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 524, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(FilePathsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jButton17, javax.swing.GroupLayout.Alignment.TRAILING, 0, 0, Short.MAX_VALUE)
                    .addComponent(jButton8, javax.swing.GroupLayout.Alignment.TRAILING, 0, 0, Short.MAX_VALUE)
                    .addComponent(jButton7, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButton6, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(jButton19, javax.swing.GroupLayout.Alignment.TRAILING, 0, 0, Short.MAX_VALUE))
                .addContainerGap())
        );

        FilePathsPanelLayout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {jButton17, jButton19, jButton6, jButton7, jButton8});

        FilePathsPanelLayout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {jLabel17, jLabel2, jLabel22, jLabel3, jLabel4});

        FilePathsPanelLayout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {GlestLabel, SettingsPathLabel, SingleplayerLabel, springpathlabel, unitsyncpathlabel});

        FilePathsPanelLayout.setVerticalGroup(
            FilePathsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(FilePathsPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(FilePathsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton6)
                    .addComponent(unitsyncpathlabel)
                    .addComponent(jLabel2))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(FilePathsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton7)
                    .addComponent(springpathlabel, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel3))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(FilePathsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton8)
                    .addComponent(jLabel17, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(SettingsPathLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 24, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(FilePathsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton17)
                    .addComponent(jLabel4)
                    .addComponent(SingleplayerLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(FilePathsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton19)
                    .addComponent(GlestLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel22))
                .addGap(32, 32, 32)
                .addComponent(jLabel21, javax.swing.GroupLayout.PREFERRED_SIZE, 101, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(213, Short.MAX_VALUE))
        );

        FilePathsPanelLayout.linkSize(javax.swing.SwingConstants.VERTICAL, new java.awt.Component[] {SettingsPathLabel, SingleplayerLabel, jButton17, jButton6, jButton7, jButton8, jLabel17, jLabel2, jLabel3, jLabel4, springpathlabel, unitsyncpathlabel});

        FilePathsPanelLayout.linkSize(javax.swing.SwingConstants.VERTICAL, new java.awt.Component[] {GlestLabel, jButton19, jLabel22});

        settingsTabPane.addTab("File Paths", new javax.swing.ImageIcon(getClass().getResource("/images/UI/page.gif")), FilePathsPanel); // NOI18N

        OnLoginPanel.setFont(CUISettings.GetFont(12,false));
        OnLoginPanel.addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentShown(java.awt.event.ComponentEvent evt) {
                OnLoginPanelComponentShown(evt);
            }
        });

        CLogonScriptText.setFont(CUISettings.GetFont(12,false));
        CLogonScriptText.setText(aflobby.UI.CUserSettings.GetStartScript());
        CLogonScriptText.addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentHidden(java.awt.event.ComponentEvent evt) {
                CLogonScriptTextComponentHidden(evt);
            }
            public void componentShown(java.awt.event.ComponentEvent evt) {
                CLogonScriptTextComponentShown(evt);
            }
        });
        jScrollPane7.setViewportView(CLogonScriptText);

        jButton2.setFont(CUISettings.GetFont(12,false));
        jButton2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/action_save.gif"))); // NOI18N
        java.util.ResourceBundle bundle = java.util.ResourceBundle.getBundle("aflobby/languages"); // NOI18N
        jButton2.setText(bundle.getString("CChannelView.jButton2.text")); // NOI18N
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        jButton3.setFont(CUISettings.GetFont(12,false));
        jButton3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/page_refresh.gif"))); // NOI18N
        jButton3.setText(bundle.getString("CChannelView.jButton3.text")); // NOI18N
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton3ActionPerformed(evt);
            }
        });

        jLabel20.setFont(CUISettings.GetFont(12,false));
        jLabel20.setText(bundle.getString("CChannelView.jLabel20.text")); // NOI18N

        autologincheckbox.setSelected(Boolean.valueOf(CUserSettings.GetValue("autologin", "false")));
        autologincheckbox.setText("Auto Login"); // NOI18N
        autologincheckbox.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                autologincheckboxActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout OnLoginPanelLayout = new javax.swing.GroupLayout(OnLoginPanel);
        OnLoginPanel.setLayout(OnLoginPanelLayout);
        OnLoginPanelLayout.setHorizontalGroup(
            OnLoginPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(OnLoginPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(OnLoginPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel20, javax.swing.GroupLayout.PREFERRED_SIZE, 586, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, OnLoginPanelLayout.createSequentialGroup()
                        .addComponent(jScrollPane7, javax.swing.GroupLayout.DEFAULT_SIZE, 705, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(OnLoginPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 99, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButton2, javax.swing.GroupLayout.PREFERRED_SIZE, 99, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addComponent(autologincheckbox, javax.swing.GroupLayout.PREFERRED_SIZE, 196, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap())
        );
        OnLoginPanelLayout.setVerticalGroup(
            OnLoginPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, OnLoginPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel20, javax.swing.GroupLayout.PREFERRED_SIZE, 105, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(autologincheckbox)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(OnLoginPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(OnLoginPanelLayout.createSequentialGroup()
                        .addComponent(jButton2)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton3))
                    .addComponent(jScrollPane7, javax.swing.GroupLayout.DEFAULT_SIZE, 346, Short.MAX_VALUE))
                .addContainerGap())
        );

        settingsTabPane.addTab("On Login", new javax.swing.ImageIcon(getClass().getResource("/images/UI/page_dynamic.gif")), OnLoginPanel); // NOI18N

        buttonGroup2.add(jRadioButton1);
        jRadioButton1.setSelected(CUserSettings.GetValue("UI.toptabpane.placement", "" + javax.swing.JTabbedPane.TOP).equalsIgnoreCase("" + javax.swing.JTabbedPane.TOP));
        jRadioButton1.setText("Top"); // NOI18N
        jRadioButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton1ActionPerformed(evt);
            }
        });

        buttonGroup2.add(jRadioButton2);
        jRadioButton2.setSelected(CUserSettings.GetValue("UI.toptabpane.placement", "" + javax.swing.JTabbedPane.TOP).equalsIgnoreCase("" + javax.swing.JTabbedPane.BOTTOM));
        jRadioButton2.setText("Bottom"); // NOI18N
        jRadioButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton2ActionPerformed(evt);
            }
        });

        buttonGroup2.add(jRadioButton3);
        jRadioButton3.setSelected(CUserSettings.GetValue("UI.toptabpane.placement", "" + javax.swing.JTabbedPane.TOP).equalsIgnoreCase("" + javax.swing.JTabbedPane.LEFT));
        jRadioButton3.setText("Left"); // NOI18N
        jRadioButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton3ActionPerformed(evt);
            }
        });

        buttonGroup2.add(jRadioButton4);
        jRadioButton4.setSelected(CUserSettings.GetValue("UI.toptabpane.placement", "" + javax.swing.JTabbedPane.TOP).equalsIgnoreCase("" + javax.swing.JTabbedPane.RIGHT));
        jRadioButton4.setText("Right"); // NOI18N
        jRadioButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton4ActionPerformed(evt);
            }
        });

        jLabel12.setText("Main lobby tab control orientation"); // NOI18N

        buttonGroup1.add(jRadioButton5);
        jRadioButton5.setSelected(CUserSettings.GetValue("looknfeel", UIManager.getSystemLookAndFeelClassName()).contains("substance"));
        jRadioButton5.setText("Use Substance theme");
        jRadioButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton5ActionPerformed(evt);
            }
        });

        buttonGroup1.add(jRadioButton6);
        jRadioButton6.setSelected(CUserSettings.GetValue("looknfeel", UIManager.getSystemLookAndFeelClassName()).equals(UIManager.getSystemLookAndFeelClassName()));
        jRadioButton6.setText("Use Native OS theme");
        jRadioButton6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton6ActionPerformed(evt);
            }
        });

        buttonGroup1.add(jRadioButton7);
        jRadioButton7.setSelected(CUserSettings.GetValue("looknfeel", UIManager.getSystemLookAndFeelClassName()).equals("defjava"));
        jRadioButton7.setText("Use default Java theme");
        jRadioButton7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jRadioButton7ActionPerformed(evt);
            }
        });

        jLabel1.setText("Main Lobby GUI theme");

        jCheckBox1.setSelected(Boolean.valueOf(CUserSettings.GetValue("angledtabs", "true")));
        jCheckBox1.setText("Use substance sideways tabs on tabs to the left and right");
        jCheckBox1.setEnabled(CUserSettings.GetValue("looknfeel", "org.jvnet.substance.skin.SubstanceBusinessBlackSteelLookAndFeel").contains("substance"));
        jCheckBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox1ActionPerformed(evt);
            }
        });

        BattlePositionCheckBox.setSelected(CUserSettings.GetValue("ui.channelview.battlelisttopposition", "true").equals("false"));
        BattlePositionCheckBox.setText("Show Battle List underneath the main tab control (TASClient style)");
        BattlePositionCheckBox.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                BattlePositionCheckBoxActionPerformed(evt);
            }
        });

        jCheckBox2.setSelected(Boolean.valueOf(CUserSettings.GetValue("ui.channelview.userjoinflags", "true")));
        jCheckBox2.setText("Show flags when User joins");
        jCheckBox2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox2ActionPerformed(evt);
            }
        });

        jCheckBox3.setSelected(Boolean.valueOf(CUserSettings.GetValue("ui.channelview.userjoinranks", "false")));
        jCheckBox3.setText("Show ranks when User joins");
        jCheckBox3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jCheckBox3ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jCheckBox2)
                    .addComponent(jLabel12)
                    .addGroup(jPanel1Layout.createSequentialGroup()
                        .addGap(10, 10, 10)
                        .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jRadioButton2, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jRadioButton1)
                            .addComponent(jRadioButton3)
                            .addComponent(jRadioButton4)))
                    .addComponent(jLabel1)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addComponent(BattlePositionCheckBox, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel1Layout.createSequentialGroup()
                            .addGap(10, 10, 10)
                            .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addGroup(jPanel1Layout.createSequentialGroup()
                                    .addComponent(jRadioButton5)
                                    .addGap(18, 18, 18)
                                    .addComponent(jCheckBox1, javax.swing.GroupLayout.PREFERRED_SIZE, 423, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addComponent(jRadioButton7)
                                .addComponent(jRadioButton6))))
                    .addComponent(jCheckBox3))
                .addContainerGap(238, Short.MAX_VALUE))
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel12)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jRadioButton1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jRadioButton2)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jRadioButton3)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jRadioButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jLabel1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jRadioButton7)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jRadioButton5)
                    .addComponent(jCheckBox1))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jRadioButton6)
                .addGap(18, 18, 18)
                .addComponent(BattlePositionCheckBox)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBox2)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jCheckBox3)
                .addContainerGap(197, Short.MAX_VALUE))
        );

        InterfacePane.setViewportView(jPanel1);

        settingsTabPane.addTab("UI Settings", new javax.swing.ImageIcon(getClass().getResource("/images/UI/icon_monitor_pc.gif")), InterfacePane); // NOI18N

        HighlightPane.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);

        jScrollPane3.setMinimumSize(new java.awt.Dimension(19, 60));
        jScrollPane3.setPreferredSize(new java.awt.Dimension(2, 60));

        Highlights.setModel(new CVectorListModel());
        Highlights.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jScrollPane3.setViewportView(Highlights);

        jLabel14.setFont(jLabel14.getFont().deriveFont(jLabel14.getFont().getSize()+3f));
        jLabel14.setText("Highlighted text"); // NOI18N

        jButton1.setText("Add"); // NOI18N
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jButton4.setText("Remove Selected"); // NOI18N
        jButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton4ActionPerformed(evt);
            }
        });

        jButton5.setText("Remove All"); // NOI18N
        jButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton5ActionPerformed(evt);
            }
        });

        jLabel15.setText("Highlights words and text in colour. note:: accepts regex highlighting"); // NOI18N

        javax.swing.GroupLayout jPanel8Layout = new javax.swing.GroupLayout(jPanel8);
        jPanel8.setLayout(jPanel8Layout);
        jPanel8Layout.setHorizontalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel8Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel8Layout.createSequentialGroup()
                        .addComponent(jButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 154, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(18, 18, 18)
                        .addComponent(jButton5, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel14, javax.swing.GroupLayout.PREFERRED_SIZE, 204, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel15, javax.swing.GroupLayout.PREFERRED_SIZE, 617, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel8Layout.createSequentialGroup()
                        .addComponent(NewHighlightEntry, javax.swing.GroupLayout.DEFAULT_SIZE, 609, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                        .addComponent(jButton1))
                    .addComponent(jScrollPane3, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 670, Short.MAX_VALUE))
                .addGap(148, 148, 148))
        );
        jPanel8Layout.setVerticalGroup(
            jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel8Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel14)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel15)
                .addGap(12, 12, 12)
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton1)
                    .addComponent(NewHighlightEntry, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(8, 8, 8)
                .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 367, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel8Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton4)
                    .addComponent(jButton5))
                .addContainerGap())
        );

        HighlightPane.setViewportView(jPanel8);

        settingsTabPane.addTab("Highlighting", new javax.swing.ImageIcon(getClass().getResource("/images/UI/page_colors.gif")), HighlightPane); // NOI18N

        TextColourCombo.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "chat text", "usernames", "timestamps", "action chat text" }));
        TextColourCombo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                TextColourComboActionPerformed(evt);
            }
        });

        jEditorPane1.setEditable(false);
        jScrollPane2.setViewportView(jEditorPane1);

        jLabel18.setText("Preview:");

        jButton18.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/colourpickerwheel.png"))); // NOI18N
        jButton18.setText("Change Colour");
        jButton18.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton18ActionPerformed(evt);
            }
        });

        TextColourPanel.setBorder(new javax.swing.border.LineBorder(new java.awt.Color(0, 0, 0), 1, true));

        javax.swing.GroupLayout TextColourPanelLayout = new javax.swing.GroupLayout(TextColourPanel);
        TextColourPanel.setLayout(TextColourPanelLayout);
        TextColourPanelLayout.setHorizontalGroup(
            TextColourPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 604, Short.MAX_VALUE)
        );
        TextColourPanelLayout.setVerticalGroup(
            TextColourPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 43, Short.MAX_VALUE)
        );

        jLabel19.setText("<html>At the moment only a few of the text types are customizeable but in the next release the full spectrum should be available.<br>\n<br>\nThe preview pane will also contain something useful in the next release.");

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(TextColourCombo, 0, 791, Short.MAX_VALUE)
                    .addComponent(jScrollPane2)
                    .addComponent(jLabel18)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                        .addComponent(jButton18, javax.swing.GroupLayout.DEFAULT_SIZE, 179, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(TextColourPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(jLabel19, javax.swing.GroupLayout.PREFERRED_SIZE, 425, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap())
        );

        jPanel2Layout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {TextColourCombo, jScrollPane2});

        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel18)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane2, javax.swing.GroupLayout.PREFERRED_SIZE, 82, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(TextColourCombo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(TextColourPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton18))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel19, javax.swing.GroupLayout.PREFERRED_SIZE, 111, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(236, Short.MAX_VALUE))
        );

        jPanel2Layout.linkSize(javax.swing.SwingConstants.VERTICAL, new java.awt.Component[] {TextColourPanel, jButton18});

        jScrollPane1.setViewportView(jPanel2);

        settingsTabPane.addTab("Chat Colours", new javax.swing.ImageIcon(getClass().getResource("/images/UI/colourpickerwheel16.png")), jScrollPane1); // NOI18N

        jLabel5.setText("Ladder password");

        ladderPassBox.setText(CUserSettings.GetValue("ladderpassword."+LM.protocol.GetUsername(), LM.protocol.Password()));

        jButton10.setText("Change Password");
        jButton10.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton10ActionPerformed(evt);
            }
        });

        jButton11.setText("Save Password");
        jButton11.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton11ActionPerformed(evt);
            }
        });

        jLabel26.setFont(jLabel26.getFont().deriveFont(jLabel26.getFont().getSize()+2f));
        jLabel26.setText("Ladder Properties");

        jLabel27.setText("Note: Currently these only affect the development ladder not the official ladder for testing purposes");

        javax.swing.GroupLayout LadderPaneLayout = new javax.swing.GroupLayout(LadderPane);
        LadderPane.setLayout(LadderPaneLayout);
        LadderPaneLayout.setHorizontalGroup(
            LadderPaneLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(LadderPaneLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(LadderPaneLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(LadderPaneLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addGroup(LadderPaneLayout.createSequentialGroup()
                            .addComponent(jButton11, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addComponent(jButton10))
                        .addGroup(LadderPaneLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 124, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(ladderPassBox, javax.swing.GroupLayout.PREFERRED_SIZE, 243, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addComponent(jLabel26)
                    .addComponent(jLabel27, javax.swing.GroupLayout.PREFERRED_SIZE, 576, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(244, Short.MAX_VALUE))
        );
        LadderPaneLayout.setVerticalGroup(
            LadderPaneLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(LadderPaneLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel26)
                .addGap(20, 20, 20)
                .addComponent(jLabel5)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(ladderPassBox, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(LadderPaneLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton10)
                    .addComponent(jButton11))
                .addGap(18, 18, 18)
                .addComponent(jLabel27)
                .addContainerGap(352, Short.MAX_VALUE))
        );

        settingsTabPane.addTab("Ladders", new javax.swing.ImageIcon(getClass().getResource("/images/UI/page_favourites.gif")), LadderPane); // NOI18N

        backButton.setText("<- Back to Main Menu"); // NOI18N
        backButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                backButtonActionPerformed(evt);
            }
        });

        jLabel6.setFont(jLabel6.getFont().deriveFont(jLabel6.getFont().getStyle() | java.awt.Font.BOLD, jLabel6.getFont().getSize()+4));
        jLabel6.setText("Settings");

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(settingsTabPane, javax.swing.GroupLayout.DEFAULT_SIZE, 835, Short.MAX_VALUE)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel6, javax.swing.GroupLayout.DEFAULT_SIZE, 612, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(backButton, javax.swing.GroupLayout.PREFERRED_SIZE, 199, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel6, javax.swing.GroupLayout.PREFERRED_SIZE, 19, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(backButton))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(settingsTabPane, javax.swing.GroupLayout.DEFAULT_SIZE, 530, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void CLogonScriptTextComponentHidden(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_CLogonScriptTextComponentHidden
        //CLogonScriptText.setText ("reload to see script");
    }//GEN-LAST:event_CLogonScriptTextComponentHidden

    private void CLogonScriptTextComponentShown(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_CLogonScriptTextComponentShown
    }//GEN-LAST:event_CLogonScriptTextComponentShown

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        aflobby.UI.CUserSettings.SaveStartScript(CLogonScriptText.getText());
    }//GEN-LAST:event_jButton2ActionPerformed

    private void jButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton3ActionPerformed
        final String s = aflobby.UI.CUserSettings.GetStartScript();
        CLogonScriptText.setText(s);
    }//GEN-LAST:event_jButton3ActionPerformed

    private void autologincheckboxActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_autologincheckboxActionPerformed
        CUserSettings.PutValue("autologin", String.valueOf(autologincheckbox.isSelected()));
}//GEN-LAST:event_autologincheckboxActionPerformed

    private void OnLoginPanelComponentShown(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_OnLoginPanelComponentShown
}//GEN-LAST:event_OnLoginPanelComponentShown

    private void jRadioButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton1ActionPerformed
        if (jRadioButton1.isSelected()) {
            CUserSettings.PutValue("UI.toptabpane.placement", "" + javax.swing.JTabbedPane.TOP);
        }
    }//GEN-LAST:event_jRadioButton1ActionPerformed

    private void jRadioButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton2ActionPerformed
        if (jRadioButton2.isSelected()) {
            CUserSettings.PutValue("UI.toptabpane.placement", "" + javax.swing.JTabbedPane.BOTTOM);
//            tabpane.setTabPlacement(javax.swing.JTabbedPane.BOTTOM);
//            tabpane.validate();
        }
    }//GEN-LAST:event_jRadioButton2ActionPerformed

    private void jRadioButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton3ActionPerformed
        if (jRadioButton3.isSelected()) {
            CUserSettings.PutValue("UI.toptabpane.placement", "" + javax.swing.JTabbedPane.LEFT);
//            tabpane.setTabPlacement(javax.swing.JTabbedPane.LEFT);
//            tabpane.validate();
        }
    }//GEN-LAST:event_jRadioButton3ActionPerformed

    private void jRadioButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton4ActionPerformed
        if (jRadioButton4.isSelected()) {
            CUserSettings.PutValue("UI.toptabpane.placement", String.valueOf(javax.swing.JTabbedPane.RIGHT));
//            tabpane.setTabPlacement(javax.swing.JTabbedPane.RIGHT);
//            tabpane.validate();
        }
    }//GEN-LAST:event_jRadioButton4ActionPerformed

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        String h = NewHighlightEntry.getText();
        if (h == null) {
            return;
        }
        if (h.trim().equals("")) {
            return;
        }
        CVectorListModel v = (CVectorListModel) Highlights.getModel();
        v.addElement(h);
        SetHighlights();
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton4ActionPerformed
        int i = Highlights.getSelectedIndex();
        if (i == -1) {
            return;
        }
        Highlights.remove(i);
        SetHighlights();
    }//GEN-LAST:event_jButton4ActionPerformed

    private void jButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton5ActionPerformed
        if (Highlights.getModel().getSize() > 0) {
            Highlights.removeAll();
            SetHighlights();
        }
    }//GEN-LAST:event_jButton5ActionPerformed

    private void backButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_backButtonActionPerformed
        LM.SetFocus("Splash");
        LM.RemoveView(this);
        LM = null;
    }//GEN-LAST:event_backButtonActionPerformed

    private void jRadioButton7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton7ActionPerformed
        if(jRadioButton7.isSelected()){
            jCheckBox1.setEnabled(false);
            CUserSettings.PutValue("looknfeel", "defjava");
            CLooknfeelHelper.SetLooknfeel(UIManager.getCrossPlatformLookAndFeelClassName());
            SwingUtilities.updateComponentTreeUI(LM);
            LM.pack();
        }
    }//GEN-LAST:event_jRadioButton7ActionPerformed

    private void jRadioButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton5ActionPerformed
        if(jRadioButton5.isSelected()){
            jCheckBox1.setEnabled(true);
            CUserSettings.PutValue("looknfeel", "org.jvnet.substance.skin.SubstanceRavenGraphiteLookAndFeel");
            CLooknfeelHelper.SetLooknfeel("org.jvnet.substance.skin.SubstanceRavenGraphiteLookAndFeel");
            SwingUtilities.updateComponentTreeUI(LM);
            LM.pack();
        }
    }//GEN-LAST:event_jRadioButton5ActionPerformed

    private void jRadioButton6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jRadioButton6ActionPerformed
        if(jRadioButton6.isSelected()){
            jCheckBox1.setEnabled(false);
            CUserSettings.PutValue("looknfeel", UIManager.getSystemLookAndFeelClassName());
            CLooknfeelHelper.SetLooknfeel(UIManager.getSystemLookAndFeelClassName());
            SwingUtilities.updateComponentTreeUI(LM);
            LM.pack();
        }
    }//GEN-LAST:event_jRadioButton6ActionPerformed

    private void jCheckBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox1ActionPerformed
        CUserSettings.PutValue("angledtabs", String.valueOf(jCheckBox1.isSelected()));
    }//GEN-LAST:event_jCheckBox1ActionPerformed

    private void jButton6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton6ActionPerformed
        int returnVal = fc.showOpenDialog(this);

        if (returnVal == JFileChooser.APPROVE_OPTION) {
            File file = fc.getSelectedFile();
            try {
                
                unitsyncpathlabel.setText(file.getCanonicalPath());
                CUserSettings.PutValue("unitsyncpath", file.getCanonicalPath());
            } catch (IOException ex) {
                Logger.getLogger(CSettings.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }//GEN-LAST:event_jButton6ActionPerformed

    private void jButton7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton7ActionPerformed
        int returnVal = fc.showOpenDialog(this);

        if (returnVal == JFileChooser.APPROVE_OPTION) {
            File file = fc.getSelectedFile();
            try {
                
                springpathlabel.setText(file.getCanonicalPath());
                CUserSettings.PutValue("springpath", file.getCanonicalPath());
            } catch (IOException ex) {
                Logger.getLogger(CSettings.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }//GEN-LAST:event_jButton7ActionPerformed

    private void BattlePositionCheckBoxActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_BattlePositionCheckBoxActionPerformed
        CUserSettings.PutValue("ui.channelview.battlelisttopposition", String.valueOf(!BattlePositionCheckBox.isSelected()));
    }//GEN-LAST:event_BattlePositionCheckBoxActionPerformed

    private void jButton11ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton11ActionPerformed
        CUserSettings.PutValue("ladderpassword."+LM.protocol.GetUsername(), ladderPassBox.getText());
    }//GEN-LAST:event_jButton11ActionPerformed

    private void jButton10ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton10ActionPerformed
        String npass = ladderPassBox.getText();
        String pass = CUserSettings.GetValue("ladderpassword."+LM.protocol.GetUsername(), LM.protocol.Password());
        String user = LM.protocol.GetUsername();
        boolean r = CMeltraxLadder.ChangePassword(user, pass, npass);
        if(!r){
            LM.Toasts.AddMessage("error, could nto change password");
        }
    }//GEN-LAST:event_jButton10ActionPerformed

    private void jButton16ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton16ActionPerformed
        String c = CUserSettings.GetValue("settings.command", "");
        if (c.equals("")) {
            return;
        } else {
            try {
                Runtime.getRuntime().exec(c);
            } catch (IOException ex) {
                Logger.getLogger(CSplashScreen.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }//GEN-LAST:event_jButton16ActionPerformed

    private void jButton9ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton9ActionPerformed
        settingsTabPane.setSelectedComponent(FilePathsPanel);
    }//GEN-LAST:event_jButton9ActionPerformed

    private void jButton12ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton12ActionPerformed
        settingsTabPane.setSelectedComponent(OnLoginPanel);
    }//GEN-LAST:event_jButton12ActionPerformed

    private void jButton13ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton13ActionPerformed
        settingsTabPane.setSelectedComponent(InterfacePane);
    }//GEN-LAST:event_jButton13ActionPerformed

    private void jButton14ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton14ActionPerformed
        settingsTabPane.setSelectedComponent(HighlightPane);
    }//GEN-LAST:event_jButton14ActionPerformed

    private void jButton15ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton15ActionPerformed
        settingsTabPane.setSelectedComponent(LadderPane);
    }//GEN-LAST:event_jButton15ActionPerformed

    private void jButton8ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton8ActionPerformed
        int returnVal = fc.showOpenDialog(this);

        if (returnVal == JFileChooser.APPROVE_OPTION) {
            File file = fc.getSelectedFile();
            try {
                SettingsPathLabel.setText(file.getCanonicalPath());
                CUserSettings.PutValue("settings.command", file.getCanonicalPath());
            } catch (IOException ex) {
                Logger.getLogger(CSettings.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }//GEN-LAST:event_jButton8ActionPerformed

    private void jButton17ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton17ActionPerformed
        int returnVal = fc.showOpenDialog(this);

        if (returnVal == JFileChooser.APPROVE_OPTION) {
            File file = fc.getSelectedFile();
            try {
                SingleplayerLabel.setText(file.getCanonicalPath());
                CUserSettings.PutValue("singleplayer.command", file.getCanonicalPath());
            } catch (IOException ex) {
                Logger.getLogger(CSettings.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }//GEN-LAST:event_jButton17ActionPerformed

    private void TextColourComboActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_TextColourComboActionPerformed
        RedrawTextPreview();
}//GEN-LAST:event_TextColourComboActionPerformed

    private void jButton18ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton18ActionPerformed
        Color c = LM.ShowColorDialog(this, "Pick a Colour");
        if(c == null){
            return;
        }
        String s = (String) TextColourCombo.getSelectedItem();
        if(s == null){
            return;
        }
        CUserSettings.PutValue("textcolours."+s, String.valueOf(c.getRGB()));
        CTextColours.load();
        RedrawTextPreview();
    }//GEN-LAST:event_jButton18ActionPerformed

    private void jCheckBox2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox2ActionPerformed
        CUserSettings.PutValue("ui.channelview.userjoinflags", String.valueOf(jCheckBox2.isSelected()));
    }//GEN-LAST:event_jCheckBox2ActionPerformed

    private void jCheckBox3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jCheckBox3ActionPerformed
        CUserSettings.PutValue("ui.channelview.userjoinranks", String.valueOf(jCheckBox3.isSelected()));
    }//GEN-LAST:event_jCheckBox3ActionPerformed

    private void jButton19ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton19ActionPerformed
        int returnVal = fc.showOpenDialog(this);

        if (returnVal == JFileChooser.APPROVE_OPTION) {
            File file = fc.getSelectedFile();
            try {
                GlestLabel.setText(file.getCanonicalPath());
                CUserSettings.PutValue("glest.command", file.getCanonicalPath());
            } catch (IOException ex) {
                Logger.getLogger(CSettings.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
    }//GEN-LAST:event_jButton19ActionPerformed

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JCheckBox BattlePositionCheckBox;
    private javax.swing.JTextPane CLogonScriptText;
    private javax.swing.JPanel FilePathsPanel;
    private javax.swing.JLabel GlestLabel;
    private javax.swing.JScrollPane HighlightPane;
    private javax.swing.JList Highlights;
    private javax.swing.JScrollPane InterfacePane;
    private javax.swing.JPanel LadderPane;
    private javax.swing.JScrollPane MainTab;
    private javax.swing.JTextField NewHighlightEntry;
    private javax.swing.JPanel OnLoginPanel;
    private javax.swing.JLabel SettingsPathLabel;
    private javax.swing.JLabel SingleplayerLabel;
    private javax.swing.JComboBox TextColourCombo;
    private javax.swing.JPanel TextColourPanel;
    private javax.swing.JCheckBox autologincheckbox;
    private javax.swing.JButton backButton;
    private javax.swing.ButtonGroup buttonGroup1;
    private javax.swing.ButtonGroup buttonGroup2;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton10;
    private javax.swing.JButton jButton11;
    private javax.swing.JButton jButton12;
    private javax.swing.JButton jButton13;
    private javax.swing.JButton jButton14;
    private javax.swing.JButton jButton15;
    private javax.swing.JButton jButton16;
    private javax.swing.JButton jButton17;
    private javax.swing.JButton jButton18;
    private javax.swing.JButton jButton19;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton4;
    private javax.swing.JButton jButton5;
    private javax.swing.JButton jButton6;
    private javax.swing.JButton jButton7;
    private javax.swing.JButton jButton8;
    private javax.swing.JButton jButton9;
    private javax.swing.JCheckBox jCheckBox1;
    private javax.swing.JCheckBox jCheckBox2;
    private javax.swing.JCheckBox jCheckBox3;
    private javax.swing.JEditorPane jEditorPane1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel13;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel15;
    private javax.swing.JLabel jLabel16;
    private javax.swing.JLabel jLabel17;
    private javax.swing.JLabel jLabel18;
    private javax.swing.JLabel jLabel19;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel20;
    private javax.swing.JLabel jLabel21;
    private javax.swing.JLabel jLabel22;
    private javax.swing.JLabel jLabel26;
    private javax.swing.JLabel jLabel27;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel4;
    private javax.swing.JPanel jPanel8;
    private javax.swing.JRadioButton jRadioButton1;
    private javax.swing.JRadioButton jRadioButton2;
    private javax.swing.JRadioButton jRadioButton3;
    private javax.swing.JRadioButton jRadioButton4;
    private javax.swing.JRadioButton jRadioButton5;
    private javax.swing.JRadioButton jRadioButton6;
    private javax.swing.JRadioButton jRadioButton7;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JScrollPane jScrollPane7;
    private javax.swing.JTextField ladderPassBox;
    private javax.swing.JTabbedPane settingsTabPane;
    private javax.swing.JLabel springpathlabel;
    private javax.swing.JLabel unitsyncpathlabel;
    // End of variables declaration//GEN-END:variables
}