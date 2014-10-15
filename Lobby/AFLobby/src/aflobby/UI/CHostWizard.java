/*
 * CHostWizard.java
 *
 * Created on 13 April 2008, 14:50
 */

package aflobby.UI;

import aflobby.CLadderProperties;
import aflobby.CMeltraxLadder;
import aflobby.CSync;
import aflobby.CUnitSyncJNIBindings;
import aflobby.LMain;
import aflobby.framework.CEvent;
import aflobby.helpers.AlphanumComparator;
import aflobby.helpers.BrowserLauncher;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import javax.swing.JPanel;
import javax.swing.SpinnerNumberModel;
import javax.swing.SwingUtilities;
import javax.swing.SwingWorker;

/**
 *
 * @author  tarendai-std
 */
public class CHostWizard extends CView {
    
    List<JPanel> pages = new ArrayList<JPanel>();
    String game = "";
    int currentIndex = 0;
    
    /** Creates new form CHostWizard
     * @param LM 
     */
    public CHostWizard(LMain LM) {
        super(LM);
        currentIndex = 0;
        initComponents();
        SwingWorker worker = new SwingWorker<Void, Void>() {

            @Override
            public Void doInBackground() {
                CMeltraxLadder.Initialize();
                return null;
            }

            @Override
            public void done() {
                wizardPagePanel.add(InitialPanel);
                if (CMeltraxLadder.GetLadderCount() > 0) {
                    for (String ln : CMeltraxLadder.ladders.values()) {
                        if (ln != null) {
                            laddercomboBox.addItem(ln);
                        }
                    }
                }
            }
        };
        worker.execute();
    }
    
    @Override
    public void NewGUIEvent(final CEvent e){
        if (e.IsEvent(CEvent.EXITEDBATTLE)) {
            if(!CUnitSyncJNIBindings.loaded){
                return;
            }
            if(currentIndex != 0){
                Runnable doWorkRunnable = new Runnable() {
                    public void run() {
                        hostButton.setEnabled(true);
                    }
                };
                SwingUtilities.invokeLater(doWorkRunnable);
            }
        } else if (e.IsEvent(CEvent.CONTENTREFRESH)) {
            //
            RefreshContent();
        }
    }
    
    @Override
    public void NewEvent(final CEvent e){
        if(CUnitSyncJNIBindings.loaded){
            if (e.IsEvent("OPENBATTLE") || e.IsEvent("JOINBATTLE")) {
                Runnable doWorkRunnable = new Runnable() {
                    public void run() {
                        hostButton.setEnabled(false);
                    }
                };
                SwingUtilities.invokeLater(doWorkRunnable);
            }
        }
    }
    
    public void RefreshContent() {
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                HostMod.removeAllItems();
                String lname = (String)laddercomboBox.getSelectedItem();
                if(lname == null){
                    lname = "None";
                }
                if(lname.equals("None")==false){
                    CLadderProperties p = CMeltraxLadder.GetLadderData(CMeltraxLadder.GetLadderID(lname));
                    if(p != null){
                        lname = p.mod;
                    }
                }
                lname = lname.toLowerCase();
                ArrayList<String> mods = new ArrayList<String>();
                for (int i = 0; i < CSync.modcount; i++) {
                    String s = CSync.mod_names.get(i);
                    if (s == null) {
                        continue;
                    }
                    if (s.equals("")) {
                        continue;
                    }
                    if(lname.equals("none")==false){
                        if (!s.toLowerCase().contains(lname)) {
                            continue;
                        }
                    }
                    mods.add(CSync.mod_names.get(i));
                }
                if(!mods.isEmpty()){
                    Object[] o = mods.toArray().clone();
                    Arrays.sort(o, new AlphanumComparator());
                    for (Object s : o) {
                        if (s == null) {
                            continue;
                        }
                        if (((String) s).equals("")) {
                            continue;
                        }
                        HostMod.addItem(s);
                    }
                    HostMod.setSelectedItem(CUserSettings.GetValue("UI.lasthosted.mod", "XTA v9"));
                }else{
                    HostMod.setSelectedItem(CUserSettings.GetValue("UI.lasthosted.mod", "XTA v9"));
                }

            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);

    }
    
    public void NextPage(){
        //
        int nextIndex = currentIndex +1;
        assert(nextIndex > pages.size());
        
        ProcessButtonEnables(nextIndex);
        
        JPanel nextPanel = pages.get(nextIndex);
        SetPage(nextPanel);
        currentIndex++;
    }
    
    public void PreviousPage(){
        //
        int previousIndex = currentIndex - 1;
        assert(previousIndex > -1);
        
        ProcessButtonEnables(previousIndex);
        
        
        JPanel nextPanel = pages.get(previousIndex);
        SetPage(nextPanel);
        currentIndex--;
    }
    
    public void ProcessButtonEnables(int newIndex){
        //
        if(newIndex == 0){
            //
            Runnable doWorkRunnable = new Runnable() {
                public void run() {
                    backButton.setEnabled(false);
                    hostButton.setEnabled(false);
                    nextButton.setEnabled(false);
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
        }else{
            Runnable doWorkRunnable = new Runnable() {
                public void run() {
                    backButton.setEnabled(true);
                    hostButton.setEnabled(true);
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
            
            if(newIndex == pages.size()-1){
            //
                Runnable doWorkRunnable4 = new Runnable() {
                    public void run() {
                        nextButton.setEnabled(false);
                    }
                };
                SwingUtilities.invokeLater(doWorkRunnable4);
            }
        }
    }
    public void SetPage(final JPanel page){
        
        Runnable doWorkRunnable = new Runnable() {
            public void run() {
                wizardPagePanel.removeAll();
                wizardPagePanel.add(page);

            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }
    
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        InitialPanel = new javax.swing.JPanel();
        jLabel1 = new javax.swing.JLabel();
        jPanel2 = new javax.swing.JPanel();
        jLabel4 = new javax.swing.JLabel();
        jButton6 = new javax.swing.JButton();
        jButton7 = new javax.swing.JButton();
        springHostWizardButton = new javax.swing.JButton();
        glestHostWizardButton = new javax.swing.JButton();
        SpringPanel = new javax.swing.JPanel();
        jLabel7 = new javax.swing.JLabel();
        jLabel12 = new javax.swing.JLabel();
        laddercomboBox = new javax.swing.JComboBox();
        HostMod = new javax.swing.JComboBox();
        jButton4 = new javax.swing.JButton();
        hostReloadmodlist = new javax.swing.JButton();
        jButton5 = new javax.swing.JButton();
        jLabel2 = new javax.swing.JLabel();
        jLabel10 = new javax.swing.JLabel();
        jLabel9 = new javax.swing.JLabel();
        HostUDPPort = new javax.swing.JTextField();
        HostNATCombo = new javax.swing.JComboBox();
        BasicPanel = new javax.swing.JPanel();
        jLabel6 = new javax.swing.JLabel();
        jLabel5 = new javax.swing.JLabel();
        HostBattleName = new javax.swing.JTextField();
        HostMaxPlayers = new javax.swing.JSpinner();
        jLabel8 = new javax.swing.JLabel();
        jLabel11 = new javax.swing.JLabel();
        HostPassword = new javax.swing.JTextField();
        HostRankLimitCombo = new javax.swing.JComboBox();
        wizardPagePanel = new javax.swing.JPanel();
        hostButton = new javax.swing.JButton();
        backButton = new javax.swing.JButton();
        jSeparator1 = new javax.swing.JSeparator();
        nextButton = new javax.swing.JButton();

        jLabel1.setFont(jLabel1.getFont().deriveFont(jLabel1.getFont().getSize()+13f));
        java.util.ResourceBundle bundle = java.util.ResourceBundle.getBundle("aflobby/languages"); // NOI18N
        jLabel1.setText(bundle.getString("CHostWizard.jLabel1.text")); // NOI18N

        jPanel2.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel4.setFont(jLabel4.getFont().deriveFont(jLabel4.getFont().getSize()+6f));
        jLabel4.setText(bundle.getString("CHostWizard.jLabel4.text_1")); // NOI18N

        jButton6.setText(bundle.getString("CHostWizard.jButton6.text")); // NOI18N
        jButton6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton6ActionPerformed(evt);
            }
        });

        jButton7.setText(bundle.getString("CHostWizard.jButton7.text")); // NOI18N
        jButton7.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton7ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel4, javax.swing.GroupLayout.DEFAULT_SIZE, 194, Short.MAX_VALUE)
                    .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                        .addComponent(jButton7, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addComponent(jButton6, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 194, Short.MAX_VALUE)))
                .addContainerGap())
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel4, javax.swing.GroupLayout.PREFERRED_SIZE, 31, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton6)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton7)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        springHostWizardButton.setText("Host a Spring Game");
        springHostWizardButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                springHostWizardButtonActionPerformed(evt);
            }
        });

        glestHostWizardButton.setText("Host a Glest Game");
        glestHostWizardButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                glestHostWizardButtonActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout InitialPanelLayout = new javax.swing.GroupLayout(InitialPanel);
        InitialPanel.setLayout(InitialPanelLayout);
        InitialPanelLayout.setHorizontalGroup(
            InitialPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(InitialPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(InitialPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(InitialPanelLayout.createSequentialGroup()
                        .addComponent(jLabel1, javax.swing.GroupLayout.DEFAULT_SIZE, 318, Short.MAX_VALUE)
                        .addGap(31, 31, 31))
                    .addGroup(InitialPanelLayout.createSequentialGroup()
                        .addGroup(InitialPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(glestHostWizardButton, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(springHostWizardButton, javax.swing.GroupLayout.Alignment.LEADING))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)))
                .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );
        InitialPanelLayout.setVerticalGroup(
            InitialPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(InitialPanelLayout.createSequentialGroup()
                .addGroup(InitialPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(InitialPanelLayout.createSequentialGroup()
                        .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 35, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 39, Short.MAX_VALUE)
                        .addComponent(glestHostWizardButton)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(springHostWizardButton))
                    .addGroup(InitialPanelLayout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addGap(22, 22, 22))
        );

        jLabel7.setText(bundle.getString("CHostWizard.jLabel7.text")); // NOI18N

        jLabel12.setText(bundle.getString("CHostWizard.jLabel12.text")); // NOI18N

        laddercomboBox.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "None" }));
        laddercomboBox.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                laddercomboBoxActionPerformed(evt);
            }
        });

        HostMod.setMaximumRowCount(16);

        jButton4.setText(bundle.getString("CHostWizard.jButton1.text")); // NOI18N
        jButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton4ActionPerformed(evt);
            }
        });

        hostReloadmodlist.setText(bundle.getString("CHostWizard.hostReloadmodlist.text")); // NOI18N
        hostReloadmodlist.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                hostReloadmodlistActionPerformed(evt);
            }
        });

        jButton5.setText(bundle.getString("CHostWizard.jButton2.text_1")); // NOI18N
        jButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton5ActionPerformed(evt);
            }
        });

        jLabel2.setFont(jLabel2.getFont().deriveFont(jLabel2.getFont().getSize()+6f));
        jLabel2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/springIcon.png"))); // NOI18N
        jLabel2.setText(bundle.getString("CHostWizard.jLabel2.text_1")); // NOI18N

        jLabel10.setText(bundle.getString("CHostWizard.jLabel10.text")); // NOI18N

        jLabel9.setText(bundle.getString("CHostWizard.jLabel9.text")); // NOI18N

        HostUDPPort.setText(bundle.getString("CChannelView.HostUDPPort.text")); // NOI18N
        HostUDPPort.setEnabled(false);

        HostNATCombo.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "none", "hole punching", "fixed ports" }));
        HostNATCombo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                HostNATComboActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout SpringPanelLayout = new javax.swing.GroupLayout(SpringPanel);
        SpringPanel.setLayout(SpringPanelLayout);
        SpringPanelLayout.setHorizontalGroup(
            SpringPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(SpringPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(SpringPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(SpringPanelLayout.createSequentialGroup()
                        .addGroup(SpringPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel7, javax.swing.GroupLayout.DEFAULT_SIZE, 116, Short.MAX_VALUE)
                            .addComponent(jLabel12, javax.swing.GroupLayout.DEFAULT_SIZE, 116, Short.MAX_VALUE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(SpringPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(laddercomboBox, javax.swing.GroupLayout.PREFERRED_SIZE, 351, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(HostMod, javax.swing.GroupLayout.PREFERRED_SIZE, 351, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(SpringPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jButton4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(hostReloadmodlist))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton5)
                        .addGap(105, 105, 105))
                    .addGroup(SpringPanelLayout.createSequentialGroup()
                        .addComponent(jLabel2)
                        .addContainerGap(621, Short.MAX_VALUE))
                    .addGroup(SpringPanelLayout.createSequentialGroup()
                        .addGroup(SpringPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(jLabel10, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 111, Short.MAX_VALUE)
                            .addComponent(jLabel9, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 111, Short.MAX_VALUE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(SpringPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(HostNATCombo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(HostUDPPort, javax.swing.GroupLayout.PREFERRED_SIZE, 66, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addContainerGap(603, Short.MAX_VALUE))))
        );

        SpringPanelLayout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {jLabel10, jLabel12, jLabel7, jLabel9});

        SpringPanelLayout.setVerticalGroup(
            SpringPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(SpringPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel2)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(SpringPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(HostMod, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(hostReloadmodlist)
                    .addComponent(jLabel7))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(SpringPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(laddercomboBox, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton4)
                    .addComponent(jButton5)
                    .addComponent(jLabel12))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(SpringPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel9)
                    .addComponent(HostUDPPort, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(SpringPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(HostNATCombo, javax.swing.GroupLayout.PREFERRED_SIZE, 24, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel10))
                .addContainerGap(40, Short.MAX_VALUE))
        );

        jLabel6.setText(bundle.getString("CHostWizard.jLabel6.text")); // NOI18N

        jLabel5.setText(bundle.getString("CHostWizard.jLabel5.text")); // NOI18N

        HostBattleName.setText(CUserSettings.GetValue("UI.lasthosted.name",""));

        HostMaxPlayers.setModel(new SpinnerNumberModel (4,1,16,1));
        HostMaxPlayers.setValue(2);

        jLabel8.setText(bundle.getString("CHostWizard.jLabel8.text")); // NOI18N

        jLabel11.setText(bundle.getString("CHostWizard.jLabel11.text")); // NOI18N

        HostPassword.setBorder(new javax.swing.border.LineBorder(new java.awt.Color(255, 255, 0), 2, true));

        HostRankLimitCombo.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "No Limit", "Beginner", "Average", "Experienced", "Highly Experienced" }));

        javax.swing.GroupLayout BasicPanelLayout = new javax.swing.GroupLayout(BasicPanel);
        BasicPanel.setLayout(BasicPanelLayout);
        BasicPanelLayout.setHorizontalGroup(
            BasicPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 508, Short.MAX_VALUE)
            .addGroup(BasicPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(BasicPanelLayout.createSequentialGroup()
                    .addContainerGap()
                    .addGroup(BasicPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                        .addGroup(javax.swing.GroupLayout.Alignment.LEADING, BasicPanelLayout.createSequentialGroup()
                            .addGroup(BasicPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jLabel6, javax.swing.GroupLayout.PREFERRED_SIZE, 115, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jLabel5, javax.swing.GroupLayout.PREFERRED_SIZE, 115, javax.swing.GroupLayout.PREFERRED_SIZE))
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addGroup(BasicPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                .addComponent(HostBattleName, javax.swing.GroupLayout.DEFAULT_SIZE, 369, Short.MAX_VALUE)
                                .addComponent(HostMaxPlayers, javax.swing.GroupLayout.PREFERRED_SIZE, 85, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addGroup(javax.swing.GroupLayout.Alignment.LEADING, BasicPanelLayout.createSequentialGroup()
                            .addGroup(BasicPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jLabel8, javax.swing.GroupLayout.DEFAULT_SIZE, 115, Short.MAX_VALUE)
                                .addComponent(jLabel11, javax.swing.GroupLayout.DEFAULT_SIZE, 115, Short.MAX_VALUE))
                            .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                            .addGroup(BasicPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(HostPassword, javax.swing.GroupLayout.PREFERRED_SIZE, 369, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(HostRankLimitCombo, javax.swing.GroupLayout.PREFERRED_SIZE, 369, javax.swing.GroupLayout.PREFERRED_SIZE))))
                    .addContainerGap()))
        );

        BasicPanelLayout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {jLabel11, jLabel5, jLabel6, jLabel8});

        BasicPanelLayout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {HostBattleName, HostPassword, HostRankLimitCombo});

        BasicPanelLayout.setVerticalGroup(
            BasicPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 192, Short.MAX_VALUE)
            .addGroup(BasicPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                .addGroup(BasicPanelLayout.createSequentialGroup()
                    .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addGroup(BasicPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(HostBattleName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel6))
                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                    .addGroup(BasicPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(HostMaxPlayers, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel5))
                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                    .addGroup(BasicPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(HostPassword, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel8))
                    .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                    .addGroup(BasicPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(HostRankLimitCombo, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel11))
                    .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)))
        );

        wizardPagePanel.setLayout(new javax.swing.BoxLayout(wizardPagePanel, javax.swing.BoxLayout.LINE_AXIS));

        hostButton.setText("Host Game");
        hostButton.setEnabled(false);
        hostButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                hostButtonActionPerformed(evt);
            }
        });

        backButton.setText("Back");
        backButton.setEnabled(false);
        backButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                backButtonActionPerformed(evt);
            }
        });

        nextButton.setText("Next");
        nextButton.setEnabled(false);
        nextButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                nextButtonActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addContainerGap(524, Short.MAX_VALUE)
                .addComponent(backButton)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(nextButton)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(hostButton)
                .addContainerGap())
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jSeparator1, javax.swing.GroupLayout.DEFAULT_SIZE, 721, Short.MAX_VALUE)
                .addContainerGap())
            .addComponent(wizardPagePanel, javax.swing.GroupLayout.DEFAULT_SIZE, 741, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addComponent(wizardPagePanel, javax.swing.GroupLayout.DEFAULT_SIZE, 134, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jSeparator1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(hostButton)
                    .addComponent(backButton)
                    .addComponent(nextButton))
                .addContainerGap())
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jButton6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton6ActionPerformed
        BrowserLauncher.openURL("http://www.glest.org/en/downloads.html");
    }//GEN-LAST:event_jButton6ActionPerformed

    private void jButton7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton7ActionPerformed
        BrowserLauncher.openURL("http://spring.clan-sy.com/download.php");
    }//GEN-LAST:event_jButton7ActionPerformed

    private void HostNATComboActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_HostNATComboActionPerformed
        HostUDPPort.setEnabled(HostNATCombo.getSelectedIndex()== 2);
    }//GEN-LAST:event_HostNATComboActionPerformed

    private void laddercomboBoxActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_laddercomboBoxActionPerformed
        String s = (String) laddercomboBox.getSelectedItem();
        if (s.equals("None") == false) {
            HostPassword.setText("ladderlock");
            HostPassword.setEnabled(false);
            HostRankLimitCombo.setEnabled(false);
            HostBattleName.setEnabled(false);
            HostBattleName.setText("(ladder " + CMeltraxLadder.GetLadderID(s) + ") " + s);
        } else {
            HostPassword.setEnabled(true);
            HostRankLimitCombo.setEnabled(true);
            HostBattleName.setEnabled(true);
            String t = HostBattleName.getText();
            if (t.startsWith("(ladder")) {
                HostBattleName.setText("");
            }
        }
        RefreshContent();
    }//GEN-LAST:event_laddercomboBoxActionPerformed

    private void jButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton4ActionPerformed
        CMeltraxLadder.Initialize();
        laddercomboBox.removeAllItems();
        laddercomboBox.addItem("None");
        if (CMeltraxLadder.GetLadderCount() > 0) {
            laddercomboBox.setEnabled(true);
            for (String ln : CMeltraxLadder.ladders.values()) {
                if (ln != null) {
                    laddercomboBox.addItem(ln);
                }
            }
        }else{
            laddercomboBox.setEnabled(false);
        }
    }//GEN-LAST:event_jButton4ActionPerformed

    private void hostReloadmodlistActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_hostReloadmodlistActionPerformed
        CSync.RefreshUnitSync();
    }//GEN-LAST:event_hostReloadmodlistActionPerformed

    private void jButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton5ActionPerformed
        BrowserLauncher.openURL("http://www.spring-league.com/ladder/index.php?ULadder/URules");
    }//GEN-LAST:event_jButton5ActionPerformed

    private void springHostWizardButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_springHostWizardButtonActionPerformed
        game = "spring";
        
        pages.clear();
        
        pages.add(InitialPanel);
        pages.add(BasicPanel);
        pages.add(SpringPanel);
        
        NextPage();
}//GEN-LAST:event_springHostWizardButtonActionPerformed

    private void glestHostWizardButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_glestHostWizardButtonActionPerformed
        game = "glest";        //
        
        pages.clear();
        
        pages.add(InitialPanel);
        pages.add(BasicPanel);
        
        NextPage();
}//GEN-LAST:event_glestHostWizardButtonActionPerformed

    private void backButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_backButtonActionPerformed
        PreviousPage();
    }//GEN-LAST:event_backButtonActionPerformed

    private void nextButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_nextButtonActionPerformed
        NextPage();
    }//GEN-LAST:event_nextButtonActionPerformed

    private void hostButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_hostButtonActionPerformed
        //OPENBATTLE type natType password port maxplayers hashcode rank maphash {map} {title} {modname}
        String s = "OPENBATTLE ";
        s += "0 "; //type
        s += this.HostNATCombo.getSelectedIndex() + " "; // natType
        if (HostPassword.getText().equals("") == false) {
            s += this.HostPassword.getText() + " ";
        } else {
            s += "* ";
        } // password
        s += HostUDPPort.getText() + " "; // port
        s += HostMaxPlayers.getValue() + " "; // maxplayers
        if(game.equalsIgnoreCase("spring")){
            

            String selected_mod = (String) HostMod.getSelectedItem();
            s += CSync.GetModHashbyName(selected_mod) + " "; // hashcode
            CUserSettings.PutValue("UI.lasthosted.mod", selected_mod);

            s += this.HostRankLimitCombo.getSelectedIndex() + " "; // rank

            String m = CUserSettings.GetValue("UI.lasthosted.map", CSync.map_names.get(0));
            s += CSync.GetMapHash(m) + " "; // maphash
            s += m;
            //        }else{
            //            s += "0 n/a ";
            //        }

            s += "\t";

            //        if (engine.equals("glest")){
            //            s += "glest: ";
            //        }
            s += HostBattleName.getText();

            //        if(engine.equals("spring")){
            s += "\t" + HostMod.getSelectedItem();
            //        }else if (engine.equals("glest")){
            //            s += "\tGlest";
            //        }
            LM.protocol.SendTraffic(s);
        } else if (game.equalsIgnoreCase("glest")){
            s += "0 ";
            s += this.HostRankLimitCombo.getSelectedIndex() + " "; // rank

            s += "0 n/a ";

            s += "\t";

            s += "glest: ";

            s += HostBattleName.getText();

            s += "\tGlest";

            LM.protocol.SendTraffic(s);

        }
        CUserSettings.PutValue("UI.lasthosted.maxplayers", "" + HostMaxPlayers.getValue());
        CUserSettings.PutValue("UI.lasthosted.name", HostBattleName.getText());
}//GEN-LAST:event_hostButtonActionPerformed
    
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JPanel BasicPanel;
    private javax.swing.JTextField HostBattleName;
    private javax.swing.JSpinner HostMaxPlayers;
    private javax.swing.JComboBox HostMod;
    private javax.swing.JComboBox HostNATCombo;
    private javax.swing.JTextField HostPassword;
    private javax.swing.JComboBox HostRankLimitCombo;
    private javax.swing.JTextField HostUDPPort;
    private javax.swing.JPanel InitialPanel;
    private javax.swing.JPanel SpringPanel;
    private javax.swing.JButton backButton;
    private javax.swing.JButton glestHostWizardButton;
    private javax.swing.JButton hostButton;
    private javax.swing.JButton hostReloadmodlist;
    private javax.swing.JButton jButton4;
    private javax.swing.JButton jButton5;
    private javax.swing.JButton jButton6;
    private javax.swing.JButton jButton7;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JSeparator jSeparator1;
    private javax.swing.JComboBox laddercomboBox;
    private javax.swing.JButton nextButton;
    private javax.swing.JButton springHostWizardButton;
    private javax.swing.JPanel wizardPagePanel;
    // End of variables declaration//GEN-END:variables
    
}
