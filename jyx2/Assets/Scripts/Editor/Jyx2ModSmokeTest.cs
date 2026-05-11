using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text.RegularExpressions;
using Cysharp.Threading.Tasks;
using Jyx2;
using Jyx2.MOD.ModV2;
using UnityEditor;
using UnityEditor.AI;
using UnityEditor.SceneManagement;
using UnityEngine;
using UnityEngine.AI;
using UnityEngine.SceneManagement;

public static class Jyx2ModSmokeTest
{
    private const string PendingKey = "Jyx2ModSmokeTest.Pending";
    private const string StartedKey = "Jyx2ModSmokeTest.Started";
    private const string ModIdKey = "Jyx2ModSmokeTest.ModId";
    private const string JshylStartScene = "52_yanziwu";
    private static bool s_BattleWatchdogActive;
    private static float s_BattleWatchdogStartedAt;
    private static int s_BattleWatchdogBattleId;
    private static string s_BattleWatchdogBattleName;
    private static string s_BattleWatchdogBattleScene;

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

    public static void ValidateStartSceneFromCommandLine()
    {
        try
        {
            var modId = GetArgValue("-modId") ?? "jshyl";
            Debug.Log($"[Jyx2ModSmokeTest] Validating start scene asset for mod: {modId}");

            ValidateStartSceneAsset(modId);

            Debug.Log($"[Jyx2ModSmokeTest] Start scene asset validation passed for '{modId}'.");
            EditorApplication.Exit(0);
        }
        catch (Exception ex)
        {
            Debug.LogError("[Jyx2ModSmokeTest] Start scene asset validation failed.");
            Debug.LogError(ex.ToString());
            EditorApplication.Exit(1);
        }
    }

    public static void RunJshylBasicGameplayChecksFromCommandLine()
    {
        try
        {
            var modId = GetArgValue("-modId") ?? "jshyl";
            Debug.Log($"[Jyx2ModSmokeTest] Running basic gameplay checks for mod: {modId}");

            ValidateModLoaderSceneAsset();
            ValidateEditorModIsDiscoverable(modId);
            ValidateJshylStartScene(modId);
            ValidateGhostShadowShader();
            ValidateStartSceneAsset(modId);
            ValidateSceneEventLuaFilesForScene(modId, $"Assets/Mods/{modId}/Maps/GameMaps/{JshylStartScene}.unity");
            ValidateSceneEventLuaFilesForScene(modId, $"Assets/Mods/{modId}/Maps/GameMaps/67_shandong.unity");
            ValidateSceneEventLuaFilesForScene(modId, $"Assets/Mods/{modId}/Maps/GameMaps/04_kunlunxianjing.unity");
            ValidateJshylLuaUsesExposedFlagApi(modId);
            ValidateHongyanMaxedPlayerOpening(modId);
            ValidateHongyanOpeningAssets(modId);
            ValidateKunlunHongyanStoryAssets(modId);
            ValidateJshylBattleSkillDisplayAssets(modId);

            Debug.Log($"[Jyx2ModSmokeTest] Basic gameplay checks passed for '{modId}'.");
            EditorApplication.Exit(0);
        }
        catch (Exception ex)
        {
            Debug.LogError("[Jyx2ModSmokeTest] Basic gameplay checks failed.");
            Debug.LogError(ex.ToString());
            EditorApplication.Exit(1);
        }
    }

    public static void AlignJshylStartScenePlayerFromCommandLine()
    {
        try
        {
            var modId = GetArgValue("-modId") ?? "jshyl";
            var scenePath = $"Assets/Mods/{modId}/Maps/GameMaps/{JshylStartScene}.unity";
            EditorSceneManager.OpenScene(scenePath);

            var player = RoleHelper.FindPlayer();
            var start = GameObject.Find("Level/Triggers/0") ?? GameObject.Find("Level/Dynamic/0");
            if (player == null || start == null)
            {
                throw new Exception("Cannot align player because player or START:0 trigger is missing.");
            }

            player.transform.position = start.transform.position;
            EditorSceneManager.MarkSceneDirty(SceneManager.GetActiveScene());
            EditorSceneManager.SaveScene(SceneManager.GetActiveScene());

            Debug.Log($"[Jyx2ModSmokeTest] Aligned '{modId}' start-scene player to START:0 at {start.transform.position}.");
            EditorApplication.Exit(0);
        }
        catch (Exception ex)
        {
            Debug.LogError("[Jyx2ModSmokeTest] Failed to align start-scene player.");
            Debug.LogError(ex.ToString());
            EditorApplication.Exit(1);
        }
    }

    public static void ConfigureJshylOpeningSceneFromCommandLine()
    {
        try
        {
            var modId = GetArgValue("-modId") ?? "jshyl";
            var scenePath = $"Assets/Mods/{modId}/Maps/GameMaps/{JshylStartScene}.unity";
            if (!File.Exists(scenePath))
            {
                File.Copy($"Assets/Mods/JYX2/Maps/GameMaps/{JshylStartScene}.unity", scenePath);
                AssetDatabase.ImportAsset(scenePath);
            }

            EditorSceneManager.OpenScene(scenePath);
            var level = GameObject.Find("Level") ?? new GameObject("Level");
            var triggers = EnsureChild(level.transform, "Triggers");
            var npcRoot = EnsureChild(level.transform, "NPC");

            foreach (var evt in UnityEngine.Object.FindObjectsOfType<GameEvent>())
            {
                if (!evt.name.StartsWith("jshyl_", StringComparison.Ordinal))
                {
                    evt.m_InteractiveEventId = "-1";
                    evt.m_UseItemEventId = "-1";
                    evt.m_EnterEventId = "-1";
                }
            }

            EnsureStartTrigger(triggers);
            OpenYanziwuDoors();
            var binvPrefab = "Assets/BuildSource/ModelCharacters/BattleNpc/OuyangkeBinv.prefab";
            var murong = EnsureNpc(npcRoot, "慕容秋荻", "Assets/BuildSource/ModelCharacters/BattleNpc/Wangyuyan.prefab", new Vector3(-18.0f, 5.5f, 27.2f));
            var meng = EnsureNpc(npcRoot, "孟星魂", "Assets/BuildSource/ModelCharacters/BattleNpc/Linghuchong.prefab", new Vector3(-13.6f, 5.5f, 30.8f));
            var shuang = EnsureNpc(npcRoot, "双儿", binvPrefab, new Vector3(-27.5f, 5.5f, 29.0f));
            var azhu = EnsureNpc(npcRoot, "阿朱", binvPrefab, new Vector3(-8.8f, 5.5f, 28.8f));
            var abi = EnsureNpc(npcRoot, "阿碧", binvPrefab, new Vector3(-24.8f, 5.5f, 19.2f));
            var shijian = EnsureNpc(npcRoot, "侍剑", "Assets/BuildSource/ModelCharacters/BattleNpc/Chengying.prefab", new Vector3(-8.6f, 5.5f, 40.5f));
            var chest = EnsureChest(npcRoot, FindExistingPosition(npcRoot, "三万两宝箱", new Vector3(-30.0f, 5.1f, 27.4f)));

            LiftOuyangkeMaidNpc(shuang);
            LiftOuyangkeMaidNpc(azhu);
            LiftOuyangkeMaidNpc(abi);

            EnsureInteractiveEvent(triggers, "jshyl_murong_opening", "5200", murong, murong.transform.position);
            EnsureInteractiveEvent(triggers, "jshyl_shuanger_rest", "5201", shuang, shuang.transform.position);
            EnsureInteractiveEvent(triggers, "jshyl_yanzi_treasure", "5202", chest, chest.transform.position);
            EnsureInteractiveEvent(triggers, "jshyl_azhu_hint", "5203", azhu, azhu.transform.position);
            EnsureInteractiveEvent(triggers, "jshyl_abi_hint", "5204", abi, abi.transform.position);
            EnsureInteractiveEvent(triggers, "jshyl_shijian_training", "5205", shijian, shijian.transform.position);

            UnityEditor.AI.NavMeshBuilder.BuildNavMesh();

            EditorSceneManager.MarkSceneDirty(SceneManager.GetActiveScene());
            EditorSceneManager.SaveScene(SceneManager.GetActiveScene());

            Debug.Log($"[Jyx2ModSmokeTest] Configured Hongyan opening scene in '{scenePath}'.");
            EditorApplication.Exit(0);
        }
        catch (Exception ex)
        {
            Debug.LogError("[Jyx2ModSmokeTest] Failed to configure Hongyan opening scene.");
            Debug.LogError(ex.ToString());
            EditorApplication.Exit(1);
        }
    }

    public static void ConfigureJshylWorldMapOpeningSpawnFromCommandLine()
    {
        try
        {
            var modId = GetArgValue("-modId") ?? "jshyl";
            var scenePath = $"Assets/Mods/{modId}/Maps/GameMaps/1000_daditu.unity";
            EditorSceneManager.OpenScene(scenePath);

            var level = GameObject.Find("Level") ?? new GameObject("Level");
            var triggers = EnsureChild(level.transform, "Triggers");
            var spawn = triggers.Find("燕子坞")?.gameObject ?? new GameObject("燕子坞");
            spawn.transform.SetParent(triggers, false);

            var yanziwu = triggers.Find("燕子坞") ??
                          UnityEngine.Object.FindObjectsOfType<MapTeleportor>()
                              .FirstOrDefault(t => t.gameObject.name == "燕子坞")?.transform;
            if (yanziwu != null)
            {
                spawn.transform.position = yanziwu.position;
                spawn.transform.rotation = yanziwu.rotation;
            }
            else
            {
                var player = RoleHelper.FindPlayer();
                spawn.transform.position = player != null ? player.transform.position : Vector3.zero;
                spawn.transform.rotation = Quaternion.identity;
            }

            EditorSceneManager.MarkSceneDirty(SceneManager.GetActiveScene());
            EditorSceneManager.SaveScene(SceneManager.GetActiveScene());

            Debug.Log($"[Jyx2ModSmokeTest] Configured world-map spawn point '燕子坞' in '{scenePath}'.");
            EditorApplication.Exit(0);
        }
        catch (Exception ex)
        {
            Debug.LogError("[Jyx2ModSmokeTest] Failed to configure world-map opening spawn.");
            Debug.LogError(ex.ToString());
            EditorApplication.Exit(1);
        }
    }

    private static Transform EnsureChild(Transform parent, string name)
    {
        var child = parent.Find(name);
        if (child != null)
        {
            return child;
        }

        var go = new GameObject(name);
        go.transform.SetParent(parent, false);
        return go.transform;
    }

    private static void EnsureStartTrigger(Transform triggers)
    {
        var start = triggers.Find("0")?.gameObject ?? new GameObject("0");
        start.transform.SetParent(triggers, false);
        start.transform.position = new Vector3(-18.0f, 5.5f, 30.2f);
        start.transform.localScale = Vector3.one;

        var collider = start.GetComponent<BoxCollider>();
        if (collider == null)
        {
            collider = start.AddComponent<BoxCollider>();
        }
        collider.size = new Vector3(1.5f, 1.0f, 1.5f);
        collider.center = Vector3.zero;
    }

    private static void OpenYanziwuDoors()
    {
        foreach (var transform in UnityEngine.Object.FindObjectsOfType<Transform>(true))
        {
            if (transform.name.IndexOf("Door", StringComparison.OrdinalIgnoreCase) < 0 &&
                transform.name.IndexOf("门", StringComparison.Ordinal) < 0)
            {
                continue;
            }

            foreach (var collider in transform.GetComponentsInChildren<Collider>(true))
            {
                collider.enabled = false;
            }

            foreach (var obstacle in transform.GetComponentsInChildren<NavMeshObstacle>(true))
            {
                obstacle.enabled = false;
            }
        }
    }

    private static void RebuildHongyanOpeningWing(Transform dynamicRoot)
    {
        var oldWing = dynamicRoot.Find("jshyl_HongyanOpeningWing");
        if (oldWing != null)
        {
            UnityEngine.Object.DestroyImmediate(oldWing.gameObject);
        }

        var wing = new GameObject("jshyl_HongyanOpeningWing");
        wing.transform.SetParent(dynamicRoot, false);
        var floorMaterial = FindSceneMaterial("Wood") ?? FindSceneMaterial("Floor");
        var wallMaterial = FindSceneMaterial("Wall") ?? floorMaterial;

        CreateRoomFloor(wing.transform, "main_hall_floor", new Vector3(-18f, 5.02f, 29f), new Vector3(12f, 0.2f, 8f), floorMaterial);
        CreateRoomFloor(wing.transform, "shuanger_room_floor", new Vector3(-28f, 5.02f, 28f), new Vector3(8f, 0.2f, 7f), floorMaterial);
        CreateRoomFloor(wing.transform, "azhu_room_floor", new Vector3(-8.5f, 5.02f, 28f), new Vector3(8f, 0.2f, 7f), floorMaterial);
        CreateRoomFloor(wing.transform, "abi_room_floor", new Vector3(-24f, 5.02f, 19f), new Vector3(8f, 0.2f, 7f), floorMaterial);
        CreateRoomFloor(wing.transform, "shuige_floor", new Vector3(-9f, 5.02f, 40f), new Vector3(9f, 0.2f, 8f), floorMaterial);
        CreateRoomFloor(wing.transform, "front_walkway", new Vector3(-13.5f, 5.02f, 47f), new Vector3(5f, 0.2f, 18f), floorMaterial);

        CreateLowWall(wing.transform, "main_back_wall", new Vector3(-18f, 5.7f, 33f), new Vector3(12f, 1.4f, 0.25f), wallMaterial);
        CreateLowWall(wing.transform, "shuanger_back_wall", new Vector3(-28f, 5.7f, 31.5f), new Vector3(8f, 1.4f, 0.25f), wallMaterial);
        CreateLowWall(wing.transform, "azhu_back_wall", new Vector3(-8.5f, 5.7f, 31.5f), new Vector3(8f, 1.4f, 0.25f), wallMaterial);
        CreateLowWall(wing.transform, "abi_back_wall", new Vector3(-24f, 5.7f, 15.5f), new Vector3(8f, 1.4f, 0.25f), wallMaterial);
        CreateLowWall(wing.transform, "shuige_back_wall", new Vector3(-9f, 5.7f, 44f), new Vector3(9f, 1.4f, 0.25f), wallMaterial);
        CreateLowWall(wing.transform, "left_partition", new Vector3(-23f, 5.7f, 28.2f), new Vector3(0.25f, 1.4f, 5.5f), wallMaterial);
        CreateLowWall(wing.transform, "right_partition", new Vector3(-13f, 5.7f, 28.2f), new Vector3(0.25f, 1.4f, 5.5f), wallMaterial);

        var leave = UnityEngine.Object.FindObjectsOfType<MapTeleportor>(true)
            .FirstOrDefault(t => t.gameObject.name == "Leave");
        if (leave != null)
        {
            leave.transform.position = new Vector3(-13.5f, 5.25f, 55.0f);
            leave.transform.localScale = new Vector3(4f, 1f, 3f);
            var collider = leave.GetComponent<BoxCollider>();
            if (collider != null)
            {
                collider.enabled = true;
                collider.isTrigger = false;
            }
        }
    }

    private static Material FindSceneMaterial(string namePart)
    {
        return UnityEngine.Object.FindObjectsOfType<Renderer>(true)
            .SelectMany(r => r.sharedMaterials)
            .FirstOrDefault(m => m != null && m.name.IndexOf(namePart, StringComparison.OrdinalIgnoreCase) >= 0);
    }

    private static GameObject CreateRoomFloor(Transform parent, string name, Vector3 position, Vector3 scale, Material material)
    {
        var go = GameObject.CreatePrimitive(PrimitiveType.Cube);
        go.name = name;
        go.transform.SetParent(parent, false);
        go.transform.position = position;
        go.transform.localScale = scale;
        ApplyMaterial(go, material);
        GameObjectUtility.SetStaticEditorFlags(go, StaticEditorFlags.BatchingStatic | StaticEditorFlags.NavigationStatic);
        return go;
    }

    private static GameObject CreateLowWall(Transform parent, string name, Vector3 position, Vector3 scale, Material material)
    {
        var go = GameObject.CreatePrimitive(PrimitiveType.Cube);
        go.name = name;
        go.transform.SetParent(parent, false);
        go.transform.position = position;
        go.transform.localScale = scale;
        ApplyMaterial(go, material);
        GameObjectUtility.SetStaticEditorFlags(go, StaticEditorFlags.BatchingStatic);
        return go;
    }

    private static void ApplyMaterial(GameObject go, Material material)
    {
        if (material == null)
        {
            return;
        }

        var renderer = go.GetComponent<Renderer>();
        if (renderer != null)
        {
            renderer.sharedMaterial = material;
        }
    }

    private static GameObject EnsureNpc(Transform parent, string name, string prefabPath, Vector3 position)
    {
        var existing = parent.Find(name) ?? GameObject.Find(name)?.transform;
        if (existing != null)
        {
            position = existing.position;
            var rotation = existing.rotation;
            var scale = existing.localScale;
            var siblingIndex = existing.GetSiblingIndex();
            UnityEngine.Object.DestroyImmediate(existing.gameObject);
            return InstantiateNamedPrefab(parent, name, prefabPath, position, rotation, scale, siblingIndex);
        }

        return InstantiateNamedPrefab(parent, name, prefabPath, position, Quaternion.Euler(0, 180, 0), Vector3.one, -1);
    }

    private static GameObject InstantiateNamedPrefab(Transform parent, string name, string prefabPath, Vector3 position,
        Quaternion rotation, Vector3 scale, int siblingIndex)
    {
        var prefab = AssetDatabase.LoadAssetAtPath<GameObject>(prefabPath);
        if (prefab == null)
        {
            throw new Exception($"Cannot load NPC prefab '{prefabPath}' for '{name}'.");
        }

        var npc = (GameObject)PrefabUtility.InstantiatePrefab(prefab, parent);
        npc.name = name;
        npc.transform.position = position;
        npc.transform.rotation = rotation;
        npc.transform.localScale = scale == Vector3.zero ? Vector3.one : scale;
        if (siblingIndex >= 0)
        {
            npc.transform.SetSiblingIndex(siblingIndex);
        }
        return npc;
    }

    private static Vector3 FindExistingPosition(Transform parent, string name, Vector3 fallback)
    {
        var existing = parent.Find(name) ?? GameObject.Find(name)?.transform;
        return existing != null ? existing.position : fallback;
    }

    private static void LiftOuyangkeMaidNpc(GameObject npc)
    {
        var position = npc.transform.position;
        if (position.y < 6.45f)
        {
            npc.transform.position = new Vector3(position.x, 6.5f, position.z);
        }
        npc.transform.localScale = Vector3.one;
    }

    private static GameObject EnsureChest(Transform parent, Vector3 position)
    {
        var existing = parent.Find("三万两宝箱");
        if (existing != null)
        {
            existing.position = position;
            return existing.gameObject;
        }

        var chest = GameObject.CreatePrimitive(PrimitiveType.Cube);
        chest.name = "三万两宝箱";
        chest.transform.SetParent(parent, false);
        chest.transform.position = position;
        chest.transform.localScale = new Vector3(0.9f, 0.55f, 0.7f);
        return chest;
    }

    private static void EnsureInteractiveEvent(Transform triggers, string name, string eventId, GameObject target, Vector3 position)
    {
        var go = triggers.Find(name)?.gameObject ?? new GameObject(name);
        go.transform.SetParent(triggers, false);
        go.transform.position = position;
        go.transform.localScale = Vector3.one;

        var collider = go.GetComponent<BoxCollider>();
        if (collider == null)
        {
            collider = go.AddComponent<BoxCollider>();
        }
        collider.size = new Vector3(2.0f, 2.0f, 2.0f);
        collider.center = new Vector3(0, 1.0f, 0);

        var evt = go.GetComponent<GameEvent>();
        if (evt == null)
        {
            evt = go.AddComponent<GameEvent>();
        }
        evt.m_EventTargets = new[] { target };
        evt.m_InteractiveEventId = eventId;
        evt.m_UseItemEventId = "-1";
        evt.m_EnterEventId = "-1";
    }

    public static void AlignJshylKunlunAqingFromCommandLine()
    {
        try
        {
            var modId = GetArgValue("-modId") ?? "jshyl";
            var scenePath = $"Assets/Mods/{modId}/Maps/GameMaps/04_kunlunxianjing.unity";
            EditorSceneManager.OpenScene(scenePath);

            var npcRoot = GameObject.Find("Level/NPC") ?? GameObject.Find("NPC");
            if (npcRoot == null)
            {
                throw new Exception("Cannot find NPC root in Kunlun scene.");
            }

            Vector3 localPosition = Vector3.zero;
            Quaternion localRotation = Quaternion.identity;
            Vector3 localScale = Vector3.one;

            var aqingEvent = UnityEngine.Object.FindObjectsOfType<GameEvent>()
                .FirstOrDefault(e => e.m_InteractiveEventId == "70");
            if (aqingEvent == null)
            {
                throw new Exception("Cannot find A-Qing interactive event 70 in Kunlun scene.");
            }

            if (npcRoot.transform.childCount > 0)
            {
                var oldNpc = npcRoot.transform.GetChild(0);
                localPosition = oldNpc.localPosition;
                localRotation = oldNpc.localRotation;
                localScale = oldNpc.localScale;
                UnityEngine.Object.DestroyImmediate(oldNpc.gameObject);
            }

            if (localPosition == Vector3.zero)
            {
                localPosition = npcRoot.transform.InverseTransformPoint(aqingEvent.transform.position);
            }

            var prefab = AssetDatabase.LoadAssetAtPath<GameObject>("Assets/BuildSource/ModelCharacters/BattleNpc/Chengying.prefab");
            if (prefab == null)
            {
                throw new Exception("Cannot load Chengying prefab for A-Qing placeholder.");
            }

            var aqing = (GameObject)PrefabUtility.InstantiatePrefab(prefab, npcRoot.transform);
            aqing.name = "阿青";
            aqing.transform.localPosition = localPosition;
            aqing.transform.localRotation = localRotation;
            aqing.transform.localScale = localScale;

            aqingEvent.m_EventTargets = new[] { aqing };

            EditorSceneManager.MarkSceneDirty(SceneManager.GetActiveScene());
            EditorSceneManager.SaveScene(SceneManager.GetActiveScene());

            Debug.Log($"[Jyx2ModSmokeTest] Replaced Kunlun NPC with A-Qing placeholder in '{scenePath}'.");
            EditorApplication.Exit(0);
        }
        catch (Exception ex)
        {
            Debug.LogError("[Jyx2ModSmokeTest] Failed to align Kunlun A-Qing NPC.");
            Debug.LogError(ex.ToString());
            EditorApplication.Exit(1);
        }
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
        EditorApplication.update -= BattleLoadWatchdogUpdate;
        EditorApplication.update += BattleLoadWatchdogUpdate;
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
        if (EditorApplication.isPlaying && Application.isPlaying)
        {
            StartPlayModeSmokeTest();
        }
    }

    private static void StartPlayModeSmokeTest()
    {
        if (!Application.isPlaying)
        {
            return;
        }

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

            if (!HasArg("-skipStartMap"))
            {
                await LoadAndValidateStartMap(startMap);
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

    private static async UniTask LoadAndValidateStartMap(LMapConfig startMap)
    {
        GameRuntimeData.CreateNew();

        var loadPara = new LevelMaster.LevelLoadPara
        {
            loadType = LevelMaster.LevelLoadPara.LevelLoadType.StartAtTrigger,
            triggerName = "0"
        };

        var startTrigger = startMap.GetTagValue("START");
        if (!string.IsNullOrEmpty(startTrigger))
        {
            loadPara.triggerName = startTrigger;
        }

        var loaded = false;
        LevelLoader.LoadGameMap(startMap, loadPara, () => loaded = true);

        await WaitUntilOrThrow(() => loaded, "Timed out while loading the start map.");
        await WaitUntilOrThrow(() => LevelMaster.Instance != null && LevelMaster.Instance.IsInited, "Timed out waiting for LevelMaster initialization.");
        await UniTask.DelayFrame(2);

        if (SceneManager.GetActiveScene().name != startMap.MapScene)
        {
            throw new Exception($"Expected active scene '{startMap.MapScene}', got '{SceneManager.GetActiveScene().name}'.");
        }

        var player = LevelMaster.Instance.GetPlayer();
        if (player == null)
        {
            throw new Exception("LevelMaster did not bind a player.");
        }

        if (!player.gameObject.activeInHierarchy)
        {
            throw new Exception("Player object is inactive in the loaded map.");
        }

        ValidateLoadedScenePlayer(loadPara.triggerName, player);

        Debug.Log($"[Jyx2ModSmokeTest] Start map loaded with active player renderers. Scene: {startMap.MapScene}, spawn: {loadPara.triggerName}");

        if (HasArg("-validateLeave") || HasArg("-validateKunlunTeleport"))
        {
            await LoadAndValidateLeaveTransport(startMap);
        }

        if (HasArg("-validateKunlunTeleport"))
        {
            await LoadAndValidateWorldMapTeleport("昆仑山洞", 67);
            await LoadAndValidateLocalTeleport("Leave2", 4);
            if (HasArg("-validateKunlunBattle"))
            {
                await LoadAndValidateBattleScene(140);
            }
        }

        if (HasArg("-validateStory"))
        {
            await LoadAndValidateStoryMap(4, "0");
        }
    }

    private static async UniTask LoadAndValidateLeaveTransport(LMapConfig startMap)
    {
        var leaveTeleportor = UnityEngine.Object.FindObjectsOfType<MapTeleportor>()
            .FirstOrDefault(t => t.gameObject.name == "Leave");
        if (leaveTeleportor == null)
        {
            throw new Exception("Start map is missing a Leave MapTeleportor.");
        }

        var destinationId = startMap.GetTransportToMapValue("Leave");
        if (!LuaToCsBridge.MapTable.TryGetValue(destinationId, out var destinationMap))
        {
            throw new Exception($"Leave transport target map '{destinationId}' is not configured.");
        }

        leaveTeleportor.DoTransport();

        await WaitUntilOrThrow(() => SceneManager.GetActiveScene().name == destinationMap.MapScene,
            $"Timed out while leaving start map for '{destinationMap.MapScene}'.");
        await WaitUntilOrThrow(() => LevelMaster.Instance != null && LevelMaster.Instance.IsInited,
            "Timed out waiting for LevelMaster after leaving start map.");
        await UniTask.DelayFrame(2);

        var player = LevelMaster.Instance.GetPlayer();
        if (player == null || !player.gameObject.activeInHierarchy)
        {
            throw new Exception("Player is missing or inactive after leaving the start map.");
        }

        Debug.Log($"[Jyx2ModSmokeTest] Leave transport loaded destination map: {destinationMap.GetShowName()} ({destinationMap.MapScene})");
    }

    private static async UniTask LoadAndValidateWorldMapTeleport(string teleportorName, int expectedMapId)
    {
        var curMap = LevelMaster.GetCurrentGameMap();
        if (curMap == null || !curMap.Tags.Contains("WORLDMAP"))
        {
            throw new Exception($"Expected to be on world map before entering '{teleportorName}', got '{curMap?.Name ?? "<null>"}'.");
        }

        if (!LuaToCsBridge.MapTable.TryGetValue(expectedMapId, out var destinationMap))
        {
            throw new Exception($"Expected world-map destination '{expectedMapId}' is not configured.");
        }

        var teleportors = UnityEngine.Object.FindObjectsOfType<MapTeleportor>();
        var worldMapTeleportor = teleportors.FirstOrDefault(t => t.gameObject.name == teleportorName);
        if (worldMapTeleportor == null)
        {
            var names = string.Join(", ", teleportors.Select(t => t.gameObject.name).OrderBy(n => n));
            throw new Exception($"World map is missing teleportor '{teleportorName}'. Available teleportors: {names}");
        }

        var resolvedMap = LuaToCsBridge.MapTable[0].GetMapByName(teleportorName);
        if (resolvedMap == null || resolvedMap.Id != expectedMapId)
        {
            throw new Exception($"World-map teleportor '{teleportorName}' resolved to '{resolvedMap?.Id.ToString() ?? "<null>"}' instead of '{expectedMapId}'.");
        }

        worldMapTeleportor.DoTransport();

        await WaitUntilOrThrow(() => SceneManager.GetActiveScene().name == destinationMap.MapScene,
            $"Timed out while entering '{teleportorName}' from world map. Active scene: {SceneManager.GetActiveScene().name}");
        await WaitUntilOrThrow(() => LevelMaster.Instance != null && LevelMaster.Instance.IsInited,
            $"Timed out waiting for LevelMaster after entering '{teleportorName}'.");
        await UniTask.DelayFrame(10);

        if (SceneManager.GetActiveScene().name != destinationMap.MapScene)
        {
            throw new Exception($"Entering '{teleportorName}' did not stay on '{destinationMap.MapScene}'. Active scene: {SceneManager.GetActiveScene().name}");
        }

        curMap = LevelMaster.GetCurrentGameMap();
        if (curMap == null || curMap.Id != expectedMapId)
        {
            throw new Exception($"Entering '{teleportorName}' loaded wrong map config: {curMap?.Name ?? "<null>"} ({curMap?.Id.ToString() ?? "<null>"}).");
        }

        var player = LevelMaster.Instance.GetPlayer();
        if (player == null || !player.gameObject.activeInHierarchy)
        {
            throw new Exception($"Player is missing or inactive after entering '{teleportorName}'.");
        }

        Debug.Log($"[Jyx2ModSmokeTest] World-map teleport '{teleportorName}' loaded destination map: {destinationMap.GetShowName()} ({destinationMap.MapScene})");
    }

    private static async UniTask LoadAndValidateLocalTeleport(string teleportorName, int expectedMapId)
    {
        var curMap = LevelMaster.GetCurrentGameMap();
        if (curMap == null || curMap.Tags.Contains("WORLDMAP"))
        {
            throw new Exception($"Expected to be on a local map before using '{teleportorName}', got '{curMap?.Name ?? "<null>"}'.");
        }

        if (!LuaToCsBridge.MapTable.TryGetValue(expectedMapId, out var destinationMap))
        {
            throw new Exception($"Expected local teleport destination '{expectedMapId}' is not configured.");
        }

        var localTeleportor = UnityEngine.Object.FindObjectsOfType<MapTeleportor>()
            .FirstOrDefault(t => t.gameObject.name == teleportorName);
        if (localTeleportor == null)
        {
            var names = string.Join(", ", UnityEngine.Object.FindObjectsOfType<MapTeleportor>()
                .Select(t => t.gameObject.name)
                .OrderBy(n => n));
            throw new Exception($"Local map '{curMap.Name}' is missing teleportor '{teleportorName}'. Available teleportors: {names}");
        }

        localTeleportor.DoTransport();

        await WaitUntilOrThrow(() => SceneManager.GetActiveScene().name == destinationMap.MapScene,
            $"Timed out while using local teleport '{teleportorName}'. Active scene: {SceneManager.GetActiveScene().name}");
        await WaitUntilOrThrow(() => LevelMaster.Instance != null && LevelMaster.Instance.IsInited,
            $"Timed out waiting for LevelMaster after local teleport '{teleportorName}'.");
        await UniTask.DelayFrame(10);

        curMap = LevelMaster.GetCurrentGameMap();
        if (SceneManager.GetActiveScene().name != destinationMap.MapScene || curMap == null || curMap.Id != expectedMapId)
        {
            throw new Exception($"Local teleport '{teleportorName}' loaded wrong destination: {curMap?.Name ?? "<null>"} ({SceneManager.GetActiveScene().name}).");
        }

        var player = LevelMaster.Instance.GetPlayer();
        if (player == null || !player.gameObject.activeInHierarchy)
        {
            throw new Exception($"Player is missing or inactive after local teleport '{teleportorName}'.");
        }

        Debug.Log($"[Jyx2ModSmokeTest] Local teleport '{teleportorName}' loaded destination map: {destinationMap.GetShowName()} ({destinationMap.MapScene})");
    }

    private static async UniTask LoadAndValidateBattleScene(int battleId)
    {
        if (!LuaToCsBridge.BattleTable.TryGetValue(battleId, out var battle))
        {
            throw new Exception($"Battle '{battleId}' is not configured.");
        }

        var callbackReached = false;
        StartBattleLoadWatchdog(battleId, battle.Name, battle.MapScene);
        LevelLoader.LoadBattle(battle, _ => callbackReached = true);

        var battleLoadStartedAt = Time.realtimeSinceStartup;
        while (!IsSceneLoaded(battle.MapScene))
        {
            if (Time.realtimeSinceStartup - battleLoadStartedAt > 45f)
            {
                throw new TimeoutException($"Timed out while loading battle scene '{battle.MapScene}'.");
            }

            await UniTask.DelayFrame(1);
        }

        var selectionConfirmed = false;
        if (battle.AutoTeamMates.Count > 0 && battle.AutoTeamMates[0] == -1)
        {
            var selectionStartedAt = Time.realtimeSinceStartup;
            while (!selectionConfirmed)
            {
                var selectRolePanel = UnityEngine.Object.FindObjectOfType<SelectRolePanel>();
                if (selectRolePanel != null && selectRolePanel.gameObject.activeInHierarchy)
                {
                    var selectParams = GetSelectRoleParams(selectRolePanel);
                    if (selectParams != null && selectParams.callback != null)
                    {
                        await UniTask.DelayFrame(2);
                        selectRolePanel.OnConfirmClick();
                        selectionConfirmed = true;
                        Debug.Log($"[Jyx2ModSmokeTest] Confirmed battle '{battleId}' role-selection panel.");
                        break;
                    }
                }

                if (Time.realtimeSinceStartup - selectionStartedAt > 15f)
                {
                    throw new Exception($"Battle '{battleId}' did not show the expected role-selection panel.");
                }

                await UniTask.DelayFrame(1);
            }
        }

        var battleboxManager = UnityEngine.Object.FindObjectOfType<BattleboxManager>();
        if (battleboxManager == null)
        {
            throw new Exception($"Battle scene '{battle.MapScene}' is missing BattleboxManager.");
        }

        var battleboxColliders = battleboxManager.GetComponentsInChildren<Collider>(true);
        if (battleboxColliders.Length == 0)
        {
            throw new Exception($"Battle scene '{battle.MapScene}' has no child colliders under BattleboxManager.");
        }

        await WaitUntilOrThrow(() => !s_BattleWatchdogActive,
            $"Timed out waiting for battle '{battleId}' watchdog to finish.", 90f);

        var roleIds = GameObject.Find("BattleRoles")
            .GetComponentsInChildren<BattleRole>(true)
            .Where(r => r.DataInstance != null)
            .Select(r => r.DataInstance.GetJyx2RoleId())
            .OrderBy(id => id)
            .ToArray();
        if (!roleIds.Contains(0) || !roleIds.Contains(320) || !roleIds.Contains(321) || !roleIds.Contains(331))
        {
            throw new Exception($"Battle '{battleId}' role roster is wrong: {string.Join(",", roleIds)}");
        }

        if (callbackReached)
        {
            throw new Exception($"Battle '{battleId}' ended during the load smoke test; expected it to remain active for validation.");
        }

        Debug.Log($"[Jyx2ModSmokeTest] Battle scene loaded: {battle.Name} ({battle.MapScene}), roles: {string.Join(",", roleIds)}");
    }

    private static bool IsSceneLoaded(string sceneName)
    {
        var scene = SceneManager.GetSceneByName(sceneName);
        return scene.IsValid() && scene.isLoaded;
    }

    private static SelectRoleParams GetSelectRoleParams(SelectRolePanel panel)
    {
        var field = typeof(SelectRolePanel).GetField("m_params",
            System.Reflection.BindingFlags.Instance | System.Reflection.BindingFlags.NonPublic);
        return field?.GetValue(panel) as SelectRoleParams;
    }

    private static void StartBattleLoadWatchdog(int battleId, string battleName, string battleScene)
    {
        s_BattleWatchdogActive = true;
        s_BattleWatchdogStartedAt = Time.realtimeSinceStartup;
        s_BattleWatchdogBattleId = battleId;
        s_BattleWatchdogBattleName = battleName;
        s_BattleWatchdogBattleScene = battleScene;
    }

    private static void BattleLoadWatchdogUpdate()
    {
        if (!s_BattleWatchdogActive || !EditorApplication.isPlaying)
        {
            return;
        }

        if (Time.realtimeSinceStartup - s_BattleWatchdogStartedAt > 90f)
        {
            s_BattleWatchdogActive = false;
            Debug.LogError($"[Jyx2ModSmokeTest] Battle watchdog timed out: {s_BattleWatchdogBattleId} ({s_BattleWatchdogBattleScene}).");
            EditorApplication.Exit(1);
            return;
        }

        if (!IsSceneLoaded(s_BattleWatchdogBattleScene))
        {
            return;
        }

        var battleRoles = GameObject.Find("BattleRoles");
        if (BattleManager.Instance == null || !BattleManager.Instance.IsInBattle || battleRoles == null)
        {
            return;
        }

        var roleIds = battleRoles
            .GetComponentsInChildren<BattleRole>(true)
            .Where(r => r.DataInstance != null)
            .Select(r => r.DataInstance.GetJyx2RoleId())
            .OrderBy(id => id)
            .ToArray();

        if (!roleIds.Contains(0) || !roleIds.Contains(320) || !roleIds.Contains(321) || !roleIds.Contains(331))
        {
            return;
        }

        s_BattleWatchdogActive = false;
        Debug.Log($"[Jyx2ModSmokeTest] Battle watchdog passed: {s_BattleWatchdogBattleName} ({s_BattleWatchdogBattleScene}), roles: {string.Join(",", roleIds)}");
        SessionState.EraseBool(PendingKey);
        SessionState.EraseBool(StartedKey);
        SessionState.EraseString(ModIdKey);
        EditorApplication.Exit(0);
    }

    private static async UniTask LoadAndValidateStoryMap(int mapId, string triggerName)
    {
        if (!LuaToCsBridge.MapTable.TryGetValue(mapId, out var storyMap))
        {
            throw new Exception($"Story map '{mapId}' is not configured.");
        }

        var loaded = false;
        LevelLoader.LoadGameMap(storyMap, new LevelMaster.LevelLoadPara
        {
            loadType = LevelMaster.LevelLoadPara.LevelLoadType.StartAtTrigger,
            triggerName = triggerName
        }, () => loaded = true);

        await WaitUntilOrThrow(() => loaded, $"Timed out while loading story map '{storyMap.MapScene}'.");
        await WaitUntilOrThrow(() => LevelMaster.Instance != null && LevelMaster.Instance.IsInited,
            "Timed out waiting for LevelMaster after loading story map.");
        await UniTask.DelayFrame(2);

        if (SceneManager.GetActiveScene().name != storyMap.MapScene)
        {
            throw new Exception($"Expected story scene '{storyMap.MapScene}', got '{SceneManager.GetActiveScene().name}'.");
        }

        var player = LevelMaster.Instance.GetPlayer();
        if (player == null || !player.gameObject.activeInHierarchy)
        {
            throw new Exception("Player is missing or inactive in the story map.");
        }

        Debug.Log($"[Jyx2ModSmokeTest] Story map loaded: {storyMap.GetShowName()} ({storyMap.MapScene})");
    }

    private static void ValidateModLoaderSceneAsset()
    {
        EditorSceneManager.OpenScene("Assets/0_MODLoaderScene.unity");
        if (GameObject.Find("ModPanelLauncher") == null)
        {
            throw new Exception("MOD loader scene is missing ModPanelLauncher.");
        }

        Debug.Log("[Jyx2ModSmokeTest] MOD loader scene contains ModPanelLauncher.");
    }

    private static GameModBase ValidateEditorModIsDiscoverable(string modId)
    {
        var mod = new GameModEditorLoader()
            .LoadModsSync()
            .FirstOrDefault(m => string.Equals(m.Id, modId, StringComparison.OrdinalIgnoreCase));

        if (mod == null)
        {
            throw new Exception($"Cannot find mod '{modId}' under Assets/Mods.");
        }

        RuntimeEnvSetup.SetCurrentMod(mod);
        var modSetting = AssetDatabase.LoadAssetAtPath<MODRootConfig>($"Assets/Mods/{modId}/ModSetting.asset");
        if (modSetting == null)
        {
            throw new Exception($"Cannot load ModSetting.asset for mod '{modId}'.");
        }

        Debug.Log($"[Jyx2ModSmokeTest] MOD '{modId}' is discoverable. Name: {modSetting.ModName}");
        return mod;
    }

    private static void ValidateJshylStartScene(string modId)
    {
        var luaPath = $"Assets/Mods/{modId}/Configs/Lua/MapConfig.lua";
        if (!File.Exists(luaPath))
        {
            throw new Exception($"Cannot find MapConfig.lua for mod '{modId}'.");
        }

        var mapConfig = File.ReadAllText(luaPath);
        var expectedEntry = $"{{0,[[燕子坞]],[[{JshylStartScene}]]";
        if (!mapConfig.Contains(expectedEntry))
        {
            throw new Exception($"MapConfig.lua must use the Hongyan opening scene '{JshylStartScene}' for map 0.");
        }

        var scenePath = $"Assets/Mods/{modId}/Maps/GameMaps/{JshylStartScene}.unity";
        if (!File.Exists(scenePath))
        {
            throw new Exception($"Missing Hongyan opening scene copy: {scenePath}");
        }

        var bigMapPath = $"Assets/Mods/{modId}/Maps/GameMaps/1000_daditu.unity";
        if (!File.Exists(bigMapPath))
        {
            throw new Exception($"Missing JYX2 baseline big-map scene copy: {bigMapPath}");
        }

        var kunlunPath = $"Assets/Mods/{modId}/Maps/GameMaps/04_kunlunxianjing.unity";
        if (!File.Exists(kunlunPath))
        {
            throw new Exception($"Missing JYX2 Kunlun scene copy for the first Hongyan story slice: {kunlunPath}");
        }

        var kunlunCavePath = $"Assets/Mods/{modId}/Maps/GameMaps/67_shandong.unity";
        if (!File.Exists(kunlunCavePath))
        {
            throw new Exception($"Missing JYX2 Kunlun cave scene copy for the big-map entrance route: {kunlunCavePath}");
        }

        var battleMapPath = $"Assets/Mods/{modId}/Maps/BattlesMaps/Jyx2Battle_5.unity";
        if (!File.Exists(battleMapPath))
        {
            throw new Exception($"Missing JYX2 battle scene copy for A-Qing first fight: {battleMapPath}");
        }

        var yuenvSkillPath = $"Assets/Mods/{modId}/Skills/越女剑法.asset";
        if (!File.Exists(yuenvSkillPath))
        {
            throw new Exception($"Missing copied skill display asset for A-Qing's opening battle skill: {yuenvSkillPath}");
        }

        Debug.Log($"[Jyx2ModSmokeTest] Hongyan opening start scene is configured: {JshylStartScene}");
    }

    private static void ValidateHongyanOpeningAssets(string modId)
    {
        var characterConfig = File.ReadAllText($"Assets/Mods/{modId}/Configs/Lua/CharacterConfig.lua");
        foreach (var roleName in new[] { "孟星魂", "慕容秋荻", "双儿", "阿朱", "阿碧", "侍剑", "十二金钗一", "十二金钗十二" })
        {
            if (!characterConfig.Contains($"[[{roleName}]]"))
            {
                throw new Exception($"CharacterConfig.lua is missing Hongyan opening role: {roleName}");
            }

            var modelPath = $"Assets/Mods/{modId}/Models/{roleName}.asset";
            if (!File.Exists(modelPath))
            {
                throw new Exception($"Missing Hongyan opening model alias: {modelPath}");
            }
        }

        var battleConfig = File.ReadAllText($"Assets/Mods/{modId}/Configs/Lua/BattleConfig.lua");
        if (!battleConfig.Contains("{145,[[燕子坞十二金钗演武]]"))
        {
            throw new Exception("BattleConfig.lua is missing the YanZiWu training battle 145.");
        }

        foreach (var luaId in new[] { "5200", "5201", "5202", "5203", "5204", "5205" })
        {
            var luaPath = $"Assets/Mods/{modId}/Lua/{luaId}.lua";
            if (!File.Exists(luaPath))
            {
                throw new Exception($"Missing Hongyan opening Lua event: {luaPath}");
            }
        }

        var mapConfig = File.ReadAllText($"Assets/Mods/{modId}/Configs/Lua/MapConfig.lua");
        if (mapConfig.Contains("{70,[[小虾米居]],[[70_xiaoxiamiju]],[[Leave:1000]],-1,19,0,[[START:0]]}"))
        {
            throw new Exception("Xiaoxiamiju is still tagged as the start scene.");
        }

        var scenePath = $"Assets/Mods/{modId}/Maps/GameMaps/{JshylStartScene}.unity";
        EditorSceneManager.OpenScene(scenePath);

        var openingObjects = new List<GameObject>();
        foreach (var requiredNpc in new[] { "慕容秋荻", "孟星魂", "双儿", "阿朱", "阿碧", "侍剑", "三万两宝箱" })
        {
            var go = GameObject.Find($"Level/NPC/{requiredNpc}") ?? GameObject.Find(requiredNpc);
            if (go == null)
            {
                throw new Exception($"Hongyan opening scene is missing object: {requiredNpc}");
            }

            openingObjects.Add(go);
        }

        for (var i = 0; i < openingObjects.Count; i++)
        {
            for (var j = i + 1; j < openingObjects.Count; j++)
            {
                if (Vector3.Distance(openingObjects[i].transform.position, openingObjects[j].transform.position) < 2.0f)
                {
                    throw new Exception($"Hongyan opening objects are too clustered: {openingObjects[i].name}, {openingObjects[j].name}");
                }
            }
        }

        var expectedEvents = new Dictionary<string, string>
        {
            { "5200", "慕容秋荻" },
            { "5201", "双儿" },
            { "5202", "三万两宝箱" },
            { "5203", "阿朱" },
            { "5204", "阿碧" },
            { "5205", "侍剑" },
        };

        foreach (var pair in expectedEvents)
        {
            var evt = UnityEngine.Object.FindObjectsOfType<GameEvent>()
                .FirstOrDefault(e => e.m_InteractiveEventId == pair.Key);
            if (evt == null)
            {
                throw new Exception($"Hongyan opening scene is missing interactive event {pair.Key}.");
            }

            var target = GameObject.Find($"Level/NPC/{pair.Value}") ?? GameObject.Find(pair.Value);
            if (target == null || Vector3.Distance(evt.transform.position, target.transform.position) > 0.75f)
            {
                throw new Exception($"Hongyan opening event {pair.Key} is not aligned to {pair.Value}.");
            }
        }

        foreach (var maidName in new[] { "双儿", "阿朱", "阿碧" })
        {
            var maid = GameObject.Find($"Level/NPC/{maidName}") ?? GameObject.Find(maidName);
            if (maid == null || maid.transform.position.y < 6.45f)
            {
                throw new Exception($"Hongyan opening maid NPC {maidName} is too low for the OuyangkeBinv prefab.");
            }
        }

        var leave = UnityEngine.Object.FindObjectsOfType<MapTeleportor>(true)
            .FirstOrDefault(t => t.gameObject.name == "Leave");
        if (leave == null)
        {
            throw new Exception("Hongyan opening scene is missing Leave teleportor.");
        }

        var start = GameObject.Find("Level/Triggers/0");
        if (start == null ||
            !NavMesh.SamplePosition(start.transform.position, out var startHit, 3f, NavMesh.AllAreas) ||
            !NavMesh.SamplePosition(leave.transform.position, out var leaveHit, 3f, NavMesh.AllAreas))
        {
            throw new Exception("Hongyan opening start or exit is not on the baked NavMesh.");
        }

        var navPath = new NavMeshPath();
        if (!NavMesh.CalculatePath(startHit.position, leaveHit.position, NavMesh.AllAreas, navPath) ||
            navPath.status != NavMeshPathStatus.PathComplete)
        {
            throw new Exception("Hongyan opening start cannot reach the expanded open exit on NavMesh.");
        }

        Debug.Log("[Jyx2ModSmokeTest] Hongyan opening assets passed: YanZiWu start, NPCs, treasure, rest, and training events.");
    }

    private static void ValidateHongyanMaxedPlayerOpening(string modId)
    {
        var characterConfig = File.ReadAllText($"Assets/Mods/{modId}/Configs/Lua/CharacterConfig.lua");
        var playerMatch = Regex.Match(characterConfig, @"^\{0,0,\d+,\[\[小虾米\]\].*$", RegexOptions.Multiline);
        if (!playerMatch.Success)
        {
            throw new Exception("Cannot find player row in CharacterConfig.lua.");
        }

        var playerRow = playerMatch.Value;
        foreach (var required in new[] { "[[小虾米]],0,30,999999,999,", ",2,999,", "{25,900}", "{30,900}", "{61,900}", "{87,900}", "{92,900}", "{205,900}" })
        {
            if (!playerRow.Contains(required))
            {
                throw new Exception($"Maxed opening player row is missing expected value/skill: {required}");
            }
        }

        var settingsConfig = File.ReadAllText($"Assets/Mods/{modId}/Configs/Lua/SettingsConfig.lua");
        foreach (var required in new[] { "[[MAX_ROLE_ATTACK]],[[999]]", "[[MAX_ROLE_DEFENCE]],[[999]]", "[[MAX_ROLE_QINGGONG]],[[999]]", "[[MAX_ROLE_ATTRIBUTE]],[[999]]" })
        {
            if (!settingsConfig.Contains(required))
            {
                throw new Exception($"SettingsConfig.lua is missing boosted jshyl limit: {required}");
            }
        }

        var skillConfig = File.ReadAllText($"Assets/Mods/{modId}/Configs/Lua/SkillConfig.lua");
        if (!skillConfig.Contains("{205,[[独孤九剑]]"))
        {
            throw new Exception("SkillConfig.lua is missing standalone skill 205 独孤九剑.");
        }

        if (!File.Exists($"Assets/Mods/{modId}/Skills/独孤九剑.asset"))
        {
            throw new Exception("Skill display asset for 独孤九剑 is missing.");
        }

        Debug.Log("[Jyx2ModSmokeTest] Hongyan maxed player opening config passed.");
    }

    private static void ValidateKunlunHongyanStoryAssets(string modId)
    {
        var modelPath = $"Assets/Mods/{modId}/Models/阿青.asset";
        if (AssetDatabase.LoadAssetAtPath<ModelAsset>(modelPath) == null)
        {
            throw new Exception($"Missing A-Qing model asset: {modelPath}");
        }

        var aqingModelText = File.ReadAllText(modelPath);
        if (!aqingModelText.Contains("06dffd771188787449f26dfc85cf3779") ||
            aqingModelText.Contains("94968680a71da5a4fbec8839939f2599"))
        {
            throw new Exception("A-Qing model asset must use the full Chengying prefab instead of the old Xiaolongnv placeholder.");
        }

        foreach (var roleModel in new[] {
            "小虾米", "阿青", "觉远", "何足道", "白猿", "无相", "无色", "尹克西", "潇湘子",
            "西域三僧甲", "西域三僧乙", "西域三僧丙", "天鸣", "卓不凡", "公孙止", "九天玄女"
        })
        {
            var roleModelPath = $"Assets/Mods/{modId}/Models/{roleModel}.asset";
            if (AssetDatabase.LoadAssetAtPath<ModelAsset>(roleModelPath) == null)
            {
                throw new Exception($"Missing model asset used by A-Qing battle 140: {roleModelPath}");
            }
        }

        foreach (var skillDisplay in new[] { "野球拳", "越女剑法", "火焰发射器" })
        {
            var skillPath = $"Assets/Mods/{modId}/Skills/{skillDisplay}.asset";
            if (!File.Exists(skillPath))
            {
                throw new Exception($"Missing skill display asset used by A-Qing battle 140: {skillPath}");
            }
        }

        var characterConfig = File.ReadAllText($"Assets/Mods/{modId}/Configs/Lua/CharacterConfig.lua");
        if (!characterConfig.Contains("{320,320,") || !characterConfig.Contains("[[阿青]]") ||
            !characterConfig.Contains("{{61,900}}"))
        {
            throw new Exception("CharacterConfig.lua is missing playable A-Qing role id 320 with generated portrait id 320 and level-10 Yue Nv Jian Fa.");
        }

        var battleConfig = File.ReadAllText($"Assets/Mods/{modId}/Configs/Lua/BattleConfig.lua");
        foreach (var requiredBattle in new[] {
            "{140,[[越女剑初遇群战]],[[Jyx2Battle_5]],900,5,{320},{-1},{321,322,323,324,325,326,327,328,329,330,331}}",
            "{141,[[越女剑白猿试剑]],[[Jyx2Battle_5]],600,5,{320},{-1},{323}}",
            "{142,[[万仙大会卓不凡]],[[Jyx2Battle_5]],1000,5,{320},{-1},{332}}",
            "{143,[[绝情谷后公孙止]],[[Jyx2Battle_5]],1100,5,{320},{-1},{333}}",
            "{144,[[墓碑问玄女]],[[Jyx2Battle_5]],1600,7,{320},{-1},{334}}"
        })
        {
            if (!battleConfig.Contains(requiredBattle))
            {
                throw new Exception($"BattleConfig.lua is missing required Yue Nv Jian battle: {requiredBattle}");
            }
        }

        var storyLua = File.ReadAllText($"Assets/Mods/{modId}/Lua/70.lua");
        if (!storyLua.Contains("TryBattle(140)") || !storyLua.Contains("TryBattle(144)") ||
            storyLua.Contains("下一步会接入正式战斗配置"))
        {
            throw new Exception("70.lua must launch the staged Yue Nv Jian battle route instead of showing placeholder messages.");
        }

        var itemConfig = File.ReadAllText($"Assets/Mods/{modId}/Configs/Lua/ItemConfig.lua");
        foreach (var requiredItem in new[] { "[[越女剑谱]]", "[[瑶池仙袖]]", "[[长生诀]]", "[[天元剑气诀]]", "[[玄女剑]]" })
        {
            if (!itemConfig.Contains(requiredItem))
            {
                throw new Exception($"ItemConfig.lua is missing required sample Hongyan item: {requiredItem}");
            }
        }

        var homeTreasureLua = File.ReadAllText($"Assets/Mods/{modId}/Lua/2.lua");
        foreach (var requiredGive in new[] { "AddItem(94, 1)", "AddItem(95, 1)", "AddItem(109, 1)", "AddItem(117, 1)", "AddItem(120, 1)", "AddItem(200, 1)" })
        {
            if (!homeTreasureLua.Contains(requiredGive))
            {
                throw new Exception($"Starter house treasure script is missing expected item grant: {requiredGive}");
            }
        }

        var aqingHeadPath = "Assets/BuildSource/head/320.png";
        if (AssetDatabase.LoadAssetAtPath<Sprite>(aqingHeadPath) == null)
        {
            throw new Exception($"Generated A-Qing portrait must be importable as a sprite: {aqingHeadPath}");
        }

        var scenePath = $"Assets/Mods/{modId}/Maps/GameMaps/04_kunlunxianjing.unity";
        var sceneText = File.ReadAllText(scenePath);
        if (!sceneText.Contains("06dffd771188787449f26dfc85cf3779") ||
            sceneText.Contains("94968680a71da5a4fbec8839939f2599"))
        {
            throw new Exception("Kunlun scene must place Chengying prefab for A-Qing instead of the old Xiaolongnv placeholder.");
        }

        EditorSceneManager.OpenScene(scenePath);
        var aqing = GameObject.Find("Level/NPC/阿青") ?? GameObject.Find("阿青");
        if (aqing == null)
        {
            throw new Exception("Kunlun scene still does not contain visible A-Qing NPC.");
        }

        if (aqing.GetComponentsInChildren<Renderer>(true).All(r => !r.enabled))
        {
            throw new Exception("Kunlun A-Qing NPC has no enabled renderers.");
        }

        var aqingEvent = UnityEngine.Object.FindObjectsOfType<GameEvent>()
            .FirstOrDefault(e => e.m_InteractiveEventId == "70");
        if (aqingEvent == null || aqingEvent.m_EventTargets == null ||
            !aqingEvent.m_EventTargets.Any(t => t != null && t.name == "阿青"))
        {
            throw new Exception("Kunlun scene event 70 is not targeting A-Qing.");
        }

        if (Vector3.Distance(aqing.transform.position, aqingEvent.transform.position) > 0.5f)
        {
            throw new Exception("Kunlun A-Qing NPC is not placed at the interactive event position.");
        }

        Debug.Log("[Jyx2ModSmokeTest] Kunlun Hongyan story assets passed: A-Qing NPC, battle 140, and event script.");
    }

    private static void ValidateGhostShadowShader()
    {
        const string shaderPath = "Assets/3D/Script/GhostShadow.shader";
        var shader = AssetDatabase.LoadAssetAtPath<Shader>(shaderPath);
        if (shader == null)
        {
            throw new Exception($"Cannot load GhostShadow shader at {shaderPath}.");
        }

        var source = File.ReadAllText(shaderPath);
        if (source.IndexOf(":Normal", StringComparison.OrdinalIgnoreCase) >= 0 ||
            source.IndexOf(": NORMAL", StringComparison.OrdinalIgnoreCase) >= 0 ||
            source.IndexOf("Normal0", StringComparison.OrdinalIgnoreCase) >= 0)
        {
            throw new Exception("GhostShadow shader still declares a normal vertex attribute and can fail on baked meshes in Metal.");
        }

        var mesh = new Mesh
        {
            vertices = new[]
            {
                new Vector3(-0.5f, -0.5f, 0f),
                new Vector3(0.5f, -0.5f, 0f),
                new Vector3(0f, 0.5f, 0f)
            },
            triangles = new[] { 0, 1, 2 }
        };
        var go = new GameObject("GhostShadowSmokeMesh");
        try
        {
            go.AddComponent<MeshFilter>().sharedMesh = mesh;
            var renderer = go.AddComponent<MeshRenderer>();
            renderer.sharedMaterial = new Material(shader);
            if (renderer.sharedMaterial.shader != shader)
            {
                throw new Exception("GhostShadow material did not retain the expected shader.");
            }
        }
        finally
        {
            UnityEngine.Object.DestroyImmediate(go);
            UnityEngine.Object.DestroyImmediate(mesh);
        }

        Debug.Log("[Jyx2ModSmokeTest] GhostShadow shader accepts a mesh without normals.");
    }

    private static void ValidateStartSceneAsset(string modId)
    {
        ValidateEditorModIsDiscoverable(modId);
        var scenePath = $"Assets/Mods/{modId}/Maps/GameMaps/{JshylStartScene}.unity";
        EditorSceneManager.OpenScene(scenePath);
        ValidateLoadedScenePlayer("0");
        ValidateSceneEventLuaFiles(modId);
    }

    private static void ValidateSceneEventLuaFilesForScene(string modId, string scenePath)
    {
        EditorSceneManager.OpenScene(scenePath);
        ValidateSceneEventLuaFiles(modId);
    }

    private static void ValidateSceneEventLuaFiles(string modId)
    {
        var missing = new List<string>();
        foreach (var evt in UnityEngine.Object.FindObjectsOfType<GameEvent>())
        {
            ValidateEventLuaFile(modId, evt.m_EnterEventId, evt.name, "enter", missing);
            ValidateEventLuaFile(modId, evt.m_InteractiveEventId, evt.name, "interactive", missing);
            ValidateEventLuaFile(modId, evt.m_UseItemEventId, evt.name, "use-item", missing);
        }

        if (missing.Count > 0)
        {
            throw new Exception("Scene references missing Lua event files: " + string.Join(", ", missing));
        }

        Debug.Log($"[Jyx2ModSmokeTest] Scene event Lua validation passed for '{modId}'.");
    }

    private static void ValidateEventLuaFile(string modId, string eventId, string eventName, string eventKind, List<string> missing)
    {
        if (string.IsNullOrEmpty(eventId) || eventId == "-1")
        {
            return;
        }

        if (int.TryParse(eventId, out var numericId) && numericId < 0)
        {
            return;
        }

        var luaPath = $"Assets/Mods/{modId}/Lua/{eventId}.lua";
        if (!File.Exists(luaPath))
        {
            missing.Add($"{eventName}:{eventKind}:{eventId}");
        }
    }

    private static void ValidateJshylLuaUsesExposedFlagApi(string modId)
    {
        var luaDir = $"Assets/Mods/{modId}/Lua";
        foreach (var luaPath in Directory.GetFiles(luaDir, "*.lua", SearchOption.AllDirectories))
        {
            var content = File.ReadAllText(luaPath);
            if (content.Contains("jyx2_GetFlagInt") || content.Contains("jyx2_SetFlagInt"))
            {
                throw new Exception($"{luaPath} uses jyx2_* flag APIs, which are not exposed as global Lua functions. Use GetFlagInt/SetFlagInt instead.");
            }
        }
    }

    private static void ValidateJshylBattleSkillDisplayAssets(string modId)
    {
        var skillConfig = File.ReadAllText($"Assets/Mods/{modId}/Configs/Lua/SkillConfig.lua");
        var characterConfig = File.ReadAllText($"Assets/Mods/{modId}/Configs/Lua/CharacterConfig.lua");
        var battleConfig = File.ReadAllText($"Assets/Mods/{modId}/Configs/Lua/BattleConfig.lua");

        var skillNamesById = Regex.Matches(skillConfig, @"^\{(\d+),\[\[(.*?)\]\],", RegexOptions.Multiline)
            .Cast<Match>()
            .ToDictionary(m => int.Parse(m.Groups[1].Value), m => m.Groups[2].Value);

        var roleRowsById = Regex.Matches(characterConfig, @"^\{(\d+),[^\n]*?\},", RegexOptions.Multiline)
            .Cast<Match>()
            .ToDictionary(m => int.Parse(m.Groups[1].Value), m => m.Value);

        var requiredRoleIds = new HashSet<int>();
        foreach (var battleId in new[] { 140, 141, 142, 143, 144 })
        {
            var battleMatch = Regex.Match(battleConfig, $@"\{{{battleId},[^\n]*?\}}\}},");
            if (!battleMatch.Success)
            {
                throw new Exception($"BattleConfig.lua is missing battle {battleId}.");
            }

            foreach (Match idMatch in Regex.Matches(battleMatch.Value, @"\d+"))
            {
                if (int.TryParse(idMatch.Value, out var id) && roleRowsById.ContainsKey(id))
                {
                    requiredRoleIds.Add(id);
                }
            }
        }

        foreach (var roleId in requiredRoleIds)
        {
            var roleRow = roleRowsById[roleId];
            var skillsMatch = Regex.Match(roleRow, @"\{\{.*?\}\}");
            if (!skillsMatch.Success)
            {
                continue;
            }

            foreach (Match skillIdMatch in Regex.Matches(skillsMatch.Value, @"\{(\d+),"))
            {
                var skillId = int.Parse(skillIdMatch.Groups[1].Value);
                if (!skillNamesById.TryGetValue(skillId, out var skillName))
                {
                    throw new Exception($"Role {roleId} references missing skill id {skillId}.");
                }

                var skillAssetPath = $"Assets/Mods/{modId}/Skills/{skillName}.asset";
                if (!File.Exists(skillAssetPath))
                {
                    throw new Exception($"Role {roleId} uses skill '{skillName}', but the skill display asset is missing: {skillAssetPath}");
                }
            }
        }
    }

    private static void ValidateLoadedScenePlayer(string startTrigger, Jyx2Player player = null)
    {
        player = player != null ? player : RoleHelper.FindPlayer();
        if (player == null)
        {
            throw new Exception("No Jyx2Player was found at Level/Player or with the Player tag.");
        }

        if (!player.gameObject.activeInHierarchy)
        {
            throw new Exception("Player object is inactive in the loaded map.");
        }

        var renderers = player.GetComponentsInChildren<Renderer>(false);
        if (renderers.Length == 0)
        {
            throw new Exception("Player has no active renderers; the character model is probably hidden.");
        }

        var hasVisibleRenderer = false;
        foreach (var renderer in renderers)
        {
            if (renderer.enabled && renderer.gameObject.activeInHierarchy)
            {
                hasVisibleRenderer = true;
                break;
            }
        }

        if (!hasVisibleRenderer)
        {
            throw new Exception("Player renderers exist but are disabled or inactive.");
        }

        var expectedSpawn = GameObject.Find($"Level/Triggers/{startTrigger}") ??
                            GameObject.Find($"Level/Dynamic/{startTrigger}");
        if (expectedSpawn == null)
        {
            throw new Exception($"Start trigger '{startTrigger}' was not found in the loaded map.");
        }

        var distance = Vector3.Distance(player.transform.position, expectedSpawn.transform.position);
        if (distance > 12f)
        {
            throw new Exception($"Player is unexpectedly far from START:{startTrigger}. Distance: {distance:0.00}");
        }

        Debug.Log($"[Jyx2ModSmokeTest] Player validation passed. Active renderers: {renderers.Length}, start: {startTrigger}, distance: {distance:0.00}");
    }

    private static async UniTask WaitUntilOrThrow(Func<bool> predicate, string message, float timeoutSeconds = 60f)
    {
        var startedAt = Time.realtimeSinceStartup;
        while (!predicate())
        {
            if (Time.realtimeSinceStartup - startedAt > timeoutSeconds)
            {
                throw new TimeoutException(message);
            }

            await UniTask.DelayFrame(1);
        }
    }

    private static bool HasArg(string name)
    {
        return Environment.GetCommandLineArgs().Contains(name);
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
