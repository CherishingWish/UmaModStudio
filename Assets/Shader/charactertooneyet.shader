Shader "Gallop/3D/Chara/ToonEye/T" {
    Properties{
        _MainTex("Diffuse", 2D) = "white" { }
        _High0Tex("High0", 2D) = "black" { }
        _High1Tex("High1", 2D) = "black" { }
        _High2Tex("High2", 2D) = "black" { }
        _WetTex("Wet Texture", 2D) = "black" { }
        _WetRate("Wet Rate", Range(0, 1)) = 1
        _CharaColor("_CharaColor", Color) = (1,1,1,1)
        _Saturation("_Saturation", Range(0, 1)) = 1
        _LightProbeColor("_LightProbeColor", Color) = (1,1,1,1)
        _Limit("_Limit", Range(0, 1)) = 0.5
        [Header(Stencil)] _StencilMask("Stencil Mask", Float) = 100
        [Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp("Stencil Comparison", Float) = 0
        [Enum(UnityEngine.Rendering.StencilOp)] _StencilOp("Stencil Operation", Float) = 0
        [Header(Toon)] _ToonStep("_ToonStep", Range(0, 1)) = 0.4
        _ToonFeather("_ToonFeather", Range(0.0001, 1)) = 0.1
        _ToonBrightColor("_ToonBrightColor", Color) = (1,1,1,0)
        _ToonDarkColor("_ToonDarkColor", Color) = (1,1,1,0)
        [MaterialToggle] _UseOriginalDirectionalLight("_UseOriginalDirectionalLight", Float) = 0
        _OriginalDirectionalLightDir("_OriginalDirectionalLightDir", Vector) = (1,1,1,1)
        _CylinderBlend("_CylinderBlend", Range(0, 1)) = 0
        [Header(MaskColor)] _MaskColorTex("MaskColorTex", 2D) = "gray" { }
        _MaskColorR1("MaskColorR1", Color) = (1,1,1,1)
        _MaskColorR2("MaskColorR2", Color) = (1,1,1,1)
        _MaskColorG1("MaskColorG1", Color) = (1,1,1,1)
        _MaskColorG2("MaskColorG2", Color) = (1,1,1,1)
        _MaskColorB1("MaskColorB1", Color) = (1,1,1,1)
        _MaskColorB2("MaskColorB2", Color) = (1,1,1,1)
        _ZWrite("_ZWrite", Float) = 1
        _ZTest("_ZTest", Float) = 4
        _EyePupliScale("_EyePupliScale", Float) = 1
    }
        //DummyShaderTextExporter
            SubShader{
                LOD 100
                Tags { "RenderType" = "Opaque" }
                Pass {
                Name "ToonEye"
                LOD 100
                Tags { "LIGHTMODE" = "UniversalForward" "RenderType" = "Opaque" }
                ZTest [_ZTest]
                ZWrite [_ZWrite]
                Stencil
                {
                    Ref [_StencilMask]
                    Comp [_StencilComp]
                    Pass [_StencilOp]
                }


                CGPROGRAM
                #pragma vertex vert
                #pragma fragment frag

                #define cmp -

                float _EyePupliScale;
                float4 _MainParam[2];
                float4 _HighParam1[3];
                float4 _HighParam2[2];
                float4 _MainTex_ST;
                float4 _High0Tex_ST;
                float4 _Offset;

                float4 _Global_FogMinDistance;
                float4 _Global_FogLength;
                float _Global_MaxHeight;

                float3 _FaceCenterPos;
                float3 _FaceUp;
                float _CylinderBlend;

                float _UseOriginalDirectionalLight;
                float3 _OriginalDirectionalLightDir;

                float _ToonStep;
                float _ToonFeather;
                float _Limit;

                sampler2D _MainTex;
                sampler2D _High0Tex;
                sampler2D _High1Tex;
                sampler2D _High2Tex;

                float4 _GlobalToonColor;
                float4 _ToonBrightColor;
                float4 _ToonDarkColor;
                float4 _CharaColor;
                float4 _LightProbeColor;

                float4 _Global_FogColor;
                float _Global_MaxDensity;

                float _Saturation;


                struct a2v {
                    float4 v0 : POSITION0;
                    float3 v1 : NORMAL0;
                    float4 v2 : TEXCOORD0;
                    float4 v3 : TEXCOORD1;
                    float2 v4 : TEXCOORD2;
                };

                struct v2f {
                    float4 o0 : SV_POSITION0;
                    float2 o1 : TEXCOORD0;
                    float2 p1 : TEXCOORD1;
                    float2 o2 : TEXCOORD2;
                    float2 p2 : TEXCOORD3;
                    float2 o3 : TEXCOORD4;
                    float2 p3 : TEXCOORD6;
                    float4 o4 : TEXCOORD7;
                    float4 o5 : TEXCOORD8;
                    float3 o6 : TEXCOORD9;
                };

                v2f vert(a2v v) {

                    v2f f;
                    UNITY_INITIALIZE_OUTPUT(v2f, f);

                    float4 r0, r1, r2, r3, r4, r5;

                    r0 = mul(unity_ObjectToWorld, v.v0);
                    r1 = mul(unity_MatrixVP, r0);

                    f.o0.xyzw = _EyePupliScale * r1.xyzw;
                    r1.xy = float2(-0.5, -0.5) + v.v2.yx;
                    r1.zw = _MainParam[0].yx + r1.xy;
                    r1.xy = _MainParam[1].yx + r1.xy;
                    sincos(_MainParam[0].z, r2.x, r3.x);
                    r2.xy = r2.xx * r1.zw;
                    r4.x = r1.w * r3.x + -r2.x;
                    r4.y = r1.z * r3.x + r2.y;
                    r1.zw = float2(0.5, 0.5) + r4.xy;
                    r2.xy = r1.zw * _MainTex_ST.xy + _MainTex_ST.zw;
                    sincos(_MainParam[1].z, r3.x, r4.x);
                    r1.zw = r3.xx * r1.xy;
                    r3.x = r1.y * r4.x + -r1.z;
                    r3.y = r1.x * r4.x + r1.w;
                    r1.xy = float2(0.5, 0.5) + r3.xy;
                    r1.xy = r1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
                    sincos(_HighParam1[0].z, r3.x, r4.x);
                    r3.yz = float2(-0.5, -0.5) + v.v3.yx;
                    r4.yz = _HighParam1[0].yx + r3.yz;
                    r3.xw = r4.yz * r3.xx;
                    r4.z = r4.z * r4.x + -r3.x;
                    r4.w = r4.y * r4.x + r3.w;
                    r3.xw = float2(0.5, 0.5) + r4.zw;
                    r3.xw = _Offset.xy + r3.xw;
                    r2.zw = r3.xw * _High0Tex_ST.xy + _High0Tex_ST.zw;
                    r3.xw = _HighParam2[0].yx + r3.yz;
                    sincos(_HighParam2[0].z, r4.x, r5.x);
                    r4.xy = r4.xx * r3.xw;
                    r4.z = r3.w * r5.x + -r4.x;
                    r4.w = r3.x * r5.x + r4.y;
                    r3.xw = float2(0.5, 0.5) + r4.zw;
                    r3.xw = _Offset.zw + r3.xw;
                    r1.zw = r3.xw * _High0Tex_ST.xy + _High0Tex_ST.zw;
                    r0.w = cmp(v.v2.y >= 0.5);
                    f.o1.xy = r0.ww ? r2.xy : r1.xy;
                    f.p1.xy = r0.ww ? r2.zw : r1.zw;
                    r1.xy = _HighParam1[1].yx + r3.yz;
                    r1.zw = _HighParam2[1].yx + r3.yz;
                    sincos(_HighParam1[1].z, r2.x, r3.x);
                    r2.xy = r2.xx * r1.xy;
                    r4.x = r1.y * r3.x + -r2.x;
                    r4.y = r1.x * r3.x + r2.y;
                    r1.xy = float2(0.5, 0.5) + r4.xy;
                    r1.xy = r1.xy * _High0Tex_ST.xy + _High0Tex_ST.zw;
                    sincos(_HighParam2[1].z, r2.x, r3.x);
                    r2.xy = r2.xx * r1.zw;
                    r4.x = r1.w * r3.x + -r2.x;
                    r4.y = r1.z * r3.x + r2.y;
                    r1.zw = float2(0.5, 0.5) + r4.xy;
                    r1.zw = r1.zw * _High0Tex_ST.xy + _High0Tex_ST.zw;
                    f.o2.xy = r0.ww ? r1.xy : r1.zw;
                    r1.xy = float2(-0.5, -0.5) + v.v4.yx;
                    r1.xy = _HighParam1[2].yx + r1.xy;
                    sincos(_HighParam1[2].z, r2.x, r3.x);
                    r1.zw = r2.xx * r1.xy;
                    r2.z = r1.y * r3.x + -r1.z;
                    r2.w = r1.x * r3.x + r1.w;
                    r1.xy = float2(0.5, 0.5) + r2.zw;
                    f.p2.xy = r1.xy * _High0Tex_ST.xy + _High0Tex_ST.zw;

                    r1 = mul(unity_ObjectToWorld, v.v0);

                    r1.x = mul(unity_MatrixV, r1).z;

                    r1.x = -_Global_FogMinDistance.w + -r1.x;
                    f.o3.x = saturate(r1.x / _Global_FogLength.w);
                    f.p3.x = r0.w ? _HighParam1[0].w : _HighParam2[0].w;
                    f.p3.y = r0.w ? _HighParam1[1].w : _HighParam2[1].w;
                    f.o3.y = r0.y / _Global_MaxHeight;
                    r1.xyz = -_FaceCenterPos.xyz + r0.xyz;
                    r0.w = dot(_FaceUp.xyz, r1.xyz);
                    r1.xyz = r0.www * _FaceUp.xyz + _FaceCenterPos.xyz;
                    r1.xyz = -r1.xyz + r0.xyz;
                    f.o5.xyz = r0.xyz;
                    r0.x = dot(r1.xyz, r1.xyz);
                    r0.x = rsqrt(r0.x);

                    r0.yzw = mul(unity_ObjectToWorld, float4(v.v1.xyz, 0)).xyz;

                    r1.xyz = r1.xyz * r0.xxx + -r0.yzw;
                    r0.xyz = _CylinderBlend * r1.xyz + r0.yzw;
                    f.o4.xyz = r0.xyz;

                    f.o6.xyz = mul(unity_MatrixV, float4(r0.xyz, 0)).xyz;

                    return f;

                }

                fixed4 frag(v2f f) : SV_Target{
                    float4 r0,r1,r2,r3;
                    float4 result;

                    r0.x = asint(_UseOriginalDirectionalLight);
                    r0.x = cmp(r0.x >= 1);
                    r0.x = r0.x ? 1.000000 : 0;
                    r0.y = dot(_OriginalDirectionalLightDir.xyz, _OriginalDirectionalLightDir.xyz);
                    r0.y = rsqrt(r0.y);
                    r0.z = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                    r0.z = rsqrt(r0.z);
                    r1.xyz = _WorldSpaceLightPos0.xyz * r0.zzz;
                    r0.yzw = _OriginalDirectionalLightDir.xyz * r0.yyy + -r1.xyz;
                    r0.xyz = r0.xxx * r0.yzw + r1.xyz;
                    r0.x = dot(f.o4.xyz, r0.xyz);
                    r0.x = r0.x * 0.5 + 0.5;
                    r0.y = _ToonStep + -_ToonFeather;
                    r0.x = r0.y + -r0.x;
                    r0.x = r0.x / _ToonFeather;
                    r0.x = saturate(1 + r0.x);
                    r0.y = cmp(0 >= _ToonFeather);
                    r0.y = r0.y ? 1.000000 : 0;
                    r0.x = r0.y * -r0.x + r0.x;

                    //r1.xyzw = t2.Sample(s2_s, f.o2.xy).xyzw;
                    r1 = tex2D(_High1Tex, f.o2.xy);

                    r1.x = r1.x * f.p3.y + -_Limit;
                    r0.y = cmp(0 < r1.x);
                    r1.y = -r1.x;
                    r0.yz = r0.yy ? float2(1,0) : r1.xy;
                    r0.w = cmp(r1.x < 0);
                    r0.yz = r0.ww ? float2(0,-1) : r0.yz;
                    r0.y = r0.y + r0.z;

                    //r1.xyzw = t1.Sample(s1_s, f.p1.xy).xyzw;
                    r1 = tex2D(_High0Tex, f.p1.xy);

                    r1.x = r1.x * f.p3.x + -_Limit;
                    r0.z = cmp(0 < r1.x);
                    r1.y = -r1.x;
                    r0.zw = r0.zz ? float2(1,0) : r1.xy;
                    r1.x = cmp(r1.x < 0);
                    r0.zw = r1.xx ? float2(0,-1) : r0.zw;
                    r0.z = r0.z + r0.w;
                    r0.yz = max(float2(0,0), r0.yz);

                    //r1.xyzw = t0.Sample(s0_s, f.o1.xy).xyzw;
                    r1 = tex2D(_MainTex, f.o1.xy);

                    r1.xyz = r1.xyz + r0.zzz;
                    result.w = r1.w;
                    r0.yzw = r1.xyz + r0.yyy;



                    //r1.xyzw = t3.Sample(s3_s, f.p2.xy).xyzw;
                    r1 = tex2D(_High2Tex, f.p2.xy);

                    r1.x = r1.x * _HighParam1[2].w + -_Limit;
                    r1.z = cmp(0 < r1.x);
                    r1.y = -r1.x;
                    r1.yz = r1.zz ? float2(1,0) : r1.xy;
                    r1.x = cmp(r1.x < 0);
                    r1.xy = r1.xx ? float2(0,-1) : r1.yz;
                    r1.x = r1.x + r1.y;
                    r1.x = max(0, r1.x);
                    r0.yzw = r1.xxx + r0.yzw;
                    r1.xyz = _GlobalToonColor.xyz * r0.yzw;
                    r1.xyz = float3(0.699999988,0.699999988,0.699999988) * r1.xyz;
                    r2.xyz = float3(-1,-1,-1) + _ToonDarkColor.xyz;
                    r1.w = cmp(0.5 >= _ToonDarkColor.w);
                    r2.w = r1.w ? 1.000000 : 0;
                    r3.xyz = r1.www ? float3(0,0,0) : _ToonDarkColor.xyz;
                    r2.xyz = r2.www * r2.xyz + float3(1,1,1);
                    r1.xyz = r1.xyz * r2.xyz + r3.xyz;
                    r2.xyz = float3(-1,-1,-1) + _ToonBrightColor.xyz;
                    r1.w = cmp(0.5 >= _ToonBrightColor.w);
                    r2.w = r1.w ? 1.000000 : 0;
                    r3.xyz = r1.www ? float3(0,0,0) : _ToonBrightColor.xyz;
                    r2.xyz = r2.www * r2.xyz + float3(1,1,1);
                    r0.yzw = r0.yzw * r2.xyz + r3.xyz;
                    r1.xyz = r1.xyz + -r0.yzw;
                    r0.xyz = r0.xxx * r1.xyz + r0.yzw;
                    r1.xyz = _LightProbeColor.xyz * _CharaColor.xyz;
                    r0.xyz = r0.xyz * r1.xyz + -_Global_FogColor.xyz;
                    r1.xy = float2(1,1) + -f.o3.xy;
                    r0.w = saturate(r1.x * r1.y + _Global_MaxDensity);
                    r0.xyz = r0.www * r0.xyz + _Global_FogColor.xyz;
                    r0.w = dot(r0.xyz, float3(0.212500006,0.715399981,0.0720999986));
                    r0.xyz = _Saturation * r0.xyz;
                    r1.x = 1 + -_Saturation;
                    result.xyz = r0.www * r1.xxx + r0.xyz;
                    return result;
                }

                ENDCG
            }
        }
            Fallback "Diffuse"
}