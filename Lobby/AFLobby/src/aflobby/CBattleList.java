/*
 * CBattleList.java
 *
 * Created on 17 September 2007, 06:11
 */
package aflobby;

import aflobby.helpers.CHolePuncher;
import aflobby.framework.CEvent;
import aflobby.UI.CUISettings;
import aflobby.UI.CView;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.Random;
import javax.swing.JTable;
import javax.swing.RowFilter;
import javax.swing.SwingUtilities;
import javax.swing.table.TableModel;
import javax.swing.table.TableRowSorter;

/**
 *
 * @author  AF-StandardUsr
 */
public class CBattleList extends CView {
    
    ArrayList<String> notifyOnBattleFinish = new ArrayList<String>();
    public CBattleTableModel jbm;

    TableRowSorter<TableModel> ts = null;
    CMyRowFilter filter = null;
    public boolean b = false;
    
    /** Creates new form CBattleList
     * @param L
     */
    public CBattleList(LMain L) {
        if(b){
            int j = 5;
        }
        LM = L;
        initComponents();
    }

    class CMyRowFilter extends RowFilter {
//       public boolean include(Entry<? extends Object, ? extends Object> entry) {
//         
//       }
        
        boolean ingame = true;
        boolean passworded = true;
        boolean locked = true;
        boolean ladder = true;
        boolean full = true;

        @Override
        public boolean include(Entry entry) {
            //for (int i = entry.getValueCount() - 1; i >= 0; i--) {
                CBattleInfo bi = (CBattleInfo) entry.getValue(0);
                if(bi.IsIngame() && (!ingame)){
                    return false;
                } else if (bi.IsPassworded() && (!passworded)){
                    return false;
                } else if (bi.locked && (!locked)){
                    return false;
                } else if (bi.isladdergame() && (!ladder)){
                    return false;
                } else if ((bi.maxplayers == bi.GetPlayerNames().size()) && (!full)){
                    return false;
                } else {
                //if (entry.getStringValue(i).startsWith("a")) {
                    // The value starts with "a", include it
                    return true;
                }
            //}
            //return false;
        }

    };
    
    @Override
    public void NewEvent(final CEvent e) {
        if (e.IsEvent(CEvent.ADDEDBATTLE)) {
            int a = 5;
            Runnable doWorkRunnable2 = new Runnable() {

                public void run() {
                    //if (jbm != null) {
                        //if (e.a != null) {
                            jbm.AddBattle((CBattleInfo) e.a);
                            battleCountLabel.setText(jbm.getRowCount() + " Battles Listed");
                        //}
                    //}
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable2);
        } else if (e.IsEvent("BATTLECLOSED")) {

            if (e.data[1] == null) {
                return;
            }
            final int k = Integer.parseInt(e.data[1].trim());
            Runnable doWorkRunnable = new Runnable() {
                public void run() {
                    jbm.RemoveBattle(k);
                    battleCountLabel.setText(jbm.getRowCount() + " Battles Listed");
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable); // BATTLE_ID username
        } else if (e.IsEvent("UPDATEBATTLEINFO")) {
            Runnable doWorkRunnable = new Runnable() {
                public void run() {
                    jbm.fireTableDataChanged();
                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);
        } else if (e.IsEvent("CLIENTSTATUS")) {
            int cstatus = Integer.parseInt(e.data[2]);
            Iterator<CBattleInfo> i = LM.protocol.GetBattles().values().iterator();
            while (i.hasNext()) {
                CBattleInfo info = i.next();
                if (info.GetHost().equalsIgnoreCase(e.data[1])) {

                    if (Misc.getInGameFromStatus(cstatus) == 1) {
                        info.SetIngame(true);
                    } else {
                        info.SetIngame(false);
                        if (notifyOnBattleFinish.contains(e.data[1])) {
                            notifyOnBattleFinish.remove(e.data[1]);
                            LM.Toasts.AddMessage("The battle hosted by " + e.data[1] + " has just finished");
                        }
                    }
                    if (jbm != null) {
                        Runnable doWorkRunnable = new Runnable() {
                                    public void run() {
                                        jbm.fireTableDataChanged();
                                    }
                                };
                        SwingUtilities.invokeLater(doWorkRunnable);
                    }
                }
            }
        }
    }

    private void JoinBattle() {
        int k = jBattleTable.getSelectedRow();
        if (k == -1) {
            return;
        }
        CBattleInfo bi = (CBattleInfo) jBattleTable.getValueAt(k, 0);
        if (bi == null) {
            LM.Toasts.AddMessage("please select a battle to join");
            return;
        }
        JoinBattle(bi);
    }

    private void JoinBattle(CBattleInfo bi) {
        if(!bi.isJoinable()){
            //
            LM.Toasts.AddMessage("Sorry this game is not joinable, make sure you have the needed game engine installed");
            return;
        }
        
        if (bi.IsIngame() == false) {
            if(bi.getEngine().equals("spring")){
                if (!CSync.HasMod(bi.GetMod())) {
                    CSync.RefreshUnitSync();
                    if (!CSync.HasMod(bi.GetMod())) {
                        // still dont have the mod?
                        LM.Toasts.AddMessage("You dont have this mod!!");
                        return;
                    }
                }
            }
            
            if (bi.natType == 1) {
                if (!CHolePuncher.SendRequest()) {
                    LM.Toasts.AddMessage("Holepunching failed....");
                    return; // holepunching failed we dont start
                }
            }
            LM.protocol.SendTraffic("JOINBATTLE " + bi.GetID() + " " + String.valueOf(BattlePass.getPassword()));
        } else {
            LM.Toasts.AddMessage("Game already in progress");
        }
    }
    
    @Override
    public void OnRemove(){
        //
        b = true;
        jbm = null;
        ts = null;
        filter = null;
    }

    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        BattleListMenu = new javax.swing.JPopupMenu();
        ShowMenu = new javax.swing.JMenu();
        IngameCheckMenuItem = new javax.swing.JCheckBoxMenuItem();
        PasswordCheckMenuItem = new javax.swing.JCheckBoxMenuItem();
        LockedCheckMenuItem = new javax.swing.JCheckBoxMenuItem();
        LadderCheckMenuItem = new javax.swing.JCheckBoxMenuItem();
        FullCheckMenuItem = new javax.swing.JCheckBoxMenuItem();
        jSeparator1 = new javax.swing.JSeparator();
        MessageOnOpenCheckMenu = new javax.swing.JCheckBoxMenuItem();
        HostInfoMenuItem = new javax.swing.JMenuItem();
        JoinBattleMenu = new javax.swing.JMenuItem();
        jLabel19 = new javax.swing.JLabel();
        jScrollPane9 = new javax.swing.JScrollPane();
        jBattleTable = new javax.swing.JTable();
        jLabel2 = new javax.swing.JLabel();
        jButton8 = new javax.swing.JButton();
        BattlePass = new javax.swing.JPasswordField();
        battlesRefreshMapMod = new javax.swing.JButton();
        battleCountLabel = new javax.swing.JLabel();
        SurpriseMeButton = new javax.swing.JButton();

        BattleListMenu.addPopupMenuListener(new javax.swing.event.PopupMenuListener() {
            public void popupMenuCanceled(javax.swing.event.PopupMenuEvent evt) {
            }
            public void popupMenuWillBecomeInvisible(javax.swing.event.PopupMenuEvent evt) {
            }
            public void popupMenuWillBecomeVisible(javax.swing.event.PopupMenuEvent evt) {
                BattleListMenuPopupMenuWillBecomeVisible(evt);
            }
        });
        BattleListMenu.addComponentListener(new java.awt.event.ComponentAdapter() {
            public void componentShown(java.awt.event.ComponentEvent evt) {
                BattleListMenuComponentShown(evt);
            }
        });

        java.util.ResourceBundle bundle = java.util.ResourceBundle.getBundle("aflobby/languages"); // NOI18N
        ShowMenu.setText(bundle.getString("CChannelView.ShowMenu.text")); // NOI18N

        IngameCheckMenuItem.setSelected(true);
        IngameCheckMenuItem.setText("Ingame");
        IngameCheckMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                IngameCheckMenuItemActionPerformed(evt);
            }
        });
        ShowMenu.add(IngameCheckMenuItem);

        PasswordCheckMenuItem.setSelected(true);
        PasswordCheckMenuItem.setText("Passworded");
        PasswordCheckMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                PasswordCheckMenuItemActionPerformed(evt);
            }
        });
        ShowMenu.add(PasswordCheckMenuItem);

        LockedCheckMenuItem.setSelected(true);
        LockedCheckMenuItem.setText("Locked");
        LockedCheckMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                LockedCheckMenuItemActionPerformed(evt);
            }
        });
        ShowMenu.add(LockedCheckMenuItem);

        LadderCheckMenuItem.setSelected(true);
        LadderCheckMenuItem.setText("Ladder");
        LadderCheckMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                LadderCheckMenuItemActionPerformed(evt);
            }
        });
        ShowMenu.add(LadderCheckMenuItem);

        FullCheckMenuItem.setSelected(true);
        FullCheckMenuItem.setText("Full");
        FullCheckMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                FullCheckMenuItemActionPerformed(evt);
            }
        });
        ShowMenu.add(FullCheckMenuItem);

        BattleListMenu.add(ShowMenu);

        jSeparator1.setEnabled(false);
        BattleListMenu.add(jSeparator1);

        MessageOnOpenCheckMenu.setText(bundle.getString("CChannelView.MessageOnOpenCheckMenu.text")); // NOI18N
        MessageOnOpenCheckMenu.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                MessageOnOpenCheckMenuMouseReleased(evt);
            }
        });
        MessageOnOpenCheckMenu.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                MessageOnOpenCheckMenuActionPerformed(evt);
            }
        });
        BattleListMenu.add(MessageOnOpenCheckMenu);

        HostInfoMenuItem.setText("View Host Info/Send PM");
        HostInfoMenuItem.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                HostInfoMenuItemActionPerformed(evt);
            }
        });
        BattleListMenu.add(HostInfoMenuItem);

        JoinBattleMenu.setText(bundle.getString("CChannelView.JoinBattleMenu.text")); // NOI18N
        JoinBattleMenu.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                JoinBattleMenuActionPerformed(evt);
            }
        });
        BattleListMenu.add(JoinBattleMenu);

        jLabel19.setFont(CUISettings.GetFont(12,false));
        jLabel19.setLabelFor(jBattleTable);
        jLabel19.setText(bundle.getString("CChannelView.jLabel19.text")); // NOI18N

        jScrollPane9.setBackground(new java.awt.Color(255, 255, 255));
        jScrollPane9.setFont(CUISettings.GetFont(12,false));
        jScrollPane9.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jScrollPane9MouseReleased(evt);
            }
        });

        jbm = new CBattleTableModel (LM);
        ts = new TableRowSorter<TableModel>(jbm);
        jBattleTable.setFont(jBattleTable.getFont().deriveFont(jBattleTable.getFont().getSize()+1f));
        jBattleTable.setModel(jbm);
        jBattleTable.setAutoResizeMode(javax.swing.JTable.AUTO_RESIZE_NEXT_COLUMN);
        jBattleTable.setRowMargin(0);
        jBattleTable.setRowSorter(ts);
        jBattleTable.setShowHorizontalLines(false);
        filter = new CMyRowFilter();
        ts.setRowFilter(filter);
        jBattleTable.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jBattleTableMouseReleased(evt);
            }
        });
        jScrollPane9.setViewportView(jBattleTable);

        jLabel2.setFont(jLabel2.getFont().deriveFont(jLabel2.getFont().getSize()+1f));
        jLabel2.setHorizontalAlignment(javax.swing.SwingConstants.RIGHT);
        jLabel2.setLabelFor(BattlePass);
        jLabel2.setText(bundle.getString("CChannelView.jLabel2.text")); // NOI18N

        jButton8.setFont(jButton8.getFont().deriveFont(jButton8.getFont().getSize()+1f));
        jButton8.setText(bundle.getString("CChannelView.jButton8.text")); // NOI18N
        jButton8.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jButton8MouseReleased(evt);
            }
        });
        jButton8.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton8ActionPerformed(evt);
            }
        });

        BattlePass.setFont(BattlePass.getFont().deriveFont(BattlePass.getFont().getSize()+1f));

        battlesRefreshMapMod.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/arrow_refresh.png"))); // NOI18N
        battlesRefreshMapMod.setText(bundle.getString("CChannelView.battlesRefreshMapMod.text")); // NOI18N
        battlesRefreshMapMod.setMargin(new java.awt.Insets(2, 6, 2, 6));
        battlesRefreshMapMod.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                battlesRefreshMapModActionPerformed(evt);
            }
        });

        battleCountLabel.setHorizontalAlignment(javax.swing.SwingConstants.RIGHT);
        battleCountLabel.setText("0 Battles Listed");

        SurpriseMeButton.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/dice.png"))); // NOI18N
        SurpriseMeButton.setText("Join Random Battle");
        SurpriseMeButton.setMargin(new java.awt.Insets(2, 6, 2, 6));
        SurpriseMeButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                SurpriseMeButtonActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane9, javax.swing.GroupLayout.DEFAULT_SIZE, 714, Short.MAX_VALUE)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addComponent(battlesRefreshMapMod, javax.swing.GroupLayout.PREFERRED_SIZE, 193, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(SurpriseMeButton, javax.swing.GroupLayout.PREFERRED_SIZE, 163, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 26, Short.MAX_VALUE)
                        .addComponent(jLabel2, javax.swing.GroupLayout.PREFERRED_SIZE, 81, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(BattlePass, javax.swing.GroupLayout.PREFERRED_SIZE, 169, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton8, javax.swing.GroupLayout.PREFERRED_SIZE, 66, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel19, javax.swing.GroupLayout.PREFERRED_SIZE, 277, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 210, Short.MAX_VALUE)
                        .addComponent(battleCountLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 227, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel19)
                    .addComponent(battleCountLabel))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane9, javax.swing.GroupLayout.DEFAULT_SIZE, 238, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jButton8)
                        .addComponent(BattlePass, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(jLabel2))
                    .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(battlesRefreshMapMod)
                        .addComponent(SurpriseMeButton)))
                .addContainerGap())
        );

        layout.linkSize(javax.swing.SwingConstants.VERTICAL, new java.awt.Component[] {BattlePass, SurpriseMeButton, battlesRefreshMapMod, jButton8, jLabel2});

    }// </editor-fold>//GEN-END:initComponents

    private void jBattleTableMouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jBattleTableMouseReleased
        if (evt.isPopupTrigger() || (evt.getButton() == java.awt.event.MouseEvent.BUTTON2) || (evt.getButton() == java.awt.event.MouseEvent.BUTTON3)) {

            JTable source = (JTable) evt.getSource();
            int row = source.rowAtPoint(evt.getPoint());
            if (row == -1) {
                return;
            }
            int column = source.columnAtPoint(evt.getPoint());
            //System.out.println(column);
            source.changeSelection(row, column, false, false);


            //int row = this.jBattleTable.getSelectedRow ();
            CBattleInfo i =  (CBattleInfo) jBattleTable.getValueAt(row, 0);
            if (i != null) {
                JoinBattleMenu.setEnabled(false);
                if (i.IsIngame()) {
                    String host = i.GetHost();
                    boolean check = notifyOnBattleFinish.contains(host);
                    MessageOnOpenCheckMenu.setSelected(check);
                    MessageOnOpenCheckMenu.setEnabled(true);
                } else {
                    if ((i.IsPassworded() == false) && (i.locked == false)) {
                        JoinBattleMenu.setEnabled(true);
                    }
                    MessageOnOpenCheckMenu.setSelected(false);
                    MessageOnOpenCheckMenu.setEnabled(false);
                }

                BattleListMenu.show(evt.getComponent(), evt.getX(), evt.getY());
            }

        /**/
        } else if (evt.getClickCount() > 1) {
            JoinBattle();
        }
    }//GEN-LAST:event_jBattleTableMouseReleased

    private void jScrollPane9MouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jScrollPane9MouseReleased
    //if(evt.getButton ()== evt.BUTTON2){
        // RIGHTCLICK!!!!
        //}
    }//GEN-LAST:event_jScrollPane9MouseReleased

    private void jButton8MouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton8MouseReleased
    }//GEN-LAST:event_jButton8MouseReleased

    private void jButton8ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton8ActionPerformed
        JoinBattle();
    }//GEN-LAST:event_jButton8ActionPerformed

    private void battlesRefreshMapModActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_battlesRefreshMapModActionPerformed
        CSync.RefreshUnitSync();
    }//GEN-LAST:event_battlesRefreshMapModActionPerformed

    private void MessageOnOpenCheckMenuMouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_MessageOnOpenCheckMenuMouseReleased
        int row = this.jBattleTable.getSelectedRow();
        CBattleTableModel m = (CBattleTableModel) jBattleTable.getModel();
        CBattleInfo i = m.GetBattleAt(row);
        if (MessageOnOpenCheckMenu.isSelected()) {
            if (notifyOnBattleFinish.contains(i.GetHost()) == false) {
                notifyOnBattleFinish.add(i.GetHost());
            }
        } else {
            notifyOnBattleFinish.remove(i.GetHost());
        }
    //notifyOnBattleFinish
    }//GEN-LAST:event_MessageOnOpenCheckMenuMouseReleased

    private void MessageOnOpenCheckMenuActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_MessageOnOpenCheckMenuActionPerformed
    //if(evt.)
    }//GEN-LAST:event_MessageOnOpenCheckMenuActionPerformed

    private void JoinBattleMenuActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_JoinBattleMenuActionPerformed
        JoinBattle();
    }//GEN-LAST:event_JoinBattleMenuActionPerformed

    private void BattleListMenuPopupMenuWillBecomeVisible(javax.swing.event.PopupMenuEvent evt) {//GEN-FIRST:event_BattleListMenuPopupMenuWillBecomeVisible
    //MessageOnOpenCheckMenu.setSelected (!MessageOnOpenCheckMenu.isSelected ());
        /*int row = this.jBattleTable.getSelectedRow ();
        if(row == -1) return;
        CBattleInfo i = ((CBattleTableModel)jBattleTable.getModel ()).GetBattleAt (row);
        if(i != null){
        if(i.IsIngame ()){
        MessageOnOpenCheckMenu.setEnabled (true);
        String host = i.GetHost ();
        boolean check = notifyOnBattleFinish.contains (host);
        MessageOnOpenCheckMenu.setSelected (check);
        }else{
        MessageOnOpenCheckMenu.setEnabled (false);
        }
        }*/
    }//GEN-LAST:event_BattleListMenuPopupMenuWillBecomeVisible

    private void BattleListMenuComponentShown(java.awt.event.ComponentEvent evt) {//GEN-FIRST:event_BattleListMenuComponentShown
    }//GEN-LAST:event_BattleListMenuComponentShown

    private void SurpriseMeButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_SurpriseMeButtonActionPerformed
        ArrayList<CBattleInfo> randomBattleList = new ArrayList<CBattleInfo>();
        ArrayList<CBattleInfo> battles = jbm.battles;
        for (CBattleInfo i : battles) {
            if (!i.IsIngame() && !i.locked && !i.IsPassworded() && !i.isladdergame()) {// AND i.haveMap AND haveMod) {
                randomBattleList.add(i);
            }
        }
        if (!randomBattleList.isEmpty()) {
            //pick a random battle from the "list" and join it
            Random r = new Random();
            r.setSeed(randomBattleList.size());
            int i = r.nextInt(randomBattleList.size());
            this.JoinBattle(randomBattleList.get(i));
        } else {
            LM.Toasts.AddMessage("No suitable battles found");
        }
}//GEN-LAST:event_SurpriseMeButtonActionPerformed

    private void HostInfoMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_HostInfoMenuItemActionPerformed
        int row = this.jBattleTable.getSelectedRow();
        CBattleTableModel m = (CBattleTableModel) jBattleTable.getModel();
        CBattleInfo i = m.GetBattleAt(row);
        String h = i.GetHost();
        CPlayerDataWindow p = new CPlayerDataWindow(LM, LM.playermanager.GetPlayer(h));
        p.setVisible(true);
}//GEN-LAST:event_HostInfoMenuItemActionPerformed

    private void IngameCheckMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_IngameCheckMenuItemActionPerformed
        filter.ingame = IngameCheckMenuItem.isSelected();
        ts.setRowFilter(filter);
    }//GEN-LAST:event_IngameCheckMenuItemActionPerformed

    private void PasswordCheckMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_PasswordCheckMenuItemActionPerformed
        filter.passworded = PasswordCheckMenuItem.isSelected();
        ts.setRowFilter(filter);
    }//GEN-LAST:event_PasswordCheckMenuItemActionPerformed

    private void LockedCheckMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_LockedCheckMenuItemActionPerformed
        filter.locked = LockedCheckMenuItem.isSelected();
        ts.setRowFilter(filter);
    }//GEN-LAST:event_LockedCheckMenuItemActionPerformed

    private void LadderCheckMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_LadderCheckMenuItemActionPerformed
        filter.ladder = LadderCheckMenuItem.isSelected();
        ts.setRowFilter(filter);
    }//GEN-LAST:event_LadderCheckMenuItemActionPerformed

    private void FullCheckMenuItemActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_FullCheckMenuItemActionPerformed
        filter.full = FullCheckMenuItem.isSelected();
        ts.setRowFilter(filter);
    }//GEN-LAST:event_FullCheckMenuItemActionPerformed

    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JPopupMenu BattleListMenu;
    private javax.swing.JPasswordField BattlePass;
    private javax.swing.JCheckBoxMenuItem FullCheckMenuItem;
    private javax.swing.JMenuItem HostInfoMenuItem;
    private javax.swing.JCheckBoxMenuItem IngameCheckMenuItem;
    private javax.swing.JMenuItem JoinBattleMenu;
    private javax.swing.JCheckBoxMenuItem LadderCheckMenuItem;
    private javax.swing.JCheckBoxMenuItem LockedCheckMenuItem;
    private javax.swing.JCheckBoxMenuItem MessageOnOpenCheckMenu;
    private javax.swing.JCheckBoxMenuItem PasswordCheckMenuItem;
    private javax.swing.JMenu ShowMenu;
    private javax.swing.JButton SurpriseMeButton;
    private javax.swing.JLabel battleCountLabel;
    private javax.swing.JButton battlesRefreshMapMod;
    private javax.swing.JTable jBattleTable;
    private javax.swing.JButton jButton8;
    private javax.swing.JLabel jLabel19;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JScrollPane jScrollPane9;
    private javax.swing.JSeparator jSeparator1;
    // End of variables declaration//GEN-END:variables
}