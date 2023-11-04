using System;
using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.IO;
using System.Runtime.InteropServices;
using System.ComponentModel;

[ExecuteAlways]
public class LoadAB : MonoBehaviour
{
    UmaDataMain Main;

    // Start is called before the first frame update
    void Start()
    {

        //AB包和其依赖暂时需要手动加载，要看每个AB包的依赖的话可以用AssetBundleBrowser，也可以看看meta数据库的d那栏

        /*
        string head = "E:/umacontent/";

        Debug.Log(this.GetInstanceID());

        AssetBundle shader_ab = AssetBundle.LoadFromFile(head + "shader");

        AssetBundle e_0 = AssetBundle.LoadFromFile(head + "3d/chara/body/bdy1030_40/ikcols/ast_bdy1030_40_ikcol00");

        AssetBundle e_1 = AssetBundle.LoadFromFile(head + "sourceresources/3d/chara/body/bdy1030_40/materials/mtl_bdy1030_40");

        AssetBundle e_2 = AssetBundle.LoadFromFile(head + "sourceresources/3d/chara/body/bdy1030_40/materials/mtl_bdy1030_40_alpha0");

        AssetBundle e_3 = AssetBundle.LoadFromFile(head + "sourceresources/3d/chara/body/bdy1030_40/materials/mtl_bdy1030_40_alpha1");
        AssetBundle e_3_0 = AssetBundle.LoadFromFile(head + "3d/chara/common/textures/tex_chr_env000");

        AssetBundle main = AssetBundle.LoadFromFile(head + "3d/chara/body/bdy1030_40/pfb_bdy1030_40");

        Debug.Log(main.name);
        */

        /*
        Debug.Log(main.GetInstanceID());

        UnityEngine.Object[] Tiles = new UnityEngine.Object[1];

        Tiles[0] = main;

        Selection.objects = Tiles;

        AssetDatabase.RemoveObjectFromAsset(main);
        AssetDatabase.CreateAsset(main, "Assets/hello.asset");
        */

        //string[] abnames = main.GetAllAssetNames();

        //var cyalume = main.LoadAsset<GameObject>(abnames[0]);




        //Instantiate(cyalume);


        Debug.Log("Hello");
        

        Main = GameObject.Find("UmaDatabase").GetComponent<UmaDataMain>();

        AssetBundle.UnloadAllAssetBundles(true);
        Main.LoadedBundles.Clear();

        //要换加载的模型修改这里
        RecursiveLoadAsset(Main.AbList.FirstOrDefault(ab => ab.Name == "3d/chara/body/bdy1100_90/pfb_bdy1100_90"));

    }

    public void RecursiveLoadAsset(UmaDatabaseEntry entry, bool IsSubAsset = false)
    {
        if (entry != null)
        {
            if (!string.IsNullOrEmpty(entry.Prerequisites))
            {
                foreach (string prerequisite in entry.Prerequisites.Split(';'))
                {
                    if (prerequisite.StartsWith(UmaDatabaseController.CharaBodyPath))
                    {
                        RecursiveLoadAsset(Main.AbCharaBody.FirstOrDefault(ab => ab.Name == prerequisite), true);
                    }
                    else if (prerequisite.StartsWith(UmaDatabaseController.CharaHeadPath))
                    {
                        RecursiveLoadAsset(Main.AbCharaHead.FirstOrDefault(ab => ab.Name == prerequisite), true);
                    }
                    else if (prerequisite.StartsWith(UmaDatabaseController.CharaPath))
                    {
                        RecursiveLoadAsset(Main.AbChara.FirstOrDefault(ab => ab.Name == prerequisite), true);
                    }
                    else if (prerequisite.StartsWith(UmaDatabaseController.CharaTexPath))
                    {
                        RecursiveLoadAsset(Main.AbCharaTex.FirstOrDefault(ab => ab.Name == prerequisite), true);
                    }
                    else
                    {
                        Debug.Log(prerequisite);
                        RecursiveLoadAsset(Main.AbList.FirstOrDefault(ab => ab.Name == prerequisite), true);
                    }

                }
            }
            LoadAsset(entry, IsSubAsset);
        }
    }

    public void LoadAsset(UmaDatabaseEntry entry, bool IsSubAsset = false)
    {
        Debug.Log("Loading " + entry.Name);
        if (Main.LoadedBundles.ContainsKey(entry.Name)) return;

        string filePath = entry.FilePath;
        if (File.Exists(filePath))
        {
            AssetBundle bundle = AssetBundle.LoadFromFile(filePath);
            if (bundle == null)
            {
                Debug.Log(filePath + " exists and doesn't work");
                return;
            }
            Main.LoadedBundles.Add(entry.Name, bundle);
            LoadBundle(bundle, IsSubAsset);
        }
        else
        {
            Debug.LogError($"{entry.Name} - {filePath} does not exist");
        }
    }

    private void LoadBundle(AssetBundle bundle, bool IsSubAsset = false)
    {
        foreach (string name in bundle.GetAllAssetNames())
        {
            object asset = bundle.LoadAsset(name);
            if (asset == null) { continue; }
            switch (asset)
            {
                case GameObject go:
                    {
                        if (!IsSubAsset)
                        {
                            LoadObject(go);
                        }
                        break;
                    }
            }
        }
    }

    private void LoadObject(GameObject go)
    {
        Instantiate(go);
    }
}

