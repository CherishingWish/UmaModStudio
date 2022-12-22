using UnityEngine;
using UnityEditor;
using System.Collections;
using System.IO;
using Newtonsoft.Json.Linq;
using Gallop;
using System;



class SelectAllOfTagMod : ScriptableWizard
{
    //复制类型
    public void CopyValues<T>(T from, T to)
    {
        var json = JsonUtility.ToJson(from);
        JsonUtility.FromJsonOverwrite(json, to);
    }

    //此函数可将无法读写的Tex克隆成一份可读写的Tex，用于提取图片至png
    Texture2D duplicateTexture(Texture2D source)
    {
        RenderTexture renderTex = RenderTexture.GetTemporary(
                    source.width,
                    source.height,
                    0,
                    RenderTextureFormat.Default,
                    RenderTextureReadWrite.Linear);

        Graphics.Blit(source, renderTex);
        RenderTexture previous = RenderTexture.active;
        RenderTexture.active = renderTex;
        Texture2D readableText = new Texture2D(source.width, source.height);
        readableText.ReadPixels(new Rect(0, 0, renderTex.width, renderTex.height), 0, 0);
        readableText.Apply();
        RenderTexture.active = previous;
        RenderTexture.ReleaseTemporary(renderTex);
        return readableText;
    }

    [MenuItem("Model/Get Select Model Mod")]
    static void CreateWindow()
    {
        ScriptableWizard.DisplayWizard(
            "Get Select Model Mod",
            typeof(SelectAllOfTagMod),
            "Start!");
    }

    void OnWizardCreate()
    {
        //加载需要替换的shader
        Shader cheekShader = (Shader)AssetDatabase.LoadAssetAtPath("Assets/Shader/charactermultiplycheek.shader", typeof(Shader));
        Shader eyeShader = (Shader)AssetDatabase.LoadAssetAtPath("Assets/Shader/charactertooneyet.shader", typeof(Shader));
        Shader faceShader = (Shader)AssetDatabase.LoadAssetAtPath("Assets/Shader/charactertoonfacetser.shader", typeof(Shader));
        Shader hairShader = (Shader)AssetDatabase.LoadAssetAtPath("Assets/Shader/charactertoonhairtser.shader", typeof(Shader));
        Shader mayuShader = (Shader)AssetDatabase.LoadAssetAtPath("Assets/Shader/charactertoonmayu.shader", typeof(Shader));
        Shader tearShader = (Shader)AssetDatabase.LoadAssetAtPath("Assets/Shader/characterunlittear.shader", typeof(Shader));

        Shader toonShader = (Shader)AssetDatabase.LoadAssetAtPath("Assets/Shader/charactertoontser.shader", typeof(Shader));
        Shader nolineToonShader = (Shader)AssetDatabase.LoadAssetAtPath("Assets/Shader/characternolinetoontser.shader", typeof(Shader));


        Debug.Log(Selection.objects[0]);

        GameObject gameobj = (GameObject)Selection.objects[0];

        if (!AssetDatabase.IsValidFolder("Assets/ModelGet"))
        {
            AssetDatabase.CreateFolder("Assets", "ModelGet");
        }

        string folder_name = "Assets/ModelGet/" + gameobj.name;

        if (!AssetDatabase.IsValidFolder(folder_name))
        {
            AssetDatabase.CreateFolder("Assets/ModelGet", gameobj.name);
        }

        foreach (SkinnedMeshRenderer skin_mesh in gameobj.transform.GetComponentsInChildren<SkinnedMeshRenderer>(true))
        {
            //提取所有Mesh至文件夹
            Mesh m = skin_mesh.sharedMesh;

            string m_parent = folder_name + "/Mesh";
            string m_path = folder_name + "/Mesh/" + m.name + ".mesh";
            if (!AssetDatabase.IsValidFolder(m_parent))
            {
                AssetDatabase.CreateFolder(folder_name, "Mesh");
            }

            Debug.Log(m.name);
            Debug.Log(AssetDatabase.IsValidFolder(m_parent));
            AssetDatabase.RemoveObjectFromAsset(m);
            AssetDatabase.CreateAsset(m, folder_name + "/Mesh/" + m.name + ".mesh");

            //创建Texture2D文件夹
            string tex_parent = folder_name + "/Texture2D";

            if (!AssetDatabase.IsValidFolder(tex_parent))
            {
                AssetDatabase.CreateFolder(folder_name, "Texture2D");
            }

            //创建Material文件夹
            string mat_parent = folder_name + "/Material";

            if (!AssetDatabase.IsValidFolder(mat_parent))
            {
                AssetDatabase.CreateFolder(folder_name, "Material");
            }

            foreach (Material mat in skin_mesh.sharedMaterials)
            {

                JArray p_name_list = new JArray();
                JArray tex_name_list = new JArray();

                //获得材质的所有属性名，如果改属性名对应的是贴图，提取该贴图
                Shader mat_shader = mat.shader;
                int p_num = mat_shader.GetPropertyCount();
                Debug.Log(p_num);
                for (int i = 0; i < p_num; i++)
                {
                    //Debug.Log(mat_shader.GetPropertyName(i));
                    //Debug.Log(mat_shader.GetPropertyType(i));
                    string p_name = mat_shader.GetPropertyName(i);
                    if (mat_shader.GetPropertyType(i) == UnityEngine.Rendering.ShaderPropertyType.Texture)
                    {
                        //Debug.Log("Hello!");
                        Debug.Log(p_name);
                        Texture2D mat_texture = (Texture2D)mat.GetTexture(p_name);
                        if (mat_texture)
                        {
                            //Debug.Log("There is a Name!");
                            string tex_name = mat_texture.name;
                            string tex_path = folder_name + "/Texture2D/" + tex_name + ".png";
                            if (!File.Exists(tex_path))
                            {
                                mat_texture = duplicateTexture(mat_texture);
                                byte[] bytes = mat_texture.EncodeToPNG();
                                File.WriteAllBytes(tex_path, bytes);
                            }
                            //记忆图片与属性名之间的关联
                            p_name_list.Add(new JValue(p_name));
                            tex_name_list.Add(new JValue(tex_path));
                        }
                    }
                }

                //替换材质shader
                switch (mat_shader.name)
                {
                    case "Gallop/3D/Chara/MultiplyCheek":
                        mat.shader = cheekShader;
                        break;
                    case "Gallop/3D/Chara/ToonEye/T":
                        mat.shader = eyeShader;
                        break;
                    case "Gallop/3D/Chara/ToonFace/TSER":
                        mat.shader = faceShader;
                        break;
                    case "Gallop/3D/Chara/ToonHair/TSER":
                        mat.shader = hairShader;
                        break;
                    case "Gallop/3D/Chara/ToonMayu":
                        mat.shader = mayuShader;
                        break;
                    case "Gallop/3D/Chara/UnlitTear":
                        mat.shader = tearShader;
                        break;
                    case "Gallop/3D/Chara/Toon/TSER":
                        mat.shader = toonShader;
                        break;
                    case "Gallop/3D/Chara/NolineToon/TSER":
                        mat.shader = nolineToonShader;
                        break;
                    default:
                        break;
                }


                //提取材质
                AssetDatabase.RemoveObjectFromAsset(mat);
                AssetDatabase.CreateAsset(mat, folder_name + "/Material/" + mat.name + ".mat");

                //刷新资源，将所有提取出来的图片载入Assets
                AssetDatabase.Refresh();

                //将图片附加进材质
                for (int i = 0; i < p_name_list.Count; i++)
                {
                    Debug.Log(p_name_list[i]);
                    Debug.Log(tex_name_list[i]);
                    mat.SetTexture(p_name_list[i].ToString(), (Texture2D)AssetDatabase.LoadAssetAtPath(tex_name_list[i].ToString(), typeof(Texture2D)));
                };


            }
        }

        foreach (MeshFilter mf in gameobj.transform.GetComponentsInChildren<MeshFilter>(true))
        {
            //提取所有Mesh至文件夹
            Mesh m = mf.sharedMesh;

            string m_parent = folder_name + "/Mesh";
            string m_path = folder_name + "/Mesh/" + m.name + ".mesh";
            if (!AssetDatabase.IsValidFolder(m_parent))
            {
                AssetDatabase.CreateFolder(folder_name, "Mesh");
            }

            Debug.Log(m.name);
            Debug.Log(AssetDatabase.IsValidFolder(m_parent));
            AssetDatabase.RemoveObjectFromAsset(m);
            AssetDatabase.CreateAsset(m, folder_name + "/Mesh/" + m.name + ".mesh");
        }

        foreach (MeshRenderer mr in gameobj.transform.GetComponentsInChildren<MeshRenderer>(true))
        {
            //创建Texture2D文件夹
            string tex_parent = folder_name + "/Texture2D";

            if (!AssetDatabase.IsValidFolder(tex_parent))
            {
                AssetDatabase.CreateFolder(folder_name, "Texture2D");
            }

            //创建Material文件夹
            string mat_parent = folder_name + "/Material";

            if (!AssetDatabase.IsValidFolder(mat_parent))
            {
                AssetDatabase.CreateFolder(folder_name, "Material");
            }

            foreach (Material mat in mr.sharedMaterials)
            {

                JArray p_name_list = new JArray();
                JArray tex_name_list = new JArray();

                //获得材质的所有属性名，如果改属性名对应的是贴图，提取该贴图
                Shader mat_shader = mat.shader;
                int p_num = mat_shader.GetPropertyCount();
                Debug.Log(p_num);
                for (int i = 0; i < p_num; i++)
                {
                    //Debug.Log(mat_shader.GetPropertyName(i));
                    //Debug.Log(mat_shader.GetPropertyType(i));
                    string p_name = mat_shader.GetPropertyName(i);
                    if (mat_shader.GetPropertyType(i) == UnityEngine.Rendering.ShaderPropertyType.Texture)
                    {
                        //Debug.Log("Hello!");
                        Debug.Log(p_name);
                        Texture2D mat_texture = (Texture2D)mat.GetTexture(p_name);
                        if (mat_texture)
                        {
                            //Debug.Log("There is a Name!");
                            string tex_name = mat_texture.name;
                            string tex_path = folder_name + "/Texture2D/" + tex_name + ".png";
                            if (!File.Exists(tex_path))
                            {
                                mat_texture = duplicateTexture(mat_texture);
                                byte[] bytes = mat_texture.EncodeToPNG();
                                File.WriteAllBytes(tex_path, bytes);
                            }
                            //记忆图片与属性名之间的关联
                            p_name_list.Add(new JValue(p_name));
                            tex_name_list.Add(new JValue(tex_path));
                        }
                    }
                }

                //替换材质shader
                switch (mat_shader.name)
                {
                    case "Gallop/3D/Chara/MultiplyCheek":
                        mat.shader = cheekShader;
                        break;
                    case "Gallop/3D/Chara/ToonEye/T":
                        mat.shader = eyeShader;
                        break;
                    case "Gallop/3D/Chara/ToonFace/TSER":
                        mat.shader = faceShader;
                        break;
                    case "Gallop/3D/Chara/ToonHair/TSER":
                        mat.shader = hairShader;
                        break;
                    case "Gallop/3D/Chara/ToonMayu":
                        mat.shader = mayuShader;
                        break;
                    case "Gallop/3D/Chara/UnlitTear":
                        mat.shader = tearShader;
                        break;
                    default:
                        break;
                }


                //提取材质
                AssetDatabase.RemoveObjectFromAsset(mat);
                AssetDatabase.CreateAsset(mat, folder_name + "/Material/" + mat.name + ".mat");

                //刷新资源，将所有提取出来的图片载入Assets
                AssetDatabase.Refresh();

                //将图片附加进材质
                for (int i = 0; i < p_name_list.Count; i++)
                {
                    Debug.Log(p_name_list[i]);
                    Debug.Log(tex_name_list[i]);
                    mat.SetTexture(p_name_list[i].ToString(), (Texture2D)AssetDatabase.LoadAssetAtPath(tex_name_list[i].ToString(), typeof(Texture2D)));
                };
            }
        }

        foreach (Animator anim in gameobj.transform.GetComponentsInChildren<Animator>(true))
        {
            //提取所有Avatar至文件夹
            Avatar av = anim.avatar;

            string av_parent = folder_name + "/Avatar";
            string av_path = folder_name + "/Avatar/" + av.name + ".asset";
            if (!AssetDatabase.IsValidFolder(av_parent))
            {
                AssetDatabase.CreateFolder(folder_name, "Avatar");
            }
            
            Debug.Log(av.name);
            Debug.Log(AssetDatabase.IsValidFolder(av_parent));
            AssetDatabase.RemoveObjectFromAsset(av);
            
            AssetDatabase.CreateAsset(av, folder_name + "/Avatar/" + av.name + ".asset");
        }

        AssetHolder assetHolder = gameobj.GetComponent<AssetHolder>();

        foreach(var asset in assetHolder._assetTable.list)
        {
            if( asset.Value.GetType() == typeof(Texture2D))
            {
                Debug.Log(asset.Key);
                string tex_name = asset.Value.name;
                string tex_path = folder_name + "/Texture2D/" + tex_name + ".png";
                if (!File.Exists(tex_path))
                {
                    Texture2D temp_tex = (Texture2D)asset.Value;
                    temp_tex = duplicateTexture(temp_tex);
                    byte[] bytes = temp_tex.EncodeToPNG();
                    File.WriteAllBytes(tex_path, bytes);
                }
                AssetDatabase.Refresh();
                asset.Value = AssetDatabase.LoadAssetAtPath(tex_path, typeof(Texture2D));
            }

            

            if(typeof(ScriptableObject).IsAssignableFrom(asset.Value.GetType()))
            {

                string scrObj_name = asset.Value.name;
                string scrObj_path = folder_name + "/ScriptableObject/" + scrObj_name + ".asset";

                if (!AssetDatabase.IsValidFolder(folder_name + "/ScriptableObject"))
                {
                    AssetDatabase.CreateFolder(folder_name, "ScriptableObject");
                }

                var new_scrObj = Activator.CreateInstance(asset.Value.GetType());
                CopyValues<object>(asset.Value, new_scrObj);

                AssetDatabase.CreateAsset((UnityEngine.Object)new_scrObj, scrObj_path);

                AssetDatabase.Refresh();

                asset.Value = AssetDatabase.LoadAssetAtPath(scrObj_path, asset.Value.GetType());
            }
        }



        AssetHolder new_assetHolder = gameobj.AddComponent<AssetHolder>();
        CopyValues<AssetHolder>(assetHolder, new_assetHolder);
        GameObject.DestroyImmediate(assetHolder);

        //提取预制体
        PrefabUtility.SaveAsPrefabAsset(gameobj, folder_name + "/" + gameobj.name + ".prefab");
    }
}