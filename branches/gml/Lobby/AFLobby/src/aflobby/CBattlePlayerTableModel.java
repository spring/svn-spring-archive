/*
 * CBattleTableModel.java
 *
 * Created on 17 September 2006, 02:19
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby;

import java.awt.Graphics2D;
import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.Iterator;
import javax.swing.ImageIcon;
import javax.swing.SwingUtilities;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author AF
 */
public class CBattlePlayerTableModel extends AbstractTableModel {

    
    LMain LM;
    //CChannelView cv;
    private String[] columns = {"Flag","Rank","...","Username","Colour","Ready?","Faction","Player N#","Ally Team","Bonus%","CPU"};//{java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleTableModel.Description"), java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleTableModel.Status"), java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleTableModel.Map"), java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleTableModel.Mod"), java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleTableModel.Host"), java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleTableModel.Players")}; //,"ID""Private?",
    public ArrayList<CBattlePlayer> players = new ArrayList<CBattlePlayer>();

    CBattlePlayerTableModel(LMain L) {
        LM = L;
        //this.cv = cv;
    }

    public void clear(){
        players.clear();
        Runnable doWorkRunnable = new Runnable() {
            public void run() {
                fireTableDataChanged();
            }
        };

        SwingUtilities.invokeLater(doWorkRunnable);
    }
    
    public int getRowCount() {
        return players.size();
    }

    public int getColumnCount() {
        return columns.length;
    }


    @Override
    public String getColumnName(int col) {
        return columns[col];
    }

    CBattlePlayer GetPlayerAt(int row) {
        
        if (row < players.size()) {
            synchronized(players){
                return players.get(row); //
            }
        } else {
            return null;
        }
        //}
    }

    public Object getValueAt(int row, int col) {

        if (row > players.size()) {
            return "";
        }

        CBattlePlayer b;
        b = GetPlayerAt(row);
        if (b == null) {
            return "";
        }

        switch (col) {
            case 0:
                return CChannel.GetFlagIcon(b.getPlayerdata().getCountry());
            case 1:
                return CChannel.smallranks[b.getPlayerdata().rank];
            case 2:
                if(Misc.getBotModeFromStatus(b.getPlayerdata().getStatus())){
                    return CChannel.botimg;
                }else if (Misc.getAccessFromStatus(b.getPlayerdata().getStatus())>0){
                    return CChannel.adminimg;
                }else{
                    return null;
                }
            case 3:
                if(b.IsAI()){
                    return "AI: "+b.getPlayername()+" type: "+b.getAI()+" owner: "+b.getAIOwner();
                }else{
                    return b.getPlayername();
                }
            case 4:
                // colour
                BufferedImage i = new BufferedImage(16,16,BufferedImage.TYPE_INT_ARGB);
                
                Graphics2D g = i.createGraphics();
                
                g.setColor(b.getColor());
                g.fillRoundRect(0, 0, 16, 16, 6, 6);
                g.setColor(b.getColor().darker());
                g.drawRoundRect(0, 0, 16, 16, 6, 6);
                
                g.dispose();
                
                return new ImageIcon(i);
                //return b.statString;
            case 5:
                // ready?
                return b.isReady();
                //return b.statString;
            case 6:
                // faction?
                if(b.isSpec()){
                    return "s";
                }
                return b.getSide();
                
            case 7:
                // playern#
                if(b.isSpec()){
                    return "s";
                }
                return b.getTeamNo()+1;
                
            case 8:
                if(b.isSpec()){
                    return "s";
                }
                return b.getAllyNo()+1;
                
            case 9:
                // bonus%
                return b.getHandicap();

            case 10:
                // cpu
                return b.getPlayerdata().getCpu();

            default:
                break;
        }

        return "";
    }

    /**
     * 
     * @param p
     */
    public void AddPlayer(final CBattlePlayer p) {
        if(p == null){
            return;
        }
        
        if(players.contains(p)){
            return;
        }
        
        //synchronized (players) {
            players.add(p);
        //}
        
        Runnable doWorkRunnable = new Runnable() {
            public void run() {
                //int index = players.indexOf(p);
                //fireTableRowsInserted(index, index);
                fireTableDataChanged();
            }
        };

        SwingUtilities.invokeLater(doWorkRunnable);
        
    }

    public void RemovePlayer(CBattlePlayer b) {
        synchronized (players) {
            Iterator<CBattlePlayer> i = players.iterator();
            while(i.hasNext()){
                CBattlePlayer ba = i.next();
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
    }

    @Override
    public boolean isCellEditable(int rowIndex, int columnIndex) {
        return false;
    }
    
    @Override
    public Class getColumnClass(int column) {
        if(column <2){
            return ImageIcon.class;
        }else if(column ==4){
            return ImageIcon.class;
        }else{
            return String.class;
        }
        /*Class returnValue;
        if ((column >= 0) && (column < getColumnCount())) {
            returnValue = getValueAt(0, column).getClass();
        } else {
            returnValue = Object.class;
        }
        return returnValue;*/
     }

}