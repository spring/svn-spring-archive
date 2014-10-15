/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package org.darkstars.battlehub.framework;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.Enumeration;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;

/**
 *
 * Based on code from here:
 * http://www.java-tips.org/java-se-tips/java.util.zip/how-to-extract-file-files-from-a-zip-file-3.html
 * @author AF-Standard
 */
public class CUnZipper {
//    public static void GetZipFiles(String filename, String destination){
//        
//        
//        GetZipFiles(new File(filename),destination);
//    }
    
    public static void unzipArchive(File archive, File outputDir) {
        try {
            ZipFile zipfile = new ZipFile(archive);
            for (Enumeration e = zipfile.entries(); e.hasMoreElements(); ) {
                ZipEntry entry = (ZipEntry) e.nextElement();
                unzipEntry(zipfile, entry, outputDir);
            }
        } catch (Exception e) {
            CErrorWindow ew = new CErrorWindow(e);
            //log.error("Error while extracting file " + archive, e);
        }
    }

    private static void unzipEntry(ZipFile zipfile, ZipEntry entry, File outputDir) throws IOException {

        if (entry.isDirectory()) {
            createDir(new File(outputDir, entry.getName()));
            return;
        }

        File outputFile = new File(outputDir, entry.getName());
        if (!outputFile.getParentFile().exists()){
            createDir(outputFile.getParentFile());
        }

        //log.debug("Extracting: " + entry);
//        BufferedInputStream inputStream = new BufferedInputStream(zipfile.getInputStream(entry));
//        BufferedOutputStream outputStream = new BufferedOutputStream(new FileOutputStream(outputFile));

        try {
            copy(zipfile.getInputStream(entry),outputFile);
            //IOUtils.copy(inputStreamzipfile.getInputStream(entry), outputStream);
        } catch(Exception e){
            CErrorWindow ew = new CErrorWindow(e);
        }finally {
        
//            outputStream.close();
//            inputStream.close();
        }
    }

    // Copies src file to dst file.
    // If the dst file does not exist, it is created
    static void copy(InputStream in, File dst){// throws IOException {
        // throws IOException {
//        if(!dst.canWrite()){
//            //
//            CErrorWindow ew = new CErrorWindow(new RuntimeException("Error target file cannot be written to CanWrite() returned false"));
//        }
        OutputStream out = null;
        try {
            out = new FileOutputStream(dst);

            // Transfer bytes from in to out
            byte[] buf = new byte[1024];
            int len;
            while ((len = in.read(buf)) > 0) {
                out.write(buf, 0, len);
            }
            out.flush();
            in.close();
            out.close();
        } catch (FileNotFoundException ex) {
            Logger.getLogger(CUnZipper.class.getName()).log(Level.SEVERE, null, ex);
            CErrorWindow ew = new CErrorWindow(ex);
        } catch (IOException ex) {
            CErrorWindow ew = new CErrorWindow(ex);
            Logger.getLogger(CUnZipper.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            try {
                out.close();
            } catch (IOException ex) {
                CErrorWindow ew = new CErrorWindow(ex);
                Logger.getLogger(CUnZipper.class.getName()).log(Level.SEVERE, null, ex);
            }
        }
        if(!dst.exists()){
            //
            CErrorWindow ew = new CErrorWindow(new RuntimeException("Error extracted file does not exist, verification failed"));
        }
    }

    private static void createDir(File dir) {
        //log.debug("Creating dir "+dir.getName());
        if(!dir.mkdirs()) throw new RuntimeException("Can not create dir "+dir);
    }

//    public static void GetZipFiles(File filename, String destination){
//        try {
//            
//            ///////////////////////////////
////            String destinationname = "d:\\servlet\\testZip\\";
//            byte[] buf = new byte[1024];
//            ZipInputStream zipinputstream = null;
//            ZipEntry zipentry;
//            zipinputstream = new ZipInputStream(new FileInputStream(filename));
//
//            zipentry = zipinputstream.getNextEntry();
//            while (zipentry != null){ 
//                //for each entry to be extracted
//                String entryName = zipentry.getName();
//                System.out.println("entryname "+entryName);
//                
//                File newFile = new File(entryName);
//                String directory = newFile.getParent();
//                
//                if(directory == null){
//                    if(newFile.isDirectory()){
//                        break;
//                    }
//                }
//                File of = new File(destination+entryName);
//                if(of.exists()){
//                    of.delete();
//                }
//                if(of.canWrite()){
//                    FileOutputStream fileoutputstream = new FileOutputStream(of);
//                    int n;
//                    while ((n = zipinputstream.read(buf, 0, 1024)) > -1){
//                        fileoutputstream.write(buf, 0, n);
//                    }
//
//                    fileoutputstream.close();
//                } else{
//                    //
//                    JOptionPane.showMessageDialog(null, "Error writting file: "+destination+entryName);
//                }
//                zipinputstream.closeEntry();
//                zipentry = zipinputstream.getNextEntry();
//
//            }//while
//
//            zipinputstream.close();
//        }catch (Exception e){
//            e.printStackTrace();
//            CErrorWindow ew = new CErrorWindow(e);
//        }
//    }
}
