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
    settings.Add("startonanylevel", false, "Autostart on any level");
    settings.SetToolTip("startonanylevel", "Start the timer on any level. By default, the timer only starts if you choose the first level.");
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
//    vars.Helper.TryLoad = (Func<dynamic, bool>)(mono =>
//    {
//        vars.Helper["isLoading"] = mono.Make<bool>("LoadingScreenManager", "sceneLoader", "_isLoading");
//        return true;
//    });
    vars.isStarted = false;
    vars.Helper.Load();
}

update {
    current.activeScene = (vars.Helper.Scenes.Active.Name == null || vars.Helper.Scenes.Active.Name == "PersistantManagers") ? current.activeScene : vars.Helper.Scenes.Active.Name;
}

isLoading
{
    return current.isLoading;
}

start
{
    if (!vars.isStarted && !current.isLoading && current.activeScene != "New_Menu") {
        if (settings["startonanylevel"] || current.activeScene == "1.1") {
            vars.isStarted = true;
            return true;
        }
    }
}

split
{
    return (current.activeScene != old.activeScene && current.activeScene != "New_Menu");
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