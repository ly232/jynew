using System;
using System.Linq;
using Cysharp.Threading.Tasks;
using Jyx2;
using Jyx2.MOD.ModV2;
using UnityEditor;
using UnityEditor.SceneManagement;
using UnityEngine;

public static class Jyx2ModSmokeTest
{
    private const string PendingKey = "Jyx2ModSmokeTest.Pending";
    private const string StartedKey = "Jyx2ModSmokeTest.Started";
    private const string ModIdKey = "Jyx2ModSmokeTest.ModId";

    public static void LoadModFromCommandLine()
    {
        RunLoadModSmokeTest().Forget();
    }

    public static void LoadModInPlayModeFromCommandLine()
    {
        var modId = GetArgValue("-modId") ?? "jshyl";
        Debug.Log($"[Jyx2ModSmokeTest] Preparing play mode smoke test for mod: {modId}");

        SessionState.SetBool(PendingKey, true);
        SessionState.SetBool(StartedKey, false);
        SessionState.SetString(ModIdKey, modId);

        EditorSceneManager.OpenScene("Assets/0_MODLoaderScene.unity");
        RegisterPlayModeRunner();
        EditorApplication.EnterPlaymode();
    }

    [InitializeOnLoadMethod]
    private static void RegisterPendingPlayModeRunner()
    {
        if (SessionState.GetBool(PendingKey, false))
        {
            RegisterPlayModeRunner();
        }
    }

    private static void RegisterPlayModeRunner()
    {
        EditorApplication.playModeStateChanged -= OnPlayModeStateChanged;
        EditorApplication.playModeStateChanged += OnPlayModeStateChanged;
        EditorApplication.update -= StartIfAlreadyPlaying;
        EditorApplication.update += StartIfAlreadyPlaying;
    }

    private static void OnPlayModeStateChanged(PlayModeStateChange state)
    {
        if (state == PlayModeStateChange.EnteredPlayMode)
        {
            StartPlayModeSmokeTest();
        }
    }

    private static void StartIfAlreadyPlaying()
    {
        if (EditorApplication.isPlaying)
        {
            StartPlayModeSmokeTest();
        }
    }

    private static void StartPlayModeSmokeTest()
    {
        if (!SessionState.GetBool(PendingKey, false) || SessionState.GetBool(StartedKey, false))
        {
            return;
        }

        SessionState.SetBool(StartedKey, true);
        RunLoadModSmokeTest(SessionState.GetString(ModIdKey, "jshyl")).Forget();
    }

    private static async UniTaskVoid RunLoadModSmokeTest()
    {
        await RunLoadModSmokeTest(GetArgValue("-modId") ?? "jshyl");
    }

    private static async UniTask RunLoadModSmokeTest(string modId)
    {
        try
        {
            Debug.Log($"[Jyx2ModSmokeTest] Loading mod: {modId}");

            RuntimeEnvSetup.ForceClear();

            var mod = new GameModEditorLoader()
                .LoadModsSync()
                .FirstOrDefault(m => string.Equals(m.Id, modId, StringComparison.OrdinalIgnoreCase));

            if (mod == null)
            {
                throw new Exception($"Cannot find mod '{modId}' under Assets/Mods.");
            }

            RuntimeEnvSetup.SetCurrentMod(mod);

            var setupStarted = await RuntimeEnvSetup.Setup();
            if (!setupStarted || RuntimeEnvSetup.CurrentModConfig == null)
            {
                throw new Exception($"RuntimeEnvSetup.Setup failed for mod '{modId}'.");
            }

            if (LuaToCsBridge.CharacterTable == null || LuaToCsBridge.CharacterTable.Count == 0)
            {
                throw new Exception("CharacterTable was not initialized.");
            }

            if (LuaToCsBridge.SettingsTable == null || LuaToCsBridge.SettingsTable.Count == 0)
            {
                throw new Exception("SettingsTable was not initialized.");
            }

            if (LuaToCsBridge.MapTable == null || LuaToCsBridge.MapTable.Count == 0)
            {
                throw new Exception("MapTable was not initialized.");
            }

            var startMap = LuaToCsBridge.MapTable[0].GetGameStartMap();
            if (startMap == null)
            {
                throw new Exception("No START map was found in MapTable[0].");
            }

            Debug.Log($"[Jyx2ModSmokeTest] Loaded mod '{RuntimeEnvSetup.CurrentModConfig.ModId}' successfully. Start map: {startMap.GetShowName()} ({startMap.MapScene})");
            SessionState.EraseBool(PendingKey);
            SessionState.EraseBool(StartedKey);
            SessionState.EraseString(ModIdKey);
            EditorApplication.Exit(0);
        }
        catch (Exception ex)
        {
            Debug.LogError("[Jyx2ModSmokeTest] Failed.");
            Debug.LogError(ex.ToString());
            SessionState.EraseBool(PendingKey);
            SessionState.EraseBool(StartedKey);
            SessionState.EraseString(ModIdKey);
            EditorApplication.Exit(1);
        }
    }

    private static string GetArgValue(string name)
    {
        var args = Environment.GetCommandLineArgs();
        for (var i = 0; i < args.Length - 1; i++)
        {
            if (args[i] == name)
            {
                return args[i + 1];
            }
        }

        return null;
    }
}
