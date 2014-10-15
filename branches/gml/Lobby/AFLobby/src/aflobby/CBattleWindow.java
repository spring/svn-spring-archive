/*
 * CBattleWindow.java
 *
 * Created on 05 June 2006, 23:05
 */

package aflobby;

import aflobby.helpers.CHolePuncher;
import aflobby.framework.CEvent;
import aflobby.IGUIBattleModel;
import aflobby.protocol.tasserver.RectHandler;
import aflobby.protocol.tasserver.RectEntry;
import aflobby.UI.CUISettings;
import aflobby.UI.CUserSettings;
import aflobby.UI.battle.CBooleanOptionsPanel;
import aflobby.UI.battle.CListOptionsPanel;
import aflobby.UI.battle.CSliderOptionsPanel;
import aflobby.UI.battle.CStringOptionsPanel;
import aflobby.UI.battle.ListItem;
import aflobby.protocol.tasserver.TeamEntry;
import aflobby.protocol.tasserver.TeamData;
import aflobby.helpers.AlphanumComparator;
import aflobby.framework.IModule;
import java.awt.Color;
import java.awt.Component;
import java.awt.Graphics2D;
import java.awt.Image;
import java.awt.event.KeyEvent;
import java.awt.image.BufferedImage;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Timer;
import java.util.TimerTask;
import java.util.TreeMap;
import java.util.concurrent.ExecutionException;
import javax.swing.ImageIcon;
import javax.swing.SwingUtilities;
import javax.swing.SwingWorker;

/**
 *
 * @author  AF
 */
class CBattleTask extends TimerTask {

    public CBattleWindow c;

    CBattleTask(CBattleWindow jc) {
        c = jc;
    }

    public void run() {
        if (c.UpdateClientsNeeded) {
            c.UpdateClientsNeeded = false;
            c.DoUpdateBattleClients();
        }
    }
}

public class CBattleWindow extends javax.swing.JFrame implements IModule {

    public IGUIBattleModel battlemodel = null;
    public LMain LM;
    public java.awt.Point origin = new java.awt.Point();
    public CBattleInfo info;
    public Integer CurrentID = null;
    public String lastsent = java.util.ResourceBundle.getBundle("aflobby/languages").getString("n/a");

    public int MyUDPPort = -1;
    public boolean UpdateClientsNeeded = false;
    public boolean active = false;
    CBattleTask jbt;
    public Timer tjb;
    public Process p;
    public boolean ingame = false;
    CBattleCommandHandler cmdhandler = null;
    //Vector<String> disabledUnits = new Vector<String>();
    CVectorListModel RestrictedUnits = new CVectorListModel();
    public CStartRectangleDrawer startrect;
    
    
    CBattlePlayerTableModel playertablemodel = null;

    /**
     * Creates new form CBattleWindow
     * @param L
     */
    public CBattleWindow(LMain L) {
        
        LM = L;
        
        
        playertablemodel = new CBattlePlayerTableModel(LM);
        
        
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                initComponents();
                Chat.LM = LM;
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
        
        
        jbt = new CBattleTask(this);
        tjb = new Timer();
        
        
        
        cmdhandler = new CBattleCommandHandler(LM, this, LM.command_handler);
        //jas = new JAutoDownScroll (BattleMessages);
        //jast = new Timer ();
        Runnable doWorkRunnable2 = new Runnable() {

            public void run() {

                playerBattleTable.getColumnModel().getColumn(0).setMaxWidth(50);
                playerBattleTable.getColumnModel().getColumn(1).setMaxWidth(50);
                playerBattleTable.getColumnModel().getColumn(2).setMaxWidth(50);
                playerBattleTable.getColumnModel().getColumn(4).setMaxWidth(30);
                playerBattleTable.getColumnModel().getColumn(5).setMaxWidth(50);
                playerBattleTable.getColumnModel().getColumn(6).setMaxWidth(60);
                playerBattleTable.getColumnModel().getColumn(7).setMaxWidth(30);
                playerBattleTable.getColumnModel().getColumn(8).setMaxWidth(30);
                playerBattleTable.getColumnModel().getColumn(9).setMaxWidth(30);
                playerBattleTable.getColumnModel().getColumn(10).setMaxWidth(40);
                    
                setLocationRelativeTo(null); // center the window on the screen
                requestFocusInWindow();
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable2);

        //this.ColourWheel.getSelectionModel().addChangeListener(this);
    }

    public void Init() {
    }

    public void SetBattleTitle(final String s) {
        //
        Runnable doWorkRunnable = new Runnable() {
            public void run() {
                setTitle(s);
            }
        };
        
        SwingUtilities.invokeLater(doWorkRunnable);
    }
    
    /**
     * 
     * @param player 
     */
    public void AddPlayer(CBattlePlayer player){
        //
        playertablemodel.AddPlayer(player);
        
        Redraw();
        String flag = " ";

        if(Boolean.valueOf(CUserSettings.GetValue("ui.channelview.userjoinflags", "false"))){
            flag=player.getPlayerdata().GetFlagHTML();
        }

        if(Boolean.valueOf(CUserSettings.GetValue("ui.channelview.userjoinranks", "false"))){
            flag+=player.getPlayerdata().GetRankHTML();
        }
        
        String name = player.getPlayername();
        String msg = java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.joined_the_battle");
        AddMessage("<font face=\"Arial, Helvetica, sans-serif\" size=\"3\"><b>" + flag + name + " " + msg);
    }
    
    public void RemovePlayer(CBattlePlayer p){
        //
        playertablemodel.RemovePlayer(p);
        AddMessage("<font face=\"Arial, Helvetica, sans-serif\" size=\"3\"><b>" + p.getPlayername() + java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.left_the_battle"));
    }
    
    public void JoinBattle(CBattleInfo jinfo) {
        battlemodel = (IGUIBattleModel) LM.battleModel;
        
        active = true;
        info = jinfo;
        
        final CBooleanOptionsPanel b = new CBooleanOptionsPanel(
                battlemodel,
                "GAME/DiminishingMMs",
                false,
                "Diminishing metal maker returns",
                " As you build more" +
                " metalmakers, their metal output drops. Metal maker" +
                " efficiency drops over time as a result as more " +
                "metalmakers are built.",
                false
                );
        final CBooleanOptionsPanel b2 = new CBooleanOptionsPanel(
                battlemodel,
                "GAME/LimitDGun",
                false,
                "Limited Dgun range",
                "Limits the dgunning to within a certain radius around your" +
                " starting position to prevent offensive commander pushes.",
                false
                );
        final CBooleanOptionsPanel b3 = new CBooleanOptionsPanel(
                battlemodel,
                "GAME/GhostedBuildings",
                true,
                "Ghosted Buildings",
                "When an enemy building goes out of view, a ghost appears" +
                " showing its location and unit type afterwards.",
                false
                );
        LM.core.AddModule(b);
        LM.core.AddModule(b2);
        LM.core.AddModule(b3);
        
        final CSliderOptionsPanel sp1 = new CSliderOptionsPanel(
                battlemodel,
                "GAME/StartEnergy",
                1000,
                500,
                10000,
                500,
                "Initial Starting Energy",
                "The amount of energy given to your commander at the start of" +
                " the game to build things with.",
                false
                );
        
        final CSliderOptionsPanel sp2 = new CSliderOptionsPanel(
                battlemodel,
                "GAME/StartMetal",
                1000,
                500,
                10000,
                500,
                "Initial Starting Metal",
                "The amount of metal given to your commander at the start of" +
                " the game to build things with.",
                false
                );
        
        final CSliderOptionsPanel sp3 = new CSliderOptionsPanel(
                battlemodel,
                "GAME/MaxUnits",
                1000,
                500,
                10000,
                500,
                "Unit Limit",
                "The maximum number of units that can be built in a single" +
                " game.",
                false
                );
        
        LM.core.AddModule(sp1);
        LM.core.AddModule(sp2);
        LM.core.AddModule(sp3);

        CSync.SetWorkingMod(info.GetMod());
        for (String s : info.GetPlayerNames()) {
            //
            CBattlePlayer pl = new CBattlePlayer();

            pl.setBattlestatus(0);
            pl.setColor(Color.BLUE);
            pl.setPlayerdata(LM.playermanager.GetPlayer(s));
            pl.setPlayername(s);
            if (s.equalsIgnoreCase(LM.protocol.GetUsername())) {
                battlemodel.SetMe(pl);
            }
            battlemodel.GetPlayers().put(s, pl);
            playertablemodel.AddPlayer(pl);
        }
        
        String sk;
        if (Misc.isWindows()) {
            sk = CUnitSyncJNIBindings.SearchVFS("AI/Bot-libs/*.dll");
        } else if (Misc.isMacOS()) {
            sk = CUnitSyncJNIBindings.SearchVFS("AI/Bot-libs/*.dylib");
        } else {
            // if(Misc.isLinux()){
            sk = CUnitSyncJNIBindings.SearchVFS("AI/Bot-libs/*.so");
        }
        //sk = sk;//replaceAll("\\", "");
        //sk = sk.replaceAll("AI/Bot-libs/", "");
        final String[] ailist = sk.split(",");

        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                
                MapList.removeAll();
                Object[] m = CSync.map_names.values().toArray().clone();
                Arrays.sort(m, new AlphanumComparator());
                MapList.setListData(m);
                
                AICombo.removeAllItems();
                for (String s : ailist) {
                    String s2 = s.replaceAll("\\\\", "/");
                    int idx = s2.lastIndexOf("/");
                    if(idx != -1){
                        s2 = s2.substring(idx+1);
                    }
                    AICombo.addItem(s2);//.substring(12));
                }
                RaceCombo.removeAllItems();
                AddAIRaceCombo.removeAllItems();
                EditAIRaceCombo.removeAllItems();
                for (int i = 0; i < CSync.sidecount; i++) {
                    String r = CSync.GetSideName(i);
                    RaceCombo.addItem(r);
                    AddAIRaceCombo.addItem(r);
                    EditAIRaceCombo.addItem(r);
                }
                // do ladder stuff
                if(info.isladdergame()){
                    //
                    SetupLadderControls();
                }
                
                
                OptionsPanel.add(b);
                OptionsPanel.add(b2);
                OptionsPanel.add(b3);
                
                OptionsPanel.add(sp1);
                OptionsPanel.add(sp2);
                OptionsPanel.add(sp3);
                
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
        
        
        /*
        Runnable doWorkRunnable = new Runnable() {
        public void run() {
        for (int i = 0; i < CSync.sidecount; i++) {
        RaceCombo.addItem(CSync.GetSideName(i));
        }
        MapList.removeAll();
        MapList.setListData(CSync.map_names.values().toArray());
        }
        };
        SwingUtilities.invokeLater(doWorkRunnable);*/

        MapChange();

        CurrentID = jinfo.GetID();
        info.SetActive(true);
        SetControls(info);
        SetHostControls(false);
        //SendMyStatus ();//###@
        //(Component) CSync.map_names.get(i));
        Redraw();
    }

    public void SetupLadderControls(){
        CLadderProperties lp = info.getLadderproperties();

        // the ladder onyl supports 2 ally teams so empty th combobox and insert 2 entries
        MyAllyTeamCombo.removeAllItems();
        MyAllyTeamCombo.addItem("Ally Team 1");
        MyAllyTeamCombo.addItem("Ally Team 2");
        /*if(lp.startpos != -1){
            StartPosCombo.setSelectedIndex(lp.startpos);
            StartPosCombo.setEnabled(false);
        }
        if(lp.gamemode != -1){
            GameEndCombo.setSelectedIndex(lp.gamemode);
            GameEndCombo.setEnabled(false);
        }
        int min=1000,max=10000;
        if(lp.maxmetal != -1){
            max = lp.maxmetal;
            StartingMetalSlider.setMaximum(max);
            //StartingMetalSlider.setEnabled(false);
        }
        if(lp.minmetal != -1){
            min = lp.minmetal;
            StartingMetalSlider.setMinimum(min);
            //StartingMetalSlider.setEnabled(false);
        }
        StartingMetalSpinner.setModel(new SpinnerNumberModel(min,min,max,500));

        min = 500;
        max = 10000;
        if(lp.maxenergy != -1){
            max = lp.maxenergy;
            StartingEnergySlider.setMaximum(max);
            //StartingEnergySlider.setEnabled(false);
        }
        if(lp.minenergy != -1){
            min = lp.minenergy;
            StartingEnergySlider.setMinimum(min);
            //StartingEnergySlider.setEnabled(false);
        }
        StartingEnergySpinner.setModel(new SpinnerNumberModel(min,min,max,500));

        min = 50;
        max = 5000;
        if(lp.maxunits != -1){
            max = lp.maxunits;
            MaxUnitsSlider.setMaximum(max);
            //MaxUnitsSlider.setEnabled(false);
        }
        if(lp.minunits != -1){
            min = lp.minunits;
            MaxUnitsSlider.setMinimum(min);
            //MaxUnitsSlider.setEnabled(false);
        }
        MaxUnitsSpinner.setModel(new SpinnerNumberModel(Math.max(min, 500),min,max,500));
*/
        /*if(lp.dgun != -1){
            LimitDGunCheck.setSelected(lp.dgun == 1);
            LimitDGunCheck.setEnabled(false);
        }
        if(lp.diminish != -1){
            DiminMMCheck.setSelected(lp.diminish == 1);
            DiminMMCheck.setEnabled(false);
        }
        if(lp.ghost != -1){
            GhostedCheck.setSelected(lp.ghost == 1);
            GhostedCheck.setEnabled(false);
        }*/
    }
    
    public void LeaveBattle() {
        
        active = false;
        

        RectHandler.clearRects();

        CEvent e = new CEvent(CEvent.EXITEDBATTLE);
        LM.core.NewGUIEvent(e);
        
        if(tjb != null){
            tjb.cancel();
            tjb = null;
        }
        
        if(battlemodel != null){
            battlemodel.Exit();
            battlemodel = null;
        }
        

        Runnable doWorkRunnable = new Runnable() {
            public void run() {
                setVisible(false);
                dispose();
            }
        };
        
        SwingUtilities.invokeLater(doWorkRunnable);
    }


    public void HostGame(CBattleInfo jinfo) {
        battlemodel = (IGUIBattleModel) LM.battleModel;
        active = true;
        info = jinfo;
        final ArrayList<Object> options = new ArrayList<Object>();
        
        final CBooleanOptionsPanel b1 = new CBooleanOptionsPanel(
                battlemodel,
                "GAME/DiminishingMMs",
                false,
                "Diminishing metal maker returns",
                " As you build more" +
                " metalmakers, their metal output drops. Metal maker" +
                " efficiency drops over time as a result as more " +
                "metalmakers are built.",
                false
                );
        final CBooleanOptionsPanel b2 = new CBooleanOptionsPanel(
                battlemodel,
                "GAME/LimitDGun",
                false,
                "Limited Dgun range",
                "Limits the dgunning to within a certain radius around your" +
                " starting position to prevent offensive commander pushes.",
                false
                );
        final CBooleanOptionsPanel b3 = new CBooleanOptionsPanel(
                battlemodel,
                "GAME/GhostedBuildings",
                true,
                "Ghosted Buildings",
                "When an enemy building goes out of view, a ghost appears" +
                " showing its location and unit type afterwards.",
                false
                );
        options.add(b1);
        options.add(b2);
        options.add(b3);
        
        final CSliderOptionsPanel sp1 = new CSliderOptionsPanel(
                battlemodel,
                "GAME/StartEnergy",
                1000,
                500,
                10000,
                500,
                "Initial Starting Energy",
                "The amount of energy given to your commander at the start of" +
                " the game to build things with.",
                false
                );
        
        final CSliderOptionsPanel sp2 = new CSliderOptionsPanel(
                battlemodel,
                "GAME/StartMetal",
                1000,
                500,
                10000,
                500,
                "Initial Starting Metal",
                "The amount of metal given to your commander at the start of" +
                " the game to build things with.",
                false
                );
        
        final CSliderOptionsPanel sp3 = new CSliderOptionsPanel(
                battlemodel,
                "GAME/MaxUnits",
                1000,
                500,
                10000,
                500,
                "Unit Limit",
                "The maximum number of units that can be built in a single" +
                " game.",
                false
                );
        
        options.add(sp1);
        options.add(sp2);
        options.add(sp3);
        
        {
            ArrayList<ListItem> items =
                    new ArrayList<ListItem>();
            
            ListItem y = new ListItem();
            y.key = "0";
            y.name = "Destroy All";
            y.description = "Annihilate all enemy units to win.";
            
            items.add(y);
            
            ListItem y1 = new ListItem();
            y1.key = "1";
            y1.name = "Commander Ends";
            y1.description = "A deathmatch where players kill eachother off by" +
                    " destroying their commanders.. Loosing your commander" +
                    " looses you the game.";
            
            items.add(y1);
            
            ListItem y2 = new ListItem();
            y2.key = "1";
            y2.name = "Lineage";
            y2.description = "Loosing your commander" +
                    " looses you the game. The difference here is that when" +
                    " your stuff dies so does everything you gave to your" +
                    " allies, and anything built with those shared units.";
            
            items.add(y2);
            
            
            final CListOptionsPanel lo = new CListOptionsPanel(
                    battlemodel,
                    "GAME/GameMode",
                    "0",
                    items,
                    "Victory Condition",
                    "Determines how the game is to be won.",
                    false
                    );
            options.add(lo);
        }
        
        {
            ArrayList<ListItem> items =
                    new ArrayList<ListItem>();
            
            ListItem y = new ListItem();
            y.key = "0";
            y.name = "Fixed";
            y.description = "Places players at predefined starting positions" +
                    " based on their ordering.";
            
            items.add(y);
            
            ListItem y1 = new ListItem();
            y1.key = "1";
            y1.name = "Random";
            y1.description = "Randomly places you on a predefined start " +
                    "position.";
            
            items.add(y1);
            
            ListItem y2 = new ListItem();
            y2.key = "2";
            y2.name = "Choose Ingame";
            y2.description = "When ingame you can choose where on the map you" +
                    " want to start by placing markers. This can be confine to" +
                    " a startign rectangle/box";
            
            items.add(y2);
            
            
            final CListOptionsPanel lo = new CListOptionsPanel(
                    battlemodel,
                    "GAME/StartPosType",
                    "0",
                    items,
                    "Starting Positions",
                    "Determines where and how on the map your units start the game.",
                    false
                    );
            options.add(lo);
        }
        

        CSync.SetWorkingMod(info.GetMod());
        
        int modoptioncount = CUnitSyncJNIBindings.GetModOptionCount();
        for(int i = 0; i < modoptioncount; i++){
            int type = CUnitSyncJNIBindings.GetOptionType(i);
            String key = "game/modoptions/"+CUnitSyncJNIBindings.GetOptionKey(i);
            String description = CUnitSyncJNIBindings.GetOptionDesc(i);
            String name = CUnitSyncJNIBindings.GetOptionName(i);
            if(type == OptionType.opt_bool){
                //
                boolean defValue = CUnitSyncJNIBindings.GetOptionBoolDef(i) == 1;
                final CBooleanOptionsPanel o = new CBooleanOptionsPanel(
                    battlemodel,
                    key,
                    defValue,
                    name,
                    description,
                    false);
                options.add(o);
            } else if (type == OptionType.opt_list){
                ArrayList<ListItem> items  = new ArrayList<ListItem>();
                
                int listoptcount = CUnitSyncJNIBindings.GetOptionListCount(i);
                for(int n = 0; n < listoptcount; n++){
                    //
                    ListItem lim = new ListItem();
                    lim.key = CUnitSyncJNIBindings.GetOptionListItemKey(i, n);
                    lim.name = CUnitSyncJNIBindings.GetOptionListItemName(i, n);
                    lim.description = CUnitSyncJNIBindings.GetOptionListItemDesc(i, n);
                    
                    items.add(lim);
                }
                
                String defValue = CUnitSyncJNIBindings.GetOptionListDef(i);
                
                CListOptionsPanel o = new CListOptionsPanel(
                        battlemodel,
                        key,
                        defValue,
                        items,
                        name,
                        description,
                        false
                        );
                
                options.add(o);
                
            } else if (type == OptionType.opt_number){
                //
                int defValue = (int) CUnitSyncJNIBindings.GetOptionNumberDef(i);
                int min = (int) CUnitSyncJNIBindings.GetOptionNumberMin(i);
                int max = (int) CUnitSyncJNIBindings.GetOptionNumberMax(i);
                int step = (int) CUnitSyncJNIBindings.GetOptionNumberMin(i);
                CSliderOptionsPanel o = new CSliderOptionsPanel(
                    battlemodel,
                    key,
                    defValue,
                    min,
                    max,
                    step,
                    name,
                    description,
                    false
                    );
                
                options.add(o);
            } else if (type == OptionType.opt_string){
                //
                String defValue = CUnitSyncJNIBindings.GetOptionStringDef(i);
                int maxlength = CUnitSyncJNIBindings.GetOptionStringMaxLen(i);
                CStringOptionsPanel o = new CStringOptionsPanel(
                        battlemodel,
                        key,
                        defValue,
                        maxlength,
                        name,
                        description,
                        false
                        );
            } else if (type == OptionType.opt_error){
                // bah
            }
        }
        
        for(Object i : options){
            LM.core.AddModule((IModule)i);
        }
        
        String sk;
        
        if (Misc.isWindows()) {
            sk = CUnitSyncJNIBindings.SearchVFS("AI/Bot-libs/*.dll");
        } else if (Misc.isMacOS()) {
            sk = CUnitSyncJNIBindings.SearchVFS("AI/Bot-libs/*.dylib");
        } else {
            // if(Misc.isLinux()){
            sk = CUnitSyncJNIBindings.SearchVFS("AI/Bot-libs/*.so");
        }
        
        final String[] ailist = sk.split(",");

        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                
                AICombo.removeAllItems();
                
                for (String s : ailist) {
                    String s2 = s.replaceAll("\\\\", "/");
                    int idx = s2.lastIndexOf("/");
                    if(idx != -1){
                        s2 = s2.substring(idx+1);
                    }
                    AICombo.addItem(s2);//.substring(12));
                }
                
                RaceCombo.removeAllItems();
                AddAIRaceCombo.removeAllItems();
                EditAIRaceCombo.removeAllItems();
                
                for (int i = 0; i < CSync.sidecount; i++) {
                    String r = CSync.GetSideName(i);
                    RaceCombo.addItem(r);
                    AddAIRaceCombo.addItem(r);
                    EditAIRaceCombo.addItem(r);
                }
                
                // do ladder stuff
                if(info.isladdergame()){
                    //
                    SetupLadderControls();
                }
                
                for(Object i : options){
                    OptionsPanel.add((Component)i);
                }
            }
        };
        
        SwingUtilities.invokeLater(doWorkRunnable);

        battlemodel.GetMe().setColor(Color.BLUE);
        battlemodel.GetMe().setBattlestatus(0);
        battlemodel.GetMe().setSpectator(false);
        battlemodel.GetMe().setPlayername(LM.protocol.GetUsername());
        battlemodel.GetMe().setPlayerdata(LM.playermanager.GetPlayer(LM.protocol.GetUsername()));
        battlemodel.GetPlayers().put(LM.protocol.GetUsername(), battlemodel.GetMe());
        info.SetMap(CUserSettings.GetValue("battle.lastmap", "SmallDivide.smf"));
        
        playertablemodel.AddPlayer(battlemodel.GetMe());
        final CBattleWindow bw = this;
        
        Runnable doWorkRunnable2 = new Runnable() {

            public void run() {
                MapList.removeAll();
                Object[] m = CSync.map_names.values().toArray().clone();
                Arrays.sort(m, new AlphanumComparator());
                MapList.setListData(m);
//                MapList.removeAll();
//                MapList.setListData(CSync.map_names.values().toArray().clone());
                ArrayList<String> a = CSync.GetUnitList();
                //if(a.isEmpty ()==false){
//                    RestrictedUnitsCombo.removeAllItems ();
                for (String s : a) {
                    RestrictedUnitsCombo.addItem(s);
                }
                startrect = new CStartRectangleDrawer(bw);
                GameOptionsPane.add(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.StartingBoxesTabTitle"), startrect);
//                }
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable2);
        
        MapChange();

        CurrentID = jinfo.GetID();
        info.SetActive(true);
        SetControls(info);
        SetHostControls(true);
        battlemodel.CheckSync();
        //SendMyStatus ();
        tjb = new Timer();
        jbt = new CBattleTask(this);
        tjb.schedule(jbt, 1000, 1000); //subsequent rate
        Redraw();
        //
    }

    public void SetHostControls(final boolean host) {
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                setVisible(true);
                SetBattleTitle(info.GetDescription() + "::" + info.GetMod());
                LockToggle.setEnabled(host);
                /*StartingEnergySlider.setEnabled(host);
                StartingEnergySpinner.setEnabled(host);
                StartingMetalSlider.setEnabled(host);
                StartingMetalSpinner.setEnabled(host);
                MaxUnitsSlider.setEnabled(host);
                MaxUnitsSpinner.setEnabled(host);*/
                //StartPosCombo.setEnabled(host);
                //GameEndCombo.setEnabled(host);
                //LimitDGunCheck.setEnabled(host);
                //DiminMMCheck.setEnabled(host);
                //GhostedCheck.setEnabled(host);
                GameStartButton.setEnabled(host);
                UnRestrictAllUnitsButton.setEnabled(host);
                UnRestrictUnitButton.setEnabled(host);
                RestrictUnitButton.setEnabled(host);
                RestrictedUnitsCombo.setEnabled(host);
                HostButtonsPanel.setVisible(host);
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);

        //
    }

    void SetControls(final CBattleInfo i) {
        CBattlePlayer me = battlemodel.GetMe();
        if(me != null){
            me.setTeamNo(1); //mybattlestatus = Misc.setTeamNoOfBattleStatus (mybattlestatus,1);
            me.setSpectator(false); //mybattlestatus = Misc.setModeOfBattleStatus (mybattlestatus,1);
            me.setReady(false); //mybattlestatus = Misc.setReadyStatusOfBattleStatus (mybattlestatus,0);
        }
        /*Runnable doWorkRunnable = new Runnable() {

            public void run() {

                /*StartingEnergySlider.getModel().setValue(info.energy);
                StartingEnergySpinner.getModel().setValue(info.energy);
                StartingMetalSlider.getModel().setValue(info.metal);
                StartingMetalSpinner.getModel().setValue(info.metal);
                MaxUnitsSlider.getModel().setValue(info.maxunits);
                MaxUnitsSpinner.getModel().setValue(info.maxunits);*/
                //StartPosCombo.setSelectedIndex(i.startPos);
                //GameEndCombo.setSelectedIndex(i.gameEndCondition);
                //LimitDGunCheck.setSelected(info.limitDGun);
                //DiminMMCheck.setSelected(info.diminishingMMs);
                //GhostedCheck.setSelected(info.ghostedBuildings);
            /*}
        };
        SwingUtilities.invokeLater(doWorkRunnable);*/
    }

    public int GetSpectatorCount() {
        int c = 0;
        Iterator<CBattlePlayer> i = battlemodel.GetPlayers().values().iterator();
        while (i.hasNext()) {
            CBattlePlayer pl = i.next();
            if (pl.isSpec()) {
                c++;
            }
        }
        return c;
    }

    public void SetTeamColor(Color c) {
        battlemodel.GetMe().setColor(c); //mycolour = c;
    }

    /*public void setStartingMetal(final int m) {
        info.metal = m;
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                StartingMetalSlider.getModel().setValue(m);
                StartingMetalSpinner.getModel().setValue(m);
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }

    public void setStartingEnergy(final int e) {
        info.energy = e;
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                StartingEnergySlider.getModel().setValue(e);
                StartingEnergySpinner.getModel().setValue(e);
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }

    public void setMaxUnits(final int u) {
        info.maxunits = u;
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                MaxUnitsSlider.getModel().setValue(u);
                MaxUnitsSpinner.getModel().setValue(u);
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }*/

    /*public void setStartPosType(final int s) {
        info.startPos = s;
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                StartPosCombo.setSelectedIndex(s);
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }

    public void setGameEnd(final int s) {
        info.gameEndCondition = s;
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                GameEndCombo.setSelectedIndex(s);
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }

    public void setLimitDGUN(final boolean b) {
        info.limitDGun = b;
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                LimitDGunCheck.getModel().setSelected(b);
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }

    public void setDiminMM(final boolean b) {
        info.diminishingMMs = b;
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                DiminMMCheck.getModel().setSelected(b);
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }

    public void setGhostedBuildings(final boolean b) {
        info.ghostedBuildings = b;
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                GhostedCheck.getModel().setSelected(b);
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }*/

    int BooltoInt(boolean b) {
        if (b == true) {
            return 1;
        } else {
            return 0;
        }
    }

    public static boolean InttoBool(int i) {
        if (i == 0) {
            return false;
        } else {
            return true;
        }
    }

    

    public void UpdateBattle() {
        MapChange();
        battlemodel.CheckSync();
    }

    /**
     * Is called when the minimap changes, it redraws and sets the new minimap
     * image and tooltip, including starting rectangles
     *
     */
    public void MapChange() {
        final String s = info.GetMap();
        Runnable doWorkRunnable = new Runnable() {
            public void run() {
                jLabel7.setText("loading minimap "+s);
                jLabel7.setIcon(null);
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
        
        SwingWorker worker = new SwingWorker<BufferedImage, Void>() {

            boolean hasmap = true;

            @Override
            public BufferedImage doInBackground() {
                String q = s;
                if (CSync.HasMap(s) == false) {
                    hasmap = false;
                    return null;
                    //URL r =
                    //jLabel7.setIcon (null);
                    //q = "Classpath: /aflobby/NoMap.JPG";
                } else {
                    q = Misc.GetMinimapPath() + s.toLowerCase() + ".jpg";
                }
                CImageLoading il = new CImageLoading();
                BufferedImage newest = il.newestLoadImage(q); //(BufferedImage)
                if (newest == null) {
                    return null;
                }
                //.getScaledInstance(196,196,Image.SCALE_SMOOTH);
//Image a = Toolkit.getDefaultToolkit().getImage(getClass().getResource("file://C:/program files/Spring/lobby/aflobby/maps/"+s+".jpg"));
                // draw out starting rectangles
                Graphics2D g = newest.createGraphics(); //getGraphics ();//createGraphics ();
                g.scale(2.58, 2.58);
                //g.scale (2,2);
                ///* = is.getGraphics ();
                Color c1 = new Color(255, 255, 255, 50);
                Color c2 = new Color(255, 255, 255, 150); // = new Color();
                ArrayList<RectEntry> a = RectHandler.getRectList();
                Iterator<RectEntry> it = a.iterator();
                while (it.hasNext()) {
                    RectEntry r = it.next();
                    //g.setColor (Color.MAGENTA);
                    int x = 1 + r.getStartRecLeft();
                    int y = 1 + r.getStartRecTop();
                    int w = r.getStartRecRight() - r.getStartRecLeft();
                    int h = r.getStartRecBottom() - r.getStartRecTop();
                    //x = (x/200)*512;
                    //y = (y/200)*512;
                    //w = (w/200)*512;
                    //h = (h/200)*512;
                    g.setColor(c1);
                    g.fillRect(x, y, w, h);
                    g.setColor(c2);
                    g.drawRect(x, y, w, h);
                    g.drawString(String.valueOf(r.getNumAlly() + 1), x + (w / 2) - 5, y + (h / 2) + 5);
                    //System.out.println (x+" "+y+" "+w+" "+h);
                    //g.drawRect (1+(r.getStartRecLeft ()*(200/196)),1+r.getStartRecTop ()*(200/196),(r.getStartRecRight ()-r.getStartRecLeft ())*(200/196),(r.getStartRecTop ()-r.getStartRecBottom ())*(200/196));
                    //System.out.println ((r.getStartRecLeft ()*(200/196))+" "+r.getStartRecTop ()+" "+(r.getStartRecRight ()-r.getStartRecLeft ())+" "+(r.getStartRecBottom ()-r.getStartRecTop ()));
                } //*/
                g.dispose();
                return newest;
            }

            @Override
            public void done() {
                if (!hasmap) {
                    AddMessage(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.dontHaveMapPrefix") + s + java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.dontHaveMapSuffix"));
                } else {
                    jLabel7.setText(s);
                }
                try {
                    BufferedImage i = get();
                    if (i != null) {
                        Image is = i.getScaledInstance(256, 256, Image.SCALE_SMOOTH);
                        ImageIcon ic = new ImageIcon(is);
                        ImageIcon oldic = (ImageIcon) jLabel7.getIcon();
                        jLabel7.setIcon(ic);
                        if (oldic != null) {
                            oldic.getImage().flush();
                            oldic = null;
                        }
                    }
                } catch (ExecutionException ex) {
                    ex.printStackTrace();
                } catch (InterruptedException ex) {
                    ex.printStackTrace();
                }
            }
        };
        worker.execute();

        if (startrect != null) {
            SwingWorker worker2 = new SwingWorker<BufferedImage, Void>() {

                boolean hasmap = true;

                @Override
                public BufferedImage doInBackground() {
                    String q = s;
                    if (CSync.HasMap(s) == false) {
                        hasmap = false;
                        return null;
                        //URL r =
                        //jLabel7.setIcon (null);
                        //q = "Classpath: /aflobby/NoMap.JPG";
                    } else {
                        q = Misc.GetMinimapPath() + s.toLowerCase() + ".jpg";
                    }
                    
                    CImageLoading il = new CImageLoading();
                    BufferedImage newest = il.newestLoadImage(q); //(BufferedImage)
                    if (newest == null) {
                        return null;
                    }
                    //.getScaledInstance(196,196,Image.SCALE_SMOOTH);
    //Image a = Toolkit.getDefaultToolkit().getImage(getClass().getResource("file://C:/program files/Spring/lobby/aflobby/maps/"+s+".jpg"));
                    // draw out starting rectangles
                    return newest;
                }

                @Override
                public void done() {
                    try {
                        BufferedImage i = get();
                        if (i != null) {
                            if (startrect != null) {
                                //Image is = i.getScaledInstance(512, 512, Image.SCALE_SMOOTH);
                                ImageIcon ic = new ImageIcon(i);
                                startrect.SetMinimapImage(ic,i);
                            }
                        }
                    } catch (ExecutionException ex) {
                        ex.printStackTrace();
                    } catch (InterruptedException ex) {
                        ex.printStackTrace();
                    }
                }
            };
            worker2.execute();
        }
    }

    public void ChangeMap() {
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                String s = (String) MapList.getSelectedValue ();
                info.SetMap(s);
                CUserSettings.PutValue("battle.lastmap", s);
                info.maphash = CSync.GetMapHash(s);
                battlemodel.SendUpdateBattle();
                MapChange();
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
    }

    

    private static String getMissingZeros(int length) {
        String zeroString = "";

        for (int i = 0; i < (7 - length); i++) {
            zeroString += "0";
        }

        return zeroString;
    }
    public int numTeams = 0;
    public int numAllies = 0;

    public String GetScript() {
        String s = "";
        if (info != null) {
            try {
                //////
                List<CBattlePlayer> a = new ArrayList<CBattlePlayer>();
                List<CBattlePlayer> btemp =  battlemodel.GetAllPlayers();
                
                for (CBattlePlayer z : btemp) {
                    CBattlePlayer r = new CBattlePlayer(z);
                    a.add(r);
                }
                AllyData ad = new AllyData(a);
                TeamData td = new TeamData(a);
                //////////
                //GroupData(Orderedplayers);
                s = "[GAME]\n" + "{\n";
                s += "\tMapname=" + info.GetMap() + ";\n";


                String m = info.GetMod();
                if(m == null){
                    throw new NullPointerException();
                }
                
                String an = CSync.mod_name_archive.get(m);
                if(an == null){
                    System.out.println(m);
                    throw new NullPointerException();
                }
                
                s += "\tGameType=" + an + ";\n";

                
                if (this.info.GetHost().equalsIgnoreCase(LM.protocol.GetUsername())) {
                    s += "\tHostIP=localhost;\n";
                } else {
                    s += "\tHostIP=" + info.ip + ";\n";
                }
                
                s += "\tHostPort=" + info.port + ";\n\n";

                // mod options
                
                Map<String, Object> options = battlemodel.GetOptions();
                
                Map<String, Object> mapOptions = new TreeMap<String, Object>();
                Map<String, Object> modOptions = new TreeMap<String, Object>();
                Map<String, Object> generalOptions = new TreeMap<String, Object>();
                
                for(String k2 : options.keySet()){
                    String k = k2.toLowerCase();
                    k.replaceAll("\\\\", "/");
                    
                    if(k.startsWith("game/mapoptions/")){
                        //
                        mapOptions.put(k.substring(16), options.get(k2));
                    } else if(k.startsWith("game/modoptions/")){
                        //
                        modOptions.put(k.substring(16), options.get(k2));
                    } else if(k.startsWith("game/")){
                        //
                        generalOptions.put(k.substring(5), options.get(k2));
                    } else {
                        generalOptions.put(k+"erm", options.get(k2));
                    }
                }
                
                if(!generalOptions.isEmpty()){
                    //
                    for(String k : generalOptions.keySet()){
                        Object v = generalOptions.get(k);
                        String value = "";
                        
                        if((v.getClass() == boolean.class)||(v.getClass() == Boolean.class)){
                            value = ""+((v.toString().equals("true"))? 1 : 0);
                        }else{
                            value = v.toString();
                        }
                        
                        s += "\t" + k + "=" + value + ";\n";
                    }
                }
                
                if(!modOptions.isEmpty()){
                    //
                    s += "\t[modoptions]\n";
                    s += "\t{\n";
                    
                    for(String k : modOptions.keySet()){
                        s += "\t\t" + k + "=" + modOptions.get(k) + ";\n";
                    }
                    
                    s += "\t}\n\n";
                }
                
                if(!mapOptions.isEmpty()){
                    //
                    s += "\t[mapoptions]\n";
                    s += "\t{\n";
                    
                    for(String k : mapOptions.keySet()){
                        s += "\t\t" + k + "=" + mapOptions.get(k) + ";\n";
                    }
                    
                    s += "\t}\n\n";
                }
                
                
                
                for (int k = 0; k < info.GetPlayerNames().size(); k++) {
                    String z = info.GetPlayerNames().get(k);
                    if (z.equalsIgnoreCase(LM.protocol.GetUsername())) {
                        s += "\tmyplayernum=" + k + ";\n\n";
                    }
                }
                
                s += "\tnumplayers=" + battlemodel.GetPlayers().size() + ";\n";
                s += "\tnumteams=" + td.getTeamCount() + ";\n";
                s += "\tnumallyteams=" + ad.getAllyCount() + ";\n";

                s += "\n";

                // PLAYERS
                for (int i = 0; i < info.GetPlayerNames().size(); i++) {
                    
                    String z = info.GetPlayerNames().get(i);
                    CBattlePlayer u = battlemodel.GetPlayers().get(z);
                    
                    s += "\t[player" + i + "]\n";
                    s += "\t{\n";
                    s += "\t\tname=" + u.getPlayername() + ";\n";
                    s += "\t\tspectator=" + BooltoInt(u.isSpec()) + ";\n";
                    s += "\t\tcountrycode="+u.getPlayerdata().getCountry()+";\n";
                    s += "\t\trank="+u.getPlayerdata().rank+";\n";
                    
                    if (!u.isSpec()) {
                        s += "\t\tteam=" + td.GetTeamNo(Misc.getTeamNoFromBattleStatus(u.getBattlestatus())) + ";\n";
                    }
                    
                    s += "\t}\n";
                }

                // TEAMS
                s += "\n";
                //////
                TreeMap<Integer, TeamEntry> orderedTeams = td.getTeamList();
                for (int i = 0; i < td.getTeamCount(); i++) {
                    s += "\t[team" + i + "]\n";
                    s += "\t{\n";


                    int currentKey = orderedTeams.firstKey();
                    TeamEntry te = orderedTeams.remove(currentKey);

                    String ai = te.getAI();
                    
                    if (ai.equalsIgnoreCase("") == false) {
                        CBattlePlayer u = battlemodel.GetPlayers().get(te.getAIOwner());
                        s += "\t\tteamleader=";
                        s += td.GetTeamNo(Misc.getTeamNoFromBattleStatus(u.getBattlestatus()));
                        s += ";\n";
                    }else{
                        s += "\t\tteamleader=" + te.getTeamLeader() + ";\n";
                    }
                    
                    s += "\t\tallyteam=" + te.getAllyNo() + ";\n";
                    
                    
                    if (ai.equalsIgnoreCase("") == false) {
                        s += "\t\taidll=AI/Bot-libs/" + ai + ";\n";
                    }else{
                        s += "\t\t// no AI\n";
                    }

                    Color col = te.getTeamColor();
                    String redCol = "" + (col.getRed() / 255d);
                    String greenCol = "" + (col.getGreen() / 255d);
                    String blueCol = "" + (col.getBlue() / 255d);

                    if (redCol.length() > 7) {
                        redCol = redCol.substring(0, 7);
                    }
                    if (greenCol.length() > 7) {
                        greenCol = greenCol.substring(0, 7);
                    }
                    if (blueCol.length() > 7) {
                        blueCol = blueCol.substring(0, 7);
                    }
                    redCol += getMissingZeros(redCol.length());
                    greenCol += getMissingZeros(greenCol.length());
                    blueCol += getMissingZeros(blueCol.length());

                    s += "\t\tRGBColor=" + redCol + " " + greenCol + " " + blueCol + ";\n";
                    s += "\t\tSide=" + CSync.GetSideName(te.getSide()) + ";\n"; //JUnitSync.GetSideName (te.getSide ())
                    s += "\t\tHandicap=" + te.getHandicap() + ";\n";

                    s += "\t}\n";
                }

                // ALLYS
                TreeMap<Integer, AllyEntry> orderedAllys = ad.getAllyList();
                for (int i = 0; i < ad.getAllyCount(); i++) {
                    s += "\t[ALLYTEAM" + i + "]\n";
                    s += "\t{\n";

                    int currentKey = orderedAllys.firstKey();
                    AllyEntry te = orderedAllys.remove(currentKey);

                    s += "\t\tNumAllies=" + 0 + ";\n";
                    RectEntry re = RectHandler.getRectForAlly(ad.untransform(i));
                    if (re != null) {
                        String[] data = re.getRectDataStr();

                        s += "\t\tStartRectLeft=" + data[0] + ";\n";
                        s += "\t\tStartRectTop=" + data[1] + ";\n";
                        s += "\t\tStartRectRight=" + data[2] + ";\n";
                        s += "\t\tStartRectBottom=" + data[3] + ";\n";
                    }
                    s += "\t}\n";
                }

                s += "\n";
                s += "\tNumRestrictions=" + RestrictedUnits.getSize() + ";\n";
                s += "\t[RESTRICT]\n";
                s += "\t{\n";
                for (int i = 0; i < RestrictedUnits.getSize(); ++i) {
                    s += "\t\tUnit" + i + "=" + RestrictedUnits.get(i) + ";\n";
                    s += "\t\tLimit" + i + "=0;\n";
                }
                s += "\t}\n";
                s += "}";
            } catch (Exception e) {
                e.printStackTrace();
            }
        } else {
            s = "n/a";
        }
        return s;
    }

    private void SendMessage() {
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                
                String[] lines = UserMessage.getText().split("\n");
                
                for (int n = 0; n < lines.length; n++) {
                    
                    String k = lines[n];
                    
                    if (cmdhandler.IsCommand(k)) {
                        cmdhandler.ExecuteCommand(k);
                        continue;
                    }
                    
                    String[] command = k.split(" ");
                    
                    if (command[0].equalsIgnoreCase("/me")) {
                        battlemodel.SendChatActionMessage(Misc.makeSentence(command, 1));
                    } else {
                        battlemodel.SendChatMessage(k);
                    }
                }
                
                UserMessage.setText("");
                UserMessage.requestFocus();
            }
        };
        
        SwingUtilities.invokeLater(doWorkRunnable);
    }

    public void SendDisabledUnits() {

        String s = "DISABLEUNITS";
        
        for (int i = 0; i < RestrictedUnits.getSize(); i++) {
            String a = (String) RestrictedUnits.get (i);
            s += " " + a;
        }
        
        LM.protocol.SendTraffic(s);
    }

    public void UpdateMyUIControls() {
        
        Runnable doWorkRunnable = new Runnable() {

            public void run() {
                cansend=false;
                
                CBattlePlayer me = battlemodel.GetMe();
                
                MyTeamCombo.setSelectedIndex(me.getTeamNo());
                MyAllyTeamCombo.setSelectedIndex(me.getAllyNo());
                RaceCombo.setSelectedIndex(me.getSideNumber());
                ColourPanel.setBackground(me.getColor());
                
                cansend=true;
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

        jPopupMenu1 = new javax.swing.JPopupMenu();
        GameOptionsPane = new javax.swing.JTabbedPane();
        chatpanel = new javax.swing.JPanel();
        jToolBar2 = new javax.swing.JToolBar();
        jToggleButton3 = new javax.swing.JToggleButton();
        JAutoScrollToggle = new javax.swing.JToggleButton();
        cSmileyCombo1 = new aflobby.UI.CSmileyCombo();
        sayButton = new javax.swing.JButton();
        jSplitPane1 = new javax.swing.JSplitPane();
        jPanel1 = new javax.swing.JPanel();
        jScrollPane2 = new javax.swing.JScrollPane();
        playerBattleTable = new javax.swing.JTable();
        MyTeamCombo = new javax.swing.JComboBox();
        MyAllyTeamCombo = new javax.swing.JComboBox();
        RaceCombo = new javax.swing.JComboBox();
        ColourButton = new javax.swing.JButton();
        ColourPanel = new javax.swing.JPanel();
        Chat = new aflobby.UI.CChatPanel();
        jScrollPane4 = new javax.swing.JScrollPane();
        UserMessage = new javax.swing.JTextArea();
        GameStartButton = new javax.swing.JButton();
        ExitButton = new javax.swing.JButton();
        SpectatorToggle = new javax.swing.JToggleButton();
        ReadyToggle = new javax.swing.JToggleButton();
        LockToggle = new javax.swing.JToggleButton();
        jLabel7 = new javax.swing.JLabel();
        MapTab = new javax.swing.JPanel();
        jScrollPane3 = new javax.swing.JScrollPane();
        MapList = new javax.swing.JList();
        ChMapButton = new javax.swing.JButton();
        reload_maplist = new javax.swing.JButton();
        MapPickerLabel = new javax.swing.JLabel();
        jPanel6 = new javax.swing.JPanel();
        HostButtonsPanel = new javax.swing.JPanel();
        jButton1 = new javax.swing.JButton();
        jButton2 = new javax.swing.JButton();
        GameSpeedLockCheck = new javax.swing.JCheckBox();
        jScrollPane1 = new javax.swing.JScrollPane();
        OptionsPanel = new javax.swing.JPanel();
        jSeparator2 = new javax.swing.JSeparator();
        AITab = new javax.swing.JPanel();
        AICombo = new javax.swing.JComboBox();
        AddAIButton = new javax.swing.JButton();
        jSeparator1 = new javax.swing.JSeparator();
        jLabel9 = new javax.swing.JLabel();
        jLabel10 = new javax.swing.JLabel();
        jLabel11 = new javax.swing.JLabel();
        MyAIsCombo = new javax.swing.JComboBox();
        RemoveAIButton = new javax.swing.JButton();
        UpdateAIButton = new javax.swing.JButton();
        jLabel12 = new javax.swing.JLabel();
        EditAIRaceCombo = new javax.swing.JComboBox();
        jLabel13 = new javax.swing.JLabel();
        EditAIAllyCombo = new javax.swing.JComboBox();
        NewAIName = new javax.swing.JTextField();
        jLabel14 = new javax.swing.JLabel();
        jLabel15 = new javax.swing.JLabel();
        jLabel16 = new javax.swing.JLabel();
        AddAIRaceCombo = new javax.swing.JComboBox();
        jLabel17 = new javax.swing.JLabel();
        jLabel18 = new javax.swing.JLabel();
        jComboBox5 = new javax.swing.JComboBox();
        jButton3 = new javax.swing.JButton();
        AIColourPanel = new javax.swing.JPanel();
        jPanel7 = new javax.swing.JPanel();
        jPanel5 = new javax.swing.JPanel();
        RestrictUnitButton = new javax.swing.JButton();
        RestrictedUnitsCombo = new javax.swing.JComboBox();
        jLabel1 = new javax.swing.JLabel();
        jScrollPane6 = new javax.swing.JScrollPane();
        DisabledUnitsList = new javax.swing.JList();
        UnRestrictUnitButton = new javax.swing.JButton();
        UnRestrictAllUnitsButton = new javax.swing.JButton();
        jPanel2 = new javax.swing.JPanel();
        jScrollPane12 = new javax.swing.JScrollPane();
        ScriptPreview = new javax.swing.JTextArea();
        jButton4 = new javax.swing.JButton();
        jLabel8 = new javax.swing.JLabel();

        setDefaultCloseOperation(javax.swing.WindowConstants.DISPOSE_ON_CLOSE);
        setTitle("BattleName :: Server"); // NOI18N
        setExtendedState(MAXIMIZED_BOTH);
        setIconImage(CUISettings.GetWindowIcon());
        setMinimumSize(new java.awt.Dimension(875, 590));
        addWindowListener(new java.awt.event.WindowAdapter() {
            public void windowClosed(java.awt.event.WindowEvent evt) {
                formWindowClosed(evt);
            }
        });

        GameOptionsPane.setTabLayoutPolicy(javax.swing.JTabbedPane.SCROLL_TAB_LAYOUT);
        GameOptionsPane.setMinimumSize(new java.awt.Dimension(867, 548));
        GameOptionsPane.setPreferredSize(new java.awt.Dimension(867, 548));

        jToolBar2.setFloatable(false);

        jToggleButton3.setFont(CUISettings.GetFont(12,false));
        jToggleButton3.setSelected(true);
        java.util.ResourceBundle bundle = java.util.ResourceBundle.getBundle("aflobby/languages"); // NOI18N
        jToggleButton3.setText(bundle.getString("CBattleWindow.Accumulate_Messages")); // NOI18N
        jToggleButton3.setMaximumSize(new java.awt.Dimension(105, 21));
        jToolBar2.add(jToggleButton3);

        JAutoScrollToggle.setFont(CUISettings.GetFont(12,false));
        JAutoScrollToggle.setSelected(true);
        JAutoScrollToggle.setText(bundle.getString("CBattleWindow.AutoScroll")); // NOI18N
        JAutoScrollToggle.setMaximumSize(new java.awt.Dimension(65, 21));
        JAutoScrollToggle.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                JAutoScrollToggleActionPerformed(evt);
            }
        });
        jToolBar2.add(JAutoScrollToggle);

        cSmileyCombo1.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Item 1", "Item 2", "Item 3", "Item 4" }));
        cSmileyCombo1.setMaximumSize(new java.awt.Dimension(300, 32767));
        jToolBar2.add(cSmileyCombo1);
        cSmileyCombo1.Init(UserMessage);

        sayButton.setText(bundle.getString("CBattleWindow.Say")); // NOI18N
        sayButton.setMargin(new java.awt.Insets(2, 6, 2, 6));
        sayButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                sayButtonActionPerformed(evt);
            }
        });

        jSplitPane1.setDividerLocation(220);
        jSplitPane1.setOrientation(javax.swing.JSplitPane.VERTICAL_SPLIT);
        jSplitPane1.setResizeWeight(0.5);
        jSplitPane1.setOneTouchExpandable(true);

        playerBattleTable.setModel(playertablemodel);
        jScrollPane2.setViewportView(playerBattleTable);

        MyTeamCombo.setFont(CUISettings.GetFont(12,false));
        MyTeamCombo.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Team 1", "Team 2", "Team 3", "Team 4", "Team 5", "Team 6", "Team 7", "Team 8", "Team 9", "Team 10", "Team 11", "Team 12", "Team 13", "Team 14", "Team 15", "Team 16" }));
        MyTeamCombo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                MyTeamComboActionPerformed(evt);
            }
        });

        MyAllyTeamCombo.setFont(CUISettings.GetFont(12,false));
        MyAllyTeamCombo.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Ally Team 1", "Ally Team 2", "Ally Team 3", "Ally Team 4", "Ally Team 5", "Ally Team 6", "Ally Team 7", "Ally Team 8", "Ally Team 9", "Ally Team 10", "Ally Team 11", "Ally Team 12", "Ally Team 13", "Ally Team 14", "Ally Team 15", "Ally Team 16" }));
        MyAllyTeamCombo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                MyAllyTeamComboActionPerformed(evt);
            }
        });

        RaceCombo.setFont(CUISettings.GetFont(12,false));
        RaceCombo.setMaximumSize(new java.awt.Dimension(70, 25));
        RaceCombo.setPreferredSize(new java.awt.Dimension(120, 25));
        RaceCombo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                RaceComboActionPerformed(evt);
            }
        });

        ColourButton.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/colourpickerwheel16.png"))); // NOI18N
        ColourButton.setText("Change Colour"); // NOI18N
        ColourButton.setMargin(new java.awt.Insets(2, 6, 2, 6));
        ColourButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ColourButtonActionPerformed(evt);
            }
        });

        ColourPanel.setBackground(Color.decode(CUserSettings.GetValue("lastbattle.colour", String.valueOf(Color.blue.getRGB()))));
        ColourPanel.setBorder(new javax.swing.border.LineBorder(new java.awt.Color(0, 0, 0), 1, true));

        javax.swing.GroupLayout ColourPanelLayout = new javax.swing.GroupLayout(ColourPanel);
        ColourPanel.setLayout(ColourPanelLayout);
        ColourPanelLayout.setHorizontalGroup(
            ColourPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 61, Short.MAX_VALUE)
        );
        ColourPanelLayout.setVerticalGroup(
            ColourPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 23, Short.MAX_VALUE)
        );

        javax.swing.GroupLayout jPanel1Layout = new javax.swing.GroupLayout(jPanel1);
        jPanel1.setLayout(jPanel1Layout);
        jPanel1Layout.setHorizontalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel1Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(MyTeamCombo, javax.swing.GroupLayout.PREFERRED_SIZE, 76, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(MyAllyTeamCombo, javax.swing.GroupLayout.PREFERRED_SIZE, 111, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(RaceCombo, javax.swing.GroupLayout.PREFERRED_SIZE, 133, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(ColourButton)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(ColourPanel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
            .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 524, Short.MAX_VALUE)
        );
        jPanel1Layout.setVerticalGroup(
            jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel1Layout.createSequentialGroup()
                .addComponent(jScrollPane2, javax.swing.GroupLayout.DEFAULT_SIZE, 177, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addGroup(jPanel1Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                        .addComponent(MyTeamCombo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(MyAllyTeamCombo, javax.swing.GroupLayout.PREFERRED_SIZE, 21, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(RaceCombo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addComponent(ColourButton))
                    .addComponent(ColourPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap())
        );

        jPanel1Layout.linkSize(javax.swing.SwingConstants.VERTICAL, new java.awt.Component[] {MyAllyTeamCombo, MyTeamCombo, RaceCombo});

        jSplitPane1.setTopComponent(jPanel1);

        Chat.LM = LM;

        javax.swing.GroupLayout ChatLayout = new javax.swing.GroupLayout(Chat);
        Chat.setLayout(ChatLayout);
        ChatLayout.setHorizontalGroup(
            ChatLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 524, Short.MAX_VALUE)
        );
        ChatLayout.setVerticalGroup(
            ChatLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 183, Short.MAX_VALUE)
        );

        jSplitPane1.setRightComponent(Chat);

        UserMessage.setColumns(20);
        UserMessage.setLineWrap(true);
        UserMessage.setRows(2);
        UserMessage.setWrapStyleWord(true);
        UserMessage.addKeyListener(new java.awt.event.KeyAdapter() {
            public void keyPressed(java.awt.event.KeyEvent evt) {
                UserMessageKeyPressed(evt);
            }
        });
        jScrollPane4.setViewportView(UserMessage);

        GameStartButton.setText(bundle.getString("CBattleWindow.Start")); // NOI18N
        GameStartButton.setBorder(new javax.swing.border.LineBorder(new java.awt.Color(0, 204, 0), 1, true));
        GameStartButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                GameStartButtonActionPerformed(evt);
            }
        });

        ExitButton.setText(bundle.getString("CBattleWindow.Exit")); // NOI18N
        ExitButton.setAlignmentX(1.0F);
        ExitButton.setBorder(new javax.swing.border.LineBorder(new java.awt.Color(255, 0, 0), 1, true));
        ExitButton.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mousePressed(java.awt.event.MouseEvent evt) {
                ExitButtonMousePressed(evt);
            }
        });
        ExitButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ExitButtonActionPerformed(evt);
            }
        });

        SpectatorToggle.setText(bundle.getString("CBattleWindow.Spectator")); // NOI18N
        SpectatorToggle.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                SpectatorToggleActionPerformed(evt);
            }
        });

        ReadyToggle.setText(bundle.getString("CBattleWindow.Ready")); // NOI18N
        ReadyToggle.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ReadyToggleActionPerformed(evt);
            }
        });

        LockToggle.setText(bundle.getString("CBattleWindow.Lock")); // NOI18N
        LockToggle.setBorder(new javax.swing.border.LineBorder(new java.awt.Color(255, 204, 0), 1, true));
        LockToggle.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                LockToggleActionPerformed(evt);
            }
        });

        jLabel7.setHorizontalAlignment(javax.swing.SwingConstants.CENTER);
        jLabel7.setText(bundle.getString("CBattleWindow.map")); // NOI18N
        jLabel7.setVerticalAlignment(javax.swing.SwingConstants.BOTTOM);
        jLabel7.setAlignmentX(0.5F);
        jLabel7.setHorizontalTextPosition(javax.swing.SwingConstants.CENTER);
        jLabel7.setMaximumSize(new java.awt.Dimension(260, 270));
        jLabel7.setMinimumSize(new java.awt.Dimension(260, 270));
        jLabel7.setPreferredSize(new java.awt.Dimension(260, 270));
        jLabel7.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);

        javax.swing.GroupLayout chatpanelLayout = new javax.swing.GroupLayout(chatpanel);
        chatpanel.setLayout(chatpanelLayout);
        chatpanelLayout.setHorizontalGroup(
            chatpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(chatpanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(chatpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(chatpanelLayout.createSequentialGroup()
                        .addGroup(chatpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                            .addComponent(jToolBar2, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 523, Short.MAX_VALUE)
                            .addGroup(chatpanelLayout.createSequentialGroup()
                                .addComponent(jScrollPane4, javax.swing.GroupLayout.DEFAULT_SIZE, 459, Short.MAX_VALUE)
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(sayButton, javax.swing.GroupLayout.PREFERRED_SIZE, 58, javax.swing.GroupLayout.PREFERRED_SIZE)))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(chatpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(LockToggle, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addGroup(javax.swing.GroupLayout.Alignment.LEADING, chatpanelLayout.createSequentialGroup()
                                .addGroup(chatpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                                    .addComponent(SpectatorToggle, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                    .addComponent(GameStartButton, javax.swing.GroupLayout.PREFERRED_SIZE, 131, javax.swing.GroupLayout.PREFERRED_SIZE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addGroup(chatpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                                    .addComponent(ReadyToggle, javax.swing.GroupLayout.PREFERRED_SIZE, 124, javax.swing.GroupLayout.PREFERRED_SIZE)
                                    .addComponent(ExitButton, javax.swing.GroupLayout.PREFERRED_SIZE, 122, javax.swing.GroupLayout.PREFERRED_SIZE)))))
                    .addGroup(chatpanelLayout.createSequentialGroup()
                        .addComponent(jSplitPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 526, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
        );

        chatpanelLayout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {ExitButton, ReadyToggle});

        chatpanelLayout.setVerticalGroup(
            chatpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(chatpanelLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(chatpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(chatpanelLayout.createSequentialGroup()
                        .addComponent(jSplitPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 409, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jToolBar2, javax.swing.GroupLayout.PREFERRED_SIZE, 25, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, chatpanelLayout.createSequentialGroup()
                        .addComponent(jLabel7, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED, 147, Short.MAX_VALUE)
                        .addComponent(LockToggle)))
                .addGap(6, 6, 6)
                .addGroup(chatpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, chatpanelLayout.createSequentialGroup()
                        .addGroup(chatpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(ReadyToggle, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(SpectatorToggle))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(chatpanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(GameStartButton)
                            .addComponent(ExitButton)))
                    .addComponent(sayButton, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 52, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jScrollPane4, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.PREFERRED_SIZE, 52, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap())
        );

        chatpanelLayout.linkSize(javax.swing.SwingConstants.VERTICAL, new java.awt.Component[] {ExitButton, GameStartButton, LockToggle, ReadyToggle, SpectatorToggle});

        GameOptionsPane.addTab("Chat", chatpanel);

        MapList.setFont(CUISettings.GetFont(12,false));
        MapList.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        MapList.addListSelectionListener(new javax.swing.event.ListSelectionListener() {
            public void valueChanged(javax.swing.event.ListSelectionEvent evt) {
                MapListValueChanged(evt);
            }
        });
        jScrollPane3.setViewportView(MapList);

        ChMapButton.setFont(CUISettings.GetFont(12,false));
        ChMapButton.setText(bundle.getString("CBattleWindow.Change_Map")); // NOI18N
        ChMapButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                ChMapButtonActionPerformed(evt);
            }
        });

        reload_maplist.setFont(CUISettings.GetFont(12,false));
        reload_maplist.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/arrow_refresh.png"))); // NOI18N
        reload_maplist.setText(bundle.getString("CBattleWindow.Reload_Maplist")); // NOI18N
        reload_maplist.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                reload_maplistActionPerformed(evt);
            }
        });

        MapPickerLabel.setText(bundle.getString("CBattleWindow.Select_a_map_from_below")); // NOI18N
        MapPickerLabel.setVerticalAlignment(javax.swing.SwingConstants.TOP);
        MapPickerLabel.setVerticalTextPosition(javax.swing.SwingConstants.BOTTOM);

        javax.swing.GroupLayout MapTabLayout = new javax.swing.GroupLayout(MapTab);
        MapTab.setLayout(MapTabLayout);
        MapTabLayout.setHorizontalGroup(
            MapTabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(MapTabLayout.createSequentialGroup()
                .addGroup(MapTabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                    .addGroup(MapTabLayout.createSequentialGroup()
                        .addContainerGap()
                        .addComponent(MapPickerLabel, javax.swing.GroupLayout.PREFERRED_SIZE, 450, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, MapTabLayout.createSequentialGroup()
                        .addGap(7, 7, 7)
                        .addComponent(reload_maplist, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(ChMapButton, javax.swing.GroupLayout.PREFERRED_SIZE, 222, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jScrollPane3, javax.swing.GroupLayout.DEFAULT_SIZE, 330, Short.MAX_VALUE)
                .addContainerGap())
        );
        MapTabLayout.setVerticalGroup(
            MapTabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, MapTabLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(MapTabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jScrollPane3, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 498, Short.MAX_VALUE)
                    .addGroup(MapTabLayout.createSequentialGroup()
                        .addComponent(MapPickerLabel, javax.swing.GroupLayout.DEFAULT_SIZE, 433, Short.MAX_VALUE)
                        .addGap(41, 41, 41)
                        .addGroup(MapTabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(reload_maplist, javax.swing.GroupLayout.PREFERRED_SIZE, 24, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(ChMapButton, javax.swing.GroupLayout.PREFERRED_SIZE, 23, javax.swing.GroupLayout.PREFERRED_SIZE))))
                .addContainerGap())
        );

        GameOptionsPane.addTab("Maps", MapTab);

        HostButtonsPanel.setOpaque(false);

        jButton1.setText("Fix Teams"); // NOI18N
        jButton1.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton1ActionPerformed(evt);
            }
        });

        jButton2.setText("Force FFA"); // NOI18N
        jButton2.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton2ActionPerformed(evt);
            }
        });

        GameSpeedLockCheck.setText(bundle.getString("CBattleWindow.")); // NOI18N
        GameSpeedLockCheck.setBorder(javax.swing.BorderFactory.createEmptyBorder(0, 0, 0, 0));
        GameSpeedLockCheck.setMargin(new java.awt.Insets(0, 0, 0, 0));
        GameSpeedLockCheck.addChangeListener(new javax.swing.event.ChangeListener() {
            public void stateChanged(javax.swing.event.ChangeEvent evt) {
                GameSpeedLockCheckStateChanged(evt);
            }
        });

        javax.swing.GroupLayout HostButtonsPanelLayout = new javax.swing.GroupLayout(HostButtonsPanel);
        HostButtonsPanel.setLayout(HostButtonsPanelLayout);
        HostButtonsPanelLayout.setHorizontalGroup(
            HostButtonsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(HostButtonsPanelLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jButton1)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jButton2)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(GameSpeedLockCheck)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );
        HostButtonsPanelLayout.setVerticalGroup(
            HostButtonsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, HostButtonsPanelLayout.createSequentialGroup()
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                .addGroup(HostButtonsPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jButton1)
                    .addComponent(jButton2)
                    .addComponent(GameSpeedLockCheck))
                .addContainerGap())
        );

        OptionsPanel.setLayout(new javax.swing.BoxLayout(OptionsPanel, javax.swing.BoxLayout.PAGE_AXIS));
        OptionsPanel.add(jSeparator2);

        jScrollPane1.setViewportView(OptionsPanel);

        javax.swing.GroupLayout jPanel6Layout = new javax.swing.GroupLayout(jPanel6);
        jPanel6.setLayout(jPanel6Layout);
        jPanel6Layout.setHorizontalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(HostButtonsPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 790, Short.MAX_VALUE))
                .addContainerGap())
        );
        jPanel6Layout.setVerticalGroup(
            jPanel6Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel6Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(HostButtonsPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(jScrollPane1, javax.swing.GroupLayout.DEFAULT_SIZE, 447, Short.MAX_VALUE)
                .addContainerGap())
        );

        GameOptionsPane.addTab("Game Options", jPanel6);

        AddAIButton.setText("Add AI"); // NOI18N
        AddAIButton.setBorder(new javax.swing.border.LineBorder(new java.awt.Color(0, 255, 0), 1, true));
        AddAIButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                AddAIButtonActionPerformed(evt);
            }
        });

        jLabel9.setFont(jLabel9.getFont().deriveFont(jLabel9.getFont().getSize()+6f));
        jLabel9.setText("Add an AI"); // NOI18N

        jLabel10.setFont(jLabel10.getFont().deriveFont(jLabel10.getFont().getSize()+6f));
        jLabel10.setText("Modify an AI"); // NOI18N

        jLabel11.setText("AI to edit:"); // NOI18N

        MyAIsCombo.setEnabled(false);
        MyAIsCombo.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                MyAIsComboActionPerformed(evt);
            }
        });

        RemoveAIButton.setText("Remove This AI"); // NOI18N
        RemoveAIButton.setBorder(new javax.swing.border.LineBorder(new java.awt.Color(255, 0, 0), 1, true));
        RemoveAIButton.setEnabled(false);
        RemoveAIButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                RemoveAIButtonActionPerformed(evt);
            }
        });

        UpdateAIButton.setText("Update AI"); // NOI18N
        UpdateAIButton.setBorder(new javax.swing.border.LineBorder(new java.awt.Color(0, 204, 0), 1, true));
        UpdateAIButton.setEnabled(false);
        UpdateAIButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                UpdateAIButtonActionPerformed(evt);
            }
        });

        jLabel12.setText("AI Race:"); // NOI18N

        EditAIRaceCombo.setEnabled(false);

        jLabel13.setText("AI Ally:"); // NOI18N

        EditAIAllyCombo.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Ally Team 1", "Ally Team 2", "Ally Team 3", "Ally Team 4", "Ally Team 5", "Ally Team 6", "Ally Team 7", "Ally Team 8", "Ally Team 9", "Ally Team 10", "Ally Team 11", "Ally Team 12", "Ally Team 13", "Ally Team 14", "Ally Team 15", "Ally Team 16" }));
        EditAIAllyCombo.setEnabled(false);

        jLabel14.setText("Choose an AI:"); // NOI18N

        jLabel15.setText("Pick a name:"); // NOI18N

        jLabel16.setText("(no spaces in AI names)"); // NOI18N

        jLabel17.setText("AI Race:"); // NOI18N

        jLabel18.setText("Difficulty:"); // NOI18N

        jComboBox5.setModel(new javax.swing.DefaultComboBoxModel(new String[] { "Easy", "Moderate", "Difficult" }));
        jComboBox5.setEnabled(false);

        jButton3.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/colourpickerwheel.png"))); // NOI18N
        jButton3.setText("Change Colour"); // NOI18N
        jButton3.setEnabled(false);
        jButton3.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                jButton3ActionPerformed(evt);
            }
        });

        AIColourPanel.setBorder(new javax.swing.border.LineBorder(new java.awt.Color(0, 0, 0), 1, true));

        javax.swing.GroupLayout AIColourPanelLayout = new javax.swing.GroupLayout(AIColourPanel);
        AIColourPanel.setLayout(AIColourPanelLayout);
        AIColourPanelLayout.setHorizontalGroup(
            AIColourPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 327, Short.MAX_VALUE)
        );
        AIColourPanelLayout.setVerticalGroup(
            AIColourPanelLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGap(0, 45, Short.MAX_VALUE)
        );

        javax.swing.GroupLayout AITabLayout = new javax.swing.GroupLayout(AITab);
        AITab.setLayout(AITabLayout);
        AITabLayout.setHorizontalGroup(
            AITabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(AITabLayout.createSequentialGroup()
                .addContainerGap()
                .addGroup(AITabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel9, javax.swing.GroupLayout.PREFERRED_SIZE, 145, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jSeparator1, javax.swing.GroupLayout.DEFAULT_SIZE, 790, Short.MAX_VALUE)
                    .addComponent(jLabel10, javax.swing.GroupLayout.PREFERRED_SIZE, 130, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addGroup(AITabLayout.createSequentialGroup()
                        .addGroup(AITabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel11)
                            .addComponent(jLabel12))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(AITabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING, false)
                            .addComponent(MyAIsCombo, 0, 188, Short.MAX_VALUE)
                            .addComponent(EditAIRaceCombo, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(EditAIAllyCombo, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton3, javax.swing.GroupLayout.PREFERRED_SIZE, 208, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(AIColourPanel, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                    .addComponent(jLabel13)
                    .addGroup(AITabLayout.createSequentialGroup()
                        .addComponent(RemoveAIButton)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(UpdateAIButton, javax.swing.GroupLayout.PREFERRED_SIZE, 81, javax.swing.GroupLayout.PREFERRED_SIZE))
                    .addGroup(AITabLayout.createSequentialGroup()
                        .addGroup(AITabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                            .addComponent(AddAIButton, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel14, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                            .addComponent(jLabel15, javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel17, javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(jLabel18, javax.swing.GroupLayout.Alignment.LEADING))
                        .addGap(9, 9, 9)
                        .addGroup(AITabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(AICombo, javax.swing.GroupLayout.PREFERRED_SIZE, 286, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addGroup(AITabLayout.createSequentialGroup()
                                .addGroup(AITabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING, false)
                                    .addComponent(jComboBox5, javax.swing.GroupLayout.Alignment.LEADING, 0, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE)
                                    .addComponent(NewAIName)
                                    .addComponent(AddAIRaceCombo, javax.swing.GroupLayout.Alignment.LEADING, 0, 99, Short.MAX_VALUE))
                                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                                .addComponent(jLabel16)))))
                .addContainerGap())
        );

        AITabLayout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {AddAIRaceCombo, NewAIName, jComboBox5});

        AITabLayout.linkSize(javax.swing.SwingConstants.HORIZONTAL, new java.awt.Component[] {EditAIAllyCombo, EditAIRaceCombo, MyAIsCombo});

        AITabLayout.setVerticalGroup(
            AITabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(AITabLayout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jLabel9, javax.swing.GroupLayout.PREFERRED_SIZE, 26, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(AITabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel14)
                    .addComponent(AICombo, javax.swing.GroupLayout.PREFERRED_SIZE, 22, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(AITabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel15)
                    .addComponent(jLabel16)
                    .addComponent(NewAIName, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(AITabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(AddAIRaceCombo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel17))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(AITabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                    .addComponent(jLabel18)
                    .addComponent(jComboBox5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(AddAIButton, javax.swing.GroupLayout.PREFERRED_SIZE, 24, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.UNRELATED)
                .addComponent(jSeparator1, javax.swing.GroupLayout.PREFERRED_SIZE, 10, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addGroup(AITabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(AITabLayout.createSequentialGroup()
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jLabel10)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(AITabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel11)
                            .addComponent(MyAIsCombo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(AITabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel12)
                            .addComponent(EditAIRaceCombo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(AITabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(jLabel13)
                            .addComponent(EditAIAllyCombo, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE))
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addGroup(AITabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.BASELINE)
                            .addComponent(RemoveAIButton, javax.swing.GroupLayout.PREFERRED_SIZE, 26, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(UpdateAIButton, javax.swing.GroupLayout.PREFERRED_SIZE, 24, javax.swing.GroupLayout.PREFERRED_SIZE)))
                    .addGroup(AITabLayout.createSequentialGroup()
                        .addGap(24, 24, 24)
                        .addGroup(AITabLayout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                            .addComponent(AIColourPanel, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                            .addComponent(jButton3, javax.swing.GroupLayout.DEFAULT_SIZE, 47, Short.MAX_VALUE))))
                .addContainerGap(189, Short.MAX_VALUE))
        );

        AITabLayout.linkSize(javax.swing.SwingConstants.VERTICAL, new java.awt.Component[] {AIColourPanel, jButton3});

        AITabLayout.linkSize(javax.swing.SwingConstants.VERTICAL, new java.awt.Component[] {RemoveAIButton, UpdateAIButton});

        GameOptionsPane.addTab("Skirmish AI", AITab);

        jPanel5.setBorder(javax.swing.BorderFactory.createTitledBorder("Add Restricted Units"));

        RestrictUnitButton.setText(bundle.getString("CBattleWindow.Restrict_Unit")); // NOI18N
        RestrictUnitButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                RestrictUnitButtonActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel5Layout = new javax.swing.GroupLayout(jPanel5);
        jPanel5.setLayout(jPanel5Layout);
        jPanel5Layout.setHorizontalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel5Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(RestrictedUnitsCombo, javax.swing.GroupLayout.Alignment.LEADING, 0, 164, Short.MAX_VALUE)
                    .addComponent(RestrictUnitButton, javax.swing.GroupLayout.Alignment.LEADING, javax.swing.GroupLayout.DEFAULT_SIZE, 164, Short.MAX_VALUE))
                .addContainerGap())
        );
        jPanel5Layout.setVerticalGroup(
            jPanel5Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel5Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(RestrictedUnitsCombo, javax.swing.GroupLayout.PREFERRED_SIZE, 18, javax.swing.GroupLayout.PREFERRED_SIZE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addComponent(RestrictUnitButton)
                .addContainerGap(javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
        );

        jLabel1.setLabelFor(DisabledUnitsList);
        jLabel1.setText(bundle.getString("CBattleWindow.Disabled_Units")); // NOI18N

        DisabledUnitsList.setFont(CUISettings.GetFont(12,false));
        DisabledUnitsList.setModel(RestrictedUnits);
        DisabledUnitsList.setSelectionMode(javax.swing.ListSelectionModel.SINGLE_SELECTION);
        jScrollPane6.setViewportView(DisabledUnitsList);

        UnRestrictUnitButton.setText(bundle.getString("CBattleWindow.UnRestrict_Unit")); // NOI18N
        UnRestrictUnitButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                UnRestrictUnitButtonActionPerformed(evt);
            }
        });

        UnRestrictAllUnitsButton.setText(bundle.getString("CBattleWindow.UnRestrict_All_Units")); // NOI18N
        UnRestrictAllUnitsButton.addActionListener(new java.awt.event.ActionListener() {
            public void actionPerformed(java.awt.event.ActionEvent evt) {
                UnRestrictAllUnitsButtonActionPerformed(evt);
            }
        });

        javax.swing.GroupLayout jPanel7Layout = new javax.swing.GroupLayout(jPanel7);
        jPanel7.setLayout(jPanel7Layout);
        jPanel7Layout.setHorizontalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel7Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jLabel1, javax.swing.GroupLayout.PREFERRED_SIZE, 161, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jScrollPane6, javax.swing.GroupLayout.PREFERRED_SIZE, 588, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(UnRestrictAllUnitsButton, javax.swing.GroupLayout.DEFAULT_SIZE, 196, Short.MAX_VALUE)
                    .addComponent(UnRestrictUnitButton, javax.swing.GroupLayout.DEFAULT_SIZE, 196, Short.MAX_VALUE)
                    .addComponent(jPanel5, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, Short.MAX_VALUE))
                .addContainerGap())
        );
        jPanel7Layout.setVerticalGroup(
            jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(jPanel7Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel7Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addGroup(jPanel7Layout.createSequentialGroup()
                        .addComponent(jPanel5, javax.swing.GroupLayout.PREFERRED_SIZE, javax.swing.GroupLayout.DEFAULT_SIZE, javax.swing.GroupLayout.PREFERRED_SIZE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(UnRestrictUnitButton)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(UnRestrictAllUnitsButton))
                    .addGroup(jPanel7Layout.createSequentialGroup()
                        .addComponent(jLabel1)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jScrollPane6, javax.swing.GroupLayout.DEFAULT_SIZE, 478, Short.MAX_VALUE)))
                .addContainerGap())
        );

        GameOptionsPane.addTab("Restricted Units", jPanel7);

        jPanel2.setDoubleBuffered(false);
        jPanel2.setEnabled(Main.dev_environment);

        ScriptPreview.setColumns(20);
        ScriptPreview.setEditable(false);
        ScriptPreview.setFont(new java.awt.Font("Arial", 0, 13));
        ScriptPreview.setLineWrap(true);
        ScriptPreview.setRows(5);
        ScriptPreview.setText("Please press refresh below"); // NOI18N
        ScriptPreview.setWrapStyleWord(true);
        jScrollPane12.setViewportView(ScriptPreview);

        jButton4.setFont(CUISettings.GetFont(12,false));
        jButton4.setIcon(new javax.swing.ImageIcon(getClass().getResource("/images/UI/arrow_refresh.png"))); // NOI18N
        jButton4.setText(bundle.getString("CBattleWindow.refresh_debug_script")); // NOI18N
        jButton4.setBorderPainted(false);
        jButton4.addMouseListener(new java.awt.event.MouseAdapter() {
            public void mouseReleased(java.awt.event.MouseEvent evt) {
                jButton4MouseReleased(evt);
            }
        });

        jLabel8.setText(bundle.getString("CBattleWindow.debugScriptNote")); // NOI18N

        javax.swing.GroupLayout jPanel2Layout = new javax.swing.GroupLayout(jPanel2);
        jPanel2.setLayout(jPanel2Layout);
        jPanel2Layout.setHorizontalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
                    .addComponent(jScrollPane12, javax.swing.GroupLayout.Alignment.TRAILING, javax.swing.GroupLayout.DEFAULT_SIZE, 790, Short.MAX_VALUE)
                    .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                        .addComponent(jLabel8, javax.swing.GroupLayout.DEFAULT_SIZE, 520, Short.MAX_VALUE)
                        .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                        .addComponent(jButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 266, javax.swing.GroupLayout.PREFERRED_SIZE)))
                .addContainerGap())
        );
        jPanel2Layout.setVerticalGroup(
            jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addGroup(javax.swing.GroupLayout.Alignment.TRAILING, jPanel2Layout.createSequentialGroup()
                .addContainerGap()
                .addComponent(jScrollPane12, javax.swing.GroupLayout.DEFAULT_SIZE, 464, Short.MAX_VALUE)
                .addPreferredGap(javax.swing.LayoutStyle.ComponentPlacement.RELATED)
                .addGroup(jPanel2Layout.createParallelGroup(javax.swing.GroupLayout.Alignment.TRAILING)
                    .addComponent(jButton4, javax.swing.GroupLayout.PREFERRED_SIZE, 28, javax.swing.GroupLayout.PREFERRED_SIZE)
                    .addComponent(jLabel8, javax.swing.GroupLayout.PREFERRED_SIZE, 28, javax.swing.GroupLayout.PREFERRED_SIZE))
                .addContainerGap())
        );

        GameOptionsPane.addTab("Script (Adv)", jPanel2);

        javax.swing.GroupLayout layout = new javax.swing.GroupLayout(getContentPane());
        getContentPane().setLayout(layout);
        layout.setHorizontalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(GameOptionsPane, javax.swing.GroupLayout.PREFERRED_SIZE, 815, Short.MAX_VALUE)
        );
        layout.setVerticalGroup(
            layout.createParallelGroup(javax.swing.GroupLayout.Alignment.LEADING)
            .addComponent(GameOptionsPane, javax.swing.GroupLayout.DEFAULT_SIZE, 548, Short.MAX_VALUE)
        );

        pack();
    }// </editor-fold>//GEN-END:initComponents

private void jButton1ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton1ActionPerformed
    // FIX TEAMS!
    int i = 0;
    for (CBattlePlayer bp : battlemodel.GetPlayers().values()) {
        bp.setTeamNo(i);
        LM.protocol.SendTraffic("FORCETEAMNO " + bp.getPlayername() + " " + i);
        i++;
    }
}//GEN-LAST:event_jButton1ActionPerformed

    private void UnRestrictAllUnitsButtonActionPerformed (java.awt.event.ActionEvent evt) {//GEN-FIRST:event_UnRestrictAllUnitsButtonActionPerformed
        LM.protocol.SendTraffic("ENABLEALLUNITS");
        RestrictedUnits.clear();
    }//GEN-LAST:event_UnRestrictAllUnitsButtonActionPerformed

    private void UnRestrictUnitButtonActionPerformed (java.awt.event.ActionEvent evt) {//GEN-FIRST:event_UnRestrictUnitButtonActionPerformed
        String s = (String) DisabledUnitsList.getSelectedValue ();
        RestrictedUnits.removeElement(s);
        SendDisabledUnits();
    }//GEN-LAST:event_UnRestrictUnitButtonActionPerformed

    private void RestrictUnitButtonActionPerformed (java.awt.event.ActionEvent evt) {//GEN-FIRST:event_RestrictUnitButtonActionPerformed
        String s = (String) RestrictedUnitsCombo.getSelectedItem ();
        
        if (RestrictedUnits.contains(s) == false) {
            RestrictedUnits.addElement(s);
            SendDisabledUnits();
        }
    }//GEN-LAST:event_RestrictUnitButtonActionPerformed

    private void JAutoScrollToggleActionPerformed (java.awt.event.ActionEvent evt) {//GEN-FIRST:event_JAutoScrollToggleActionPerformed
        Chat.SetAutoScroll(JAutoScrollToggle.isSelected());
    }//GEN-LAST:event_JAutoScrollToggleActionPerformed

    private void reload_maplistActionPerformed (java.awt.event.ActionEvent evt) {//GEN-FIRST:event_reload_maplistActionPerformed
        CSync.RefreshUnitSync();
    }//GEN-LAST:event_reload_maplistActionPerformed

    private void GameStartButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_GameStartButtonActionPerformed
        battlemodel.Start();
}//GEN-LAST:event_GameStartButtonActionPerformed

    private void ReadyToggleActionPerformed (java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ReadyToggleActionPerformed
        battlemodel.GetMe().setReady(ReadyToggle.isSelected());
        SendMyStatus();
    }//GEN-LAST:event_ReadyToggleActionPerformed

    private void SpectatorToggleActionPerformed (java.awt.event.ActionEvent evt) {//GEN-FIRST:event_SpectatorToggleActionPerformed
        battlemodel.GetMe().setSpectator(SpectatorToggle.isSelected());
        SendMyStatus();
    }//GEN-LAST:event_SpectatorToggleActionPerformed

    private void MapListValueChanged(javax.swing.event.ListSelectionEvent evt) {//GEN-FIRST:event_MapListValueChanged
        final String s = (String) MapList.getSelectedValue ();
        
        Runnable doWorkRunnable = new Runnable() {
            public void run() {
                MapPickerLabel.setText("loading minimap "+s);
                MapPickerLabel.setIcon(null);
            }
        };
        SwingUtilities.invokeLater(doWorkRunnable);
        
        SwingWorker worker = new SwingWorker<ImageIcon, Void>() {

            @Override
            public ImageIcon doInBackground() {
                CImageLoading il = new CImageLoading();
                Image newest = il.olderLoadImage(Misc.GetMinimapPath() + s.toLowerCase() + ".jpg");
                return new ImageIcon(newest.getScaledInstance(400, 400, Image.SCALE_SMOOTH));
            }

            @Override
            public void done() {
                try {
                    MapPickerLabel.setIcon(get());
                } catch (ExecutionException ex) {
                    ex.printStackTrace();
                } catch (InterruptedException ex) {
                    ex.printStackTrace();
                }
                MapPickerLabel.setText("");
            }
        };
        worker.execute();
    }//GEN-LAST:event_MapListValueChanged

    private void jButton4MouseReleased(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_jButton4MouseReleased
        ScriptPreview.setText(GetScript());
    }//GEN-LAST:event_jButton4MouseReleased

    /*public void stateChanged(ChangeEvent e) {
    if(this.info == null) return;
    if(ColourWheel == e.getSource()){
    Color c = ColourWheel.getColor();
    if(!c.equals(mycolour)){
    mycolour = c;
    SendMyStatus();
    }
    }
    }*/
    private void GameSpeedLockCheckStateChanged(javax.swing.event.ChangeEvent evt) {//GEN-FIRST:event_GameSpeedLockCheckStateChanged
        if (battlemodel.AmIHost()) {
            //info. = GameSpeedLockCheck.isSelected();
            //UpdateBattleClients();
        }
    }//GEN-LAST:event_GameSpeedLockCheckStateChanged

    //private boolean wipenext=false;
    private void ExitButtonMousePressed(java.awt.event.MouseEvent evt) {//GEN-FIRST:event_ExitButtonMousePressed
    }//GEN-LAST:event_ExitButtonMousePressed

    private void AddAIButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_AddAIButtonActionPerformed
        //ADDBOT name battlestatus teamcolor {AIDLL}
        String s = "ADDBOT ";
        String name = NewAIName.getText().replaceAll(" ", "");
        if (name.equals("")) {
            return;
        }
        s += name + " ";
        CBattlePlayer bp = new CBattlePlayer();
        bp.setSpectator(false);
        bp.setTeamNo(battlemodel.GetFirstFreeTeam());
        bp.setAllyNo(battlemodel.GetFirstFreeAlly());
        bp.setSide(AddAIRaceCombo.getSelectedIndex());
        s += bp.getBattlestatus() + " ";
        s += ColourHelper.ColorToInteger(Color.BLUE).intValue() + " ";
        s += AICombo.getSelectedItem();
        LM.protocol.SendTraffic(s);
    }//GEN-LAST:event_AddAIButtonActionPerformed

    private void RaceComboActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_RaceComboActionPerformed
        if (battlemodel.GetMe() == null) {
            return;
        }
        int i = RaceCombo.getSelectedIndex();
        battlemodel.GetMe().setSide(i); //mybattlestatus = Misc.setSideOfBattleStatus (mybattlestatus,i);
        SendMyStatus();
    }//GEN-LAST:event_RaceComboActionPerformed

    private void MyAllyTeamComboActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_MyAllyTeamComboActionPerformed
        int i = MyAllyTeamCombo.getSelectedIndex();
        battlemodel.GetMe().setAllyNo(i); //mybattlestatus = Misc.setAllyNoOfBattleStatus (mybattlestatus,i);
        SendMyStatus();
    }//GEN-LAST:event_MyAllyTeamComboActionPerformed

    private void MyTeamComboActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_MyTeamComboActionPerformed
        int i = MyTeamCombo.getSelectedIndex();
        battlemodel.GetMe().setTeamNo(i); //mybattlestatus = Misc.setTeamNoOfBattleStatus (mybattlestatus,i);
        SendMyStatus();
    }//GEN-LAST:event_MyTeamComboActionPerformed

    private void MyAIsComboActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_MyAIsComboActionPerformed
        String name = (String) MyAIsCombo.getSelectedItem();
        
        CBattlePlayer bp = battlemodel.GetAIPlayers().get(name);
        
        if (bp == null) {
            return;
        }
        
        EditAIAllyCombo.setSelectedIndex(bp.getAllyNo());
        
        aicolour = bp.getColor();

        int side = bp.getSideNumber();
        EditAIRaceCombo.setSelectedIndex(side);
    }//GEN-LAST:event_MyAIsComboActionPerformed

    private void RemoveAIButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_RemoveAIButtonActionPerformed
        String ainame = (String) MyAIsCombo.getSelectedItem();
        LM.protocol.SendTraffic("REMOVEBOT " + ainame);
        /*MyAIsCombo.removeItemAt(MyAIsCombo.getSelectedIndex());
        if(MyAIsCombo.getItemCount() == 0){
        MyAIsCombo.setEnabled(false);
        }
        AIplayers.remove(e.data[2]);
        AIs.remove(e.data[2]);
        MyAIsCombo.removeItem(e.data[2]);
        if(MyAIsCombo.isEnabled()){
        if(MyAIsCombo.getItemCount()==0){
        MyAIsCombo.setEnabled(false);
        EditAIAllyCombo.setEnabled(false);
        EditAIRaceCombo.setEnabled(false);
        RemoveAIButton.setEnabled(false);
        UpdateAIButton.setEnabled(false);
        EditAIColors.setEnabled(false);
        }
        }
        }
         */
}//GEN-LAST:event_RemoveAIButtonActionPerformed

    private void UpdateAIButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_UpdateAIButtonActionPerformed
        String ainame = (String) MyAIsCombo.getSelectedItem();
        CBattlePlayer bp = battlemodel.GetAIPlayers().get(ainame);
        if (bp == null) {
            return;
        }
        bp.setColor(aicolour);
        bp.setSide(EditAIRaceCombo.getSelectedIndex());
        bp.setAllyNo(EditAIAllyCombo.getSelectedIndex());
        // UPDATEBOT name battlestatus teamcolor
        String s = "UPDATEBOT " + ainame;
        s += " " + bp.getBattlestatus();
        s += " " + ColourHelper.ColorToInteger(bp.getColor()).intValue();
        LM.protocol.SendTraffic(s);
}//GEN-LAST:event_UpdateAIButtonActionPerformed

    private void jButton2ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton2ActionPerformed
        // FORCE FFA!
        int i = 0;
        for (CBattlePlayer bp : battlemodel.GetPlayers().values()) {
            bp.setAllyNo(i);
            LM.protocol.SendTraffic("FORCEALLYNO " + bp.getPlayername() + " " + i);
            i++;
        }
    }//GEN-LAST:event_jButton2ActionPerformed

    private void ChMapButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ChMapButtonActionPerformed
        if (battlemodel.AmIHost()) {
            // change map!
            ChangeMap();
        } else {
            // suggest we change the map!
            String s = (String) MapList.getSelectedValue ();
            s = java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.suggests_this_map:_") + s;
            LM.protocol.SendTraffic("SAYBATTLEEX " + s);
            //CUserSettings.PutValue("UI.lasthosted.map", s);
        }
    }//GEN-LAST:event_ChMapButtonActionPerformed
    boolean closing = false;

    private void formWindowClosed(java.awt.event.WindowEvent evt) {//GEN-FIRST:event_formWindowClosed
        if (!closing) {
            LeaveBattle();
            closing = true;
        }
    }//GEN-LAST:event_formWindowClosed

    private void ExitButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ExitButtonActionPerformed
        if (!closing) {
            LeaveBattle();
            closing = true;
        }
    }//GEN-LAST:event_ExitButtonActionPerformed

    private void UserMessageKeyPressed(java.awt.event.KeyEvent evt) {//GEN-FIRST:event_UserMessageKeyPressed
        if (evt.getKeyCode() == KeyEvent.VK_ENTER) {
            if (evt.isShiftDown()) {
                return;
            }
            SendMessage();
        }
    }//GEN-LAST:event_UserMessageKeyPressed

    private void ColourButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_ColourButtonActionPerformed
        // TODO add your handling code here:
        Color c = LM.ShowColorDialog(this, "Pick a Colour");
        if(c == null){
            return;
        }
        ColourPanel.setBackground(c);
        battlemodel.GetMe().setColor(c);
        CUserSettings.PutValue("lastbattle.colour", String.valueOf(c.getRGB()));
        colorchange = true;
    }//GEN-LAST:event_ColourButtonActionPerformed
    
    Color aicolour = Color.black;
    private void jButton3ActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_jButton3ActionPerformed
        Color c = LM.ShowColorDialog(this, "Pick a Colour");
        if(c == null){
            return;
        }else{
            aicolour = c;
        }
        AIColourPanel.setBackground(c);
}//GEN-LAST:event_jButton3ActionPerformed

    private void sayButtonActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_sayButtonActionPerformed
        SendMessage();
}//GEN-LAST:event_sayButtonActionPerformed

    private void LockToggleActionPerformed(java.awt.event.ActionEvent evt) {//GEN-FIRST:event_LockToggleActionPerformed
        battlemodel.SetLocked(LockToggle.isSelected());
    }//GEN-LAST:event_LockToggleActionPerformed


    //}
    public void AddMessage(final String s) {
        Chat.AddMessage(s); // + "<br>");
    }
    
    public boolean scroll = false;
    boolean colorchange = false;
    int scrollcount = 10;

    public void Update() {
        scrollcount--;
        
        if (scrollcount < 1) {
            scrollcount = 10;
            
            if (colorchange) {
                colorchange = false;
                this.SendMyStatus();
            }
            
            if (info.natType == 1) {
                if (ingame == false) {
                    if (!CHolePuncher.SendRequest()) {
                        LM.Toasts.AddMessage(java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.Holepunching_failed"));
                        return; // holepunching failed we dont start
                    }
                }
            }
        
        }
    }

    public void NewEvent(final CEvent e) {
        
        if (info == null) {
            return;
        }
        
        if (!active) {
            return;
        }
        
        if (e.IsEvent("SAIDBATTLE")) {
            
            String Msg = Misc.toHTML(Misc.makeSentence(e.data, 2));
            String User = e.data[1];
            
            if (lastsent.equalsIgnoreCase(User)) {

                AddMessage("<font face=\"Arial, Helvetica, sans-serif\" size=\"3\">&nbsp;&nbsp;&nbsp;" + Msg + "</font>");

            } else if (lastsent.equalsIgnoreCase("")) {
                AddMessage("<font face=\"Arial, Helvetica, sans-serif\" size=\"3\"><b><i>" + User + java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.Says") + " " + Msg + "</font>");
                lastsent = User;
            } else if (lastsent.equalsIgnoreCase(User) == false) {
                AddMessage("<font face=\"Arial, Helvetica, sans-serif\" size=\"3\"><b><i>" + User + java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.Says") + " " + Msg + "</font>");
                lastsent = User;
            } //
        } else if (e.IsEvent("REMOVEBOT")) {

            //REMOVEBOT BATTLE_ID name
            
            CBattlePlayer ai = battlemodel.GetAI(e.data[2]);
            playertablemodel.RemovePlayer(ai);
            
            battlemodel.RemoveAI(e.data[2]);
            
            Runnable doWorkRunnable = new Runnable() {

                public void run() {

                    if (MyAIsCombo.getItemCount() == 1) {
                        MyAIsCombo.addItem(" ");
                    }
                    
                    MyAIsCombo.removeItem(e.data[2]);

                    if (MyAIsCombo.getItemCount() == 1) {
                        MyAIsCombo.setEnabled(false);
                        EditAIAllyCombo.setEnabled(false);
                        EditAIRaceCombo.setEnabled(false);
                        RemoveAIButton.setEnabled(false);
                        UpdateAIButton.setEnabled(false);
                        jButton3.setEnabled(false);
                    }

                }
            };
            SwingUtilities.invokeLater(doWorkRunnable);

            //info.GetPlayerNames ().add (e.data[2]);
            AddMessage("<font face=\"Arial, Helvetica, sans-serif\" size=\"3\"><b>" + e.data[2] + " AI removed by " + e.data[2] + "</b></font>");

            battlemodel.SendUpdateBattle();
            Redraw();

        } else if (e.IsEvent("ADDBOT")) {
            
            //ADDBOT BATTLE_ID name owner battlestatus teamcolor {AIDLL}
            
            CBattlePlayer pl = new CBattlePlayer();
            
            pl.setPlayername(e.data[2]);
            pl.setAIOwner(e.data[3]);
            pl.setBattlestatus(Integer.parseInt(e.data[4]));
            pl.setPlayerdata(LM.playermanager.GetPlayer(e.data[3]));
            pl.setColor(ColourHelper.IntegerToColor(Integer.parseInt(e.data[5])));
            
            String t = Misc.makeSentence(e.data, 6).replaceAll("\t", "");
            pl.setAI(t);
            pl.setSpectator(false);
            
            battlemodel.AddAI(e.data[2], pl);
            
            playertablemodel.AddPlayer(pl);

            
            String flag;
            
            if(CUserSettings.GetValue("ui.channelview.userjoinflags", "true").equals("false")){
                flag="";
            }else{
                flag=pl.getPlayerdata().GetFlagHTML();
            }
            
            AddMessage("<font face=\"Arial, Helvetica, sans-serif\" size=\"3\"><b>" + flag + " AI added by " + e.data[2] + "</b></font>");

            if (e.data[3].equalsIgnoreCase(LM.protocol.GetUsername()) || battlemodel.AmIHost()) {
                //
                Runnable doWorkRunnable = new Runnable() {

                    public void run() {
                        
                        MyAIsCombo.addItem(e.data[2]);
                        MyAIsCombo.removeItem(" ");

                        MyAIsCombo.setEnabled(true);
                        
                        EditAIAllyCombo.setEnabled(true);
                        EditAIRaceCombo.setEnabled(true);
                        RemoveAIButton.setEnabled(true);
                        UpdateAIButton.setEnabled(true);
                        jButton3.setEnabled(true);

                    }
                };
                SwingUtilities.invokeLater(doWorkRunnable);
            }


            battlemodel.SendUpdateBattle();
            Redraw();
            
        } else if (e.IsEvent("DISABLEUNITS")) {
            
            Runnable doWorkRunnable = new Runnable() {
                public void run() {
                    
                    for (int i = 1; i < e.data.length; i++) {
                        if (RestrictedUnits.contains(e.data[i]) == false) {
                            RestrictedUnits.addElement(e.data[i]);
                        }
                    }
                    
                }
            };
            
            SwingUtilities.invokeLater(doWorkRunnable);
            
        } else if (e.IsEvent("ENABLEUNITS")) {
            //ENABLEALLUNITS
            Runnable doWorkRunnable = new Runnable() {

                public void run() {
                    
                    for (int i = 1; i < e.data.length; i++) {
                        RestrictedUnits.removeElement(e.data[i]);
                    }
                    
                }
            };
            
            SwingUtilities.invokeLater(doWorkRunnable);
            
        } else if (e.IsEvent("ENABLEALLUNITS")) {
            
            Runnable doWorkRunnable = new Runnable() {
                public void run() {
                    RestrictedUnits.clear();
                }
            };
            
            SwingUtilities.invokeLater(doWorkRunnable);
            
        } else if (e.IsEvent("SAIDBATTLEEX")) {
            AddMessage("<font face=\"Arial, Helvetica, sans-serif\" size=\"3\" color=\"3322FF\"><b> " + Misc.makeSentence(e.data, 1) + "</b></font>");
            lastsent = e.data[2];
            
        } else if (e.IsEvent("UDPSOURCEPORT")) {
            MyUDPPort = Integer.parseInt(e.data[1]);
            
        } else if (e.IsEvent("CLIENTSTATUS")) {
            
            if (!battlemodel.AmIHost()) {
                if (info != null) {
                    
                    if (e.data[1].equalsIgnoreCase(info.GetHost())) {
                        
                        int status = Integer.parseInt(e.data[2]);
                        if (Misc.getInGameFromStatus(status) > 0) {
                            if (ingame == false) {
                                if (battlemodel.GetMe().isSpec() || battlemodel.GetMe().isReady()) {
                                    battlemodel.Start();
                                }
                            }
                        } else {
                            ingame = false;
                        }
                    }
                }
            }
            
        } else if (e.IsEvent("UPDATEBATTLEINFO")) {
            // UPDATEBATTLEINFO BATTLE_ID SpectatorCount locked maphash {mapname}
            
            if (!battlemodel.AmIHost()) {
                if (Integer.parseInt(e.data[1]) == info.GetID()) {
                    this.MapChange();
                }
            }
            
        } else if (e.IsEvent("ADDSTARTRECT")) {
            // ADDSTARTRECT allyno left top right bottom
            
            int allynum = Integer.parseInt(e.data[1]);
            
            
            RectHandler.SetRect(allynum, Integer.parseInt(e.data[2]), Integer.parseInt(e.data[3]), Integer.parseInt(e.data[4]), Integer.parseInt(e.data[5]));
            MapChange();
            
        } else if (e.IsEvent("REMOVESTARTRECT")) {
            // REMOVESTARTRECT allyno
            
            RectHandler.RemoveRect(Integer.parseInt(e.data[1]));
            MapChange();
            
        }
    }
    
    boolean cansend = false;
    
    public void SendMyStatus() {
        
        if(!cansend){
            return;
        }
        
        // check sync again
        battlemodel.CheckSync();
        
        //MYBATTLESTATUS battlestatus myteamcolor
        
        String s = "MYBATTLESTATUS ";
        s += battlemodel.GetMe().getBattlestatus() + " ";
        
        int color = ColourHelper.ColorToInteger(battlemodel.GetMe().getColor()).intValue();
        s += color;
        
        if (LM.protocol != null) {
            LM.protocol.SendTraffic(s);
        }
    }

    public void UpdateBattleClients() {
        this.UpdateClientsNeeded = true;
    }

    public void DoUpdateBattleClients() {
        //UPDATEBATTLEDETAILS startingmetal startingenergy maxunits startpos gameendcondition limitdgun diminishingMMs ghostedBuildings
        
        String s = "SETSCRIPTTAGS ";
        /*= "UPDATEBATTLEDETAILS ";
        s += info.metal + " ";
        s += info.energy + " ";
        s += info.maxunits + " ";
        s += info.startPos + " ";
        s += info.gameEndCondition + " ";
        s +=  + " ";
        s +=  + " ";
        s += ;*/
        
        /*String pair = "GAME/StartMetal="+info.metal;
        s = pair;
        
        pair = "\tGAME/StartEnergy="+info.energy;
        s += pair;
        
        pair = "\tGAME/MaxUnits="+info.maxunits;
        s += pair;*/
        
        //pair = "\tGAME/StartPosType="+info.startPos;
        //s += pair;
        
        
        /*pair = "\tGAME/LimitDGun="+BooltoInt(info.limitDGun);
        s += pair;
        
        pair = "\tGAME/DiminishingMMs="+BooltoInt(info.diminishingMMs);
        s += pair;
        
        pair = "\tGAME/GhostedBuildings="+BooltoInt(info.ghostedBuildings);
        s += pair;*/
        
        Map<String,Object> options = battlemodel.GetOptions();
        
        for(String key : options.keySet()){
            //
            Object v = options.get(key);
            
            String value = "";
            if((v.getClass() == boolean.class)||(v.getClass() == Boolean.class)){
                value = ""+((v.toString().equals("true"))? 1 : 0);
            }else{
                value = v.toString();
            }
            
            key = key.replaceAll("/", "\\\\");
            
            String pair = "\t"+key+"="+value;
            s += pair;
        }
        
        
        

        //s += pair+"\t";
        

        LM.protocol.SendTraffic(s);
        UpdateClientsNeeded = false;
    }

    @SuppressWarnings(value = "unchecked")
    public void NewGUIEvent(final CEvent e) {
        
        if (e.IsEvent(CEvent.LOGGEDOUT) || e.IsEvent(CEvent.LOGOUT) || e.IsEvent(CEvent.DISCONNECTED) || e.IsEvent(CEvent.DISCONNECT)) {
            
            Runnable doWorkRunnable = new Runnable() {
                public void run() {
                    dispose();
                }
            };
            
            SwingUtilities.invokeLater(doWorkRunnable);
        
        } else if (e.IsEvent(CEvent.CONTENTREFRESH)) {
        
            MapList.removeAll();
            Object[] m = CSync.map_names.values().toArray().clone();
            Arrays.sort(m, new AlphanumComparator());
            MapList.setListData(m);
            battlemodel.CheckSync();
        
        }
    }

    void Redraw() {
        
        Runnable doWorkRunnable = new Runnable() {
            public void run() {
                playertablemodel.fireTableDataChanged();
            }
        };

        SwingUtilities.invokeLater(doWorkRunnable);
        
        /*SwingWorker worker = new SwingWorker<String, Void>() {

            @Override
            public String doInBackground() {
                
                CPlayer q = LM.playermanager.GetPlayer(info.GetHost());
                
                boolean bot = false;
                if (q != null) {
                    if (Misc.getBotModeFromStatus(q.getStatus())) {
                        bot = true; // its a bot host!!!!! Autohost!!!!!
                    }
                }
                
                Color c = chatpanel.getBackground();
                String p = "<body bgcolor=\"#" + ColourHelper.ColourToHex(c) + "\"><b>";
                
                if (!bot) {
                    p += "<font face=\"Arial\"color=\"#FFFFFF\" size=5>" + java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.HOST:") + info.GetHost() + "</font><br>\n<br>\n";
                } else {
                    URL h = getClass().getResource("/images/bot/32.png");
                    if (h != null) {
                        p += "<img src = \"" + h.toExternalForm()+"\"></img><font face=\"Arial\" color=\"#FFFFFF\">" + java.util.ResourceBundle.getBundle("aflobby/languages").getString("CBattleWindow.AUTOHOST") + info.GetHost() + "</font><br>\n<br>\n";
                    }
                }
                
                p += "</b>";

                String f1 = "<font face=\"Arial\"color=\"#FFFFFF\"><b>";
                String f2 = "</b></font>";
                p += "<table width=\"100%\" border=\"0\">";

                String darkcell = " bgcolor=\"#" + ColourHelper.ColourToHex(c.darker()) + "\"";
                
                // Header
                p += "<tr >";
                p += "<td width=\"60\"" + darkcell + "></td>";
                p += "<td width=\"40\" width=\"40\"" + darkcell + ">" + f1 + "Color" + f2 + "</td>";
                p += "<td " + darkcell + ">" + f1 + "AI/Player name" + f2 + "</td>";
                p += "<td " + darkcell + ">" + f1 + "Faction" + f2 + "</td>";
                p += "<td " + darkcell + ">" + f1 + "PlayerID" + f2 + "</td>";
                p += "<td " + darkcell + ">" + f1 + "Alliance" + f2 + "</td>";
                p += "<td " + darkcell + ">" + f1 + "Handicap" + f2 + "</td>";
                p += "<td " + darkcell + ">" + f1 + "CPU" + f2 + "</td>";
                p += "<td " + darkcell + ">" + f1 + "Ready?" + f2 + "</td>";
                p += "</tr>";
                
                //content
                boolean darker = false;
                for (CBattlePlayer a : battlemodel.GetAllPlayers()) {
                    
                    String dc;
                    
                    if (darker) {
                        dc = darkcell;
                    } else {
                        dc = "";
                    }
                    
                    darker = !darker;

                    CPlayer jp = a.getPlayerdata();
                    if (jp == null) {
                        continue;
                    }
                    
                    int sta = jp.getStatus();

                    // start row
                    p += "<tr>";

                    // Images
                    p += "<td " + dc + ">";
                    p += jp.GetSmallFlagHTML() + jp.GetRankHTML();
                    
                    if (Misc.getAccessFromStatus(sta) > 0) {
                        URL r = getClass().getResource("/images/admin.png");
                        p += "<img src = \"" + r.toExternalForm() + "\"></img>";
                    }
                    
                    p += "</td>";

                    // Colours
                    p += "<td width=\"40\" bgcolor=\"" + ColourHelper.ColourToHex(a.getColor()) + "\" width=\"40\">&nbsp;&nbsp;</td>";

                    if (!a.getAI().equals("")) {
                        // Name
                        p += "<td " + dc + ">" + f1 + "AI: " + a.getPlayername() + " AIType: " + a.getAI() + " Owner:" + a.getAIOwner() + f2 + "</td>";
                    } else {
                        // Name
                        p += "<td " + dc + ">" + f1 + a.getPlayername() + f2 + "</td>";
                    }

                    if (a.isSpec()) {
                        // Faction
                        p += "<td " + dc + "></td>";

                        //Ally
                        p += "<td " + dc + "></td>";

                        //Team
                        p += "<td " + dc + "></td>";

                        // Handicap
                        p += "<td " + dc + "></td>";
                    } else {
                        // Faction
                        p += "<td " + dc + ">" + f1 + a.getSide() + f2 + "</td>";

                        //Team
                        p += "<td " + dc + ">" + f1 + (a.getTeamNo() + 1) + f2 + "</td>";

                        //Ally
                        p += "<td " + dc + ">" + f1 + (a.getAllyNo() + 1) + f2 + "</td>";

                        // Handicap
                        p += "<td " + dc + ">" + f1 + a.getHandicap() + f2 + "</td>";
                    }
                    
                    // Synced?
                    //p += "<td " + dc + ">"+f1+a.+f2+"</td>";
                    // CPU
                    p += "<td " + dc + ">" + f1 + a.getPlayerdata().getCpu() + f2 + "</td>";

                    // Ready
                    p += "<td " + dc + ">" + f1;
                    if (a.getPlayerdata().IsIngame()) {
                        p += "INGAME";
                    } else {
                        if (a.isReady()) {
                            p += "READY";
                        } else {
                            p += "<i>NOT READY</i>";
                        }
                    }
                    
                    p += f2 + "</td>";

                    // End row
                    p += "</tr>";
                }

                p += "</table>";
                
                p += "</body>";
                return p;
            }

            @Override
            public void done() {
                try {
                    //Misc.toHTML(
                    PlayerPane.setText(get());
                } catch (ExecutionException ex) {
                    ex.printStackTrace();
                } catch (InterruptedException ex) {
                    ex.printStackTrace();
                }
            }
        };
        
        worker.execute();*/
    }
    
    // Variables declaration - do not modify//GEN-BEGIN:variables
    private javax.swing.JPanel AIColourPanel;
    private javax.swing.JComboBox AICombo;
    private javax.swing.JPanel AITab;
    private javax.swing.JButton AddAIButton;
    private javax.swing.JComboBox AddAIRaceCombo;
    private javax.swing.JButton ChMapButton;
    private aflobby.UI.CChatPanel Chat;
    private javax.swing.JButton ColourButton;
    private javax.swing.JPanel ColourPanel;
    private javax.swing.JList DisabledUnitsList;
    private javax.swing.JComboBox EditAIAllyCombo;
    private javax.swing.JComboBox EditAIRaceCombo;
    private javax.swing.JButton ExitButton;
    private javax.swing.JTabbedPane GameOptionsPane;
    private javax.swing.JCheckBox GameSpeedLockCheck;
    public javax.swing.JButton GameStartButton;
    private javax.swing.JPanel HostButtonsPanel;
    private javax.swing.JToggleButton JAutoScrollToggle;
    private javax.swing.JToggleButton LockToggle;
    private javax.swing.JList MapList;
    private javax.swing.JLabel MapPickerLabel;
    private javax.swing.JPanel MapTab;
    private javax.swing.JComboBox MyAIsCombo;
    private javax.swing.JComboBox MyAllyTeamCombo;
    private javax.swing.JComboBox MyTeamCombo;
    private javax.swing.JTextField NewAIName;
    private javax.swing.JPanel OptionsPanel;
    private javax.swing.JComboBox RaceCombo;
    public javax.swing.JToggleButton ReadyToggle;
    private javax.swing.JButton RemoveAIButton;
    private javax.swing.JButton RestrictUnitButton;
    private javax.swing.JComboBox RestrictedUnitsCombo;
    private javax.swing.JTextArea ScriptPreview;
    private javax.swing.JToggleButton SpectatorToggle;
    private javax.swing.JButton UnRestrictAllUnitsButton;
    private javax.swing.JButton UnRestrictUnitButton;
    private javax.swing.JButton UpdateAIButton;
    private javax.swing.JTextArea UserMessage;
    private aflobby.UI.CSmileyCombo cSmileyCombo1;
    private javax.swing.JPanel chatpanel;
    private javax.swing.JButton jButton1;
    private javax.swing.JButton jButton2;
    private javax.swing.JButton jButton3;
    private javax.swing.JButton jButton4;
    private javax.swing.JComboBox jComboBox5;
    private javax.swing.JLabel jLabel1;
    private javax.swing.JLabel jLabel10;
    private javax.swing.JLabel jLabel11;
    private javax.swing.JLabel jLabel12;
    private javax.swing.JLabel jLabel13;
    private javax.swing.JLabel jLabel14;
    private javax.swing.JLabel jLabel15;
    private javax.swing.JLabel jLabel16;
    private javax.swing.JLabel jLabel17;
    private javax.swing.JLabel jLabel18;
    private javax.swing.JLabel jLabel7;
    private javax.swing.JLabel jLabel8;
    private javax.swing.JLabel jLabel9;
    private javax.swing.JPanel jPanel1;
    private javax.swing.JPanel jPanel2;
    private javax.swing.JPanel jPanel5;
    private javax.swing.JPanel jPanel6;
    private javax.swing.JPanel jPanel7;
    private javax.swing.JPopupMenu jPopupMenu1;
    private javax.swing.JScrollPane jScrollPane1;
    private javax.swing.JScrollPane jScrollPane12;
    private javax.swing.JScrollPane jScrollPane2;
    private javax.swing.JScrollPane jScrollPane3;
    private javax.swing.JScrollPane jScrollPane4;
    private javax.swing.JScrollPane jScrollPane6;
    private javax.swing.JSeparator jSeparator1;
    private javax.swing.JSeparator jSeparator2;
    private javax.swing.JSplitPane jSplitPane1;
    private javax.swing.JToggleButton jToggleButton3;
    private javax.swing.JToolBar jToolBar2;
    private javax.swing.JTable playerBattleTable;
    private javax.swing.JButton reload_maplist;
    private javax.swing.JButton sayButton;
    // End of variables declaration//GEN-END:variables

    public void Init(LMain L) {
        throw new UnsupportedOperationException("Not supported yet.");
    }

    public void OnRemove() {
        //
    }
}
