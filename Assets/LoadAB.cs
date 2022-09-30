using System;
using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;
using System.Linq;
using System.Runtime.InteropServices;

[ExecuteAlways]
public class LoadAB : MonoBehaviour
{
    // Start is called before the first frame update
    void Start()
    {
        string head = "E:/umacontent/";

        Debug.Log(this.GetInstanceID());

        AssetBundle shader_ab = AssetBundle.LoadFromFile(head + "manifest/shader");

        AssetBundle e_0 = AssetBundle.LoadFromFile(head + "3d/chara/head/chr1030_40/ikcols/ast_chr1030_40_ikcol00");

        AssetBundle e_1 = AssetBundle.LoadFromFile(head + "sourceresources/3d/chara/head/chr1030_40/facial/ast_chr1030_40_ear_target");

        AssetBundle e_2 = AssetBundle.LoadFromFile(head + "sourceresources/3d/chara/head/chr1030_40/materials/mtl_chr1030_40_cheek");

        AssetBundle e_3 = AssetBundle.LoadFromFile(head + "sourceresources/3d/chara/head/chr1030_40/materials/mtl_chr1030_40_eye");

        AssetBundle e_4 = AssetBundle.LoadFromFile(head + "sourceresources/3d/chara/head/chr1030_40/materials/mtl_chr1030_40_face");
        AssetBundle e_4_0 = AssetBundle.LoadFromFile(head + "3d/chara/common/textures/tex_chr_env000");

        AssetBundle e_5 = AssetBundle.LoadFromFile(head + "sourceresources/3d/chara/head/chr1030_40/materials/mtl_chr1030_40_hair");

        AssetBundle e_6 = AssetBundle.LoadFromFile(head + "sourceresources/3d/chara/head/chr1030_40/materials/mtl_chr1030_40_mayu");

        AssetBundle e_7 = AssetBundle.LoadFromFile(head + "sourceresources/3d/chara/head/chr1030_40/materials/mtl_chr1030_40_tear");

        AssetBundle e_8 = AssetBundle.LoadFromFile(head + "sourceresources/3d/chara/head/chr1030_40/textures/tex_chr1030_40_cheek0");

        AssetBundle main = AssetBundle.LoadFromFile(head + "3d/chara/head/chr1030_40/pfb_chr1030_40");

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

