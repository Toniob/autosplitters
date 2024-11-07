state("River Tails - Stronger Together")
{
    bool isLoading: "UnityPlayer.dll", 0x01A22F68, 0x00, 0x508, 0x1D8, 0x00, 0x38, 0xA9;
}

startup
{
    vars.Log = (Action<object>)(output => print("[River Tails] " + output));

    Assembly.Load(File.ReadAllBytes("Components/asl-help")).CreateInstance("Unity");
    vars.Helper.GameName = "River Tails - Stronger Together";
    vars.Helper.LoadSceneManager = true;
    vars.Helper.AlertGameTime();

    // Settings
    settings.Add("autoreset", true, "Reset Automatically");
    settings.SetToolTip("autoreset", "Automatically reset if you go back to the menu");
    settings.Add("pauseoncutscene", true, "Pause on cutscene");
    settings.SetToolTip("pauseoncutscene", "Pause the In Game Timer during the cutscenes.");
    settings.Add("startonanylevel", false, "Autostart on any level");
    settings.SetToolTip("startonanylevel", "Start the timer on any level. By default, the timer only starts if you choose the first level.");

    vars.Levels = new List<string>() {
        "1.1", "1.2", "1.3", "1.4",
        "2.1", "2.2", "2.3", "2.4_BossBattle",
        "3.0 Furple", "3.0.Finn", "3.1", "3.2", "3.3",
        "4.1", "4.2", "4.3",
        "5.1", "5.2_1",
        "6.1_2", "6.4WolfBattle"
    };
    vars.IgnoredScenes = new List<string>() {
        "New_Menu",
        "05_Piranha Prince boss Fight - DELIVERY",
        "06_Not Again_DELIVERY",
        "07_The King Frog_DELIVERY",
        "08_My beloved leaf_DELIVERY",
        "09_Furple needs help_DELIVERY",
        "Wolf in the wood_DELIVERY",
        "10_Canyon_wake_Up_DELIVERY",
        "13_Jellyfish_Mum_DELIVERY",
        "17_Back_DELIVERY",
        "17.5_BattleEndWolf_DELIVERY",
        "20_We are all together DELIVERY"
    };
}

onStart {
  vars.isStarted = true;
}
onSplit {}
onReset {
  vars.isStarted = false;
}

init
{
    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
    {
        return true;
    });
    vars.isStarted = false;
    vars.Helper.Load();
    old.activeScene = current.activeScene = "";
}

update {
    current.activeScene = vars.Levels.Contains(vars.Helper.Scenes.Active.Name) || vars.IgnoredScenes.Contains(vars.Helper.Scenes.Active.Name) ? vars.Helper.Scenes.Active.Name : current.activeScene;
}

isLoading
{
    return current.isLoading || (settings["pauseoncutscene"] && vars.IgnoredScenes.Contains(current.activeScene));
}

start
{
    if (!vars.isStarted && !current.isLoading && vars.Levels.Contains(current.activeScene)) {
        if (settings["startonanylevel"] || current.activeScene == "1.1") {
            vars.isStarted = true;
            return true;
        }
    }
}

split
{
    return (current.activeScene != old.activeScene && vars.Levels.Contains(old.activeScene));
}

reset {
    if (settings["autoreset"] && old.activeScene != "New_Menu" && current.activeScene == "New_Menu") {
        vars.isStarted = false;
        return true;
    }
}

exit
{
    vars.isStarted = false;
    vars.Helper.Dispose();
}

shutdown
{
    vars.isStarted = false;
    vars.Helper.Dispose();
}