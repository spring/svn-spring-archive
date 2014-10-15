/*
 * JChannel.java
 * 98612769816789122
 * Created on 28 May 2006, 13:22
 */

package aflobby;

import aflobby.UI.CUISettings;
import aflobby.UI.CUserSettings;
import aflobby.UI.CView;
import aflobby.helpers.BrowserLauncher;
import aflobby.helpers.AlphanumComparator;
import aflobby.protocol.tasserver.ui.CChannelList;
import java.awt.Color;
import java.awt.Component;
import java.awt.event.KeyEvent;
import java.lang.reflect.InvocationTargetException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collection;
import java.util.Iterator;
import java.util.TreeMap;
import java.util.concurrent.ExecutionException;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.PatternSyntaxException;
import javax.swing.DefaultComboBoxModel;
import javax.swing.JTable;
import javax.swing.RowFilter;
import javax.swing.SpinnerNumberModel;
import javax.swing.SwingUtilities;
import javax.swing.SwingWorker;
import javax.swing.table.DefaultTableCellRenderer;

//import javax.swing.text.html.*;
import javax.swing.table.TableRowSorter;
import org.jvnet.lafwidget.LafWidget;
import org.jvnet.lafwidget.tabbed.DefaultTabPreviewPainter;


/**
 *
 * @author  Shade
 */
public class CChannelView extends CView {

    //public LMain LM;
    boolean redrawusers = true;
    //int status;
    
    
    public boolean htmlaccess = false;

    CChannelList  cChannelList = null;
    CSettings cSettings = null;
    CBattleList cBattleList = null;
    CPlayerTableModel usertablemodel = null;
    TableRowSorter<CPlayerTableModel> playertablesorter = null;
    
    
    
    
    

    public CChannelView(LMain L) {
        try {
            setTitle("jChannelView");
            LM = L;

            Runnable doWorkRunnable = new Runnable() {

                public void run() {

                    usertablemodel = new CPlayerTableModel(LM);
                    

                    playertablesorter = new TableRowSorter<CPlayerTableModel>(usertablemodel);
                    playertablesorter.setComparator(3, new AlphanumComparator());

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
            SwingUtilities.invokeAndWait(doWorkRunnable);
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
        } catch (InterruptedException ex) {
            Logger.getLogger(CChannelView.class.getName()).log(Level.SEVERE, null, ex);
        } catch (InvocationTargetException ex) {
            Logger.getLogger(CChannelView.class.getName()).log(Level.SEVERE, null, ex);
        }
        

        //ValidatePanel ();
    }

    @Override
    public void OnRemove() {
        
        if(cSettings!= null){
            LM.core.RemoveModule(cSettings);
        }
        
        if(cBattleList != null){
            LM.core.RemoveModule(cBattleList);
        }
    }

    @Override
    public void Initialize() {
        UserTitle = "Main lobby page";
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

        jMenuBar1 = new javax.swing.JMenuBar();
        jMenu1 = new javax.swing.JMenu();
        jMenuItem1 = new javax.swing.JMenuItem();
        jRadioButtonMenuItem1 = new javax.swing.JRadioButtonMenuItem();
        tabplacementGroup = new javax.swing.ButtonGroup();
        SplitPane = new javax.swing.JSplitPane();
        tabpane = new javax.swing.JTabbedPane();
        jScrollPane1 = new javax.swing.JScrollPane();
        jPanel7 = new javax.swing.JPanel();
        LogOutButton = new javax.swing.JButton();
        StatusCombo = new javax.swing.JComboBox();
        number_of_battles = new javax.swing.JLabel();
        ingame_label = new javax.swing.JLabel();
        jScrollPane4 = new javax.swing.JScrollPane();
        FServerMessages = new javax.swing.JEditorPane();
        ladderLabel = new javax.swing.JLabel();
        jButton12 = new javax.swing.JButton();
        jButton13 = new javax.swing.JButton();
        jButton14 = new javax.swing.JButton();
        jButton15 = new javax.swing.JButton();
        WelcomeLabel = new javax.swing.JLabel();
        SearchBox = new javax.swing.JTextField();
        jButton3 = new javax.swing.JButton();
        jButton4 = new javax.swing.JButton();
        jButton5 = new javax.swing.JButton();
        jButton8 = new javax.swing.JButton();
        PlayerList = new javax.swing.JPanel();
        UserSearch = new javax.swing.JTextField();
        jLabel4 = new javax.swing.JLabel();
        jScrollPane3 = new javax.swing.JScrollPane();
        UserTable = new javax.swing.JTable();
        jPanel3 = new javax.swing.JPanel();
        HostBattleName = new javax.swing.JTextField();
        HostMaxPlayers = new javax.swing.JSpinner();
        jLabel5 = new javax.swing.JLabel();
        jLabel6 = new javax.swing.JLabel();
        jComboBox1 = new javax.swing.JComboBox();
        HostMod = new javax.swing.JComboBox();
        jLabel7 = new javax.swing.JLabel();
        HostPassword = new javax.swing.JTextField();
        jLabel8 = new javax.swing.JLabel();
        HostUDPPort = new javax.swing.JTextField();
        jLabel9 = new javax.swing.JLabel();
        jLabel10 = new javax.swing.JLabel();
        HostNATCombo = new javax.swing.JComboBox();
        jLabel11 = new javax.swing.JLabel();
        HostRankLimitCombo = new javax.swing.JComboBox();
        jLabel1 = new javax.swing.JLabel();
        HostButton = new javax.swing.JButton();
        hostReloadmodlist = new javax.swing.JButton();
        jLabel12 = new javax.swing.JLabel();
        laddercomboBox = new javax.swing.JComboBox();
        jButton1 = new javax.swing.JButton();
        jButton2 = new javax.swing.JButton();
        jLabel2 = new javax.swing.JLabel();
        BottomPanel = new javax.swing.JPanel();

        java.util.ResourceBundle bundle = java.util.ResourceBundle.getBundle("aflobby/languages"); // NOI18N
        jMenu1.setText(bundle.getString("CChannelView.jMenu1.text")); // NOI18N
        jMenu1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jMenu1ActionPerformed(evt);
            }
        });

        jMenuItem1.setText(bundle.getString("CChannelView.jMenuItem1.text")); // NOI18N
        jMenu1.add(jMenuItem1);

        jRadioButtonMenuItem1.setText(bundle.getString("CChannelView.jRadioButtonMenuItem1.text")); // NOI18N
        jMenu1.add(jRadioButtonMenuItem1);

        jMenuBar1.add(jMenu1);

        setFont(CUISettings.GetFont(12,false));
        setMaximumSize(new java.awt.Dimension(2840, 2560));
        setMinimumSize(new java.awt.Dimension(840, 570));
        setPreferredSize(new java.awt.Dimension(840, 570));

        SplitPane.setDividerSize(8);
        SplitPane.setOrientation(javax.swing.JSplitPane.VERTICAL_SPLIT);
        SplitPane.setResizeWeight(1.0);
        SplitPane.setOneTouchExpandable(true);

        tabpane.setTabPlacement(Integer.parseInt(CUserSettings.GetValue("UI.toptabpane.placement", ""+javax.swing.JTabbedPane.TOP)));
        tabpane.setMaximumSize(new java.awt.Dimension(83000, 530000));
        tabpane.setMinimumSize(new java.awt.Dimension(640, 300));
        tabpane.setPreferredSize(new java.awt.Dimension(840, 570));
        tabpane.putClientProperty(
            LafWidget.TABBED_PANE_PREVIEW_PAINTER,
            new DefaultTabPreviewPainter());

        jScrollPane1.setHorizontalScrollBarPolicy(javax.swing.ScrollPaneConstants.HORIZONTAL_SCROLLBAR_NEVER);

        jPanel7.setFont(CUISettings.GetFont(12,false));

        LogOutButton.setText(bundle.getString("LMain.Logout")); // NOI18N
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
        ladderLabel.setText("Not registered to the ladder");

        jButton12.setText(bundle.getString("CChannelView.jButton12.text")); // NOI18N
        jButton12.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton12ActionPerformed(evt);
            }
        });

        jButton13.setText(bundle.getString("CChannelView.jButton13.text")); // NOI18N
        jButton13.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton13ActionPerformed(evt);
            }
        });

        jButton14.setText("Darkstars.co.uk");
        jButton14.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton14ActionPerformed(evt);
            }
        });

        jButton15.setText(bundle.getString("CChannelView.jButton15.text")); // NOI18N
        jButton15.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton15ActionPerformed(evt);
            }
        });

        WelcomeLabel.setFont(CUISettings.GetFont(24,true));
        WelcomeLabel.setText("Welcome "+LM.protocol.GetUsername());

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
        jButton5.setMargin(new java.awt.Insets(2, 6, 2, 6));
        jButton5.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton5ActionPerformed(evt);
            }
        });

        jButton8.setText(bundle.getString("CChannelView.jButton8.text_1")); // NOI18N
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
                    .addComponent(WelcomeLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 465, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(jPanel7Layout.createSequentialGroup()
                        .addComponent(number_of_battles, javax.swing.GroupLayout.PREFERRED_SIZE, 272, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(ladderLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 254, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel7Layout.createSequentialGroup()
                        .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addGroup(jPanel7Layout.createSequentialGroup()
                                .addComponent(ingame_label, javax.swing.GroupLayout.PREFERRED_SIZE, 295, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addGap(344, 344, 344))
                            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel7Layout.createSequentialGroup()
                                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addComponent(SearchBox, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 648, Short.MAX_VALUE)
                                    .addGroup(javax.swing.GroupLayout.Alignment.LEADING, jPanel7Layout.createSequentialGroup()
                                        .addComponent(jButton5, javax.swing.GroupLayout.PREFERRED_SIZE, 188, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(LogOutButton, javax.swing.GroupLayout.PREFERRED_SIZE, 150, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(StatusCombo, javax.swing.GroupLayout.PREFERRED_SIZE, 117, javax.swing.GroupLayout.PREFERRED_SIZE)
                                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                        .addComponent(jButton4, javax.swing.GroupLayout.DEFAULT_SIZE, 175, Short.MAX_VALUE))
                                    .addComponent(jScrollPane4, javax.swing.GroupLayout.DEFAULT_SIZE, 648, Short.MAX_VALUE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)))
                        .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                .addComponent(jButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 157, javax.swing.GroupLayout.PREFERRED_SIZE)
                                .addComponent(jButton8, javax.swing.GroupLayout.DEFAULT_SIZE, 157, Short.MAX_VALUE))
                            .addGroup(jPanel7Layout.createSequentialGroup()
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                                    .addComponent(jButton12, javax.swing.GroupLayout.DEFAULT_SIZE, 157, Short.MAX_VALUE)
                                    .addComponent(jButton13, javax.swing.GroupLayout.DEFAULT_SIZE, 157, Short.MAX_VALUE)
                                    .addComponent(jButton14, javax.swing.GroupLayout.DEFAULT_SIZE, 157, Short.MAX_VALUE)
                                    .addComponent(jButton15, javax.swing.GroupLayout.DEFAULT_SIZE, 157, Short.MAX_VALUE))))))
                .addContainerGap())
        );

        jPanel7Layout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {jButton3, jButton8});

        jPanel7Layout.setVerticalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel7Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(WelcomeLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 34, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jButton8, javax.swing.GroupLayout.PREFERRED_SIZE, 41, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton4, javax.swing.GroupLayout.DEFAULT_SIZE, 41, Short.MAX_VALUE)
                    .addComponent(StatusCombo, javax.swing.GroupLayout.DEFAULT_SIZE, 41, Short.MAX_VALUE)
                    .addComponent(LogOutButton, javax.swing.GroupLayout.DEFAULT_SIZE, 41, Short.MAX_VALUE)
                    .addComponent(jButton5, javax.swing.GroupLayout.DEFAULT_SIZE, 41, Short.MAX_VALUE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(number_of_battles)
                    .addComponent(ladderLabel))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(ingame_label)
                .addGap(13, 13, 13)
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton3)
                    .addComponent(SearchBox, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addGap(18, 18, 18)
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel7Layout.createSequentialGroup()
                        .addComponent(jButton12)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton13)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton14)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton15))
                    .addComponent(jScrollPane4, javax.swing.GroupLayout.DEFAULT_SIZE, 329, Short.MAX_VALUE))
                .addContainerGap())
        );

        jPanel7Layout.linkSize(javax.swing.SwingConstants.VERTICAL, new java.awt.Component[] {LogOutButton, StatusCombo, jButton4, jButton5, jButton8});

        jPanel7Layout.linkSize(javax.swing.SwingConstants.VERTICAL, new java.awt.Component[] {SearchBox, jButton3});

        jScrollPane1.setViewportView(jPanel7);

        tabpane.addTab(bundle.getString("CChannelView.jScrollPane1.TabConstraints.tabTitle"), jScrollPane1); // NOI18N

        PlayerList.setFont(CUISettings.GetFont(12,false));
        PlayerList.addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentShown(java.awt.event.ComponentEvent evt) {
                PlayerListComponentShown(evt);
            }
        });

        UserSearch.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyTyped(java.awt.event.KeyEvent evt) {
                UserSearchKeyTyped(evt);
            }
        });

        jLabel4.setBackground(new java.awt.Color(255, 255, 255));
        jLabel4.setFont(jLabel4.getFont().deriveFont(jLabel4.getFont().getSize()+1f));
        jLabel4.setLabelFor(UserSearch);
        jLabel4.setText(bundle.getString("CChannelView.jLabel4.text")); // NOI18N

        UserTable.setModel(usertablemodel);
        UserTable.setRowSorter(playertablesorter);
        UserTable.setShowHorizontalLines(false);
        UserTable.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                UserTableMousePressed(evt);
            }
        });
        jScrollPane3.setViewportView(UserTable);

        javax.swing.GroupLayout PlayerListLayout = new javax.swing.GroupLayout(PlayerList);
        PlayerList.setLayout(PlayerListLayout);
        PlayerListLayout.setHorizontalGroup(
            PlayerListLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(PlayerListLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(PlayerListLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 813, Short.MAX_VALUE)
                    .addGroup(PlayerListLayout.createSequentialGroup()
                        .addComponent(jLabel4, javax.swing.GroupLayout.DEFAULT_SIZE, 154, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(UserSearch, javax.swing.GroupLayout.DEFAULT_SIZE, 655, Short.MAX_VALUE)))
                .addContainerGap())
        );
        PlayerListLayout.setVerticalGroup(
            PlayerListLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(PlayerListLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(PlayerListLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(UserSearch, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel4))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 484, Short.MAX_VALUE)
                .addContainerGap())
        );

        tabpane.addTab(bundle.getString("CChannelView.PlayerList.TabConstraints.tabTitle"), PlayerList); // NOI18N

        jPanel3.setEnabled(CUnitSyncJNIBindings.loaded);
        jPanel3.setFont(CUISettings.GetFont(12,false));
        jPanel3.setMinimumSize(new java.awt.Dimension(500, 300));

        HostBattleName.setText(CUserSettings.GetValue("UI.lasthosted.name",""));

        HostMaxPlayers.setModel(new SpinnerNumberModel (4,1,16,1));
        HostMaxPlayers.setValue(2);

        jLabel5.setFont(jLabel5.getFont().deriveFont(jLabel5.getFont().getSize()+1f));
        jLabel5.setText(bundle.getString("CChannelView.jLabel5.text")); // NOI18N

        jLabel6.setFont(jLabel6.getFont().deriveFont(jLabel6.getFont().getSize()+1f));
        jLabel6.setLabelFor(HostBattleName);
        jLabel6.setText(bundle.getString("CChannelView.jLabel6.text")); // NOI18N

        jComboBox1.setModel(new DefaultComboBoxModel(CContentManager.GetInstalledEngines()));
        jComboBox1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jComboBox1ActionPerformed(evt);
            }
        });

        HostMod.setMaximumRowCount(16);

        jLabel7.setFont(jLabel7.getFont().deriveFont(jLabel7.getFont().getSize()+1f));
        jLabel7.setText(bundle.getString("CChannelView.jLabel7.text")); // NOI18N

        jLabel8.setFont(jLabel8.getFont().deriveFont(jLabel8.getFont().getSize()+1f));
        jLabel8.setText(bundle.getString("CChannelView.jLabel8.text")); // NOI18N

        HostUDPPort.setText(bundle.getString("CChannelView.HostUDPPort.text")); // NOI18N
        HostUDPPort.setEnabled(false);

        jLabel9.setFont(jLabel9.getFont().deriveFont(jLabel9.getFont().getSize()+1f));
        jLabel9.setText(bundle.getString("CChannelView.jLabel9.text")); // NOI18N

        jLabel10.setFont(jLabel10.getFont().deriveFont(jLabel10.getFont().getSize()+1f));
        jLabel10.setText(bundle.getString("CChannelView.jLabel10.text")); // NOI18N

        HostNATCombo.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "none", "hole punching", "fixed ports" }));
        HostNATCombo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                HostNATComboActionPerformed(evt);
            }
        });

        jLabel11.setFont(jLabel11.getFont().deriveFont(jLabel11.getFont().getSize()+1f));
        jLabel11.setText(bundle.getString("CChannelView.jLabel11.text")); // NOI18N

        HostRankLimitCombo.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "No Limit", "Beginner", "Average", "Experienced", "Highly Experienced" }));

        jLabel1.setFont(jLabel1.getFont().deriveFont(jLabel1.getFont().getSize()+13f));
        jLabel1.setText(bundle.getString("CChannelView.jLabel1.text")); // NOI18N

        HostButton.setText(bundle.getString("CChannelView.HostButton.text")); // NOI18N
        HostButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                HostButtonActionPerformed(evt);
            }
        });

        hostReloadmodlist.setText(bundle.getString("CChannelView.hostReloadmodlist.text")); // NOI18N
        hostReloadmodlist.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                hostReloadmodlistActionPerformed(evt);
            }
        });

        jLabel12.setFont(jLabel12.getFont().deriveFont(jLabel12.getFont().getSize()+1f));
        jLabel12.setText(bundle.getString("CChannelView.jLabel12.text")); // NOI18N

        laddercomboBox.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "None" }));
        laddercomboBox.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                laddercomboBoxActionPerformed(evt);
            }
        });

        jButton1.setText(bundle.getString("CChannelView.jButton1.text")); // NOI18N
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jButton2.setText(bundle.getString("CChannelView.jButton2.text_1")); // NOI18N
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        jLabel2.setText(bundle.getString("CChannelView.jLabel2.text_1")); // NOI18N

        javax.swing.GroupLayout jPanel3Layout = new javax.swing.GroupLayout(jPanel3);
        jPanel3.setLayout(jPanel3Layout);
        jPanel3Layout.setHorizontalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel2, javax.swing.GroupLayout.DEFAULT_SIZE, 111, Short.MAX_VALUE)
                    .addComponent(jLabel6, javax.swing.GroupLayout.DEFAULT_SIZE, 111, Short.MAX_VALUE)
                    .addComponent(jLabel5, javax.swing.GroupLayout.DEFAULT_SIZE, 111, Short.MAX_VALUE)
                    .addComponent(jLabel10, javax.swing.GroupLayout.PREFERRED_SIZE, 111, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel7, javax.swing.GroupLayout.DEFAULT_SIZE, 111, Short.MAX_VALUE)
                    .addComponent(jLabel12, javax.swing.GroupLayout.DEFAULT_SIZE, 111, Short.MAX_VALUE)
                    .addComponent(jLabel8, javax.swing.GroupLayout.DEFAULT_SIZE, 111, Short.MAX_VALUE)
                    .addComponent(jLabel11, javax.swing.GroupLayout.DEFAULT_SIZE, 111, Short.MAX_VALUE)
                    .addComponent(jLabel9, javax.swing.GroupLayout.PREFERRED_SIZE, 111, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(HostBattleName, javax.swing.GroupLayout.DEFAULT_SIZE, 328, Short.MAX_VALUE)
                    .addComponent(HostMaxPlayers, javax.swing.GroupLayout.PREFERRED_SIZE, 85, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jComboBox1, javax.swing.GroupLayout.PREFERRED_SIZE, 197, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(laddercomboBox, 0, 328, Short.MAX_VALUE)
                    .addComponent(HostPassword, javax.swing.GroupLayout.DEFAULT_SIZE, 328, Short.MAX_VALUE)
                    .addComponent(HostRankLimitCombo, 0, 328, Short.MAX_VALUE)
                    .addComponent(HostMod, 0, 328, Short.MAX_VALUE)
                    .addComponent(HostUDPPort, javax.swing.GroupLayout.PREFERRED_SIZE, 66, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(HostNATCombo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addComponent(jButton1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                    .addComponent(hostReloadmodlist))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton2)
                .addContainerGap(142, Short.MAX_VALUE))
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGap(10, 10, 10)
                .addComponent(HostButton, javax.swing.GroupLayout.PREFERRED_SIZE, 99, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap(724, Short.MAX_VALUE))
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addGap(10, 10, 10)
                .addComponent(jLabel1, javax.swing.GroupLayout.DEFAULT_SIZE, 823, Short.MAX_VALUE))
        );

        jPanel3Layout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {HostMod, jComboBox1});

        jPanel3Layout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {jLabel10, jLabel11, jLabel12, jLabel2, jLabel5, jLabel6, jLabel7, jLabel8, jLabel9});

        jPanel3Layout.setVerticalGroup(
            jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel3Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 35, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(HostBattleName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel6))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(HostMaxPlayers, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel5))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jComboBox1, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel2))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(HostMod, javax.swing.GroupLayout.PREFERRED_SIZE, 20, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(hostReloadmodlist)
                    .addComponent(jLabel7))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(laddercomboBox, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jButton1)
                    .addComponent(jButton2)
                    .addComponent(jLabel12))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(HostPassword, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel8))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(HostRankLimitCombo, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel11))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 7, Short.MAX_VALUE)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(HostUDPPort, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel9))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel3Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(HostNATCombo, javax.swing.GroupLayout.PREFERRED_SIZE, 24, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel10))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 204, Short.MAX_VALUE)
                .addComponent(HostButton, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addContainerGap())
        );

        tabpane.addTab(bundle.getString("CChannelView.jPanel3.TabConstraints.tabTitle"), jPanel3); // NOI18N

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

    private void jMenu1ActionPerformed (java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jMenu1ActionPerformed
// TODO add your handling code here:
    }//GEN-LAST:event_jMenu1ActionPerformed

    private void PlayerListComponentShown (java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_PlayerListComponentShown
    }//GEN-LAST:event_PlayerListComponentShown
    public boolean search_changed = false;

    private void LogOutButtonMouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_LogOutButtonMouseReleased
        CEvent e = new CEvent(CEvent.LOGOUT);
        LM.core.NewGUIEvent(e);
    }//GEN-LAST:event_LogOutButtonMouseReleased

    private void jButton12ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton12ActionPerformed
        BrowserLauncher.openURL("http://www.unknown-files.net/spring/category/13/Maps/");
    }//GEN-LAST:event_jButton12ActionPerformed

    private void jButton13ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton13ActionPerformed
        BrowserLauncher.openURL("http://www.unknown-files.net/spring/category/14/Mods/");
    }//GEN-LAST:event_jButton13ActionPerformed

    private void jButton14ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton14ActionPerformed
        BrowserLauncher.openURL("http://www.darkstars.co.uk");
    }//GEN-LAST:event_jButton14ActionPerformed

    private void jButton15ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton15ActionPerformed
        BrowserLauncher.openURL("http://www.spring-league.com/");
    }//GEN-LAST:event_jButton15ActionPerformed

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
        String url = "http://www.unknown-files.net/spring/search/"+Misc.toHTML(s)+"/";
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
        LM.protocol.JoinChannel("new", "");
    }//GEN-LAST:event_jButton4ActionPerformed

    private void jButton5ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton5ActionPerformed
        CEvent e = new CEvent(CEvent.TOGGLERAWTRAFFIC);
        LM.core.NewGUIEvent(e);
    }//GEN-LAST:event_jButton5ActionPerformed

    private void jButton8ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton8ActionPerformed
        aflobby.helpers.BrowserLauncher.openURL("http://mantis.darkstars.co.uk/bug_report_page.php");
    }//GEN-LAST:event_jButton8ActionPerformed

    private void jComboBox1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jComboBox1ActionPerformed
        String e = (String) jComboBox1.getSelectedItem();
        boolean b = e.equals("spring");
        HostMod.setEnabled(b);
        hostReloadmodlist.setEnabled(b);
    }//GEN-LAST:event_jComboBox1ActionPerformed

    private void HostButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_HostButtonActionPerformed
        //OPENBATTLE type natType password port maxplayers startingmetal startingenergy maxunits startpos gameendcondition limitdgun diminishingMMs ghostedBuildings hashcode rank maphash {map} {title} {modname}
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
        s += "1000 "; // startingmetal
        s += "1000 "; // startignenergy
        s += "500 "; // maxunits
        s += "0 "; // startpos
        s += "0 "; // gamendcondition
        s += "0 "; // limitdgun
        s += "0 "; //diminishingMMs
        s += "1 "; // ghostedBuildings
        String engine = (String) jComboBox1.getSelectedItem();
        if(engine.equals("spring")){
            String selected_mod = (String) HostMod.getSelectedItem ();
            s += CSync.GetModHashbyName(selected_mod) + " "; // hashcode
            CUserSettings.PutValue("UI.lasthosted.mod", selected_mod);
        }else if (engine.equals("glest")){
            s += "0 ";
        }
        s += this.HostRankLimitCombo.getSelectedIndex() + " "; // rank
        String m = CUserSettings.GetValue("UI.lasthosted.map", CSync.map_names.get(0));
        s += CSync.GetMapHash(m) + " "; // maphash
        s += m;
        
        s += "\t";
        
        if (engine.equals("glest")){
            s += "glest: ";
        }
        s += HostBattleName.getText();
        
        if(engine.equals("spring")){
            s += "\t" + HostMod.getSelectedItem();
        }else if (engine.equals("glest")){
            s += "\tGlest";
        }
        LM.protocol.SendTraffic(s);
        
        CUserSettings.PutValue("UI.lasthosted.maxplayers", "" + HostMaxPlayers.getValue());
        CUserSettings.PutValue("UI.lasthosted.name", HostBattleName.getText());
        
    }//GEN-LAST:event_HostButtonActionPerformed

    private void UserTableMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_UserTableMousePressed
        if (evt.getClickCount() > 1) {
            String n = (String) UserTable.getValueAt(UserTable.getSelectedRow(), 3);
            CPlayer cp = LM.playermanager.GetPlayer(n);
            if(cp == null){
                return;
            }
            aflobby.CPlayerDataWindow p = new CPlayerDataWindow(LM, cp);
            p.setVisible(true);
        }
    }//GEN-LAST:event_UserTableMousePressed

    private void UserSearchKeyTyped(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_UserSearchKeyTyped
        Runnable doWorkRunnable = new Runnable () {
            public void run () {
                try {
                    playertablesorter.setRowFilter(
                    RowFilter.regexFilter(UserSearch.getText()));
                } catch (PatternSyntaxException pse) {
                    //System.err.println("Bad regex pattern");
                }
            }
        };
        SwingUtilities.invokeLater (doWorkRunnable);
    }//GEN-LAST:event_UserSearchKeyTyped
    
    boolean started = false;
    int fredrawcounter = 80;
    ArrayList<String> startupcommands = new ArrayList<String>();

    /**
     * The Update() Routine
     */
    @Override
    public void Update() {
        fredrawcounter--;
        if ((fredrawcounter == 15) || (fredrawcounter == 30) || (fredrawcounter == 45)) {
            if (startupcommands.isEmpty() == false) {

                String f = startupcommands.get(0);
                //System.out.println(f);
                startupcommands.remove(0);
                LM.command_handler.ExecuteCommand(f);
            }
            if (newchannels) {
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
        }
        
        if(fredrawcounter == 0){
            fredrawcounter = 60;
        }
        for (CChannel cc : channels.values()) {
            cc.Update();
        }
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
                    String e = (String) jComboBox1.getSelectedItem();
                    boolean b = !e.equals("glest");
                    HostMod.setEnabled(b);
                    HostButton.setEnabled(true);
                }else{
                    HostMod.setSelectedItem(CUserSettings.GetValue("UI.lasthosted.mod", "XTA v9"));
                    String e = (String) jComboBox1.getSelectedItem();
                    boolean b = e.equals("glest");
                    HostMod.setEnabled(false);
                    HostButton.setEnabled(b);
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
                    synchronized (channels) {
                        channels.clear();
                    }
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
            LM.RemoveView(getTitle());
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

        } else if (e.IsEvent("ADDUSER")) {
            AddPlayer(e.data[1]);
        } else if (e.IsEvent("ACCEPTED")) {
            String s = aflobby.UI.CUserSettings.GetStartScript();
            if (s.equals("") == false) {
                String[] lines = s.split("\n");
                for (int h = 0; h < lines.length; ++h) {
                    //System.out.println(lines[h]);
                    startupcommands.add(lines[h]);
                }
            }
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
            
            
            Runnable doWorkRunnable = new Runnable() {
                public void run() {
                    usertablemodel.clear();
                    UserTable.getColumnModel().getColumn(0).setMaxWidth(50);
                    UserTable.getColumnModel().getColumn(1).setMaxWidth(50);
                    UserTable.getColumnModel().getColumn(2).setMaxWidth(50);
                    
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
            
            Runnable doWorkRunnable2 = new Runnable() {

                public void run() {
                    for(String s : LM.playermanager.activeplayers){
                        CPlayer p = LM.playermanager.GetPlayer(s);
                        usertablemodel.AddPlayer(p);
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
    ArrayList<String> players = new ArrayList<String>();

    void AddPlayer(String player) {
        if (player.equals("")) {
            return;
        } else if (player == null) {
            return;
        }
        if (players.contains(player) == false) {
            synchronized (players) {
                players.add(player);
            }
            usertablemodel.AddPlayer(LM.playermanager.GetPlayer(player));
        }
        search_changed = true;
        //ReDrawPlayerList ();
    }

    void RemovePlayer(String player) {
        if (player.equals("")) {
            return;
        } else if (player == null) {
            return;
        }
        synchronized (players) {
            players.remove(player);
        }
        usertablemodel.RemovePlayer(LM.playermanager.GetPlayer(player));
        search_changed = true;
        //ReDrawPlayerList ();
    }

    void ClearPlayers() {
        synchronized (players) {
            players.clear();
        }
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
    private javax.swing.JPanel PlayerList;
    private javax.swing.JTextField SearchBox;
    private javax.swing.JSplitPane SplitPane;
    private javax.swing.JComboBox StatusCombo;
    private javax.swing.JTextField UserSearch;
    private javax.swing.JTable UserTable;
    private javax.swing.JLabel WelcomeLabel;
    private javax.swing.JButton hostReloadmodlist;
    private javax.swing.JLabel ingame_label;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton12;
    private javax.swing.JButton jButton13;
    private javax.swing.JButton jButton14;
    private javax.swing.JButton jButton15;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton4;
    private javax.swing.JButton jButton5;
    private javax.swing.JButton jButton8;
    private javax.swing.JComboBox jComboBox1;
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
    private javax.swing.JMenu jMenu1;
    private javax.swing.JMenuBar jMenuBar1;
    private javax.swing.JMenuItem jMenuItem1;
    private javax.swing.JPanel jPanel3;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JRadioButtonMenuItem jRadioButtonMenuItem1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JLabel ladderLabel;
    private javax.swing.JComboBox laddercomboBox;
    private javax.swing.JLabel number_of_battles;
    public javax.swing.JTabbedPane tabpane;
    private javax.swing.ButtonGroup tabplacementGroup;
    // End of variables declaration//GEN-END:variables
}