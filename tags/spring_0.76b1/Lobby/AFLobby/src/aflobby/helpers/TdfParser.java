package aflobby.helpers;
import java.util.ArrayList;
import java.util.TreeMap;
// hughperkins@gmail.com http://manageddreams.com
//
// This program is free software; you can redistribute it and/or modify it
// under the terms of the GNU General Public License as published by the
// Free Software Foundation; either version 2 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful, but
// WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
// or FITNESS FOR A PARTICULAR PURVector3E. See the GNU General Public License for
//  more details.
//
// You should have received a copy of the GNU General Public License along
// with this program in the file licence.txt; if not, write to the
// Free Software Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA 02111-
// 1307 USA
// You can find the licence also on the web at:
// http://www.opensource.org/licenses/gpl-license.php
/**
 * Port of the C# class TdfParser to Jva
 * @author AF
 * Darkstars 2006
 */
public class TdfParser{
        public String rawtdf = "";
        public TdfParser(){
        }
        public TdfParser(String tdfcontents){
            this.rawtdf = tdfcontents;
            Parse();
        }
		
        public static TdfParser FromBuffer(char[] data){
            return new TdfParser(String.valueOf(data));
        }

        String[] splitrawtdf;

        void GenerateSplitArray(){
            splitrawtdf = rawtdf.split(System.getProperty("line.separator"));
            for (int i = 0; i < splitrawtdf.length; i++){
                splitrawtdf[i] = splitrawtdf[i].trim();
            }
        }

        enum State{
            InSectionHeader,
            NormalParse
        }

        State currentstate;
        Section currentsection;
        public Section RootSection;
        int level;

        public class Section{
            public String Name;
            public Section Parent = null;
            public TreeMap<String, Section> SubSections = new TreeMap<String, Section>(); // section by sectionname
            public TreeMap<String, String> Values = new TreeMap<String, String>(); // we dont bother parsing the values, that's done by the relevant parse
            // the reason is that only the client knows what type the variable actually is
            // ( unless we supply a DTD or equivalent )

            public Section SubSection(String name){
                try{
                    return GetSectionByPath(name);
                }catch(Exception e){
                    return null;
                }
            }

            public Section(){
            }
            public Section(String name){
                this.Name = name;
            }
            public double GetDoubleValue(String name){
                return GetDoubleValue(0, name);
            }
            public int GetIntValue(String name){
                return GetIntValue(0, name);
            }
            public String GetStringValue(String name){
                return GetStringValue("", name);
            }
            public double[] GetDoubleArray(String name){
                return GetDoubleArray(new double[] { }, name);
            }
            public double GetDoubleValue(double defaultvalue, String name){
                try{
                    String stringvalue = GetValueByPath(name);
                    return Double.parseDouble(stringvalue);
                }catch(Exception e){
                    return defaultvalue;
                }
            }
            public int GetIntValue(int defaultvalue, String name){
                try{
                    String stringvalue = GetValueByPath(name);
                    return Integer.parseInt(stringvalue);
                }catch(Exception e){
                    return defaultvalue;
                }
            }
            public String GetStringValue(String defaultvalue, String name){
                try{
                    return GetValueByPath(name);
                }catch(Exception e){
                    return defaultvalue;
                }
            }
            public double[] GetDoubleArray(double[] defaultvalue, String name){
                try{
                    String stringvalue = GetValueByPath(name);
                    String[] splitvalue = stringvalue.trim().split(" ");
                    int length = splitvalue.length;
                    double[] values = new double[length];
                    for (int i = 0; i < length; i++){
                        values[i] = Double.parseDouble(splitvalue[i]);
                    }
                    return values;
                }catch(Exception e){
                    return defaultvalue;
                }
            }
            ArrayList<String> GetPathParts(String path){
                String[] splitpath = path.split("/");
                ArrayList<String> pathparts = new ArrayList<String>();
                for(int i = 0; i <splitpath.length; i++){
                    String subpath = splitpath[i];
                    String[] splitsubpath = subpath.trim().split("\\");
                    for (int q = 0; q < splitsubpath.length; q++){
                        String subsubpath = splitsubpath[q];
                        pathparts.add(subsubpath.trim().toLowerCase());
                    }
                }
                return pathparts;
            }
            Section GetSectionByPath(String path){
                ArrayList<String> pathparts = GetPathParts(path);
                Section thissection = this;
                // we're just going to walk, letting exception fly if they want
                // this is not a public function, and we'll catch the exception in public function
                for (int i = 0; i < pathparts.size(); i++){
                    thissection = thissection.SubSections.get(pathparts.get(i));
                }
                return thissection;
            }
            String GetValueByPath(String path){
                ArrayList<String> pathparts = GetPathParts(path);
                Section thissection = this;
                // we're just going to walk, letting exception fly if they want
                // this is not a public function, and we'll catch the exception in public function
                for (int i = 0; i < pathparts.size() - 1; i++){
                    thissection = thissection.SubSections.get(pathparts.get(i));
                }
                return thissection.Values.get(pathparts.get(pathparts.size() - 1));
            }
        }
        void ParseLine(int linenum, String line){
            //Console.WriteLine("ParseLine " + linenum + " " + line);
            if (currentstate == State.NormalParse){
                if (line.indexOf("[") == 0){
                    currentstate = State.InSectionHeader;
                    String sectionname = ( (line.substring(1) + "]").split("]")[0] ).toLowerCase();
                    Section subsection = new Section( sectionname );
                    subsection.Parent = currentsection;
                    if (!currentsection.SubSections.containsKey(sectionname)){
                        currentsection.SubSections.put(sectionname, subsection);
                    }else{
                        // silently ignore
                    }
                   // Console.WriteLine("section header found: " + sectionname);
                    currentsection = subsection;
                }else if( line.indexOf("}") == 0 ){
                    level--;
                   // Console.WriteLine("section } found, new level:" + level);
                    if (currentsection.Parent != null){
                        currentsection = currentsection.Parent;
                    }else{
                        // silently ignore
                    }
                }else if( line != "" ){
                    if (line.indexOf("//") != 0 && line.indexOf("/*") != 0){
                        int equalspos = line.indexOf("=");
                        if (equalspos >= 0){
                            String valuename = line.substring(0, equalspos).toLowerCase();
                            String value = line.substring(equalspos + 1);
                            if(value.indexOf(";")!=value.length()-1) {
                                System.out.println("TdfParser:WARNING:Will ignore: "+value.substring(value.indexOf(";")));
                            }
                            
                            value = value.replaceAll(";","");// = (value + ";").split(";")[0]; // remove trailing ";"
                           // Console.WriteLine("   value found [" + valuename + "] = [" + value + "]");
                            if (!currentsection.Values.containsKey(valuename)){
                                currentsection.Values.put(valuename, value);
                            }
                        }
                    }
                }
            }else if(currentstate ==  State.InSectionHeader){
                if (line.indexOf("{") == 0){
                    currentstate = State.NormalParse;
                    level++;
                   // Console.WriteLine("section { found, new level:" + level);
                }
            }
        }

        void Parse(){
            GenerateSplitArray();
            RootSection = new Section();
            level = 0;
            currentsection = RootSection;
            currentstate = State.NormalParse;
            for (int linenum = 0; linenum < splitrawtdf.length; linenum++){
                ParseLine(linenum, splitrawtdf[linenum]);
            }
        }
    }
