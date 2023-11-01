// Upgrade NOTE: replaced 'glstate_matrix_projection' with 'UNITY_MATRIX_P'

Shader "Gallop/3D/Chara/ToonFace/TSER" {
	Properties {
		_MainTex("Diffuse Map", 2D) = "white" { }
		_TripleMaskMap("_TripleMaskMap", 2D) = "white" { }
		_OptionMaskMap("_OptionMaskMap", 2D) = "black" { }
		[MaterialToggle] _UseOptionMaskMap("_UseOptionMaskMap", Float) = 0
		[Header(Specular)] _SpecularColor("_SpecularColor", Color) = (1,1,1,1)
		_SpecularPower("_SpecularPower", Range(0, 1)) = 0
		[Header(Toon)] _ToonMap("_ToonMap", 2D) = "white" { }
		_ToonStep("_ToonStep", Range(0, 1)) = 0.5
		_ToonFeather("_ToonFeather", Range(0.0001, 1)) = 0.0001
		[Header(Environment)] _EnvMap("_EnvMap", 2D) = "black" { }
		_EnvRate("_EnvRate", Range(0, 1)) = 0.5
		_EnvBias("_EnvBias", Range(0, 8)) = 1
		[Header(Rim)] _RimStep("_RimStep", Range(0, 1)) = 0.5
		_RimFeather("_RimFeather", Range(0.0001, 1)) = 0.3
		_RimColor("_RimColor", Color) = (1,1,1,0.3922)
		_RimSpecRate("_RimSpecRate", Range(0, 1)) = 0
		_RimShadow("_RimShadow", Range(0, 2)) = 0
		[Header(Outline)] _OutlineWidth("_OutlineWidth", Range(0.01, 5)) = 1
		_OutlineColor("_OutlineColor", Color) = (0.125,0.047,0,0.098)
		[Header(Dirt)] _DirtTex("_DirtTex", 2D) = "black" { }
		_DirtScale("_DirtScale", Range(0, 1)) = 1
		[Header(Emissive)] _EmissiveTex("_EmissiveTex", 2D) = "black" { }
		_EmissiveColor("_EmissiveColor", Color) = (1,1,1,1)
		[Header(Other)] _CharaColor("_CharaColor", Color) = (1,1,1,1)
		_Saturation("_Saturation", Range(0, 1)) = 1
		_ToonBrightColor("_ToonBrightColor", Color) = (1,1,1,0)
		_ToonDarkColor("_ToonDarkColor", Color) = (1,1,1,0)
		_StencilMask("Stencil Mask", Float) = 100
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp("Stencil Comparison", Float) = 8
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilOp("Stencil Operation", Float) = 2
		_LightProbeColor("_LightProbeColor", Color) = (1,1,1,1)
		_Cutoff("_Cutoff", Range(0, 1)) = 0.98
		_UseOriginalDirectionalLight("_UseOriginalDirectionalLight", Float) = 0
		_OriginalDirectionalLightDir("_OriginalDirectionalLightDir", Vector) = (1,1,1,1)
		_CheekPretenseThreshold("_CheekPretenseThreshold", Range(0, 0.9999)) = 0.775
		_NosePretenseThreshold("_NosePretenseThreshold", Range(0, 0.9999)) = 0.775
		_NoseVisibility("_NoseVisibility", Range(0, 1)) = 1
		_CylinderBlend("_CylinderBlend", Range(0, 1)) = 0
		_HairNormalBlend("_HairNormalBlend", Range(0, 1)) = 1
		_VertexColorToonPower("_VertexColorToonPower", Range(0, 2)) = 1
		_faceShadowAlpha("_faceShadowAlpha", Range(0, 1)) = 0
		_faceShadowEndY("_faceShadowEndY", Range(-1, 1)) = 0
		_faceShadowLength("_faceShadowLength", Range(0, 1)) = 0.1
		_faceShadowColor("_faceShadowColor", Color) = (0.6,0.6,1,1)
		[Header(MaskColor)] _MaskColorTex("MaskColorTex", 2D) = "gray" { }
		_MaskColorR1("MaskColorR1", Color) = (1,1,1,1)
		_MaskColorR2("MaskColorR2", Color) = (1,1,1,1)
		_MaskColorG1("MaskColorG1", Color) = (1,1,1,1)
		_MaskColorG2("MaskColorG2", Color) = (1,1,1,1)
		_MaskColorB1("MaskColorB1", Color) = (1,1,1,1)
		_MaskColorB2("MaskColorB2", Color) = (1,1,1,1)
		_MaskToonColorR1("MaskToonColorR1", Color) = (1,1,1,1)
		_MaskToonColorR2("MaskToonColorR2", Color) = (1,1,1,1)
		_MaskToonColorG1("MaskToonColorG1", Color) = (1,1,1,1)
		_MaskToonColorG2("MaskToonColorG2", Color) = (1,1,1,1)
		_MaskToonColorB1("MaskToonColorB1", Color) = (1,1,1,1)
		_MaskToonColorB2("MaskToonColorB2", Color) = (1,1,1,1)
	}
	//DummyShaderTextExporter
	SubShader{
		LOD 100
		Tags { "MyShadow" = "Chara" "QUEUE" = "Geometry-1" "RenderType" = "Opaque" }
		Pass {
		    Name "Toon"
		    LOD 100
		    Tags { "LIGHTMODE" = "UniversalForward" "MyShadow" = "Chara" "QUEUE" = "Geometry-1" "RenderType" = "Opaque" }
		    Stencil
		    {
			    Ref[_StencilMask]
			    Comp[_StencilComp]
			    Pass[_StencilOp]
		    }
		    CGPROGRAM
		    #pragma vertex vert
		    #pragma fragment frag

            #define cmp -

		    float4 _Global_FogMinDistance;
		    float4 _Global_FogLength;

		    float _Global_MaxDensity;
		    float _Global_MaxHeight;

		    float4 _MainTex_ST;

		    float _CylinderBlend;

		    float3 _FaceCenterPos;
		    float3 _FaceUp;

		    float _SpecularPower;

		    matrix _faceShadowHeadMat;

            float _RimVerticalOffset;
            float _RimHorizonOffset;

            float _UseOptionMaskMap;

            float4 _SpecularColor;
            float4 _LightColor0;

            float4 _GlobalToonColor;

            float4 _ToonBrightColor;
            float4 _ToonDarkColor;

            float _VertexColorToonPower;
            float _UseOriginalDirectionalLight;

            float3 _OriginalDirectionalLightDir;

            float _ToonStep;
            float _ToonFeather;

            float4 _GlobalDirtColor;
            float4 _GlobalDirtRimSpecularColor;
            float4 _GlobalDirtToonColor;

            float _DirtScale;
            float _DirtRate[3];

            float _EnvRate;
            float _EnvBias;

            float _RimStep;
            float _RimFeather;
            float4 _RimColor;
            float _RimShadow;
            float _RimSpecRate;
            float _RimShadowRate;
            float _RimStep2;
            float _RimFeather2;
            float4 _RimColor2;
            float _RimSpecRate2;
            float _RimHorizonOffset2;
            float _RimVerticalOffset2;
            float _RimShadowRate2;

            float4 _GlobalRimColor;

            float3 _FaceForward;

            float _CheekPretenseThreshold;
            float _NosePretenseThreshold;
            float _NoseVisibility;

            float4 _EmissiveColor;
            float4 _LightProbeColor;
            float4 _CharaColor;

            float _faceShadowAlpha;
            float _faceShadowEndY;
            float _faceShadowLength;
            float4 _faceShadowColor;

            float4 _Global_FogColor;
            float _Saturation;


            sampler2D _EnvMap;
            sampler2D _OptionMaskMap;
            sampler2D _ToonMap;
            sampler2D _MainTex;
            sampler2D _TripleMaskMap;
            sampler2D _DirtTex;
            sampler2D _EmissiveTex;

		    struct a2v {
			    float4 v0 : POSITION0;
			    float2 v1 : TEXCOORD0;
			    float3 v2 : NORMAL0;
			    float4 v3 : COLOR0;
		    };

		    struct v2f {
			    float4 o0 : SV_POSITION0;
			    float2 o1 : TEXCOORD0;
			    float p1 : TEXCOORD5;
			    float4 o2 : TEXCOORD7;
			    float4 o3 : TEXCOORD8;
			    float4 o4 : TEXCOORD1;
			    float4 o5 : TEXCOORD2;
			    float4 o6 : TEXCOORD3;
			    float4 o7 : TEXCOORD4;
			    float4 o8 : TEXCOORD9;
		    };

		    v2f vert(a2v v) {

			    v2f f;
			    UNITY_INITIALIZE_OUTPUT(v2f, f);

			    float4 r0, r1, r2;

			    r0 = mul(unity_ObjectToWorld, v.v0);

			    f.o0 = mul(unity_MatrixVP, r0);

			    r1 = mul(unity_ObjectToWorld, v.v0);

			    r0.w = mul(unity_MatrixV, r1).z;

			    r0.w = -_Global_FogMinDistance.w + -r0.w;
			    r0.w = saturate(r0.w / _Global_FogLength.w);
			    r0.w = 1 + -r0.w;
			    r1.x = saturate(r0.y / _Global_MaxHeight);
			    r1.x = 1 + -r1.x;
			    f.p1.x = saturate(r0.w * r1.x + _Global_MaxDensity);
			    f.o1.xy = v.v1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			    f.o2.xyz = float3(0, 0, 0);
			    f.o3.xyzw = v.v3.xyzw;
			    r0.w = 1 + -_CylinderBlend;
			    r0.w = v.v3.z * r0.w;

			    r1.xyz = mul(unity_ObjectToWorld, float4(v.v2, 0)).xyz;

			    r2.xyz = -_FaceCenterPos + r0.xyz;
			    r1.w = dot(_FaceUp, r2.xyz);
			    r2.xyz = r1.www * _FaceUp + _FaceCenterPos;
			    r2.xyz = -r2.xyz + r0.xyz;
			    r1.w = dot(r2.xyz, r2.xyz);
			    r1.w = rsqrt(r1.w);
			    r1.xyz = -r2.xyz * r1.www + r1.xyz;
			    r2.xyz = r2.xyz * r1.www;
			    r1.xyz = r0.www * r1.xyz + r2.xyz;
			    f.o4.xyz = r1.xyz;
			    f.o5.xyz = r0.xyz;

			    f.o6.xyz = mul(unity_MatrixV, float4(r1.xyz, 0)).xyz;

			    r0.w = _SpecularPower * -10 + 11;
			    f.o7.x = exp2(r0.w);
			    f.o7.yzw = float3(0, 0, 0);

			    f.o8 = mul(_faceShadowHeadMat, r0);

			    return f;

		    }

		    fixed4 frag(v2f f) : SV_Target{

			    float4 r0,r1,r2,r3,r4,r5,r6,r7,r8,r9,r10,r11,r12;
			    float4 result;

                r0.xy = float2(1, 1) + f.o6.xy;
                r0.xy = float2(0.5, 0.5) * r0.xy;

                //r0.xyzw = t5.Sample(s3_s, r0.xy).xyzw;
                r0 = tex2D(_EnvMap, r0.xy);

                r0.w = _SpecularPower * 10 + 1;
                r0.w = max(0, r0.w);
                r1.x = cmp(-0 >= _RimVerticalOffset);
                r1.y = cmp(-0 >= _RimHorizonOffset);
                r1.xy = r1.xy ? float2(1, 1) : float2(-1, -1);
                r2.xyz = _WorldSpaceCameraPos.xyz + -f.o5.xyz;
                r1.z = dot(r2.xyz, r2.xyz);
                r1.z = rsqrt(r1.z);
                r2.xyz = r2.xyz * r1.zzz;
                r3.x = unity_MatrixV[0].x; //cb3[9].x
                r3.y = unity_MatrixV[0].y; //cb3[10].x
                r3.z = unity_MatrixV[0].z; //cb3[11].x
                r1.yzw = r3.xyz * r1.yyy + -r2.xyz;
                r1.yzw = abs(_RimHorizonOffset) * r1.yzw + r2.xyz;
                r4.x = unity_MatrixV[1].x;  //cb3[9].y;
                r4.y = unity_MatrixV[1].y; //cb3[10].y;
                r4.z = unity_MatrixV[1].z; //cb3[11].y;
                r5.xyz = r4.xyz * r1.xxx + -r1.yzw;
                r1.xyz = abs(_RimVerticalOffset) * r5.xyz + r1.yzw;
                r1.x = dot(r1.xyz, f.o4.xyz);
                r1.y = max(0, r1.x);
                r1.y = log2(r1.y);
                r0.w = r1.y * r0.w;
                r0.w = exp2(r0.w);
                r0.w = min(1, r0.w);

                //r5.xyzw = t2.Sample(s2_s, f.o1.xy).xyzw;
                //r5 = tex2D(_OptionMaskMap, f.o1.xy);

                //预处理可选贴图
                float4 option = tex2D(_OptionMaskMap, f.o1.xy);
                r1.z = option.y * _UseOptionMaskMap;
                r1.w = (option.z - 0.5) * _UseOptionMaskMap + 0.5;

                r0.w = r1.y * r0.w;
                r5.xyz = _SpecularColor.xyz * _LightColor0.xyz;
                r5.xyz = r5.xyz * r0.www;
                r5.xyz = max(float3(0, 0, 0), r5.xyz);

                //r6.xyzw = t3.Sample(s4_s, f.o1.xy).xyzw;
                r6 = tex2D(_ToonMap, f.o1.xy);

                r6.xyz = _LightColor0.xyz * r6.xyz;
                r6.xyz = _GlobalToonColor.xyz * r6.xyz;
                r7.xyz = float3(-1, -1, -1) + _ToonDarkColor.xyz;
                r0.w = 1 + -f.o3.w;
                r0.w = _VertexColorToonPower * r0.w;
                r1.y = asint(_UseOriginalDirectionalLight);
                r1.y = cmp(r1.y >= 1);
                r1.y = r1.y ? 1.000000 : 0;
                r2.w = dot(_OriginalDirectionalLightDir.xyz, _OriginalDirectionalLightDir.xyz);
                r2.w = rsqrt(r2.w);
                r3.w = dot(_WorldSpaceLightPos0.xyz, _WorldSpaceLightPos0.xyz);
                r3.w = rsqrt(r3.w);
                r8.xyz = _WorldSpaceLightPos0.xyz * r3.www;
                r9.xyz = _OriginalDirectionalLightDir.xyz * r2.www + -r8.xyz;
                r8.xyz = r1.yyy * r9.xyz + r8.xyz;
                r1.y = dot(f.o4.xyz, r8.xyz);
                r2.w = 0.5 * r1.y;
                r2.w = min(0, r2.w);
                r2.w = 0.5 + r2.w;
                r0.w = dot(r0.ww, r2.ww);
                r0.w = 1 + -r0.w;
                r2.w = cmp(0.5 >= _ToonDarkColor.w);
                r3.w = r2.w ? 1.000000 : 0;
                r9.xyz = r2.www ? float3(0, 0, 0) : _ToonDarkColor.xyz;
                r9.xyz = r9.xyz * r0.www;
                r2.w = r3.w * r0.w;
                r7.xyz = r2.www * r7.xyz + float3(1, 1, 1);
                r6.xyz = r6.xyz * r7.xyz + r9.xyz;
                r2.w = cmp(0.5 >= _ToonBrightColor.w);
                r3.w = r2.w ? 1.000000 : 0;
                r7.xyz = r2.www ? float3(0, 0, 0) : _ToonBrightColor.xyz;
                r7.xyz = r7.xyz * r0.www;
                r0.w = r3.w * r0.w;
                r9.xyz = float3(-1, -1, -1) + _ToonBrightColor.xyz;
                r9.xyz = r0.www * r9.xyz + float3(1, 1, 1);

                //r10.xyzw = t0.Sample(s0_s, f.o1.xy).xyzw;
                r10 = tex2D(_MainTex, f.o1.xy);

                r10.xyz = _LightColor0.xyz * r10.xyz;

                result.w = r10.w;
                r7.xyz = r10.xyz * r9.xyz + r7.xyz;

                

                r9.xyz = -r7.xyz + r6.xyz;

                r0.w = cmp(0 >= _ToonFeather);
                r0.w = r0.w ? 1.000000 : 0;
                r2.w = -_ToonFeather + _ToonStep;
                r3.w = r1.y * 0.5 + 0.5;
                r1.y = max(0, r1.y);

                //r10.xyzw = t1.Sample(s1_s, f.o1.xy).xyzw;
                r10 = tex2D(_TripleMaskMap, f.o1.xy);

                r2.w = -r10.x * r3.w + r2.w;
                r3.w = -r10.x * r3.w + _ToonStep;
                r3.w = -0.0500000007 + r3.w;
                r3.w = saturate(r3.w * 20 + 1);
                r2.w = r2.w / _ToonFeather;
                r2.w = saturate(1 + r2.w);
                r0.w = r0.w * -r2.w + r2.w;
                r11.xyz = r0.www * r9.xyz + r7.xyz;

                

                r5.xyz = r11.xyz + r5.xyz;
                r11.xyz = _GlobalDirtToonColor.xyz + -_GlobalDirtColor.xyz;
                r11.xyz = r0.www * r11.xyz + _GlobalDirtColor.xyz;
                r11.xyz = r11.xyz + -r5.xyz;

                

                //r12.xyzw = t4.Sample(s5_s, f.o1.xy).xyzw;
                r12 = tex2D(_DirtTex, f.o1.xy);

                r12.xyz = _DirtScale * r12.xyz;
                r0.w = _DirtRate[1] * r12.y;
                r0.w = r12.x * _DirtRate[0] + r0.w;
                r0.w = r12.z * _DirtRate[2] + r0.w;
                r5.xyz = r0.www * r11.xyz + r5.xyz;

                

                r0.xyz = r5.xyz * r0.xyz;
                r0.xyz = r0.xyz * _EnvBias + -r5.xyz;
                r1.z = _EnvRate * r1.z;
                r0.xyz = r1.zzz * r0.xyz + r5.xyz;

                

                r1.z = _RimStep + -_RimFeather;
                r1.x = r1.z + -r1.x;
                r1.x = r1.x / _RimFeather;
                r1.x = saturate(1 + r1.x);
                r1.x = r1.x * r1.x;
                r1.x = r1.x * r1.x;
                r1.x = _RimColor.w * r1.x;
                r1.x = r1.x * r1.w;
                r5.xyz = _RimColor.xyz + -_SpecularColor.xyz;
                r5.xyz = _RimSpecRate * r5.xyz + _SpecularColor.xyz;
                r5.xyz = r5.xyz * r1.xxx;
                r1.x = _RimShadow + r1.y;
                r1.y = _RimShadowRate2 + r1.y;
                r1.x = _RimShadowRate + r1.x;
                r5.xyz = r5.xyz * r1.xxx;
                r0.xyz = r5.xyz * _GlobalRimColor.xyz + r0.xyz;

                r1.xz = cmp(float2(-0, -0) >= float2(_RimHorizonOffset2, _RimVerticalOffset2));
                r1.xz = r1.xz ? float2(1, 1) : float2(-1, -1);
                r3.xyz = r3.xyz * r1.xxx + -r2.xyz;
                r2.xyz = abs(_RimHorizonOffset2) * r3.xyz + r2.xyz;
                r3.xyz = r4.xyz * r1.zzz + -r2.xyz;
                r2.xyz = abs(_RimVerticalOffset2) * r3.xyz + r2.xyz;
                r1.x = dot(r2.xyz, f.o4.xyz);
                r1.z = _RimStep2 + -_RimFeather2;
                r1.x = r1.z + -r1.x;
                r1.x = r1.x / _RimFeather2;
                r1.x = saturate(1 + r1.x);
                r1.x = r1.x * r1.x;
                r1.x = r1.x * r1.x;
                r1.x = _RimColor.w * r1.x;
                r1.x = r1.x * r1.w;
                r2.xyz = _RimColor2.xyz + -_SpecularColor.xyz;
                r2.xyz = _RimSpecRate2 * r2.xyz + _SpecularColor.xyz;
                r1.xzw = r2.xyz * r1.xxx;
                r1.xyz = r1.xzw * r1.yyy;
                r0.xyz = r1.xyz * _GlobalRimColor.xyz + r0.xyz;
                r1.xy = _GlobalRimColor.xy * r5.xy;
                r1.x = r1.x + r1.y;
                r1.x = r5.z * _GlobalRimColor.z + r1.x;
                r1.x = cmp(9.99999975e-06 >= r1.x);
                r1.xyz = r1.xxx ? _GlobalDirtColor.xyz : _GlobalDirtRimSpecularColor.xyz;
                r1.xyz = r1.xyz + -r0.xyz;
                r0.xyz = r0.www * r1.xyz + r0.xyz;
                r0.w = 1 + -r0.w;
                r1.xyz = _FaceForward.zxy * r8.yzx;
                r1.xyz = _FaceForward.yzx * r8.zxy + -r1.xyz;
                r1.x = dot(r1.xyz, _FaceUp);
                r1.x = cmp(r1.x >= 0);
                r1.yzw = -_FaceCenterPos.yzx + f.o5.yzx;
                r2.xyz = _FaceForward.zxy * r1.yzw;
                r1.yzw = _FaceForward.yzx * r1.zwy + -r2.xyz;
                r1.y = dot(r1.yzw, _FaceUp);
                r1.y = cmp(r1.y >= 0);
                r1.xy = r1.xy ? float2(1, 1) : float2(-1, -1);
                r1.x = r1.y * r1.x + 1;
                r1.x = 0.5 * r1.x;
                r1.yzw = r1.xxx * r9.xyz + r7.xyz;
                r2.xyz = r7.xyz + -r6.xyz;
                r2.xyz = r1.xxx * r2.xyz + r6.xyz;
                r1.xyz = r1.yzw + -r0.xyz;
                r1.w = dot(_FaceForward.xyz, -r8.xyz);
                r1.w = 0.100000001 + r1.w;
                r1.w = max(0, r1.w);
                r1.w = 0.5 + -r1.w;
                r1.w = -abs(r1.w) * 2 + 1;
                r1.w = max(0, r1.w);
                r2.w = dot(_FaceUp, r8.xyz);
                r3.x = dot(_FaceForward.xyz, r8.xyz);
                r3.x = 1 + -abs(r3.x);
                r3.x = saturate(r3.x + r3.x);
                r2.w = min(0, r2.w);
                r2.w = 1 + r2.w;
                r2.w = r2.w * r2.w;
                r1.w = r2.w * r1.w;
                r2.w = -0.50999999 + r10.y;
                r2.w = max(0, r2.w);
                r2.w = r2.w * r3.w;
                r1.w = dot(r2.ww, r1.ww);
                r3.yz = float2(1, 1) + -float2(_CheekPretenseThreshold, _NosePretenseThreshold);
                r1.w = cmp(r1.w >= r3.y);
                r1.w = r1.w ? 1.000000 : 0;
                r2.w = cmp(r10.y >= 0.50999999);
                r2.w = r2.w ? 1.000000 : 0;
                r1.w = r2.w * r1.w;
                r0.xyz = r1.www * r1.xyz + r0.xyz;
                r1.xyz = r2.xyz + -r0.xyz;
                r1.w = min(0.49000001, r10.y);
                r1.w = r1.w * -2 + 1;
                r1.w = r1.w * r3.x;
                r1.w = cmp(r1.w >= r3.z);
                r1.w = r1.w ? 1.000000 : 0;
                r2.x = cmp(0.49000001 >= r10.y);
                r2.x = r2.x ? 1.000000 : 0;
                r1.w = r2.x * r1.w;
                r1.w = _NoseVisibility * r1.w;
                r0.xyz = r1.www * r1.xyz + r0.xyz;

                //r1.xyzw = t6.Sample(s6_s, f.o1.xy).xyzw;
                r1 = tex2D(_EmissiveTex, f.o1.xy);

                r1.xyz = _EmissiveColor.xyz * r1.xyz;
                r1.xyz = r1.xyz * r0.www;
                r2.xyz = _LightProbeColor.xyz * _CharaColor.xyz;
                r0.xyz = r0.xyz * r2.xyz + r1.xyz;
                r0.w = -_faceShadowEndY + f.o8.y;
                r0.w = saturate(r0.w / _faceShadowLength);
                r1.x = -r0.w * _faceShadowAlpha + 1;
                r0.w = _faceShadowAlpha * r0.w;
                r0.w = r10.z * r0.w;
                r1.yzw = r0.www * r0.xyz;
                r0.w = r10.z * r1.x;
                r1.x = 1 + -r10.z;
                r2.xyz = r0.www * r0.xyz;
                r0.xyz = r1.xxx * r0.xyz + r2.xyz;
                r0.xyz = r1.yzw * _faceShadowColor.xyz + r0.xyz;
                r0.xyz = -_Global_FogColor.xyz + r0.xyz;
                r0.xyz = f.p1.xxx * r0.xyz + _Global_FogColor.xyz;
                r0.w = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
                r0.xyz = _Saturation * r0.xyz;
                r1.x = 1 + -_Saturation;
                result.xyz = r0.www * r1.xxx + r0.xyz;
                return result;
		    }


		    ENDCG
	    }

        Pass{
        Name "Outline"
        LOD 100
        Tags { "LIGHTMODE" = "Outline" "MyShadow" = "Chara" "QUEUE" = "Geometry-1" "RenderType" = "Opaque" }
        ZTest Less
        Cull Front
        Offset 1, -1
        Stencil {
            Ref[_StencilMask]
            Comp[_StencilComp]
            Pass[_StencilOp]
        }
        CGPROGRAM
        #pragma vertex vert
        #pragma fragment frag

#define cmp -

        float _GlobalCameraFov;
        float _GlobalOutlineWidth;
        float _OutlineWidth;
        float _GlobalOutlineOffset;
        float _Global_MaxHeight;
        float4 _Global_FogMinDistance;
        float4 _Global_FogLength;

        float4 _OutlineColor;
        float4 _Global_FogColor;
        float _Global_MaxDensity;
        float4 _CharaColor;
        float _Saturation;
        float4 _LightProbeColor;

        sampler2D _MainTex;

        struct a2v {
            float4 v0 : POSITION0;
            float3 v1 : TANGENT0;
            float2 v2 : TEXCOORD0;
            float4 v3 : COLOR0;
        };

        struct v2f {
            float4 o0 : SV_POSITION0;
            float2 o1 : TEXCOORD10;
            float2 p1 : TEXCOORD11;
        };

        v2f vert(a2v v) {

            v2f f;
            UNITY_INITIALIZE_OUTPUT(v2f, f);

            float4 r0, r1, r2;
            /*
            r0.xyz = cb2[14].yyy * cb1[5].xyz;
            r0.xyz = cb1[4].xyz * cb2[14].xxx + r0.xyz;
            r0.xyz = cb1[6].xyz * cb2[14].zzz + r0.xyz;
            r0.xyz = cb1[7].xyz * cb2[14].www + r0.xyz;
            */
            r0.xyz = mul(unity_WorldToObject, float4(unity_MatrixInvV[0].y, unity_MatrixInvV[1].y, unity_MatrixInvV[2].y, unity_MatrixInvV[3].y)).xyz;

            r0.x = dot(r0.xyz, v.v1.xyz);
            //r0.xy = cb2[6].xy * r0.xx;
            r0.xy = float2(UNITY_MATRIX_P[0].y, UNITY_MATRIX_P[1].y) * r0.xx;

            /*
            r1.xyz = cb2[13].yyy * cb1[5].xyz;
            r1.xyz = cb1[4].xyz * cb2[13].xxx + r1.xyz;
            r1.xyz = cb1[6].xyz * cb2[13].zzz + r1.xyz;
            r1.xyz = cb1[7].xyz * cb2[13].www + r1.xyz;
            */

            r1.xyz = mul(unity_WorldToObject, float4(unity_MatrixInvV[0].x, unity_MatrixInvV[1].x, unity_MatrixInvV[2].x, unity_MatrixInvV[3].x)).xyz;

            r0.z = dot(r1.xyz, v.v1.xyz);
            //r0.xy = cb2[5].xy * r0.zz + r0.xy;
            r0.xy = float2(UNITY_MATRIX_P[0].x, UNITY_MATRIX_P[1].x) * r0.zz + r0.xy;

            /*
            r1.xyz = cb2[15].yyy * cb1[5].xyz;
            r1.xyz = cb1[4].xyz * cb2[15].xxx + r1.xyz;
            r1.xyz = cb1[6].xyz * cb2[15].zzz + r1.xyz;
            r1.xyz = cb1[7].xyz * cb2[15].www + r1.xyz;
            */
            r1.xyz = mul(unity_WorldToObject, float4(unity_MatrixInvV[0].z, unity_MatrixInvV[1].z, unity_MatrixInvV[2].z, unity_MatrixInvV[3].z)).xyz;

            r0.z = dot(r1.xyz, v.v1.xyz);
            //r0.xy = cb2[7].xy * r0.zz + r0.xy;
            r0.xy = float2(UNITY_MATRIX_P[0].z, UNITY_MATRIX_P[1].z) * r0.zz + r0.xy;

            //r0.xy = cb2[8].xy + r0.xy;
            r0.xy = float2(UNITY_MATRIX_P[0].w, UNITY_MATRIX_P[1].w) + r0.xy;

            r0.z = _GlobalCameraFov * 0.5 + 0.75;
            r0.xy = r0.xy * r0.zz;
            r0.z = _GlobalOutlineWidth * v.v3.x;
            r0.z = _OutlineWidth.x * r0.z;
            r0.z = 0.0027999999 * r0.z;

            /*
            r1.xyzw = cb1[1].xyzw * v.v0.yyyy;
            r1.xyzw = cb1[0].xyzw * v.v0.xxxx + r1.xyzw;
            r1.xyzw = cb1[2].xyzw * v.v0.zzzz + r1.xyzw;
            r1.xyzw = cb1[3].xyzw + r1.xyzw;
            */
            r1 = mul(unity_ObjectToWorld, v.v0);

            /*
            r2.xyzw = cb2[18].xyzw * r1.yyyy;
            r2.xyzw = cb2[17].xyzw * r1.xxxx + r2.xyzw;
            r2.xyzw = cb2[19].xyzw * r1.zzzz + r2.xyzw;
            r2.xyzw = cb2[20].xyzw * r1.wwww + r2.xyzw;
            */
            r2 = mul(unity_MatrixVP, r1);


            f.o0.xy = r0.xy * r0.zz + r2.xy;
            r0.x = 1 + -v.v3.y;
            r0.x = 0.0187500007 * r0.x;
            r0.x = _GlobalCameraFov * r0.x;
            f.o0.z = -r0.x * _GlobalOutlineOffset + r2.z;
            f.o0.w = r2.w;

            /*
            r0.x = cb2[10].z * r1.y;
            r0.x = cb2[9].z * r1.x + r0.x;
            r0.x = cb2[11].z * r1.z + r0.x;
            r0.x = cb2[12].z * r1.w + r0.x;
            */
            r0.x = mul(unity_MatrixV, r1).z;

            f.p1.y = r1.y / _Global_MaxHeight;
            r0.x = -_Global_FogMinDistance.w + -r0.x;
            f.p1.x = saturate(r0.x / _Global_FogLength.w);
            f.o1.xy = v.v2.xy;
            return f;

        }

        fixed4 frag(v2f f) : SV_Target{
            float4 r0,r1,r2;
            float4 result;

            r0.x = cmp(_OutlineColor.w >= 0.5);
            r0.x = r0.x ? 1.000000 : 0;
            r1.xyzw = float4(-0.5,-1,-1,-1) + _OutlineColor.wxyz;
            r0.y = r1.x + r1.x;
            r0.yzw = r0.yyy * r1.yzw + float3(1,1,1);
            r1.x = _OutlineColor.w + _OutlineColor.w;

            //r2.xyzw = t0.Sample(s0_s, f.o1.xy).xyzw;
            r2 = tex2D(_MainTex, f.o1.xy);

            r1.yzw = -_OutlineColor.xyz + r2.xyz;
            r1.xyz = r1.xxx * r1.yzw + _OutlineColor.xyz;
            r0.yzw = r2.xyz * r0.yzw + -r1.xyz;
            r0.xyz = r0.xxx * r0.yzw + r1.xyz;
            result.w = r2.w;
            r1.xyz = _LightProbeColor.xyz * _CharaColor.xyz;
            r0.xyz = r0.xyz * r1.xyz + -_Global_FogColor.xyz;
            r1.xy = float2(1,1) + -f.p1.xy;
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