/*
 * CSliderOptionsPanel.java
 *
 * Created on 12 January 2008, 13:39
 */

package aflobby.UI.battle;

import aflobby.framework.CEvent;
import aflobby.IBattleModel;
import aflobby.LMain;
import aflobby.framework.IModule;
import javax.swing.SwingUtilities;

/**
 *
 * @author  tarendai-std
 */
public class CSliderOptionsPanel extends javax.swing.JPanel implements IModule{
    
    int defValue;
    String title;
    String description;
    String key;
    IBattleModel battlemodel;
    boolean host;
    boolean map;
    int min;
    int max;
    int step;
    
    /** Creates new form CSliderOptionsPanel
     * @param battlemodel
     * @param key 
     * @param defValue
     * @param min 
     * @param max 
     * @param step 
     * @param title
     * @param description
     * @param map 
     */
    public CSliderOptionsPanel(
            IBattleModel battlemodel, String key, float defValue, float min, float max, float step, String title, String description, boolean map) {
        
        this.host = battlemodel.AmIHost();
        this.defValue = (int) defValue;
        this.title = new String(title);
        this.key = new String(key);
        this.description = new String(description);
        this.battlemodel = battlemodel;
        this.min = (int) min;
        this.max = (int) max;
        this.step = (int) step;
        this.map = map;
        
        battlemodel.PutOption(key, defValue);
        
        Runnable doWorkRunnable = new Runnable() {
            public void run() {
                initComponents();
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

        jLabel2 = new javax.swing.JLabel();
        jLabel1 = new javax.swing.JLabel();
        Slider = new javax.swing.JSlider();
        jButton1 = new javax.swing.JButton();
        Spinner = new javax.swing.JSpinner();
        jLabel3 = new javax.swing.JLabel();

        jLabel2.setText(description);

        jLabel1.setFont(jLabel1.getFont().deriveFont(jLabel1.getFont().getSize()+5f));
        jLabel1.setText(title);

        Slider.setMajorTickSpacing(step);
        Slider.setMaximum(max);
        Slider.setMinimum(min);
        Slider.setValue(defValue);
        Slider.setEnabled(host);
        Slider.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                SliderStateChanged(evt);
            }
        });

        jButton1.setText("Reset");
        jButton1.setEnabled(host);
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        Spinner.setModel(new javax.swing.SpinnerNumberModel(defValue, min, max, step));
        Spinner.setEnabled(host);
        Spinner.setValue(defValue);
        Spinner.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                SpinnerStateChanged(evt);
            }
        });

        jLabel3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/map.png"))); // NOI18N
        jLabel3.setDisabledIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/optionflag.png"))); // NOI18N
        jLabel3.setEnabled(map);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel2, javax.swing.GroupLayout.DEFAULT_SIZE, 429, Short.MAX_VALUE)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, layout.createSequentialGroup()
                        .addComponent(Slider, javax.swing.GroupLayout.DEFAULT_SIZE, 273, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(Spinner, javax.swing.GroupLayout.PREFERRED_SIZE, 53, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton1, javax.swing.GroupLayout.PREFERRED_SIZE, 91, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(layout.createSequentialGroup()
                        .addComponent(jLabel1, javax.swing.GroupLayout.DEFAULT_SIZE, 361, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel3)))
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(layout.createSequentialGroup()
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(layout.createSequentialGroup()
                        .addGap(8, 8, 8)
                        .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 36, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(layout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(jLabel3, javax.swing.GroupLayout.DEFAULT_SIZE, 36, Short.MAX_VALUE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jLabel2)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(jButton1)
                        .addComponent(Spinner, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addComponent(Slider, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap(16, Short.MAX_VALUE))
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
        Runnable doWorkRunnable = new Runnable() {
            public void run() {
                Slider.setValue(defValue);
                Spinner.setValue(defValue);
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
        battlemodel.PutOption(key, defValue);
    }//GEN-LAST:event_jButton1ActionPerformed

    private void SliderStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_SliderStateChanged
        int value = Slider.getValue();
        Runnable doWorkRunnable = new Runnable() {
            public void run() {
                Spinner.setValue(Slider.getValue());
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
        battlemodel.PutOption(key, value);
    }//GEN-LAST:event_SliderStateChanged

    private void SpinnerStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_SpinnerStateChanged
        Integer value = (Integer) Spinner.getValue();
        Runnable doWorkRunnable = new Runnable() {
            public void run() {
                Slider.setValue((Integer)Spinner.getValue());
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
        battlemodel.PutOption(key, value);
    }//GEN-LAST:event_SpinnerStateChanged
    
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JSlider Slider;
    private javax.swing.JSpinner Spinner;
    private javax.swing.JButton jButton1;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel2;
    private javax.swing.JLabel jLabel3;
    // End of variables declaration//GEN-END:variables

    public void Init(LMain L) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void Update() {
        
    }

    public void NewEvent(CEvent e) {
        if(e.IsEvent("SETSCRIPTTAGS")){
            //
            String[] pairs = e.parameters.split("\t");
            
            for(int i = 0; i< pairs.length; i++){
                
                String[] pair = pairs[i].split("=");
                
                String k = pair[0];
                k = k.replaceAll("\\\\", "/");
                String value = pair[1];
                
                if(k.equalsIgnoreCase(key)){
                    final Integer iv = Float.valueOf(value).intValue();
                    Runnable doWorkRunnable = new Runnable() {
                        public void run() {
                            Slider.setValue(iv);
                            Spinner.setValue(iv);
                        }
                    };
                    SwingUtilities.invokeLater(doWorkRunnable);
                }
                
            }
        }
    }

    public void NewGUIEvent(CEvent e) {

    }

    public void OnRemove() {
        battlemodel = null;
    }
    
}