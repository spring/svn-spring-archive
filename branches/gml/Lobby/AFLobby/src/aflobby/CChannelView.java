/*
 * JChannel.java
 * 98612769816789122
 * Created on 28 May 2006, 13:22
 */

package aflobby;

import aflobby.framework.CEvent;
import aflobby.UI.CUISettings;
import aflobby.UI.CUserSettings;
import aflobby.UI.CView;
import aflobby.helpers.BrowserLauncher;
import aflobby.helpers.AlphanumComparator;
import aflobby.protocol.tasserver.ui.CChannelList;
import java.awt.Color;
import java.awt.Component;
import java.awt.event.KeyEvent;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;
import java.util.TreeMap;
import java.util.concurrent.ExecutionException;
import javax.swing.JTable;
import javax.swing.SpinnerNumberModel;
import javax.swing.SwingUtilities;
import javax.swing.SwingWorker;
import javax.swing.table.DefaultTableCellRenderer;
import org.jvnet.lafwidget.LafWidget;
import org.jvnet.lafwidget.tabbed.DefaultTabPreviewPainter;

/**
 *
 * @author  Shade
 */
public class CChannelView extends CView {
    
    
    public boolean htmlaccess = false;

    CChannelList  cChannelList = null;
    CSettings cSettings = null;
    CBattleList cBattleList = null;
    

    public CChannelView(LMain L) {
        //try {
            setTitle("jChannelView");
            LM = L;

            Runnable doWorkRunnable = new Runnable() {

                public void run() {

                    initComponents();
                    Initialize();

                    if ((Main.chat_only_mode) || (!CUnitSyncJNIBindings.loaded)) {
                        Runnable doWorkRunnable = new Runnable() {

                            public void run() {

                                if ((Main.chat_only_mode) || (CContentManager.GetInstalledEngines().length < 1)) {
                                    tabpane.remove(jPanel3);
                                }
                            }
                        };
                        SwingUtilities.invokeLater(doWorkRunnable);
                    }
                    if (!Main.chat_only_mode) {
                        boolean b = CUserSettings.GetValue("ui.channelview.battlelisttopposition", "true").equals("true");
                        cBattleList = new CBattleList(LM);
                        LM.core.AddModule(cBattleList);
                        if (b) {
                            Runnable doWorkRunnable = new Runnable() {

                                public void run() {
                                    tabpane.add("Battle List", cBattleList);
                                    SplitPane.setDividerSize(0);
                                }
                            };
                            SwingUtilities.invokeLater(doWorkRunnable);
                        } else {
                            Runnable doWorkRunnable = new Runnable() {

                                public void run() {
                                    SplitPane.setResizeWeight(0.5);
                                    SplitPane.setDividerSize(8);
                                    SplitPane.setDividerLocation(0.7);
                                    SplitPane.setBottomComponent(cBattleList);
                                    LM.DoValidate();
                                }
                            };
                            SwingUtilities.invokeLater(doWorkRunnable);
                            //                    BottomPanel.add();
                        }
                    } else {
                        int a = 4;
                    }
                    
                    Runnable doWorkRunnable = new Runnable() {
                        public void run() {
                            cChannelList = new CChannelList(LM);
                            tabpane.add("Channels", cChannelList);
                            LM.core.AddModule(cChannelList);
                        }
                    };
                    SwingUtilities.invokeLater(doWorkRunnable);
                    
                    Runnable doWorkRunnable2 = new Runnable() {

                        public void run() {
                            cSettings = new CSettings(LM, false);
                            tabpane.add("Settings", cSettings);
                            LM.core.AddModule(cSettings);
                        }
                    };
                    SwingUtilities.invokeLater(doWorkRunnable2);

                    
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
            SwingWorker worker = new SwingWorker<Void, Void>() {

                @Override
                public Void doInBackground() {
                    CMeltraxLadder.Initialize();
                    return null;
                }

                @Override
                public void done() {
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


            //ValidatePanel ();
        /*} catch (InterruptedException ex) {
            Logger.getLogger(CChannelView.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InvocationTargetException ex) {
            Logger.getLogger(CChannelView.class.getName()).log(Level.SEVERE, null, ex);
        }*/
        

        //ValidatePanel ();
    }

    @Override
    public void OnRemove() {
        
        if(cSettings != null){
            LM.core.RemoveModule(cSettings);
            cSettings = null;
        }
        
        if(cBattleList != null){
            LM.core.RemoveModule(cBattleList);
            cBattleList = null;
        }
        
        for(CChannel c : this.channels.values()){
            LM.core.RemoveModule(c);
        }
        
        channels.clear();
    }

    @Override
    public void Initialize() {
        UserTitle = "Main lobby page";
    }

    private void AddPlayer( CPlayer cPlayer ) {
        
        
        playerTablePanel.AddPlayer(cPlayer);
    }


    // public javax.swing.JPanel jPanel1aaaaa;
    //public javax.swing.JScrollPane jScrollPane1aaaa;
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        tabplacementGroup = new javax.swing.ButtonGroup();
        SplitPane = new javax.swing.JSplitPane();
        tabpane = new javax.swing.JTabbedPane();
        jPanel7 = new javax.swing.JPanel();
        LogOutButton = new javax.swing.JButton();
        StatusCombo = new javax.swing.JComboBox();
        number_of_battles = new javax.swing.JLabel();
        ingame_label = new javax.swing.JLabel();
        jScrollPane4 = new javax.swing.JScrollPane();
        FServerMessages = new javax.swing.JEditorPane();
        ladderLabel = new javax.swing.JLabel();
        jButton14 = new javax.swing.JButton();
        WelcomeLabel = new javax.swing.JLabel();
        SearchBox = new javax.swing.JTextField();
        jButton3 = new javax.swing.JButton();
        jButton4 = new javax.swing.JButton();
        jButton5 = new javax.swing.JButton();
        jButton8 = new javax.swing.JButton();
        jPanel3 = new javax.swing.JPanel();
        HostBattleName = new javax.swing.JTextField();
        HostMaxPlayers = new javax.swing.JSpinner();
        jLabel5 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        HostPassword = new javax.swing.JTextField();
        jLabel8 = new javax.swing.JLabel();
        jLabel11 = new javax.swing.JLabel();
        HostRankLimitCombo = new javax.swing.JComboBox();
        jLabel1 = new javax.swing.JLabel();
        springHostPanel = new javax.swing.JPanel();
        HostButton = new javax.swing.JButton();
        jLabel10 = new javax.swing.JLabel();
        jLabel9 = new javax.swing.JLabel();
        HostUDPPort = new javax.swing.JTextField();
        HostNATCombo = new javax.swing.JComboBox();
        jLabel7 = new javax.swing.JLabel();
        jLabel12 = new javax.swing.JLabel();
        laddercomboBox = new javax.swing.JComboBox();
        HostMod = new javax.swing.JComboBox();
        jButton1 = new javax.swing.JButton();
        hostReloadmodlist = new javax.swing.JButton();
        jButton2 = new javax.swing.JButton();
        jLabel2 = new javax.swing.JLabel();
        glestHostPanel = new javax.swing.JPanel();
        jLabel3 = new javax.swing.JLabel();
        glestHostButton = new javax.swing.JButton();
        jPanel2 = new javax.swing.JPanel();
        jLabel4 = new javax.swing.JLabel();
        jButton6 = new javax.swing.JButton();
        jButton7 = new javax.swing.JButton();
        jPanel1 = new javax.swing.JPanel();
        playerTablePanel = new aflobby.UI.CPlayerTablePanel();
        playerTablePanel.LM = LM;
        BottomPanel = new javax.swing.JPanel();

        setFont(CUISettings.GetFont(12,false));
        setMaximumSize(new java.awt.Dimension(2840, 2560));
        setMinimumSize(new java.awt.Dimension(840, 570));
        setPreferredSize(new java.awt.Dimension(840, 570));

        SplitPane.setDividerSize(8);
        SplitPane.setOrientation(javax.swing.JSplitPane.VERTICAL_SPLIT);
        SplitPane.setResizeWeight(1.0);
        SplitPane.setOneTouchExpandable(true);

        tabpane.setTabLayoutPolicy(javax.swing.JTabbedPane.SCROLL_TAB_LAYOUT);
        tabpane.setTabPlacement(Integer.parseInt(CUserSettings.GetValue("UI.toptabpane.placement", ""+javax.swing.JTabbedPane.TOP)));
        tabpane.setMaximumSize(new java.awt.Dimension(83000, 530000));
        tabpane.setMinimumSize(new java.awt.Dimension(640, 300));
        tabpane.setPreferredSize(new java.awt.Dimension(840, 570));
        tabpane.putClientProperty(
            LafWidget.TABBED_PANE_PREVIEW_PAINTER,
            new DefaultTabPreviewPainter());

        jPanel7.setFont(CUISettings.GetFont(12,false));

        java.util.ResourceBundle bundle = java.util.ResourceBundle.getBundle("aflobby/languages"); // NOI18N
        LogOutButton.setText(bundle.getString("LMain.Logout")); // NOI18N
        LogOutButton.setBorder(new javax.swing.border.LineBorder(new java.awt.Color(255, 51, 0), 2, true));
        LogOutButton.setHorizontalAlignment(javax.swing.SwingConstants.LEADING);
        LogOutButton.setMargin(new java.awt.Insets(1, 6, 1, 6));
        LogOutButton.setPreferredSize(new java.awt.Dimension(33, 19));
        LogOutButton.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                LogOutButtonMouseReleased(evt);
            }
        });

        StatusCombo.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Online", "Away" }));
        StatusCombo.setMaximumSize(new java.awt.Dimension(70, 18));
        StatusCombo.addItemListener(new java.awt.event.ItemListener() {
            public void itemStateChanged(java.awt.event.ItemEvent evt) {
                StatusComboItemStateChanged(evt);
            }
        });
        StatusCombo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                StatusComboActionPerformed(evt);
            }
        });

        number_of_battles.setFont(number_of_battles.getFont().deriveFont(number_of_battles.getFont().getSize()+1f));
        number_of_battles.setText(bundle.getString("CChannelView.number_of_battles.text")); // NOI18N

        ingame_label.setFont(ingame_label.getFont().deriveFont(ingame_label.getFont().getSize()+1f));
        ingame_label.setText(bundle.getString("CChannelView.ingame_label.text")); // NOI18N

        FServerMessages.setContentType(bundle.getString("CChannelView.FServerMessages.contentType")); // NOI18N
        FServerMessages.setEditable(false);
        jScrollPane4.setViewportView(FServerMessages);

        ladderLabel.setFont(ladderLabel.getFont().deriveFont(ladderLabel.getFont().getSize()+1f));
        ladderLabel.setText("Not registered to the ladder"); // NOI18N

        jButton14.setText("www.darkstars.co.uk"); // NOI18N
        jButton14.setHorizontalAlignment(javax.swing.SwingConstants.LEADING);
        jButton14.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton14ActionPerformed(evt);
            }
        });

        WelcomeLabel.setFont(CUISettings.GetFont(24,true));
        WelcomeLabel.setText("Welcome "+LM.protocol.GetUsername() + "!");

        SearchBox.setText(bundle.getString("CChannelView.SearchBox.text")); // NOI18N
        SearchBox.addFocusListener(new java.awt.event.FocusAdapter() {
            public void focusGained(java.awt.event.FocusEvent evt) {
                SearchBoxFocusGained(evt);
            }
        });
        SearchBox.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyReleased(java.awt.event.KeyEvent evt) {
                SearchBoxKeyReleased(evt);
            }
            public void keyTyped(java.awt.event.KeyEvent evt) {
                SearchBoxKeyTyped(evt);
            }
        });

        jButton3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/icon_get_world.gif"))); // NOI18N
        jButton3.setText(bundle.getString("CChannelView.jButton3.text_1")); // NOI18N
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton3ActionPerformed(evt);
            }
        });

        jButton4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/info_small.png"))); // NOI18N
        jButton4.setText(bundle.getString("CChannelView.jButton4.text")); // NOI18N
        jButton4.setHorizontalAlignment(javax.swing.SwingConstants.LEADING);
        jButton4.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton4ActionPerformed(evt);
            }
        });

        jButton5.setText(bundle.getString("CChannelView.jButton5.text")); // NOI18N
        jButton5.setHorizontalAlignment(javax.swing.SwingConstants.LEADING);
        jButton5.setMargin(new java.awt.Insets(2, 6, 2, 6));
        jButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton5ActionPerformed(evt);
            }
        });

        jButton8.setText(bundle.getString("CChannelView.jButton8.text_1")); // NOI18N
        jButton8.setHorizontalAlignment(javax.swing.SwingConstants.LEADING);
        jButton8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton8ActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel7Layout = new javax.swing.GroupLayout(jPanel7);
        jPanel7.setLayout(jPanel7Layout);
        jPanel7Layout.setHorizontalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel7Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(WelcomeLabel, javax.swing.GroupLayout.DEFAULT_SIZE, 813, Short.MAX_VALUE)
                    .addGroup(jPanel7Layout.createSequentialGroup()
                        .addComponent(SearchBox, javax.swing.GroupLayout.DEFAULT_SIZE, 645, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 162, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(ingame_label, javax.swing.GroupLayout.DEFAULT_SIZE, 813, Short.MAX_VALUE)
                    .addComponent(number_of_battles, javax.swing.GroupLayout.DEFAULT_SIZE, 813, Short.MAX_VALUE)
                    .addComponent(ladderLabel, javax.swing.GroupLayout.DEFAULT_SIZE, 813, Short.MAX_VALUE)
                    .addGroup(jPanel7Layout.createSequentialGroup()
                        .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                .addComponent(LogOutButton, javax.swing.GroupLayout.PREFERRED_SIZE, 110, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(StatusCombo, javax.swing.GroupLayout.PREFERRED_SIZE, 136, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jButton8, javax.swing.GroupLayout.PREFERRED_SIZE, 169, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jButton5, javax.swing.GroupLayout.DEFAULT_SIZE, 178, Short.MAX_VALUE)
                                .addComponent(jButton4, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                            .addComponent(jButton14, javax.swing.GroupLayout.PREFERRED_SIZE, 74, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jScrollPane4, javax.swing.GroupLayout.DEFAULT_SIZE, 629, Short.MAX_VALUE)))
                .addContainerGap())
        );

        jPanel7Layout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {LogOutButton, StatusCombo, jButton14, jButton4, jButton5, jButton8});

        jPanel7Layout.setVerticalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel7Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(WelcomeLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(ingame_label)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(number_of_battles)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(ladderLabel)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(SearchBox, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton3))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel7Layout.createSequentialGroup()
                        .addComponent(jButton4, javax.swing.GroupLayout.DEFAULT_SIZE, 41, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(LogOutButton, javax.swing.GroupLayout.DEFAULT_SIZE, 41, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(StatusCombo, javax.swing.GroupLayout.DEFAULT_SIZE, 41, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton5, javax.swing.GroupLayout.PREFERRED_SIZE, 41, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton8, javax.swing.GroupLayout.PREFERRED_SIZE, 41, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton14))
                    .addComponent(jScrollPane4, javax.swing.GroupLayout.DEFAULT_SIZE, 376, Short.MAX_VALUE))
                .addContainerGap())
        );

        jPanel7Layout.linkSize(javax.swing.SwingConstants.VERTICAL, new java.awt.Component[] {LogOutButton, StatusCombo, jButton14, jButton4, jButton5, jButton8});

        jPanel7Layout.linkSize(javax.swing.SwingConstants.VERTICAL, new java.awt.Component[] {SearchBox, jButton3});

        tabpane.addTab(bundle.getString("CChannelView.jPanel7.TabConstraints.tabTitle_1"), jPanel7); // NOI18N

        jPanel3.setEnabled(CUnitSyncJNIBindings.loaded);
        jPanel3.setFont(CUISettings.GetFont(12,false));
        jPanel3.setMinimumSize(new java.awt.Dimension(500, 300));

        HostBattleName.setText(CUserSettings.GetValue("UI.lasthosted.name",""));

        HostMaxPlayers.setModel(new SpinnerNumberModel (4,1,16,1));
        HostMaxPlayers.setValue(2);

        jLabel5.setText(bundle.getString("CChannelView.jLabel5.text")); // NOI18N

        jLabel6.setLabelFor(HostBattleName);
        jLabel6.setText(bundle.getString("CChannelView.jLabel6.text")); // NOI18N

        HostPassword.setBorder(new javax.swing.border.LineBorder(new java.awt.Color(255, 255, 0), 2, true));

        jLabel8.setText(bundle.getString("CChannelView.jLabel8.text")); // NOI18N

        jLabel11.setText(bundle.getString("CChannelView.jLabel11.text")); // NOI18N

        HostRankLimitCombo.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "No Limit", "Beginner", "Average", "Experienced", "Highly Experienced" }));

        jLabel1.setFont(jLabel1.getFont().deriveFont(jLabel1.getFont().getSize()+13f));
        jLabel1.setText(bundle.getString("CChannelView.jLabel1.text")); // NOI18N

        HostButton.setText(bundle.getString("CChannelView.HostButton.text")); // NOI18N
        HostButton.setBorder(new javax.swing.border.LineBorder(new java.awt.Color(153, 204, 0), 2, true));
        HostButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                HostButtonActionPerformed(evt);
            }
        });

        jLabel10.setText(bundle.getString("CChannelView.jLabel10.text")); // NOI18N

        jLabel9.setText(bundle.getString("CChannelView.jLabel9.text")); // NOI18N

        HostUDPPort.setText(bundle.getString("CChannelView.HostUDPPort.text")); // NOI18N
        HostUDPPort.setEnabled(false);

        HostNATCombo.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "none", "hole punching", "fixed ports" }));
        HostNATCombo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                HostNATComboActionPerformed(evt);
            }
        });

        jLabel7.setText(bundle.getString("CChannelView.jLabel7.text")); // NOI18N

        jLabel12.setText(bundle.getString("CChannelView.jLabel12.text")); // NOI18N

        laddercomboBox.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "None" }));
        laddercomboBox.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                laddercomboBoxActionPerformed(evt);
            }
        });

        HostMod.setMaximumRowCount(16);

        jButton1.setText(bundle.getString("CChannelView.jButton1.text")); // NOI18N
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        hostReloadmodlist.setText(bundle.getString("CChannelView.hostReloadmodlist.text")); // NOI18N
        hostReloadmodlist.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                hostReloadmodlistActionPerformed(evt);
            }
        });

        jButton2.setText(bundle.getString("CChannelView.jButton2.text_1")); // NOI18N
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        jLabel2.setFont(jLabel2.getFont().deriveFont(jLabel2.getFont().getSize()+6f));
        jLabel2.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/springIcon.png"))); // NOI18N
        jLabel2.setText(bundle.getString("CChannelView.jLabel2.text_1")); // NOI18N

        javax.swing.GroupLayout springHostPanelLayout = new javax.swing.GroupLayout(springHostPanel);
        springHostPanel.setLayout(springHostPanelLayout);
        springHostPanelLayout.setHorizontalGroup(
            springHostPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(springHostPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(springHostPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(springHostPanelLayout.createSequentialGroup()
                        .addGroup(springHostPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel7, javax.swing.GroupLayout.DEFAULT_SIZE, 111, Short.MAX_VALUE)
                            .addComponent(jLabel12, javax.swing.GroupLayout.DEFAULT_SIZE, 111, Short.MAX_VALUE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(springHostPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(laddercomboBox, 0, 347, Short.MAX_VALUE)
                            .addComponent(HostMod, 0, 347, Short.MAX_VALUE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(springHostPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(jButton1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(hostReloadmodlist))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton2)
                        .addGap(105, 105, 105))
                    .addGroup(springHostPanelLayout.createSequentialGroup()
                        .addComponent(jLabel2)
                        .addContainerGap(621, Short.MAX_VALUE))
                    .addGroup(springHostPanelLayout.createSequentialGroup()
                        .addGroup(springHostPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(jLabel10, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 111, Short.MAX_VALUE)
                            .addComponent(jLabel9, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 111, Short.MAX_VALUE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(springHostPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(HostUDPPort, javax.swing.GroupLayout.PREFERRED_SIZE, 66, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(HostNATCombo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addContainerGap(608, Short.MAX_VALUE))
                    .addGroup(springHostPanelLayout.createSequentialGroup()
                        .addComponent(HostButton, javax.swing.GroupLayout.PREFERRED_SIZE, 143, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addContainerGap())))
        );

        springHostPanelLayout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {HostMod, laddercomboBox});

        springHostPanelLayout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {jLabel10, jLabel12, jLabel7, jLabel9});

        springHostPanelLayout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {HostNATCombo, HostUDPPort});

        springHostPanelLayout.setVerticalGroup(
            springHostPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, springHostPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel2)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 21, Short.MAX_VALUE)
                .addGroup(springHostPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(HostMod, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(hostReloadmodlist)
                    .addComponent(jLabel7))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(springHostPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(laddercomboBox, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton1)
                    .addComponent(jButton2)
                    .addComponent(jLabel12))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(springHostPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(HostUDPPort, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel9))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(springHostPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(HostNATCombo, javax.swing.GroupLayout.PREFERRED_SIZE, 24, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel10))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(HostButton, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        jLabel3.setFont(jLabel3.getFont().deriveFont(jLabel3.getFont().getSize()+6f));
        jLabel3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/shinyGlest.png"))); // NOI18N
        jLabel3.setText(bundle.getString("CChannelView.jLabel3.text")); // NOI18N

        glestHostButton.setText(bundle.getString("CChannelView.glestHostButton.text")); // NOI18N
        glestHostButton.setBorder(new javax.swing.border.LineBorder(new java.awt.Color(102, 204, 0), 2, true));
        glestHostButton.setEnabled(aflobby.CContentManager.SupportsEngine("glest"));
        glestHostButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                glestHostButtonActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout glestHostPanelLayout = new javax.swing.GroupLayout(glestHostPanel);
        glestHostPanel.setLayout(glestHostPanelLayout);
        glestHostPanelLayout.setHorizontalGroup(
            glestHostPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(glestHostPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(glestHostPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel3)
                    .addComponent(glestHostButton, javax.swing.GroupLayout.PREFERRED_SIZE, 143, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(665, Short.MAX_VALUE))
        );
        glestHostPanelLayout.setVerticalGroup(
            glestHostPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(glestHostPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel3)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(glestHostButton, javax.swing.GroupLayout.PREFERRED_SIZE, 24, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jPanel2.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        jLabel4.setFont(jLabel4.getFont().deriveFont(jLabel4.getFont().getSize()+6f));
        jLabel4.setText(bundle.getString("CChannelView.jLabel4.text_1")); // NOI18N

        jButton6.setText(bundle.getString("CChannelView.jButton6.text")); // NOI18N
        jButton6.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton6ActionPerformed(evt);
            }
        });

        jButton7.setText(bundle.getString("CChannelView.jButton7.text")); // NOI18N
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

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jLabel1, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 488, Short.MAX_VALUE)
                            .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel3Layout.createSequentialGroup()
                                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel6, javax.swing.GroupLayout.PREFERRED_SIZE, 115, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(jLabel5, javax.swing.GroupLayout.DEFAULT_SIZE, 115, Short.MAX_VALUE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(HostBattleName, javax.swing.GroupLayout.DEFAULT_SIZE, 369, Short.MAX_VALUE)
                                    .addComponent(HostMaxPlayers, javax.swing.GroupLayout.PREFERRED_SIZE, 85, javax.swing.GroupLayout.PREFERRED_SIZE)))
                            .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel3Layout.createSequentialGroup()
                                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(jLabel8, javax.swing.GroupLayout.DEFAULT_SIZE, 115, Short.MAX_VALUE)
                                    .addComponent(jLabel11, javax.swing.GroupLayout.DEFAULT_SIZE, 115, Short.MAX_VALUE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(HostPassword, javax.swing.GroupLayout.DEFAULT_SIZE, 369, Short.MAX_VALUE)
                                    .addComponent(HostRankLimitCombo, 0, 369, Short.MAX_VALUE))))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 110, Short.MAX_VALUE)
                        .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addGap(18, 18, 18))
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(glestHostPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel3Layout.createSequentialGroup()
                        .addComponent(springHostPanel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addContainerGap())))
        );
        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel3Layout.createSequentialGroup()
                        .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 35, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(HostBattleName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel6))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(HostMaxPlayers, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel5))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(HostPassword, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel8))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(HostRankLimitCombo, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jLabel11)))
                    .addComponent(jPanel2, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(17, 17, 17)
                .addComponent(glestHostPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(springHostPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(62, Short.MAX_VALUE))
        );

        tabpane.addTab(bundle.getString("CChannelView.jPanel3.TabConstraints.tabTitle"), jPanel3); // NOI18N

        javax.swing.GroupLayout playerTablePanelLayout = new javax.swing.GroupLayout(playerTablePanel);
        playerTablePanel.setLayout(playerTablePanelLayout);
        playerTablePanelLayout.setHorizontalGroup(
            playerTablePanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 813, Short.MAX_VALUE)
        );
        playerTablePanelLayout.setVerticalGroup(
            playerTablePanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 510, Short.MAX_VALUE)
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(playerTablePanel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(playerTablePanel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addContainerGap())
        );

        tabpane.addTab(bundle.getString("CChannelView.jPanel1.TabConstraints.tabTitle"), jPanel1); // NOI18N

        SplitPane.setLeftComponent(tabpane);

        javax.swing.GroupLayout BottomPanelLayout = new javax.swing.GroupLayout(BottomPanel);
        BottomPanel.setLayout(BottomPanelLayout);
        BottomPanelLayout.setHorizontalGroup(
            BottomPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 838, Short.MAX_VALUE)
        );
        BottomPanelLayout.setVerticalGroup(
            BottomPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 0, Short.MAX_VALUE)
        );

        SplitPane.setRightComponent(BottomPanel);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addGap(0, 0, 0)
                .addComponent(SplitPane, javax.swing.GroupLayout.DEFAULT_SIZE, 840, Short.MAX_VALUE)
                .addGap(0, 0, 0))
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addComponent(SplitPane, javax.swing.GroupLayout.DEFAULT_SIZE, 570, Short.MAX_VALUE)
                .addGap(0, 0, 0))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void hostReloadmodlistActionPerformed (java.awt.event.ActionEvent evt) {//GEN-FIRST:event_hostReloadmodlistActionPerformed
        CSync.RefreshUnitSync();
    }//GEN-LAST:event_hostReloadmodlistActionPerformed

    private void StatusComboItemStateChanged (java.awt.event.ItemEvent evt) {//GEN-FIRST:event_StatusComboItemStateChanged
        if (LM.protocol == null) {
            return;
        }
        if (evt.getStateChange() == java.awt.event.ItemEvent.SELECTED) {
            if (StatusCombo.getSelectedIndex() == 0) {
                // ONLINE
                LM.protocol.SetAway(false);
                LM.protocol.SetIngame(false);
            } else if (StatusCombo.getSelectedIndex() == 1) {
                // AWAY
                LM.protocol.SetAway(true);
                LM.protocol.SetIngame(false);
            }
        }
    }//GEN-LAST:event_StatusComboItemStateChanged

    private void StatusComboActionPerformed (java.awt.event.ActionEvent evt) {//GEN-FIRST:event_StatusComboActionPerformed
        /*if(LM.connection == null){
        return;
        }
        if(StatusCombo.getSelectedIndex ()==0){// ONLINE
        status = Misc.setAwayBitToStatus (status,0);
        status = Misc.setInGameToStatus (status,0);
        LM.connection.SendLine ("MYSTATUS " + status);
        }else if(StatusCombo.getSelectedIndex ()==1){// AWAY
        status = Misc.setAwayBitToStatus (status,1);
        status = Misc.setInGameToStatus (status,0);
        LM.connection.SendLine ("MYSTATUS " + status);
        }*/
    }//GEN-LAST:event_StatusComboActionPerformed
    public boolean search_changed = false;

    private void LogOutButtonMouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_LogOutButtonMouseReleased
        CEvent e = new CEvent(CEvent.LOGOUT);
        LM.core.NewGUIEvent(e);
    }//GEN-LAST:event_LogOutButtonMouseReleased

    private void jButton14ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton14ActionPerformed
        BrowserLauncher.openURL("http://www.darkstars.co.uk");
    }//GEN-LAST:event_jButton14ActionPerformed

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

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
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
    }//GEN-LAST:event_jButton1ActionPerformed

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        BrowserLauncher.openURL("http://www.spring-league.com/ladder/index.php?ULadder/URules");
    }//GEN-LAST:event_jButton2ActionPerformed

    private void jButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton3ActionPerformed
        String s = SearchBox.getText();
        String url = "http://www.darkstars.co.uk/downloads/search.php?search="+Misc.toHTML(s)+"/";
        BrowserLauncher.openURL(url);
    }//GEN-LAST:event_jButton3ActionPerformed

    private void SearchBoxFocusGained(java.awt.event.FocusEvent evt) {//GEN-FIRST:event_SearchBoxFocusGained
        SearchBox.setSelectionStart(0);
        SearchBox.setSelectionEnd(SearchBox.getText().length());
    }//GEN-LAST:event_SearchBoxFocusGained

    private void SearchBoxKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_SearchBoxKeyTyped
        // TODO add your handling code here:
    }//GEN-LAST:event_SearchBoxKeyTyped

    private void SearchBoxKeyReleased(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_SearchBoxKeyReleased
        if(evt.getKeyCode() == KeyEvent.VK_ENTER){
            String s = SearchBox.getText();
            String url = "http://www.unknown-files.net/spring/search/"+Misc.toHTML(s)+"/";
            BrowserLauncher.openURL(url);
        }
    }//GEN-LAST:event_SearchBoxKeyReleased

    private void HostNATComboActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_HostNATComboActionPerformed
        HostUDPPort.setEnabled(HostNATCombo.getSelectedIndex()== 2);
    }//GEN-LAST:event_HostNATComboActionPerformed

    private void jButton4ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton4ActionPerformed
        LM.protocol.JoinChannel("newbies", "");
    }//GEN-LAST:event_jButton4ActionPerformed

    private void jButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton5ActionPerformed
        CEvent e = new CEvent(CEvent.TOGGLERAWTRAFFIC);
        LM.core.NewGUIEvent(e);
    }//GEN-LAST:event_jButton5ActionPerformed

    private void jButton8ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton8ActionPerformed
        aflobby.helpers.BrowserLauncher.openURL("http://mantis.darkstars.co.uk/bug_report_page.php");
    }//GEN-LAST:event_jButton8ActionPerformed

    private void HostButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_HostButtonActionPerformed
        //OPENBATTLE type natType password port maxplayers startingmetal startingenergy maxunits startpos gameendcondition limitdgun diminishingMMs ghostedBuildings hashcode rank maphash {map} {title} {modname}
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

//        if(engine.equals("spring")){
            String selected_mod = (String) HostMod.getSelectedItem ();
            s += CSync.GetModHashbyName(selected_mod) + " "; // hashcode
            CUserSettings.PutValue("UI.lasthosted.mod", selected_mod);
//        }else if (engine.equals("glest")){
//            s += "0 ";
//        }
        s += this.HostRankLimitCombo.getSelectedIndex() + " "; // rank
//        if (engine.equals("spring")){
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
        
        CUserSettings.PutValue("UI.lasthosted.maxplayers", "" + HostMaxPlayers.getValue());
        CUserSettings.PutValue("UI.lasthosted.name", HostBattleName.getText());
        
    }//GEN-LAST:event_HostButtonActionPerformed

    private void glestHostButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_glestHostButtonActionPerformed
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

        s += "0 ";
        s += this.HostRankLimitCombo.getSelectedIndex() + " "; // rank

        s += "0 n/a ";
        
        s += "\t";

        s += "glest: ";

        s += HostBattleName.getText();
        
        s += "\tGlest";
        
        LM.protocol.SendTraffic(s);
        
        CUserSettings.PutValue("UI.lasthosted.maxplayers", "" + HostMaxPlayers.getValue());
        CUserSettings.PutValue("UI.lasthosted.name", HostBattleName.getText());
}//GEN-LAST:event_glestHostButtonActionPerformed

    private void jButton7ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton7ActionPerformed
        BrowserLauncher.openURL("http://spring.clan-sy.com/download.php");
    }//GEN-LAST:event_jButton7ActionPerformed

    private void jButton6ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton6ActionPerformed
        BrowserLauncher.openURL("http://www.glest.org/en/downloads.html");
    }//GEN-LAST:event_jButton6ActionPerformed
    
    boolean started = false;
    int fredrawcounter = 80;
    ArrayList<String> startupcommands = new ArrayList<String>();

    /**
     * The Update() Routine
     */
    @Override
    public void Update() {
        fredrawcounter--;
        //if ((fredrawcounter == 2) || (fredrawcounter == 4)) {
            if (startupcommands.isEmpty() == false) {

                String f = startupcommands.get(0);
                //System.out.println(f);
                startupcommands.remove(0);
                LM.command_handler.ExecuteCommand(f);
            }
            if ( (newchannels) && (channels != null)) {
                //
                if (channels.isEmpty() == false) {
                    Runnable doWorkRunnable = new Runnable() {

                        public void run() {
                            synchronized (channels) {
                                Iterator<CChannel> i = channels.values().iterator();
                                while (i.hasNext()) {
                                    CChannel c = i.next();
                                    if (tabpane.indexOfComponent(c) == -1) {
                                        tabpane.add("#" + c.Channel, c);
                                    }
                                }
                            }
                        }
                    };
                    SwingUtilities.invokeLater(doWorkRunnable);
                }
                //tabpane.add ("#"+e.data[1],c1);
            }
        //}
        
        //if(fredrawcounter == 0){
        //    fredrawcounter = 4;
        //}
        /*for (CChannel cc : channels.values()) {
            cc.Update();
        }*/
    }

    @Override
    public void ValidatePanel() {
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                validate();
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
        LM.DoValidate();
    }
    boolean Event_avail = true;
    public TreeMap<String, String> channeltemp = new TreeMap<String, String>();
    boolean newchannels = false;
    TreeMap<String, CChannel> channels = new TreeMap<String, CChannel>();
    boolean refreshing_channels = false;

    @SuppressWarnings(value = "unchecked")
    public void RefreshContent() {
        Runnable doWorkRunnable = new Runnable() {

            @SuppressWarnings(value = "unchecked")
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

    /**
     * Class notification routine
     * @param e
     */
    @Override
    public void NewGUIEvent(final CEvent e) {
        //
        if (e.IsEvent(CEvent.LOGOUT) || e.IsEvent(CEvent.LOGGEDOUT) || e.IsEvent(CEvent.DISCONNECT) || e.IsEvent(CEvent.DISCONNECTED)) {
            Runnable doWorkRunnable = new Runnable() {

                public void run() {
                    ClearPlayers();
                    tabpane.removeAll();
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
            LM.RemoveView(this);
            if (e.IsEvent(CEvent.DISCONNECTED)) {
                LM.Toasts.AddMessage("You've been disconnected");
            }
        } else if (e.IsEvent(CEvent.CHANNELUNREAD)) {
            final String s = "#" + e.data[1];
            Runnable doWorkRunnable = new Runnable() {

                public void run() {
                    for (int i = 0; i < tabpane.getTabCount(); i++) {
                        String q = tabpane.getTitleAt(i);
                        if (q.equalsIgnoreCase(s)) {
                            tabpane.setIconAt(i, new javax.swing.ImageIcon(getClass().getResource("/images/UI/comment_new.gif")));
                            break;
                        }
                    }
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
        } else if (e.IsEvent(CEvent.CHANNELREAD)) {
            final String s = "#" + e.data[1];
            Runnable doWorkRunnable = new Runnable() {

                public void run() {
                    for (int i = 0; i < tabpane.getTabCount(); i++) {
                        String q = tabpane.getTitleAt(i);
                        if (q.equalsIgnoreCase(s)) {
                            //
                            tabpane.setIconAt(i, null);
                            break;
                        }
                    }
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
        } else if (e.IsEvent(CEvent.CHANNELCLOSED)) {
            final String t1 = e.data[1];
            Runnable doWorkRunnable = new Runnable() {

                public void run() {
                    CChannel c = channels.get(t1);
                    synchronized (channels) {
                        channels.remove(t1);
                    }
                    LM.core.RemoveModule(c);
                    tabpane.remove(c);
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
        } else if (e.IsEvent(CEvent.EXITEDBATTLE)) {
            if(!CUnitSyncJNIBindings.loaded){
                return;
            }
            Runnable doWorkRunnable = new Runnable() {

                public void run() {
                    glestHostButton.setEnabled(false);
                    HostButton.setEnabled(true);
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
        } else if (e.IsEvent(CEvent.CONTENTREFRESH)) {
            //
            RefreshContent();
        }
    }

    @Override
    public void NewEvent(final CEvent e) {
        if (e.IsEvent("JOIN")) {

            CChannel c1 = new CChannel();
            LM.core.AddModule(c1);
            synchronized (channels) {
                channels.put(e.data[1], c1);
            }
            c1.Init(LM, e.data[1]);
            newchannels = true;

        } else if (e.IsEvent(CEvent.NEWUSRADDED)) {
            AddPlayer((CPlayer)e.a);
        } else if (e.IsEvent("ACCEPTED")) {
            
            LM.protocol.SendTraffic("GETINGAMETIME");
            SwingWorker worker = new SwingWorker<Boolean, Void>() {

                @Override
                public Boolean doInBackground() {
                    boolean b = CMeltraxLadder.AccountExists(LM.protocol.GetUsername());
                    return b;
                }

                @Override
                public void done() {
                    try {
                        if (get()) {
                            ladderLabel.setText("Account is registered on the ladder");
                        }
                    } catch (ExecutionException ex) {
                        ex.printStackTrace();
                    } catch (InterruptedException ex) {
                        ex.printStackTrace();
                    }
                    WelcomeLabel.setText("Welcome " + LM.protocol.GetUsername());
                }
            };
            worker.execute();
        } else if (e.data[0].equalsIgnoreCase("LOGININFOEND") == true) {
            RefreshContent();
            LM.SetFocus(this);
            
            String s = aflobby.UI.CUserSettings.GetStartScript();
            if (s.equals("") == false) {
                String[] lines = s.split("\n");
                for (int h = 0; h < lines.length; ++h) {
                    //System.out.println(lines[h]);
                    startupcommands.add(lines[h]);
                }
            }
            
            
            Runnable doWorkRunnable = new Runnable() {
                public void run() {
                    playerTablePanel.ClearPlayers();
                    
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
            
            Runnable doWorkRunnable2 = new Runnable() {

                public void run() {
                    ArrayList<String> list = new ArrayList<String>();
                    synchronized(LM.playermanager.activeplayers){
                        list.addAll(LM.playermanager.activeplayers);
                    }

                    for(String o : list){
                        CPlayer p = LM.playermanager.GetPlayer(o);
                        playerTablePanel.AddPlayer(p);
                    }
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable2);
            
            
            
        } else if (e.IsEvent("REMOVEUSER") == true) {
            RemovePlayer(e.data[1]);
        } else if (e.IsEvent("OPENBATTLE") || e.IsEvent("JOINBATTLE")) {
            if(CUnitSyncJNIBindings.loaded){
                Runnable doWorkRunnable = new Runnable() {
                    public void run() {
                        glestHostButton.setEnabled(false);
                        HostButton.setEnabled(false);
                    }
                };
                SwingUtilities.invokeLater(doWorkRunnable);
            }
        } else if (e.IsEvent("CLIENTSTATUS") == true) {
            if (e.data[1].equalsIgnoreCase(LM.protocol.GetUsername())) {
                final int status = Integer.parseInt(e.data[2]);
                Runnable doWorkRunnable = new Runnable() {

                    public void run() {
                        if (Misc.getAwayBitFromStatus(status) == 1) {
                            // AWAY
                            StatusCombo.setSelectedIndex(1);
                        } else {
                            // NORMAL ONLINE
                            StatusCombo.setSelectedIndex(0);
                        }
                    }
                };
                SwingUtilities.invokeLater(doWorkRunnable);
            } //Iterator<CChannel> i = channels.values ().iterator ();
            //if(e.data[0].equalsIgnoreCase (""))
        } else if (e.IsEvent("DENIED") == true) {
            Runnable doWorkRunnable = new Runnable() {

                public void run() {
                    Collection co = channels.values();
                    @SuppressWarnings(value = "unchecked")
                    Iterator<aflobby.CChannel> i = co.iterator();
                    while (i.hasNext()) {
                        CChannel cn = i.next();
                        if (cn == null) {
                            continue;
                        }
                        tabpane.remove(cn);
                    }
                    channels.clear();
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
            LM.RemoveView(getTitle());
        } else if (e.IsEvent("MOTD") == true) {
            AddMOTD(Misc.makeSentence(e.data, 1));
        } else if (e.IsEvent("SERVERMSG") || e.IsEvent("SERVERMSGBOX")) {
            AddMOTD(Misc.makeSentence(e.data, 1));
            if (Misc.makeSentence(e.data, 0).startsWith("SERVERMSG Your in-game time is")) {
                Runnable doWorkRunnable = new Runnable() {

                    public void run() {
                        ingame_label.setText("Your ingame time is: " + e.data[5] + " minutes");
                    }
                };
                SwingUtilities.invokeLater(doWorkRunnable);
            }
            //FServerMessages.setCaretPosition(FServerMessages.getText().length());
        } else if (e.data[0].equalsIgnoreCase("BATTLEOPENED")) {
            if(!CUnitSyncJNIBindings.loaded){
                return;
            }
            // Add!!!!!
            if (e.data[1] == null) {
                System.out.println("e.data[1] == null for:" + Misc.makeSentence(e.data, 0));
                return;
            }
            /*Integer i = new Integer (e.data[1].trim ());// Integer.getInteger(e.data[1].trim());
            if(i == null){
            LM.Toasts.AddMessage ("i == null for battles \""+e.data[1].trim ()+" \" in ::\n"+Misc.makeSentence (e.data,0));
            return;
            }*/
            /*Integer i = new Integer (e.data[1].trim ());// Integer.getInteger(e.data[1].trim());
            if(i == null){
            LM.Toasts.AddMessage ("i == null for battles \""+e.data[1].trim ()+" \" in ::\n"+Misc.makeSentence (e.data,0));
            return;
            }*/
            int i = Integer.parseInt(e.data[1]);
            Runnable doWorkRunnable = new Runnable() {

                public void run() {
                    number_of_battles.setText("To date " + e.data[1] + " battles have been opened");
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
        }
        
        /*synchronized (channels) {
            Iterator<CChannel> i = channels.values().iterator();
            while (i.hasNext()) {
                CChannel cc = i.next();
                cc.NewEvent(e);
            }
        }*/
        //Event_avail=true;
        //notifyAll();
    }
    String MOTD = "";

    void AddMOTD(String s) {
        synchronized (MOTD) {
            MOTD += s + "<br>";
        }
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                FServerMessages.setText(MOTD);
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }
    //ArrayList<String> players = new ArrayList<String>();

    void AddPlayer(String player) {
        if (player.equals("")) {
            return;
        } else if (player == null) {
            return;
        }

        playerTablePanel.AddPlayer(LM.playermanager.GetPlayer(player));
        
        search_changed = true;
        //ReDrawPlayerList ();
    }

    void RemovePlayer(String player) {
        if (player.equals("")) {
            return;
        } else if (player == null) {
            return;
        }
        playerTablePanel.RemovePlayer(LM.playermanager.GetPlayer(player));
        search_changed = true;
        //ReDrawPlayerList ();
    }

    void ClearPlayers() {
        this.playerTablePanel.ClearPlayers();
    }


    String playersearchstring = "";


    /**
     * 
     */
    public class TblRenderer extends DefaultTableCellRenderer {

        @Override
        public Component getTableCellRendererComponent(JTable jTable, Object value, boolean isSelected, boolean hasFocus, int row, int col) {
            super.getTableCellRendererComponent(jTable, value, isSelected, hasFocus, row, col);

            String tvalue = (String) jTable.getValueAt (row,1);
            if (tvalue != null) {
                if (tvalue.startsWith("Ingame")) {
                    setBackground(new Color(215, 240, 247));
                } else if (tvalue.startsWith("Locked")) {
                    setBackground(new Color(242, 242, 242));
                } else if (tvalue.startsWith("Full")) {
                    setBackground(new Color(221, 221, 221));
                } else if (tvalue.contains("passworded")) {
                    setBackground(new Color(255, 235, 166));
                } else {
                    setBackground(Color.white);
                }
                if (isSelected) {
                    setForeground(Color.red);
                    setFont(CUISettings.GetFont(12, true));
                } else {
                    setForeground(Color.BLACK);
                }
                /*
                 *else if(b.locked){
                s += "Locked";
                }else if(b.maxplayers == b.GetPlayerNames ().size ()){
                s+= "Full";
                }else{
                s += "Open";
                }
                if(b.IsPassworded ()){
                s += " & passworded";//<HTML><body bgcolor=\"FFDD00\"> <font color=\"#000000\">"+"&nbsp;";
                }
                 */

                /*if( val>valMin )
                setBackground (Color.yellow);
                if( val>valMax)
                setBackground (Color.red);*/
            } else {
                setBackground(Color.white);
            }
            return this;
        }
    }
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JPanel BottomPanel;
    private javax.swing.JEditorPane FServerMessages;
    private javax.swing.JTextField HostBattleName;
    private javax.swing.JButton HostButton;
    private javax.swing.JSpinner HostMaxPlayers;
    private javax.swing.JComboBox HostMod;
    private javax.swing.JComboBox HostNATCombo;
    private javax.swing.JTextField HostPassword;
    private javax.swing.JComboBox HostRankLimitCombo;
    private javax.swing.JTextField HostUDPPort;
    private javax.swing.JButton LogOutButton;
    private javax.swing.JTextField SearchBox;
    private javax.swing.JSplitPane SplitPane;
    private javax.swing.JComboBox StatusCombo;
    private javax.swing.JLabel WelcomeLabel;
    private javax.swing.JButton glestHostButton;
    private javax.swing.JPanel glestHostPanel;
    private javax.swing.JButton hostReloadmodlist;
    private javax.swing.JLabel ingame_label;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton14;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton4;
    private javax.swing.JButton jButton5;
    private javax.swing.JButton jButton6;
    private javax.swing.JButton jButton7;
    private javax.swing.JButton jButton8;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    private javax.swing.JLabel jLabel4;
    private javax.swing.JLabel jLabel5;
    private javax.swing.JLabel jLabel6;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JLabel ladderLabel;
    private javax.swing.JComboBox laddercomboBox;
    private javax.swing.JLabel number_of_battles;
    private aflobby.UI.CPlayerTablePanel playerTablePanel;
    private javax.swing.JPanel springHostPanel;
    public javax.swing.JTabbedPane tabpane;
    private javax.swing.ButtonGroup tabplacementGroup;
    // End of variables declaration//GEN-END:variables
}