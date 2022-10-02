Shader "Gallop/3D/Chara/ToonMayu" {
	Properties {
		_MainTex("Diffuse Map", 2D) = "white" { }
		_TripleMaskMap("_TripleMaskMap", 2D) = "white" { }
		_OptionMaskMap("_OptionMaskMap", 2D) = "black" { }
		_UseOptionMaskMap("_UseOptionMaskMap", Float) = 0
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
		_RimShadow("_RimShadow", Range(0, 2)) = 0
		[Header(Outline)] _OutlineParam("Outline Param : x=Width y=Brightness", Vector) = (1,0.5,0,0)
		[Header(Other)] _CharaColor("_CharaColor", Color) = (1,1,1,1)
		_Saturation("_Saturation", Range(0, 1)) = 1
		_ToonBrightColor("_ToonBrightColor", Color) = (1,1,1,0)
		_ToonDarkColor("_ToonDarkColor", Color) = (1,1,1,0)
		_LightProbeColor("_LightProbeColor", Color) = (1,1,1,1)
		_StencilMask("Stencil Mask", Float) = 100
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp("Stencil Comparison", Float) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilOp("Stencil Operation", Float) = 0
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
		Tags { "QUEUE" = "Geometry-1" "RenderType" = "Opaque" }
		Pass {
		Name "ToonMayu/R"
		LOD 100
		Tags { "LIGHTMODE" = "FORWARDBASE" "QUEUE" = "Geometry-1" "RenderType" = "Opaque" }
		ZTest Off
		ZWrite Off
		Stencil {
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
		float4 _Global_FogColor;
		float4 _ToonDarkColor;
		float4 _CharaColor;
		float _Saturation;
		float4 _LightProbeColor;

		sampler2D _MainTex;



		struct a2v {
			float4 v0 : POSITION0;
			float2 v1 : TEXCOORD0;
			float3 v2 : NORMAL0;
		};

		struct v2f {
			float4 o0 : SV_POSITION0;
			float2 o1 : TEXCOORD0;
			float p1 : TEXCOORD5;
			float3 o2 : TEXCOORD7;
		};

		v2f vert(a2v v) {

			v2f f;
			UNITY_INITIALIZE_OUTPUT(v2f, f);

			float4 r0, r1;
			
			/*
			r0.xyz = cb1[1].xyz * v.v0.yyy;
			r0.xyz = cb1[0].xyz * v.v0.xxx + r0.xyz;
			r0.xyz = cb1[2].xyz * v.v0.zzz + r0.xyz;
			r0.xyz = cb1[3].xyz + r0.xyz;
			*/

			r0.xyz = mul(unity_ObjectToWorld, float4(v.v0.xyz, 1)).xyz;

			/*
			r1.xyzw = cb2[18].xyzw * r0.yyyy;
			r1.xyzw = cb2[17].xyzw * r0.xxxx + r1.xyzw;
			r1.xyzw = cb2[19].xyzw * r0.zzzz + r1.xyzw;
			f.o0.xyzw = cb2[20].xyzw + r1.xyzw;
			*/

			f.o0 = mul(unity_MatrixVP, float4(r0.xyz, 1));


			r0.x = saturate(r0.y / _Global_MaxHeight);
			
			/*
			r1.xyzw = cb1[1].xyzw * v.v0.yyyy;
			r1.xyzw = cb1[0].xyzw * v.v0.xxxx + r1.xyzw;
			r1.xyzw = cb1[2].xyzw * v.v0.zzzz + r1.xyzw;
			r1.xyzw = cb1[3].xyzw + r1.xyzw;
			*/

			r1 = mul(unity_ObjectToWorld, float4(v.v0.xyz, 1));

			/*
			r0.y = cb2[10].z * r1.y;
			r0.y = cb2[9].z * r1.x + r0.y;
			r0.y = cb2[11].z * r1.z + r0.y;
			r0.y = cb2[12].z * r1.w + r0.y;
			*/

			r0.y = mul(unity_MatrixV, r1).z;

			r0.y = -_Global_FogMinDistance.w + -r0.y;
			r0.y = saturate(r0.y / _Global_FogLength.w);
			r0.xy = float2(1, 1) + -r0.xy;
			f.p1.x = saturate(r0.y * r0.x + _Global_MaxDensity);
			f.o1.xy = v.v1.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			f.o2.xyz = float3(0, 0, 0);
			return f;

		}

		fixed4 frag(v2f f) : SV_Target{

			float4 r0,r1,r2;
			float4 result;
			
			r0.xyz = float3(-1,-1,-1) + _ToonDarkColor.xyz;
			r0.w = cmp(0.5 >= _ToonDarkColor.w);
			r1.x = r0.w ? 1.000000 : 0;
			r1.yzw = r0.www ? float3(0,0,0) : _ToonDarkColor.xyz;
			r0.xyz = r1.xxx * r0.xyz + float3(1,1,1);

			//r2.xyzw = t0.Sample(s0_s, f.o1.xy).xyzw;
			r2 = tex2D(_MainTex, f.o1.xy);

			r0.xyz = r2.xyz * r0.xyz + r1.yzw;
			result.w = r2.w;
			r1.xyz = _LightProbeColor.xyz * _CharaColor.xyz;
			r0.xyz = r0.xyz * r1.xyz + -_Global_FogColor.xyz;
			r0.xyz = f.p1.xxx * r0.xyz + _Global_FogColor.xyz;
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