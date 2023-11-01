using System;
using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;

[ExecuteAlways]
public class LoadAB_old : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {

        //请试试使用新脚本Scripts/LoadAB.cs加载模型

        /*
        string head = "E:/umacontent/";

        Debug.Log(this.GetInstanceID());

        AssetBundle shader_ab = AssetBundle.LoadFromFile(head + "shader");

        AssetBundle e_0 = AssetBundle.LoadFromFile(head + "3d/chara/body/bdy1030_40/ikcols/ast_bdy1030_40_ikcol00");

        AssetBundle e_1 = AssetBundle.LoadFromFile(head + "sourceresources/3d/chara/body/bdy1030_40/materials/mtl_bdy1030_40");

        AssetBundle e_2 = AssetBundle.LoadFromFile(head + "sourceresources/3d/chara/body/bdy1030_40/materials/mtl_bdy1030_40_alpha0");

        AssetBundle e_3 = AssetBundle.LoadFromFile(head + "sourceresources/3d/chara/body/bdy1030_40/materials/mtl_bdy1030_40_alpha1");
        AssetBundle e_3_0 = AssetBundle.LoadFromFile(head + "3d/chara/common/textures/tex_chr_env000");
        */

        AssetBundle main = AssetBundle.LoadFromFile(@"D:\Gal\Fire Emblem Engage (NSP)(Converted)\Fire Emblem Engage [0100A6301214E000][v0][US]\out\out\1\Data\StreamingAssets\aa\Switch\fe_assets_unit\model\ubody\eir0af\c000\prefabs\ubody_eir0af_c000.bundle");

        /*
        Debug.Log(main.GetInstanceID());
        UnityEngine.Object[] Tiles = new UnityEngine.Object[1];
        Tiles[0] = main;
        Selection.objects = Tiles;
        AssetDatabase.RemoveObjectFromAsset(main);
        AssetDatabase.CreateAsset(main, "Assets/hello.asset");
        */

        string[] abnames = main.GetAllAssetNames();

        var cyalume = main.LoadAsset<GameObject>(abnames[0]);




        Instantiate(cyalume);


        Debug.Log(abnames[0]);



    }

}
