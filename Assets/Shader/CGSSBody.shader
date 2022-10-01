Shader "Cygames/3DLive/Chara/CharaDefaultRich"
{
    Properties
    {
        [MaterialToggle] _UseFaceTex("UseFaceTex", Float) = 0
        [KeywordEnum(Original, Accessory, Head, Object, Body)] _TexturePack("TexturePack", Float) = 0
        [Space(5)] _MainTex("Diffuse Texture", 2D) = "white" { }
        _CharaColor("_RimColor", Color) = (1,1,1,1)
        _ControlMap("_ControlMap", 2D) = "white" { }
        _RimNormalAdjust("_RimNormalAdjust", Range(-2, 2)) = 0
        _RimPower("_RimPower", Range(1, 16)) = 4
        _RimRate("_RimRate", Range(0, 2)) = 0.5
        _RimColor("_RimColor", Color) = (1,1,1,1)
        _RimShadow("_RimShadow", Range(0, 2)) = 0
        _SpecTex("_SpecTex", 2D) = "white" { }
        [Toggle(DISABLE_SPECULAR)] _bSpecular("Disable Specular", Float) = 0
        _SpecPower("_SpecPower", Range(1, 200)) = 32
        _SpecRate("_SpecRate", Range(0, 1)) = 0.2
        _SpecColor("_SpecColor", Color) = (1,1,1,1)
        _EnvRate("_EnvRate", Range(0, 1)) = 0.5
        _EnvBias("_EnvBias", Range(0, 8)) = 1
        _OutlineTex("Outline Texture", 2D) = "red" { }
        _outlineParam("Outline Param : x=Width y=Brightness", Vector) = (1,0.5,0,0)
        _outlineZOffset("Outline Z Offset", Float) = 0.0015
        _RimColorMulti("_RimColorMulti", Color) = (1,1,1,1)
        _HeightLightParam("_HeightLightParam", Vector) = (0,1,0,0)
        _HeightLightColor("_HeightLightColor", Color) = (0,0,0,0)
        _StencilValue("_StencilValue", Float) = 127
    }
        SubShader{
         LOD 100
         Tags { "Mirror" = "Chara" "MyShadow" = "Chara" "QUEUE" = "Geometry-1" "RenderType" = "Opaque" }
         Pass {
          Name "Toon"
          LOD 100
          Tags { "LIGHTMODE" = "FORWARDBASE" "Mirror" = "Chara" "MyShadow" = "Chara" "QUEUE" = "Geometry-1" "RenderType" = "Opaque" "SHADOWSUPPORT" = "true" }
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag

            float4 _MainTex_ST; //Ö÷ÌûÍ¼Ëõ·ÅÆ«ÒÆ


        sampler2D _ControlMap;
        sampler2D _MainTex;
        sampler2D _GlobalEnvTex;
        sampler2D _SpecTex;


        float4 _HeightLightParam;
        float4 _HeightLightColor;

        float _RimNormalAdjust;
        float _RimPower;
        float _RimRate;

        float4 _RimColor;
        float4 _RimColorMulti;

        float _RimShadow;
        float _RimSpecRate;

        float _SpecPower;
        float _SpecRate;
        float4 _SpecColor;
        float4 _CharaColor;
        float4 _GlobalEnvColor;
        float _GlobalEnvRate;
        float _EnvRate;
        float _EnvBias;
        float _GlobalSpecRate;
        float _GlobalRimRate;
        float _GlobalRimShadowRate;
        float4 _GlobalLightDir;




    
    struct a2v {
        float4 v0 : POSITION0;
        float4 v1 : NORMAL0;
        float2 v2 : TEXCOORD0;
        float4 v3 : TANGENT0;
    };

    struct v2f {
        float2 o0 : TEXCOORD0;
        float2 p0 : TEXCOORD2;
        float3 o1 : TEXCOORD1;
        float4 o2 : SV_POSITION0;
        float4 o3 : TEXCOORD3;
    };

    v2f vert(a2v v) {

        v2f f;
        float4 r0, r1;


        r0.xyzw = mul(unity_ObjectToWorld, v.v3);
        f.o1.xyz = r0.xyz;

        
        f.p0.xy = mul(unity_MatrixV, r0).xy;
        

        f.o0.xy = v.v2.xy * _MainTex_ST.xy + _MainTex_ST.zw;


        r0.xyz = unity_ObjectToWorld[1].xyz * v.v0.yyy;
        r0.xyz = unity_ObjectToWorld[0].xyz * v.v0.xxx + r0.xyz;
        r0.xyz = unity_ObjectToWorld[2].xyz * v.v0.zzz + r0.xyz;
        r0.xyz = unity_ObjectToWorld[3].xyz * v.v0.www + r0.xyz;
        r1.xyzw = unity_MatrixVP[1].xyzw * r0.yyyy;
        r1.xyzw = unity_MatrixVP[0].xyzw * r0.xxxx + r1.xyzw;
        r1.xyzw = unity_MatrixVP[2].xyzw * r0.zzzz + r1.xyzw;
        f.o2.xyzw = UnityObjectToClipPos(v.v0);

        r0.x = -_HeightLightParam.x + r0.y;
        r0.x = saturate(r0.x / _HeightLightParam.y);
        r0.x = 1 + -r0.x;
        f.o3.xyzw = _HeightLightColor.xyzw * r0.xxxx;
        


        return f;

    }

    fixed4 frag(v2f f) : SV_Target{

        float4 r0,r1,r2,r3;
        float4 result;

        
        r0.x = 1 + _RimPower;

        r1.x = unity_MatrixV[2].x;
        r1.y = unity_MatrixV[2].y;
        r1.z = unity_MatrixV[2].z;
        r0.y = saturate(dot(r1.xyz, f.o1.xyz));

        r1.xyz = r1.xyz * _RimNormalAdjust + f.o1.xyz;
        r0.y = 1 + -r0.y;
        r0.y = log2(r0.y);
        r0.x = r0.x * r0.y;
        r0.x = exp2(r0.x);
        r0.x = _RimRate * r0.x;

        //r2.xyzw = t0.Sample(s1_s, f.o0.xy).xyzw;
        r2 = tex2D(_ControlMap, f.o0.xy);

        r0.x = r2.z * r0.x;
        //r3.xyzw = t3.Sample(s2_s, f.o0.xy).xyzw;
        r3 = tex2D(_SpecTex, f.o0.xy);

        r0.yzw = _RimColor.xyz + -r3.xyz;
        r0.yzw = _RimSpecRate * r0.yzw + r3.xyz;
        r0.xyz = r0.yzw * r0.xxx;
        r0.w = dot(r1.xyz, r1.xyz);
        r0.w = rsqrt(r0.w);
        r1.xyz = r1.xyz * r0.www;
        r0.w = dot(_GlobalLightDir.xyz, r1.xyz);
        r0.w = max(0, r0.w);
        r1.x = _RimShadow + r0.w;
        r0.w = log2(r0.w);
        r0.w = _SpecPower * r0.w;
        r0.w = exp2(r0.w);
        r0.w = _SpecRate * r0.w;
        r0.w = r0.w * r2.x;
        r1.y = _EnvRate * r2.y;
        r1.y = _GlobalEnvRate * r1.y;
        r0.w = _GlobalSpecRate * r0.w;
        r1.x = _GlobalRimShadowRate + r1.x;
        r0.xyz = r1.xxx * r0.xyz;
        r0.xyz = _RimColorMulti.xyz * r0.xyz;
        r1.xz = float2(1,1) + f.p0.xy;
        r1.xz = float2(0.5,0.5) * r1.xz;
        //r2.xyzw = t2.Sample(s3_s, r1.xz).xyzw;
        r2 = tex2D(_GlobalEnvTex, r1.xz);

        r1.xzw = _GlobalEnvColor.xyz * r2.xyz;
        //r2.xyzw = t1.Sample(s0_s, f.o0.xy).xyzw;
        r2 = tex2D(_MainTex, f.o0.xy);

        r1.xzw = r2.xyz * r1.xzw;
        r1.xzw = r1.xzw * _EnvBias + -r2.xyz;
        r1.xyz = r1.yyy * r1.xzw + r2.xyz;
        result.w = r2.w;

        r2.xyz = r3.xyz * _SpecColor.xyz + -r1.xyz;
        r1.xyz = r0.www * r2.xyz + r1.xyz;
        r0.xyz = r0.xyz * _GlobalRimRate + r1.xyz;

        result.xyz = r0.xyz * _CharaColor.xyz + f.o3.xyz;

        return result;
    }

    ENDCG
    }
    }
    Fallback "Diffuse"
}
