using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Linq;
using System;

[ExecuteAlways]
public class UmaDataMain : MonoBehaviour
{

    public static UmaDataMain Instance;

    public List<UmaDatabaseEntry> AbList = new List<UmaDatabaseEntry>();
    public List<UmaDatabaseEntry> AbChara = new List<UmaDatabaseEntry>();
    public List<UmaDatabaseEntry> AbCharaBody = new List<UmaDatabaseEntry>();
    public List<UmaDatabaseEntry> AbCharaHead = new List<UmaDatabaseEntry>();
    public List<UmaDatabaseEntry> AbCharaTex = new List<UmaDatabaseEntry>();

    public Dictionary<string, AssetBundle> LoadedBundles = new Dictionary<string, AssetBundle>();

    private void Awake()
    {
        Instance = this;

        AbList = UmaDatabaseController.Instance.MetaEntries.ToList();
        AbChara = AbList.Where(ab => ab.Name.StartsWith(UmaDatabaseController.CharaPath)).ToList();
        AbCharaBody = AbList.Where(ab => ab.Name.StartsWith(UmaDatabaseController.CharaBodyPath)).ToList();
        AbCharaHead = AbList.Where(ab => ab.Name.StartsWith(UmaDatabaseController.CharaHeadPath)).ToList();
        AbCharaTex = AbList.Where(ab => ab.Name.StartsWith(UmaDatabaseController.CharaTexPath)).ToList();
    }
}
