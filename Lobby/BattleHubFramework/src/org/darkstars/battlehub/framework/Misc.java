package org.darkstars.battlehub.framework;

/*
 * Misc.java
 *
 * Created on 27 May 2006, 21:09
 *
 * To change this template, choose Tools | Template Manager
 * and open the template in the editor.
 */
/**
 *
 * @author AF
 */
import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.InetAddress;
import java.net.MalformedURLException;
import java.net.NetworkInterface;
import java.net.URISyntaxException;
import java.net.URL;
import java.net.UnknownHostException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Enumeration;
import java.util.logging.Level;
import java.util.logging.Logger;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public class Misc {

    public static final byte EOL = 13;
    private static String hex = "0123456789ABCDEF";

    public static String getOrdinalFor(int value) {
        int hundredRemainder = value % 100;
        int tenRemainder = value % 10;
        if (hundredRemainder - tenRemainder == 10) {
            return "th";
        }

        switch (tenRemainder) {
            case 1:
                return "st";
            case 2:
                return "nd";
            case 3:
                return "rd";
            default:
                return "th";
        }
    }

    public static String chat_string_create_urls(String input) {

        String regex = "\\b" +
                "(" +
                "    (www\\.)" +
                "    |" +
                "    (" +
                "        (ftps?)" +
                "        |" +
                "        (file)" +
                "        |" +
                "        (svn)" +
                "        |" +
                "        (git)" +
                "        |" +
                "        (ssh)" +
                "        |" +
                "        (https?)" +
                "    )://" +
                ")" +
                "([a-zA-Z0-9_\\-\\?=~&\\+\\./%\\#]+)";
        
//        regex += "{";
//        regex += "  \\\\b" ;
        // Match the leading part (proto://hostname, or just hostname)
//        regex += "  (" ;
        // http://, or https:// leading part
//        regex += "    (https?)://[-\\w]+(\\.\\w[-\\w]*)+" ;
//        regex += "  |" ;
        // or, try to find a hostname with more specific sub-expression
//        regex += "    (?i: [a-z0-9] (?:[-a-z0-9]*[a-z0-9])? \\\\. )+ ";// sub domains
        // Now ending .com, etc. For these, require lowercase
//        regex += "    (?-i: com\\b" ;
//        regex += "        | edu\\b" ;
//        regex += "        | biz\\b" ;
//        regex += "        | gov\\b" ;
//        regex += "        | in(?:t|fo)\\\\b ";// .int or .info
//        regex += "        | mil\\b" ;
//        regex += "        | net\\b" ;
//        regex += "        | org\\b" ;
//        regex += "        | [a-z][a-z]\\\\.[a-z][a-z]\\\\b ";// two-letter country code
        //regex += "    )" ;
        //regex += "  )" ;
        // Allow an optional port number
        //regex += "  ( : \\\\d+ )?" ;
        // The rest of the URL is optional, and begins with / 
        //regex += "  (" ;
        //regex += "    /" ;
        // The rest are heuristics for what seems to work well
        //regex += "    [^.!,?;\"\\\\'<>()\\[\\]\\{\\}\\s\\x7F-\\\\xFF]*" ;
        //regex += "    (" ;
        //regex += "      [.!,?]+ [^.!,?;”\\\\’<>()\\\\[\\\\]\\{\\\\}\\s\\\\x7F-\\\\xFF]+" ;
        //regex += "    )*" ;
        //regex += "  )?" ;
        //regex += "}";//ix
        //String strRegex = "(@)?(href=\")?(http://)?[A-Za-z]+(\\.\\w+)+(/[&\\n=?\\+\\%/\\.\\w]+)?";
//                "^(https?://)"
//        + "?(([0-9a-z_!~*'().&=+$%-]+: )?[0-9a-z_!~*'().&=+$%-]+@)?" //user@
//        + "(([0-9]{1,3}\\.){3}[0-9]{1,3}" // IP- 199.194.52.184
//        + "|" // allows either IP or domain
//        + "([0-9a-z_!~*'()-]+\\.)*" // tertiary domain(s)- www.
//        + "([0-9a-z][0-9a-z-]{0,61})?[0-9a-z]\\." // second level domain
//        + "[a-z]{2,6})" // first level domain- .com or .museum
//        + "(:[0-9]{1,4})?" // port number- :80
//        + "((/?)|" // a slash isn't required if there is no file name<a href=></a>
//        + "(/[0-9a-z_!~*'().;?:@&=+$,%#-]+)+/?)$";

        Pattern re = Pattern.compile(regex, Pattern.CASE_INSENSITIVE | Pattern.COMMENTS);
        Matcher m = re.matcher(input);
        String result = m.replaceAll("<a href=\\\"$0\\\">$0</a>");
        //result = Misc.toHTML(result);
        return result;

    //"(http:|ftp:|teamspeak:|https:|ftps:|file|www\\.|ftp\\.|://)[a-z0-9/~_:#?&=\\.-]*[a-z0-9/]" jjjjjjjjjj
//return input.replaceAll ("[^\"]((http:|ftp:|teamspeak:|https:|ftps:|file|www\\.|ftp\\.|://)[a-z0-9/~_:#?&=\\.-]*[a-z0-9/])[^\"]","<a href=\"$1\">$1</a>").replaceAll ("href=\"www.","href=\"http://www.");
//        String t = input; //
//        t.replaceAll("((http:|ftp:|teamspeak:|https:|ftps:|file:|www|ftp\\.|://)[a-zA-Z0-9%/~_:;#?&=\\.-]*[a-zA-Z0-9%/])", ">$0");
//        t = t.replaceAll("(>[^<]*?)((http:|ftp:|teamspeak:|https:|ftps:|file|www|ftp\\.|://)[a-zA-Z0-9%/~_:#;?&=\\.-]*[a-zA-Z0-9%/])", "$1<a href=\"$2\">$2</a>"); //replaceAll ("href=\"www.","href=\"http://www.");
//        t = t.replaceAll("=\">", "=\"");
//        t = t.replaceAll("=\"www.", "=\"http://www.");
//        //t = t.substring (1);
//        //t = t.replaceAll ("([^<;])((ftp|http|https|gopher|mailto|news|nntp|telnet|wais|file|prospero|aim|webcal):[A-Za-z0-9/](([A-Za-z0-9$_.+!*(),;/?:@&~=-])|%[A-Fa-f0-9]{2})+(#([a-zA-Z0-9][a-zA-Z0-9$_.+!*(),;/?:@&~=%-]*))?)[^>]","<a href=\"$0\">$0</a>");
//        return t;
    } //

    public static String easyDateFormat(String format) {
        Date today = new Date();
        SimpleDateFormat formatter = new SimpleDateFormat(format);
        return formatter.format(today);
    }

    public static String easyDateFormat(long date, String format) {
        Date d = new Date(date);
        SimpleDateFormat formatter = new SimpleDateFormat(format);
        return formatter.format(d);
    }

    /**
     * puts together strings from sl, starting at sl[startIndex]
     * @param sl 
     * @param startIndex 
     * @return 
     */
    public static String makeSentence(String[] sl, int startIndex) {
        if (startIndex > sl.length - 1) {
            return "";
        }
        String res = new String(sl[startIndex]);
        for (int i = startIndex + 1; i < sl.length; i++) {
            res = res.concat(" " + sl[i]);
        }
        return res;
    }

    /**
     * Strips html of all tags allowing it to be shown without any formatting
     *
     * Specifically, it will take out all instances of < > and & replacing them with their html characters
     * @param s 
     * @return 
     */
    public static String toHTML(String s) {
        String s1 = "";
        char c;
        for (int i = 0; i < s.length(); i++) {
            c = s.charAt(i);
            if (c == '<' || c == '>' || c == '&') {
                s1 += "&#" + (byte) c + ";";
            } else {
                s1 += "" + c;
            }
        }
        return s1;
    }

    /* returns false if char is not an allowed character in the name of a channel, nickname, username, ... */
    public static boolean isValidChar(char c) {
        if (((c >= 48) && (c <= 57)) || ((c >= 65) && (c <= 90)) || ((c >= 97) && (c <= 122)) || (c == 95) || (c == 91) || (c == 93)) {
            return true;
        } else {
            return false;
        }
    }

    /* returns false if name (of a channel, nickname, username, ...) is invalid */
    public static boolean isValidName(String name) {
        for (int i = 0; i < name.length(); i++) {
            if (!isValidChar(name.charAt(i))) {
                return false;
            }
        }
        return true;
    }

    public static boolean isValidPass(String pass) {
        if (pass.length() < 2) {
            return false;
        }
        if (pass.length() > 30) {
            return false; // md5-base64 encoded passwords require 24 chars
        }
        // we have to allow a bit wider range of possible chars as base64 can produce chars such as +, = and /
        for (int i = 0; i < pass.length(); i++) {
            if ((pass.charAt(i) < 43) || (pass.charAt(i) > 122)) {
                return false;
            }
        }
        return true;
    }

    public static String boolToStr(boolean b) {
        if (b) {
            return "1";
        } else {
            return "0";
        }
    }

    public static boolean strToBool(String s) {
        if (s.equals("1")) {
            return true;
        } else {
            return false;
        }
    }

    public static char[] byteToHex(byte b) {
        char[] res = new char[2];
        res[0] = hex.charAt((b & 0xF0) >> 4);
        res[1] = hex.charAt(b & 0x0F);
        return res;
    }

    /* this method will return local IP address such as "192.168.1.100" instead of "127.0.0.1".
     * Found it here: http://forum.java.sun.com/thread.jspa?threadID=619056&messageID=3477258
     *  */
    public static String getLocalIPAddress() {
        try {
            Enumeration e = NetworkInterface.getNetworkInterfaces();

            while (e.hasMoreElements()) {
                NetworkInterface netface = (NetworkInterface) e.nextElement();
                Enumeration e2 = netface.getInetAddresses();

                while (e2.hasMoreElements()) {
                    InetAddress ip = (InetAddress) e2.nextElement();
                    if (!ip.isLoopbackAddress() && ip.getHostAddress().indexOf(":") == -1) {
                        return ip.getHostAddress();
                    }
                }
            }
        } catch (Exception e) {
            return null;
        }
        return null;
    }

    public static long IP2Long(String IP) {
        long f1;
        long f2;
        long f3;
        long f4;
        String[] tokens = IP.split("\\.");
        if (tokens.length != 4) {
            return -1;
        }
        try {
            f1 = Long.parseLong(tokens[0]) << 24;
            f2 = Long.parseLong(tokens[1]) << 16;
            f3 = Long.parseLong(tokens[2]) << 8;
            f4 = Long.parseLong(tokens[3]);
            return f1 + f2 + f3 + f4;
        } catch (Exception e) {
            return -1;
        }
    }

    /* converts time (in milliseconds) to "<x> days, <y> hours and <z> minutes" string */
    public static String timeToDHM(long duration) {
        long temp = duration / (1000 * 60 * 60 * 24);
        String res = temp + " days, ";
        duration -= temp * (1000 * 60 * 60 * 24);
        temp = duration / (1000 * 60 * 60);
        res += temp + " hours and ";
        duration -= temp * (1000 * 60 * 60);
        temp = duration / (1000 * 60);
        res += temp + " minutes";
        return res;
    }

    /*
     * copied from: http://www.source-code.biz/snippets/java/3.htm
     *
     * Reallocates an array with a new size, and copies the contents
     * of the old array to the new array.
     * @param oldArray  the old array, to be reallocated.
     * @param newSize   the new array size.
     * @return          A new array with the same contents.
     */
    public static Object resizeArray(Object oldArray, int newSize) {
        int oldSize = java.lang.reflect.Array.getLength(oldArray);
        Class elementType = oldArray.getClass().getComponentType();
        Object newArray = java.lang.reflect.Array.newInstance(elementType, newSize);
        int preserveLength = Math.min(oldSize, newSize);
        if (preserveLength > 0) {
            System.arraycopy(oldArray, 0, newArray, 0, preserveLength);
        }
        return newArray;
    }

    public static String getHashText(String plainText, String algorithm) throws NoSuchAlgorithmException {
        MessageDigest mdAlgorithm = MessageDigest.getInstance(algorithm);

        mdAlgorithm.update(plainText.getBytes());

        byte[] digest = mdAlgorithm.digest();
        StringBuffer hexString = new StringBuffer();

        for (int i = 0; i < digest.length; i++) {
            plainText = Integer.toHexString(0xFF & digest[i]);

            if (plainText.length() < 2) {
                plainText = "0" + plainText;
            }

            hexString.append(plainText);
        }

        return hexString.toString();
    }

    public static byte[] getMD5(String plainText) throws NoSuchAlgorithmException {
        MessageDigest mdAlgorithm = MessageDigest.getInstance("md5");

        mdAlgorithm.update(plainText.getBytes());

        byte[] digest = mdAlgorithm.digest();
        return digest;
    }

    public static String getURLContent(String url, String defvalue) {
        try {
            String q = "";
            URL yahoo = new URL(url);
            BufferedReader in;
            in = new BufferedReader(new InputStreamReader(yahoo.openStream()));

            String inputLine;

            while ((inputLine = in.readLine()) != null) {
                q += inputLine + "\n";
            }
            in.close();
            return q;
        } catch (MalformedURLException ex) {
            ex.printStackTrace();
            return defvalue;
        } catch (UnknownHostException e) {
            return defvalue;
        } catch (IOException ex) {
            ex.printStackTrace();
            return defvalue;
        }
    }

    // this method encodes plain-text password to md5 hashed one in base-64 form:
    public static String encodePassword(String plainPassword) {
        //return getURLContent("http://michielvdb.byethost7.com/lobbypass.php?pass="+plainPassword,plainPassword);
        try {
            return new String(CBase64Coder.encode(getMD5(plainPassword))); //new sun.misc.BASE64Encoder().encode
        } catch (Exception e) {
            // this should not happen!
            System.out.println("WARNING: Serious error occured: " + e.getMessage());
            //TASServer.closeServerAndExit();
            return plainPassword;
        }
    }

    /* this method is thread-safe (or at least it is if not called from multiple threads with same Exception object)
     * and must remain such since multiple threads may call it. */
    public static String exceptionToFullString(Exception e) {
        String res = e.toString();

        StackTraceElement[] trace = e.getStackTrace();
        for (int i = 0; i < trace.length; i++) {
            res += "\r\n\tat " + trace[i];
        }
        return res;
    }

    /* various methods dealing with battleStatus: */
    public static int getReadyStatusFromBattleStatus(int battleStatus) {
        return (battleStatus & 0x2) >> 1;
    }

    /*public static int getSpectatorFromBattleStatus(int battleStatus) {
    //return (battleStatus & 0x2) >> 1;
    return battleStatus & (1 << 5)
    }*/
    //
    public static int getTeamNoFromBattleStatus(int battleStatus) {
        return (battleStatus & 0x3C) >> 2;
    }

    public static int getAllyNoFromBattleStatus(int battleStatus) {
        return (battleStatus & 0x3C0) >> 6;
    }

    public static int getModeFromBattleStatus(int battleStatus) {
        return (battleStatus & 0x400) >> 10;
    }

    public static int getHandicapFromBattleStatus(int battleStatus) {
        return (battleStatus & 0x3F800) >> 11;
    }

    public static int getTeamColorFromBattleStatus(int battleStatus) {
        return (battleStatus & 0x3C0000) >> 18;
    }

    public static int getSyncFromBattleStatus(int battleStatus) {
        return (battleStatus & 0xC00000) >> 22;
    }

    public static int getSideFromBattleStatus(int battleStatus) {
        return (battleStatus & 0xF000000) >> 24;
    }

    public static int setReadyStatusOfBattleStatus(int battleStatus, int ready) {
        return (battleStatus & 0xFFFFFFFD) | (ready << 1);
    }

    public static int setTeamNoOfBattleStatus(int battleStatus, int team) {
        return (battleStatus & 0xFFFFFFC3) | (team << 2);
    }

    public static int setAllyNoOfBattleStatus(int battleStatus, int ally) {
        return (battleStatus & 0xFFFFFC3F) | (ally << 6);
    }

    public static int setModeOfBattleStatus(int battleStatus, int mode) {
        return (battleStatus & 0xFFFFFBFF) | (mode << 10);
    }

    public static int setHandicapOfBattleStatus(int battleStatus, int handicap) {
        return (battleStatus & 0xFFFC07FF) | (handicap << 11);
    }

    public static int setTeamColorOfBattleStatus(int battleStatus, int color) {
        return (battleStatus & 0xFFC3FFFF) | (color << 18);
    }

    public static int setSyncOfBattleStatus(int battleStatus, int sync) {
        return (battleStatus & 0xFF3FFFFF) | (sync << 22);
    }

    public static int setSideOfBattleStatus(int battleStatus, int side) {
        return (battleStatus & 0xF0FFFFFF) | (side << 24);
    }

    /* various methods dealing with status: */
    public static int getInGameFromStatus(int status) {
        return status & 0x1;
    }

    public static int getAwayBitFromStatus(int status) {
        return (status & 0x2) >> 1;
    }

    public static int getRankFromStatus(int status) {
        return (status & 0x1C) >> 2;
    }

    public static int getAccessFromStatus(int status) {
        return (status & 0x20) >> 5;
    }

    public static boolean getBotModeFromStatus(int status) {
        return ((status & 0x40) >> 6) == 1;
    }

    public static int setInGameToStatus(int status, int inGame) {
        return (status & 0xFFFFFFFE) | inGame;
    }

    public static int setAwayBitToStatus(int status, int away) {
        return (status & 0xFFFFFFFD) | (away << 1);
    }

    public static int setRankToStatus(int status, int rank) {
        return (status & 0xFFFFFFE3) | (rank << 2);
    }

    public static int setAccessToStatus(int status, int access) {
        if ((access < 0) || (access > 1)) {
            //System.out.println("Critical error: Invalid use of setAccessToStatus()! Shuting down the server ...");
            //TASServer.closeServerAndExit();
        }
        return (status & 0xFFFFFFDF) | (access << 5);
    }

    public static boolean isWindows() {
        String osName = System.getProperty("os.name");
        return osName.startsWith("Windows");
    }

    // "Linux
    public static boolean isMacOSX() {
        // http://developer.apple.com/technotes/tn2002/tn2110.html
        String lcOSName = System.getProperty("os.name").toLowerCase();
        return lcOSName.startsWith("mac os x");
    }

    public static boolean isMacOS() {
        // http://developer.apple.com/technotes/tn2002/tn2110.html
        return System.getProperty("os.name").toLowerCase().startsWith("mac os");
    }

    public static boolean isLinux() {
        // http://developer.apple.com/technotes/tn2002/tn2110.html
        String lcOSName = System.getProperty("os.name").toLowerCase();
        return lcOSName.startsWith("linux");
    }

    public static boolean isSolaris() {
        // http://developer.apple.com/technotes/tn2002/tn2110.html
        String lcOSName = System.getProperty("os.name").toLowerCase();
        return lcOSName.startsWith("SunOS");
    }

    public static boolean isJava6() {
        // http://developer.apple.com/technotes/tn2002/tn2110.html
        String javaVersion = System.getProperty("java.version");
        return javaVersion.startsWith("1.6");
    }

    public static boolean isJava5() {
        // http://developer.apple.com/technotes/tn2002/tn2110.html
        String javaVersion = System.getProperty("java.version");
        return javaVersion.startsWith("1.5");
    }
    public static boolean dev_environment = false;

    

    public static String GetMinimapPath(ICentralClass c) {
        //
        return c.GetAbsoluteLobbyFolderPath() + "minimaps/";
    //return "";
    }

    public static int bitStringToInt(String bitString) {
        int intValue = 0;
        for (int i = 1; i <= bitString.length(); i++) {
            int currBit = Integer.parseInt(bitString.substring(i - 1, i));
            intValue += currBit * Math.pow(2d, (double) (i - 1));
        }

        return intValue;
    }

    public static String formatDoubleStrToLength(String toFormat, int length) {
        if (toFormat.length() > length) {
            toFormat = toFormat.substring(0, length);
        }

        if (toFormat.length() < length) {
            String zeros = "";

            for (int i = 0; i < length - toFormat.length(); i++) {
                zeros += "0";
            }

            toFormat += zeros;
        }

        return toFormat;
    }
}