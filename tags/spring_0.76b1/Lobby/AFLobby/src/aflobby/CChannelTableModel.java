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
import java.util.Iterator;
import javax.swing.ImageIcon;
import javax.swing.table.AbstractTableModel;

/**
 *
 * @author AF
 */
public class CChannelTableModel extends AbstractTableModel {
    LMain LM;
    
    private String[] columns = {
        "Icon",
        "Channel name",
        "Users",
        "Topic"
    };
    
    public ArrayList<CChannelInfo> channels = new ArrayList<CChannelInfo>();

    public CChannelTableModel(LMain L) {
        LM = L;
        //this.cv = cv;
    }

    public void clear(){
        channels.clear();
        fireTableDataChanged();
    }
    
    public int getRowCount() {
        return channels.size();
    }

    public int getColumnCount() {
        return columns.length;
    }


    @Override
    public String getColumnName(int col) {
        return columns[col];
    }

    /**
     * 
     * @param row
     * @return
     */
    public CChannelInfo GetPlayerAt(int row) {
        //synchronized(battles){
        if (row < channels.size()) {
            return channels.get(row); //
        } else {
            return null;
        }
        //}
    }

    public Object getValueAt(int row, int col) {

        if (row > channels.size()) {
            return "";
        }

        CChannelInfo b = GetPlayerAt(row);
        if (b == null) {
            return "";
        }

        switch (col) {
            case 0:
                return b.getIcon();
            case 1:
                return b.getName();
            case 2:
                return b.getUsercount();
            case 3:
                return b.getTopic();
            default:
                break;
        }

        return "";
    }

    /**
     * 
     * @param p
     */
    public void AddChannel(CChannelInfo p) {
        if(p == null){
            return;
        }
        
        if(channels.contains(p)){
            return;
        }
        
        channels.add(p);
        fireTableDataChanged();
    }

    /**
     * 
     * @param b
     */
    public void RemoveChannel(CChannelInfo b) {
        synchronized (channels) {
            Iterator<CChannelInfo> i = channels.iterator();
            while(i.hasNext()){
                CChannelInfo ba = i.next();
                if(ba == b){
                    i.remove();
                }
            }
        }
        fireTableDataChanged();
//        synchronized (battles) {
//            battles.remove(b);
//        }
//        fireTableDataChanged();
//        return b;
    }

    @Override
    public boolean isCellEditable(int rowIndex, int columnIndex) {
        return false;
    }
    
    @Override
    public Class getColumnClass(int column) {
        if(column <1){
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