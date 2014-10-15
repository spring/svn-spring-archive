package aflobby;
/*
 * CImageLoading.java
 *
 * Created on 11 February 2007, 20:38
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */

import java.awt.Component;
import java.awt.Image;
import java.awt.MediaTracker;
import java.awt.Toolkit;
import java.awt.image.BufferedImage;
import java.io.File;
import javax.imageio.ImageIO;
import javax.swing.ImageIcon;
import javax.swing.JLabel;
 
public class CImageLoading {
    /*public static void main(String[] args) {
        CImageLoading test = new CImageLoading();
        test.loadImages("images/cougar.jpg");
    }
 
    private void loadImages(String path) {
        Image older = olderLoadImage(path);
        Image newer = newerLoadImage(path);
        BufferedImage newest = newestLoadImage(path);
        JPanel panel = new JPanel(new GridLayout(1,0,2,0));
        panel.add(wrap(older));
        panel.add(wrap(newer));
        panel.add(wrap(newest));
        JOptionPane.showMessageDialog(null, panel, "",
                                      JOptionPane.PLAIN_MESSAGE);
    }*/
 
    private JLabel wrap(Image image) {
        return new JLabel(new ImageIcon(image));
    }
 
    public Image olderLoadImage(String path) {
        Image image = Toolkit.getDefaultToolkit().createImage(path);
        MediaTracker mt = new MediaTracker(new Component() {});
        mt.addImage(image, 0);
        try {
            mt.waitForID(0);
        } catch(InterruptedException e) {
            System.out.println("mt interrupted");
        }
        if(mt.isErrorAny()) {
            int status = mt.statusAll(false);
            printError(status, path);
        }
        return image;
    }
 
    public Image newerLoadImage(String path) {
        ImageIcon icon = new ImageIcon(path);
        int status = icon.getImageLoadStatus();
        if(status != MediaTracker.COMPLETE)
            printError(status, path);
        return icon.getImage();
    }
 
    public void printError(int status, String path) {
        String s = "Image loading error for " + path + ": ";
        switch(status) {
            case MediaTracker.ABORTED:
                s += "ABORTED";
                break;
            case MediaTracker.COMPLETE:
                s += "COMPLETE";
                break;
            case MediaTracker.ERRORED:
                s += "ERRORED";
                break;
            case MediaTracker.LOADING:
                s += "LOADING";
                break;
            default:
                System.out.println("unexpected status: " + status);
        }
        System.out.println(s);
    }
 
    public BufferedImage newestLoadImage(String path) {
        BufferedImage image = null;
        try {
            image = ImageIO.read(new File(path));
        } catch(Exception e) {
            System.out.println(e.getClass().getName() + ": " +
                               e.getMessage());
        }
        return image;
    }
}