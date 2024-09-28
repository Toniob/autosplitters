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
}

onStart {}
onSplit {}
onReset {}

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
    if (!vars.isStarted && current.activeScene == "1.1" && !current.isLoading) {
        vars.isStarted = true;
        return true;
    }
}

split
{
    return (current.activeScene != old.activeScene && current.activeScene != "New_Menu");
}

reset {
    if (old.activeScene != "New_Menu" && current.activeScene == "New_Menu") {
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