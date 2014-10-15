/*
 * AllyEntry.java
 *
 * Created on 20 March 2007, 19:00
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

package aflobby;

public class AllyEntry {
    private int numAllies;
    private double startRecLeft = 0d;
    private double startRecTop = 0d;
    private double startRecRight = 0d;
    private double startRecBottom = 0d;
    
    /** Creates a new instance of AllyEntry */
    public AllyEntry() {
    }

    public int getNumAllies() {
        return numAllies;
    }

    public void setNumAllies(int numAllies) {
        this.numAllies = numAllies;
    }

    public double getStartRecLeft() {
        return startRecLeft;
    }

    public void setStartRecLeft(double startRecLeft) {
        this.startRecLeft = startRecLeft;
    }

    public double getStartRecTop() {
        return startRecTop;
    }

    public void setStartRecTop(double startRecTop) {
        this.startRecTop = startRecTop;
    }

    public double getStartRecRight() {
        return startRecRight;
    }

    public void setStartRecRight(double startRecRight) {
        this.startRecRight = startRecRight;
    }

    public double getStartRecBottom() {
        return startRecBottom;
    }

    public void setStartRecBottom(double startRecBottom) {
        this.startRecBottom = startRecBottom;
    }
    
}
