/*
 * CAgree.java
 *
 * Created on 29 August 2006, 03:12
 */

package aflobby.protocol.tasserver.ui;

import aflobby.framework.CEvent;
import aflobby.*;
import javax.swing.SwingUtilities;

/**
 *
 * @author  Shade
 */
public class CAgree extends javax.swing.JFrame implements java.awt.event.ActionListener {
    LMain LM;
    
    
    /**
     * Creates new form CAgree
     */
    public CAgree () {
        Runnable doWorkRunnable = new Runnable () {
            public void run () {
                initComponents ();
            }
        };
        SwingUtilities.invokeLater (doWorkRunnable);
        
    }
    
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    // <editor-fold defaultstate="collapsed" desc="Generated Code">//GEN-BEGIN:initComponents
    private void initComponents() {

        jPanel1 = new javax.swing.JPanel();
        jScrollPane1 = new javax.swing.JScrollPane();
        Agreement = new javax.swing.JEditorPane();
        Disagree = new javax.swing.JButton();
        Agree = new javax.swing.JButton();

        setDefaultCloseOperation(javax.swing.WindowConstants.EXIT_ON_CLOSE);
        java.util.ResourceBundle bundle = java.util.ResourceBundle.getBundle("aflobby/languages"); // NOI18N
        setTitle(bundle.getString("CAgree.Agreement")); // NOI18N
        setAlwaysOnTop(true);
        setResizable(false);

        jPanel1.setBorder(javax.swing.BorderFactory.createEtchedBorder());

        Agreement.setContentType("text/rtf");
        Agreement.setEditable(false);
        jScrollPane1.setViewportView(Agreement);

        Disagree.setText(bundle.getString("CAgree.I_Disagree/Disconnect")); // NOI18N
        Disagree.addActionListener(this);

        Agree.setText(bundle.getString("CAgree.I_Agree")); // NOI18N
        Agree.addActionListener(this);

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 474, Short.MAX_VALUE)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                        .addComponent(Agree)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(Disagree)))
                .addContainerGap())
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane1, javax.swing.GroupLayout.PREFERRED_SIZE, 327, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(Disagree)
                    .addComponent(Agree))
                .addContainerGap())
        );

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(jPanel1, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
        );

        pack();
    }

    // Code for dispatching events from components to event handlers.

    public void actionPerformed(java.awt.event.ActionEvent evt) {
        if (evt.getSource() == Disagree) {
            CAgree.this.DisagreeActionPerformed(evt);
        }
        else if (evt.getSource() == Agree) {
            CAgree.this.AgreeActionPerformed(evt);
        }
    }// </editor-fold>//GEN-END:initComponents
    
    private void DisagreeActionPerformed (java.awt.event.ActionEvent evt) {//GEN-FIRST:event_DisagreeActionPerformed
        Disagree ();
    }//GEN-LAST:event_DisagreeActionPerformed
    
    private void AgreeActionPerformed (java.awt.event.ActionEvent evt) {//GEN-FIRST:event_AgreeActionPerformed
        Agree ();
    }//GEN-LAST:event_AgreeActionPerformed
    
    /**
     * 
     */
    public void Agree(){
        
        LM.protocol.SendTraffic ("CONFIRMAGREEMENT");
        
        CEvent e = new CEvent("RESENDLOGIN");
        LM.core.NewGUIEvent (e);

        Runnable doWorkRunnable = new Runnable () {
            public void run () {
                setVisible (false);
            }
        };
        SwingUtilities.invokeLater (doWorkRunnable);

    }
    
    /**
     * 
     */
    public void Disagree(){
        LM.protocol.Disconnect ();
        
        Runnable doWorkRunnable = new Runnable () {
            public void run () {
                setVisible (false);
            }
        };
        SwingUtilities.invokeLater (doWorkRunnable);
        
        LM.SetFocus ("LoginPanel");
    }
    
    /**
     * 
     * @param L
     */
    public void Init(LMain L){
        LM = L;
    }
    
    private String m = "";
    
    /**
     * 
     * @param msg
     */
    public void AddLine(String msg){
        m = m + msg + "\n";
        
        Runnable doWorkRunnable = new Runnable () {
            public void run () {
                Agreement.setText (m);
            }
        };
        SwingUtilities.invokeLater (doWorkRunnable);
        
    }
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JButton Agree;
    private javax.swing.JEditorPane Agreement;
    private javax.swing.JButton Disagree;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JScrollPane jScrollPane1;
    // End of variables declaration//GEN-END:variables
    
}