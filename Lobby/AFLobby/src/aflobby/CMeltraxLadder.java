/*
 * CMeltraxLadder.java
 *
 * Created on 01-Sep-2007, 01:00:00
 *
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

package aflobby;

import aflobby.helpers.CFSHelper;
import com.myjavatools.web.ClientHttpRequest;
import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.MalformedURLException;
import java.net.URL;
import java.net.URLConnection;
import java.net.URLEncoder;
import java.util.TreeMap;


/**
 *
 * @author AF-StandardUsr
 */
public class CMeltraxLadder {

    /**
     * 
     */
    public static final String prefix = "http://meltrax.homeip.net/projects/other/spring/ladder/lobby/";
    //http://www.spring-league.com/ladder/lobby/";
    
    public static TreeMap<Integer, String> ladders = new TreeMap<Integer, String>();
    
    /**
     * 
     */
    public static TreeMap<String, Integer> ladderIDs = new TreeMap<String, Integer>();
    
    /**
     * 
     */
    public static TreeMap<Integer, CLadderProperties> ladderProperties = new TreeMap<Integer, CLadderProperties>();

    /*
    mod <long modname substring (ie 'Balanced Annihilation')>
    min_players_per_allyteam <number equal or greater than 1>
    max_players_per_allyteam <number equal or greater than 1>
    startpos (0|1|2|any)
    gamemode (0|1|2|any)
    dgun (0|1|any)
    ghost (0|1|any)
    diminish (0|1|any)
    metal (<number min> <number max>|any)
    energy (<number min> <number max>|any)
    units (<number min> <number max>|any)
    restricted (<comma-seperated list of unit shortnames (ie 'armmex,cormex')>|none)
    rules <rules-text (can contain any number of newlines)>
     */
    
    /**
     *
     */
    public static void Initialize() {
        GetLadders();
    }
    
    /**
     *
     */
    public static void GetLadders() {
        ladders.clear();
        //http://www.spring-league.com/ladder/lobby/ladderlist.php
        System.out.println("retrieving ladder data");
        String s = Misc.getURLContent(prefix+"ladderlist.php", "");
        System.out.println("got raw ladder data, parsing");
        String[] myladders = s.split("\n");
        System.out.println("ladders: " + myladders.length);
        System.out.println("\"" + s + "\"");
        for (String l : myladders) {
            int i = l.indexOf(" ");
            Integer ladder_id = Integer.valueOf(l.substring(0, i));
            String ladder_name = l.substring(i);
            ladders.put(ladder_id, ladder_name);
            ladderIDs.put(ladder_name, ladder_id);
            ladderProperties.put(ladder_id.intValue(), RetrieveLadderData(ladder_id.intValue()));
        }
        System.out.println("ladder data retrieved and parsed");
    }

    /**
     * Parses a battle description and returns either a aldder ID or -1.
     * 
     * @param battledesc - the string representing the battles description.
     * @return 
     */
    public static int ParseBattleDescription(String battledesc){
        if(battledesc.startsWith("(ladder")==false){
            return -1;
        } else{
            String p = battledesc.replaceAll("(ladder ", "");
            int i = p.indexOf(')');
            int value = Integer.parseInt(p.substring(0, i));
            return value;
        }
    }
    
    public static boolean ChangePassword(String username, String password, String newpassword){
        String url = prefix+"changepassword.php?username="+username+"&password="+password+"&newPass="+newpassword;
        String result = Misc.getURLContent(url, "error");
        if(result.toLowerCase().contains("error")){
            return false;
        }
        return true;
    }
    
    /**
     * Gets data and rules of the specified ladder.
     * @param id the ID number of the ladder
     * @return
     */
    public static CLadderProperties GetLadderData(int id) {
        // http://www.spring-league.com/ladder/lobby/rules.php?ladder=1
        return ladderProperties.get(id);
    }
    
    /**
     * Retrieves data and rules of the specified ladder from the web.
     * @param id the ID number of the ladder
     * @return
     */
    public static CLadderProperties RetrieveLadderData(int id) {
        // http://www.spring-league.com/ladder/lobby/rules.php?ladder=1
        String s = Misc.getURLContent(prefix+"rules.php?ladder="+id, "");
        if ((s == null) || (s.equals(""))) {
            return null;
        }
        String[] params = s.split("\n");
        
        CLadderProperties d = new CLadderProperties();
        d.mod = params[0].substring(4);
        d.min_players_per_allyteam = Integer.parseInt( params[1].split(" ")[1] );
        d.max_players_per_allyteam = Integer.parseInt( params[2].split(" ")[1] );
        
        if(params[3].endsWith("any")){
            d.startpos = 3;
        }else{
            d.startpos = Integer.parseInt( params[3].split(" ")[1] );
        }
        
        if(params[4].endsWith("any")){
            d.gamemode = 3;
        }else{
            d.gamemode = Integer.parseInt( params[4].split(" ")[1] );
        }
        
        if(params[5].endsWith("any")){
            d.dgun = 2;
        }else{
            d.dgun = Integer.parseInt( params[5].split(" ")[1] );
        }
        
        if(params[6].endsWith("any")){
            d.ghost = 2;
        }else{
            d.ghost = Integer.parseInt( params[6].split(" ")[1] );
        }
        
        if(params[7].endsWith("any")){
            d.diminish = 2;
        }else{
            d.diminish = Integer.parseInt( params[7].split(" ")[1] );
        }
        
        // metal (<number min> <number max>|any)
        if(params[8].endsWith("any")){
            d.minmetal= -1;
            d.maxmetal = -1;
        }else{
            d.minmetal = Integer.parseInt( params[8].split(" ")[1] );
            d.maxmetal = Integer.parseInt( params[8].split(" ")[2] );
        }
        
        if(params[9].endsWith("any")){
            d.minenergy= -1;
            d.maxenergy = -1;
        }else{
            d.minenergy = Integer.parseInt( params[9].split(" ")[1] );
            d.maxenergy = Integer.parseInt( params[9].split(" ")[2] );
        }
        
        if(params[10].endsWith("any")){
            d.minunits= -1;
            d.maxunits = -1;
        }else{
            d.minunits = Integer.parseInt( params[10].split(" ")[1] );
            d.maxunits = Integer.parseInt( params[10].split(" ")[2] );
        }
        
        if(params[11].endsWith("none")==false){
            String[] u = params[11].substring(12).split(",");
            for(String n :u){
                if(n != null){
                    d.restricted_units.add(n);
                }
            }
        }
        
        return d;
    }

    public static int GetLadderCount() {
        return ladders.size();
    }

    public static String GetLadderName(int id) {
        return ladders.get(id);
    }

    public static int GetLadderID(String name) {
        return ladderIDs.get(name);
    }
    
    public static boolean AccountExists(String username) {
        String url = prefix + "ranking.php?ladder=1&players[]=" + username;
        String s = Misc.getURLContent(url, "n");
        if (s.equals("n")) {
            return false;
        }
        String[] d = s.split(" ");
        return !d[1].equals("n/a");
    }

    public static void ReportGame3(String username, String password) {
        /*
        <form action="https://meltrax.homeip.net/projects/other/spring/ladder/lobby/report.php"
        method="post" enctype="multipart/form-data">
        Username: <input name="username"><br>
        Password: <input name="password" type="password"><br>
        Spring\Infolog.txt: <input name="infolog" type="file"><br>
        Spring\Script.txt: <input name="script" type="file"><br>
        ReplayID from <a href="http://replays.unknown-files.net/">http://replays.unknown-files.net/</a> (optional): <input name="replay"><br>
        <input type="submit">
        </form>
         */
        try {
            // Construct data
            String data = URLEncoder.encode("username", "UTF-8") + "=" + URLEncoder.encode(username, "UTF-8");
            data += "&" + URLEncoder.encode("password", "UTF-8") + "=" + URLEncoder.encode(password, "UTF-8");
            data += "&" + URLEncoder.encode("infolog", "UTF-8") + "=" + URLEncoder.encode(CFSHelper.GetFileContents("infolog.txt"), "UTF-8");
            data += "&" + URLEncoder.encode("script", "UTF-8") + "=" + URLEncoder.encode(CFSHelper.GetFileContents("script.txt"), "UTF-8");

            // Send data
            URL url = new URL(prefix +"report.php");
            URLConnection conn = url.openConnection();
            conn.setDoOutput(true);
            OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
            wr.write(data);
            wr.flush();

            // Get the response
            BufferedReader rd = new BufferedReader(new InputStreamReader(conn.getInputStream()));
            String line;
            while ((line = rd.readLine()) != null) {
                // Process line...
            }
            wr.close();
            rd.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    public static void ReportGame(String username, String password) {
        /*
        <form action="https://meltrax.homeip.net/projects/other/spring/ladder/lobby/report.php"
        method="post" enctype="multipart/form-data">
        Username: <input name="username"><br>
        Password: <input name="password" type="password"><br>
        Spring\Infolog.txt: <input name="infolog" type="file"><br>
        Spring\Script.txt: <input name="script" type="file"><br>
        ReplayID from <a href="http://replays.unknown-files.net/">http://replays.unknown-files.net/</a> (optional): <input name="replay"><br>
        <input type="submit">
        </form>
         */
        
        
        try {
            URL url = new URL(prefix +"report.php");
            TreeMap values = new TreeMap();
            values.put("username", username);
            values.put("password", password);
            values.put("infolog", new File("infolog.txt"));
            values.put("script", new File("script.txt"));
            
            // Send data
            InputStream serverInput = ClientHttpRequest.post(
                    url,
                    values
                    );
            

            // Get the response
            BufferedReader rd = new BufferedReader(new InputStreamReader(serverInput));
            String line;
            while ((line = rd.readLine()) != null) {
                // Process line...
            }
            rd.close();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    @SuppressWarnings(value = "deprecation")
    public static void ReportGame2() throws Exception {

        HttpURLConnection conn = null;
        BufferedReader br = null;
        DataOutputStream dos = null;
        DataInputStream inStream = null;

        InputStream is = null;
        OutputStream os = null;
        boolean ret = false;

        String lineEnd = "\r\n";
        String twoHyphens = "--";
        String boundary = "*****";


        int bytesRead;
        int bytesAvailable;
        int bufferSize;

        byte[] buffer;

        int maxBufferSize = 1 * 1024 * 1024;


        String responseFromServer = "";

        String urlString = prefix+"report.php";


        try {
            String data = URLEncoder.encode("username", "UTF-8") + "=" + URLEncoder.encode("[]Lobbytest", "UTF-8");
            data += "&" + URLEncoder.encode("password", "UTF-8") + "=" + URLEncoder.encode("mypass", "UTF-8");

            //------------------ CLIENT REQUEST
            FileInputStream fileInputStream = new FileInputStream(new File("script.txt"));
            FileInputStream fileInputStream2 = new FileInputStream(new File("infolog.txt"));

            // open a URL connection to the Servlet
            URL url = new URL(urlString);


            // Open a HTTP connection to the URL
            conn = (HttpURLConnection) url.openConnection();



            // Allow Inputs
            conn.setDoInput(true);

            // Allow Outputs
            conn.setDoOutput(true);

            // Don't use a cached copy.
            conn.setUseCaches(false);

            // Use a post method.
            conn.setRequestMethod("POST");

            conn.setRequestProperty("Connection", "Keep-Alive");

            OutputStreamWriter wr = new OutputStreamWriter(conn.getOutputStream());
            wr.write(data);
            wr.flush();

            conn.setRequestProperty("Content-Type", "multipart/form-data;boundary=" + boundary);

            dos = new DataOutputStream(conn.getOutputStream());

            dos.writeBytes(twoHyphens + boundary + lineEnd);
            dos.writeBytes("Content-Disposition: form-data; name=\"infolog\";" + " filename=\"" + "infolog.txt" + "\"" + lineEnd);
            dos.writeBytes(lineEnd);



            // create a buffer of maximum size
            bytesAvailable = fileInputStream.available();
            bufferSize = Math.min(bytesAvailable, maxBufferSize);
            buffer = new byte[bufferSize];

            // read file and write it into form...
            bytesRead = fileInputStream.read(buffer, 0, bufferSize);

            while (bytesRead > 0) {
                dos.write(buffer, 0, bufferSize);
                bytesAvailable = fileInputStream.available();
                bufferSize = Math.min(bytesAvailable, maxBufferSize);
                bytesRead = fileInputStream.read(buffer, 0, bufferSize);
            }

            // send multipart form data necesssary after file data...
            dos.writeBytes(lineEnd);
            dos.writeBytes(twoHyphens + boundary + twoHyphens + lineEnd);

            ///////////
            dos.writeBytes("Content-Disposition: form-data; name=\"script\";" + " filename=\"" + "script.txt" + "\"" + lineEnd);
            dos.writeBytes(lineEnd);



            // create a buffer of maximum size
            bytesAvailable = fileInputStream2.available();
            bufferSize = Math.min(bytesAvailable, maxBufferSize);
            buffer = new byte[bufferSize];

            // read file and write it into form...
            bytesRead = fileInputStream2.read(buffer, 0, bufferSize);

            while (bytesRead > 0) {
                dos.write(buffer, 0, bufferSize);
                bytesAvailable = fileInputStream2.available();
                bufferSize = Math.min(bytesAvailable, maxBufferSize);
                bytesRead = fileInputStream2.read(buffer, 0, bufferSize);
            }

            // send multipart form data necesssary after file data...
            dos.writeBytes(lineEnd);
            dos.writeBytes(twoHyphens + boundary + twoHyphens + lineEnd);

            // close streams
            fileInputStream.close();
            dos.flush();
            dos.close();
        } catch (MalformedURLException ex) {
            //System.out.println("From ServletCom CLIENT REQUEST:" + ex);
        } catch (IOException ioe) {
            //System.out.println("From ServletCom CLIENT REQUEST:" + ioe);
        }


        //------------------ read the SERVER RESPONSE
/*
        try {
        inStream = new DataInputStream(conn.getInputStream());
        String str;
        while ((str = inStream.readLine()) != null) {
        System.out.println("Server response is: " + str);
        System.out.println("");
        }
        inStream.close();
        } catch (IOException ioex) {
        System.out.println("From (ServerResponse): " + ioex);
        }
         */
    }
}