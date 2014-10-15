/*
 * CBattleTableModel.java
 *
 * Created on 17 September 2006, 02:19
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.Iterator;
import javax.swing.SwingUtilities;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author AF
 */
public class CBattleTableModel extends AbstractTableModel {

    class battle_comp implements Comparator {

        public int compare(Object a, Object b) {
            try {
                int as;
                int bs;
                if (((CBattleInfo) a).IsIngame()) {
                    as = 0;
                } else if (((CBattleInfo) a).IsPassworded()) {
                    as = 1;
                } else {
                    as = 2;
                }
                if (((CBattleInfo) b).IsIngame()) {
                    bs = 0;
                } else if (((CBattleInfo) b).IsPassworded()) {
                    bs = 1;
                } else {
                    bs = 2;
                }
                if (as == bs) {
                    return ((CBattleInfo) a).GetMod().compareTo(((CBattleInfo) b).GetMod());
                }
                if (as > bs) {
                    return 0;
                } else {
                    return 1;
                }
                /*int i1=((CBattleInfo)a).GetID ();
                int i2 = ((CBattleInfo)b).GetID();
                if(i1 < i2){
                return 1;
                }else{
                return 0;
                }*/
            } catch (Exception e) {
                return 0;
            }
        }
    }
    LMain LM;
    //CChannelView cv;
    private String[] columns = {java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleTableModel.Description"), java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleTableModel.Status"), java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleTableModel.Map"), java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleTableModel.Mod"), java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleTableModel.Host"), java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleTableModel.Players")}; //,"ID""Private?",
    public ArrayList<CBattleInfo> battles = new ArrayList<CBattleInfo>();

    CBattleTableModel(LMain L) {
        LM = L;
    }

    public int getRowCount() {
        return battles.size();
    }

    public int getColumnCount() {
        return columns.length;
    }


    @Override
    public String getColumnName(int col) {
        return columns[col];
    }

    CBattleInfo GetBattleAt(int row) {
        //synchronized(battles){
        if (row < battles.size()) {
            return battles.get(row); //
        } else {
            return null;
        }
        //}
    }

    public Object getValueAt(int row, int col) {

        if (row > battles.size()) {
            return "";
        }

        CBattleInfo b = GetBattleAt(row);
        if (b == null) {
            return "";
        }

        switch (col) {
            case 0:
                return b;
            case 1:

                String s = "";
                
                if (b.IsIngame()) {
                    s +=  java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleTableModel.Ingame");
                } else if (b.locked) {
                    s += java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleTableModel.Locked");
                } else if (b.maxplayers == b.GetPlayerNames().size()) {
                    s += java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleTableModel.Full");
                } else if (b.isladdergame()){
                    s += "ladder game";
                } else {
                    s += java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleTableModel.Open");
                }
                
                if (b.IsPassworded()) {
                    s += java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleTableModel._&_passworded"); //<HTML><body bgcolor=\"FFDD00\"> <font color=\"#000000\">"+"&nbsp;";
                }

                return s;
            case 2:
                String t = b.GetMap();
                if (t.endsWith(".smf") || t.endsWith(".sm3")) {
                    t = t.substring(0, t.length() - 4);
                }
                return t;
            case 3:
                String modname = b.GetMod();

                // please thank springlobby for this little block
                //{
                modname = modname.replace("Absolute Annihilation", "AA");
                modname = modname.replace("Complete Annihilation", "CA");
                modname = modname.replace("Balanced Annihilation", "BA");
                modname = modname.replace("Expand and Exterminate", "EE");
                modname = modname.replace("War Evolution", "WarEv");
                modname = modname.replace("TinyComm", "TC");
                modname = modname.replace("BETA", "b");
                modname = modname.replace("Public Alpha", "pa");
                modname = modname.replace("Public Beta", "pb");
                modname = modname.replace("Public", "p");
                modname = modname.replace("Alpha", "a");
                //}
                return modname;
            case 4:
                return b.GetHost();
            case 5:
                String q = "(";
                q += (b.GetPlayerNames().size() - b.spectatorcount) + "+" + b.spectatorcount;
                q += "/" + b.maxplayers + ")";
                q += b.GetPlayerNames().toString();
                return q;
            default:
                break;
        }

        return "";
    }

    public void AddBattle(CBattleInfo b) {
        if(battles.contains(b)){
            return;
        }
        
        battles.add(b);
        Runnable doWorkRunnable = new Runnable() {
            public void run() {
                fireTableDataChanged();
            }
        };

        SwingUtilities.invokeLater(doWorkRunnable);
    }

    public void RemoveBattle(CBattleInfo b) {
        synchronized (battles) {
            Iterator<CBattleInfo> i = battles.iterator();
            while(i.hasNext()){
                CBattleInfo ba = i.next();
                if(ba == b){
                    i.remove();
                }
            }
        }
        Runnable doWorkRunnable = new Runnable() {
            public void run() {
                fireTableDataChanged();
            }
        };

        SwingUtilities.invokeLater(doWorkRunnable);
//        synchronized (battles) {
//            battles.remove(b);
//        }
//        fireTableDataChanged();
//        return b;
    }
    
    public void RemoveBattle(int idx) {
        synchronized (battles) {
            Iterator<CBattleInfo> i = battles.iterator();
            while(i.hasNext()){
                CBattleInfo b = i.next();
                if(b.GetID() == idx){
                    i.remove();
                }
            }
        }
        Runnable doWorkRunnable = new Runnable() {
            public void run() {
                fireTableDataChanged();
            }
        };

        SwingUtilities.invokeLater(doWorkRunnable);
    }

    @Override
    public boolean isCellEditable(int rowIndex, int columnIndex) {
        return false;
    }
    
    @Override
    public Class getColumnClass(int column) {
        Class returnValue;
        if ((column >= 0) && (column < getColumnCount())) {
            returnValue = getValueAt(0, column).getClass();
        } else {
            returnValue = Object.class;
        }
        return returnValue;
     }

}