/*
 * JStartPanel.java
 *
 * Created on 07 June 2006, 18:46
 */

package jlobby;

import java.io.IOException;

/**
 *
 * @author  AF
 */
public class JStartPanel extends javax.swing.JPanel {
    LMain LM;
    /** Creates new form JStartPanel */
    public JStartPanel() {
        initComponents();
        try {
            jEditorPane1.setPage("http://www.darkstars.co.uk");
        } catch (IOException ex) {
            ex.printStackTrace();
        }
    }
    void Update(){
        //
    }
    void NewEvent(JEvent e){
        //
    }
    void Init(LMain L){
        LM = L;
    }
    /** This method is called from within the constructor to
     * initialize the form.
     * WARNING: Do NOT modify this code. The content of this method is
     * always regenerated by the Form Editor.
     */
    // <editor-fold defaultstate="collapsed" desc=" Generated Code ">//GEN-BEGIN:initComponents
    private void initComponents() {
        jScrollPane1 = new javax.swing.JScrollPane();
        jEditorPane1 = new javax.swing.JEditorPane();

        setMinimumSize(new java.awt.Dimension(840, 570));
        setPreferredSize(new java.awt.Dimension(840, 570));
        jEditorPane1.setBorder(null);
        jEditorPane1.setEditable(false);
        jEditorPane1.addHyperlinkListener(new javax.swing.event.HyperlinkListener() {
            public void hyperlinkUpdate(javax.swing.event.HyperlinkEvent evt) {
                jEditorPane1HyperlinkUpdate(evt);
            }
        });

        jScrollPane1.setViewportView(jEditorPane1);

        org.jdesktop.layout.GroupLayout layout = new org.jdesktop.layout.GroupLayout(this);
        this.setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(layout.createSequentialGroup()
                .addContainerGap()
                .add(jScrollPane1, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 820, Short.MAX_VALUE)
                .addContainerGap())
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(org.jdesktop.layout.GroupLayout.LEADING)
            .add(layout.createSequentialGroup()
                .addContainerGap()
                .add(jScrollPane1, org.jdesktop.layout.GroupLayout.DEFAULT_SIZE, 548, Short.MAX_VALUE)
                .addContainerGap())
        );
    }// </editor-fold>//GEN-END:initComponents

    private void jEditorPane1HyperlinkUpdate(javax.swing.event.HyperlinkEvent evt) {//GEN-FIRST:event_jEditorPane1HyperlinkUpdate
// TODO add your handling code here:
        String s  = evt.getURL().toString();
        if(s.equalsIgnoreCase("http://darkstars.co.uk/lobby.login")){
            // switch to login view
            LM.SetFocus("LoginPanel");
        }
    }//GEN-LAST:event_jEditorPane1HyperlinkUpdate
    
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JEditorPane jEditorPane1;
    private javax.swing.JScrollPane jScrollPane1;
    // End of variables declaration//GEN-END:variables
    
}