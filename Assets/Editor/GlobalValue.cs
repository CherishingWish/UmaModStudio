using UnityEngine;
using UnityEditor;
using System.Collections;
using System.Collections.Generic;

public class GlobalValue : EditorWindow
{
    public GameObject from;
    public GameObject to;


    float _Global_MaxDensity = 1.0f;
    float _Global_MaxHeight = 10.0f;
    float _GlobalOutlineOffest = 0.0f;
    float _GlobalOutlineWidth = 1.0f;
    float _GlobalCameraFov = 0.0f;
    float _CylinderBlend = 0.0f;
    Color _GlobalToonColor = new Color(1, 1, 1, 0);
    Color _Global_FogColor;
    Color _GlobalDirtRimSpecularColor;
    Color _GlobalDirtToonColor;
    Color _GlobalRimColor = new Color(1, 1, 1, 0);
    Color _GlobalDirtColor;
    Color _RimColor2;
    List<Vector4> _MainParam = new List<Vector4>();
    Vector4 _MainParam_0;
    Vector4 _MainParam_1;
    List<Vector4> _HighParam1 = new List<Vector4>();
    Vector4 _HighParam1_0 = new Vector4(0, 0, 0, 1);
    Vector4 _HighParam1_1 = new Vector4(0, 0, 0, 1);
    Vector4 _HighParam1_2;
    List<Vector4> _HighParam2 = new List<Vector4>();
    Vector4 _HighParam2_0 = new Vector4(0, 0, 0, 1);
    Vector4 _HighParam2_1 = new Vector4(0, 0, 0, 1);

    List<Vector4> _ColorArray = new List<Vector4>();
    Vector4 _ColorArray_0;
    Vector4 _ColorArray_1;
    Vector4 _ColorArray_2;
    Vector4 _ColorArray_3;
    Vector4 _ColorArray_4;
    Vector4 _ColorArray_5;
    Vector4 _ColorArray_6;
    Vector4 _ColorArray_7;
    Vector4 _ColorArray_8;
    Vector4 _ColorArray_9;

    List<float> _DirtRate = new List<float>();
    float _DirtRate_0;
    float _DirtRate_1;
    float _DirtRate_2;


    Vector4 _Global_FogMinDistance;
    Vector4 _Global_FogLength;

    float _RimHorizonOffset;

    Color _AmbientColor;

    Color _CharaColor;
    Color _GlobalEnvColor;

    float _GlobalEnvRate;
    float _GlobalSpecRate;
    float _GlobalRimRate;
    float _GlobalRimShadowRate;

    Vector2 scrollPosition = Vector2.zero;

    bool USE_MASK_COLOR;

    [MenuItem("Global/Value Set")]
    public static void ValueWindow()
    {
        EditorWindow.GetWindow<GlobalValue>("SetValue");
    }

    void OnGUI()
    {
        scrollPosition = GUILayout.BeginScrollView(scrollPosition, true, true);
        GUILayout.Label("Set Your Global Value!", EditorStyles.boldLabel);
        //Vector
        _Global_FogMinDistance = EditorGUILayout.Vector4Field("�������־���", _Global_FogMinDistance);
        _Global_FogLength = EditorGUILayout.Vector4Field("��������", _Global_FogLength);
        //Float
        _Global_MaxDensity = EditorGUILayout.Slider("����ܼ���", _Global_MaxDensity, 0, 1);
        _Global_MaxHeight = EditorGUILayout.Slider("��߿ɼ��߶�", _Global_MaxHeight, 0, 10);
        _GlobalOutlineOffest = EditorGUILayout.Slider("_GlobalOutlineOffest", _GlobalOutlineOffest, 0, 100);
        _GlobalOutlineWidth = EditorGUILayout.Slider("ȫ�������߿��", _GlobalOutlineWidth, 0, 100);
        _GlobalCameraFov = EditorGUILayout.Slider("_GlobalCameraFov", _GlobalCameraFov, 0, 100);
        _CylinderBlend = EditorGUILayout.Slider("_CylinderBlend", _CylinderBlend, 0, 100);
        _RimHorizonOffset = EditorGUILayout.Slider("_RimHorizonOffset", _RimHorizonOffset, 0, 1);

        _GlobalEnvRate = EditorGUILayout.Slider("_GlobalEnvRate", _GlobalEnvRate, 0, 1);
        _GlobalSpecRate = EditorGUILayout.Slider("_GlobalSpecRate", _GlobalSpecRate, 0, 1);
        _GlobalRimRate = EditorGUILayout.Slider("_GlobalRimRate", _GlobalRimRate, 0, 1);
        _GlobalRimShadowRate = EditorGUILayout.Slider("_GlobalRimShadowRate", _GlobalRimShadowRate, 0, 1);

        //Color
        _GlobalToonColor = EditorGUILayout.ColorField("��Ӱ��ɫ", _GlobalToonColor);
        _Global_FogColor = EditorGUILayout.ColorField("_Global_FogColor", _Global_FogColor);
        _GlobalDirtRimSpecularColor = EditorGUILayout.ColorField("_GlobalDirtRimSpecularColor", _GlobalDirtRimSpecularColor);
        _GlobalDirtToonColor = EditorGUILayout.ColorField("_GlobalDirtToonColor", _GlobalDirtToonColor);
        _GlobalRimColor = EditorGUILayout.ColorField("��Ե����ɫ", _GlobalRimColor);
        _GlobalDirtColor = EditorGUILayout.ColorField("_GlobalDirtColor", _GlobalDirtColor);
        _RimColor2 = EditorGUILayout.ColorField("_RimColor2", _RimColor2);

        _AmbientColor = EditorGUILayout.ColorField("_AmbientColor", _AmbientColor);
        _CharaColor = EditorGUILayout.ColorField("_CharaColor", _CharaColor);
        _GlobalEnvColor = EditorGUILayout.ColorField("_GlobalEnvColor", _GlobalEnvColor);
        //Vector Array
        _MainParam_0 = EditorGUILayout.Vector4Field("����ƫ��", _MainParam_0);
        _MainParam_1 = EditorGUILayout.Vector4Field("����ƫ��", _MainParam_1);

        _HighParam1_0 = EditorGUILayout.Vector4Field("�����ϸ߹⣨wֵΪǿ�ȣ�", _HighParam1_0);
        _HighParam1_1 = EditorGUILayout.Vector4Field("�����¸߹�", _HighParam1_1);
        _HighParam1_2 = EditorGUILayout.Vector4Field("˫����˸Ч��", _HighParam1_2);

        _HighParam2_0 = EditorGUILayout.Vector4Field("�����ϸ߹�", _HighParam2_0);
        _HighParam2_1 = EditorGUILayout.Vector4Field("�����¸߹�", _HighParam2_1);

        _ColorArray_0 = EditorGUILayout.ColorField("_ColorArray_0", _ColorArray_0);
        _ColorArray_1 = EditorGUILayout.ColorField("_ColorArray_1", _ColorArray_1);
        _ColorArray_2 = EditorGUILayout.ColorField("_ColorArray_2", _ColorArray_2);
        _ColorArray_3 = EditorGUILayout.ColorField("_ColorArray_3", _ColorArray_3);
        _ColorArray_4 = EditorGUILayout.ColorField("_ColorArray_4", _ColorArray_4);
        _ColorArray_5 = EditorGUILayout.ColorField("_ColorArray_5", _ColorArray_5);
        _ColorArray_6 = EditorGUILayout.ColorField("_ColorArray_6", _ColorArray_6);
        _ColorArray_7 = EditorGUILayout.ColorField("_ColorArray_7", _ColorArray_7);
        _ColorArray_8 = EditorGUILayout.ColorField("_ColorArray_8", _ColorArray_8);
        _ColorArray_9 = EditorGUILayout.ColorField("_ColorArray_9", _ColorArray_9);



        //Float Array
        _DirtRate_0 = EditorGUILayout.Slider("_DirtRate_0", _DirtRate_0, 0, 1);
        _DirtRate_1 = EditorGUILayout.Slider("_DirtRate_1", _DirtRate_1, 0, 1);
        _DirtRate_2 = EditorGUILayout.Slider("_DirtRate_2", _DirtRate_2, 0, 1);

        USE_MASK_COLOR = EditorGUILayout.ToggleLeft("USE_MASK_COLOR", USE_MASK_COLOR);

        GUILayout.EndScrollView();
    }

    void Update()
    {
        //Color
        Shader.SetGlobalColor("_GlobalToonColor", _GlobalToonColor);
        Shader.SetGlobalColor("_Global_FogColor", _Global_FogColor);
        Shader.SetGlobalColor("_GlobalDirtRimSpecularColor", _GlobalDirtRimSpecularColor);
        Shader.SetGlobalColor("_GlobalDirtToonColor", _GlobalDirtToonColor);
        Shader.SetGlobalColor("_GlobalRimColor", _GlobalRimColor);
        Shader.SetGlobalColor("_GlobalDirtColor", _GlobalDirtColor);
        Shader.SetGlobalColor("_RimColor2", _RimColor2);



        //Float
        Shader.SetGlobalFloat("_Global_MaxDensity", _Global_MaxDensity);
        Shader.SetGlobalFloat("_Global_MaxHeight", _Global_MaxHeight);
        Shader.SetGlobalFloat("_GlobalOutlineOffest", _GlobalOutlineOffest);
        Shader.SetGlobalFloat("_GlobalOutlineWidth", _GlobalOutlineWidth);
        Shader.SetGlobalFloat("_GlobalCameraFov", _GlobalCameraFov);
        Shader.SetGlobalFloat("_CylinderBlend", _CylinderBlend);
        Shader.SetGlobalFloat("_RimHorizonOffset", _RimHorizonOffset);

        Shader.SetGlobalFloat("_GlobalEnvRate", _GlobalEnvRate);
        Shader.SetGlobalFloat("_GlobalSpecRate", _GlobalSpecRate);
        Shader.SetGlobalFloat("_GlobalRimRate", _GlobalRimRate);
        Shader.SetGlobalFloat("_GlobalRimShadowRate", _GlobalRimShadowRate);

        //Vector Array
        _MainParam.Clear();
        _MainParam.Add(_MainParam_0);
        _MainParam.Add(_MainParam_1);
        Shader.SetGlobalVectorArray("_MainParam", _MainParam);

        _HighParam1.Clear();
        _HighParam1.Add(_HighParam1_0);
        _HighParam1.Add(_HighParam1_1);
        _HighParam1.Add(_HighParam1_2);
        Shader.SetGlobalVectorArray("_HighParam1", _HighParam1);

        _HighParam2.Clear();
        _HighParam2.Add(_HighParam2_0);
        _HighParam2.Add(_HighParam2_1);
        Shader.SetGlobalVectorArray("_HighParam2", _HighParam2);

        _ColorArray.Clear();
        _ColorArray.Add(_ColorArray_0);
        _ColorArray.Add(_ColorArray_1);
        _ColorArray.Add(_ColorArray_2);
        _ColorArray.Add(_ColorArray_3);
        _ColorArray.Add(_ColorArray_4);
        _ColorArray.Add(_ColorArray_5);
        _ColorArray.Add(_ColorArray_6);
        _ColorArray.Add(_ColorArray_7);
        _ColorArray.Add(_ColorArray_8);
        _ColorArray.Add(_ColorArray_9);
        Shader.SetGlobalVectorArray("_ColorArray", _ColorArray);

        Shader.SetGlobalVector("_Global_FogMinDistance", _Global_FogMinDistance);
        Shader.SetGlobalVector("_Global_FogLength", _Global_FogLength);

        _DirtRate.Clear();
        _DirtRate.Add(_DirtRate_0);
        _DirtRate.Add(_DirtRate_1);
        _DirtRate.Add(_DirtRate_2);
        Shader.SetGlobalFloatArray("_DirtRate", _DirtRate);

        Shader.SetGlobalColor("_AmbientColor", _AmbientColor);

        Shader.SetGlobalColor("_CharaColor", _CharaColor);

        Shader.SetGlobalColor("_GlobalEnvColor", _GlobalEnvColor);

        if (USE_MASK_COLOR)
        {
            Shader.EnableKeyword("USE_MASK_COLOR");
        }
        else
        {
            Shader.DisableKeyword("USE_MASK_COLOR");
        }
        
    }
}
