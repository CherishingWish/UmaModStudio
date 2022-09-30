Shader "Gallop/3D/Chara/ToonHair/TSER" {
	Properties {
		[NoScaleOffset] _MainTex ("Diffuse Map", 2D) = "white" {}
		[NoScaleOffset] _TripleMaskMap ("_TripleMaskMap", 2D) = "white" {}
		[NoScaleOffset] _OptionMaskMap ("_OptionMaskMap", 2D) = "black" {}
		[MaterialToggle] _UseOptionMaskMap ("_UseOptionMaskMap", Float) = 0
		[Header(Specular)] _SpecularColor ("_SpecularColor", Vector) = (1,1,1,1)
		_SpecularPower ("_SpecularPower", Range(0, 1)) = 0
		[Header(Toon)] [NoScaleOffset] _ToonMap ("_ToonMap", 2D) = "white" {}
		_ToonStep ("_ToonStep", Range(0, 1)) = 0.5
		_ToonFeather ("_ToonFeather", Range(0.0001, 1)) = 0.0001
		[Header(Environment)] [NoScaleOffset] _EnvMap ("_EnvMap", 2D) = "black" {}
		_EnvRate ("_EnvRate", Range(0, 1)) = 0.5
		_EnvBias ("_EnvBias", Range(0, 8)) = 1
		[Header(Rim)] _RimStep ("_RimStep", Range(0, 1)) = 0.5
		_RimFeather ("_RimFeather", Range(0.0001, 1)) = 0.3
		_RimColor ("_RimColor", Vector) = (1,1,1,0.3922)
		_RimSpecRate ("_RimSpecRate", Range(0, 1)) = 0
		_RimShadow ("_RimShadow", Range(0, 2)) = 0
		[Header(Outline)] _OutlineWidth ("_OutlineWidth", Range(0.01, 5)) = 1
		_OutlineColor ("_OutlineColor", Vector) = (0.125,0.047,0,0.098)
		[Header(Dirt)] [NoScaleOffset] _DirtTex ("_DirtTex", 2D) = "black" {}
		_DirtScale ("_DirtScale", Range(0, 1)) = 1
		[Header(Emissive)] [NoScaleOffset] _EmissiveTex ("_EmissiveTex", 2D) = "black" {}
		_EmissiveColor ("_EmissiveColor", Vector) = (1,1,1,1)
		[Header(Other)] _CharaColor ("_CharaColor", Vector) = (1,1,1,1)
		_Saturation ("_Saturation", Range(0, 1)) = 1
		_ToonBrightColor ("_ToonBrightColor", Vector) = (1,1,1,0)
		_ToonDarkColor ("_ToonDarkColor", Vector) = (1,1,1,0)
		_StencilMask ("Stencil Mask", Float) = 100
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Stencil Comparison", Float) = 8
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilOp ("Stencil Operation", Float) = 2
		_LightProbeColor ("_LightProbeColor", Vector) = (1,1,1,1)
		_Cutoff ("_Cutoff", Range(0, 1)) = 0.98
		_UseOriginalDirectionalLight ("_UseOriginalDirectionalLight", Float) = 0
		_OriginalDirectionalLightDir ("_OriginalDirectionalLightDir", Vector) = (1,1,1,1)
		_CylinderBlend ("_CylinderBlend", Range(0, 1)) = 0
		_HairNormalBlend ("_HairNormalBlend", Range(0, 1)) = 1
		[HideInInspector] _HightLightParam ("_HightLightParam", Vector) = (0,1,0,0)
		[HideInInspector] _HightLightColor ("_HightLightColor", Vector) = (0,0,0,0)
		[Header(MaskColor)] [NoScaleOffset] _MaskColorTex ("MaskColorTex", 2D) = "gray" {}
		_MaskColorR1 ("MaskColorR1", Vector) = (1,1,1,1)
		_MaskColorR2 ("MaskColorR2", Vector) = (1,1,1,1)
		_MaskColorG1 ("MaskColorG1", Vector) = (1,1,1,1)
		_MaskColorG2 ("MaskColorG2", Vector) = (1,1,1,1)
		_MaskColorB1 ("MaskColorB1", Vector) = (1,1,1,1)
		_MaskColorB2 ("MaskColorB2", Vector) = (1,1,1,1)
		_MaskToonColorR1 ("MaskToonColorR1", Vector) = (1,1,1,1)
		_MaskToonColorR2 ("MaskToonColorR2", Vector) = (1,1,1,1)
		_MaskToonColorG1 ("MaskToonColorG1", Vector) = (1,1,1,1)
		_MaskToonColorG2 ("MaskToonColorG2", Vector) = (1,1,1,1)
		_MaskToonColorB1 ("MaskToonColorB1", Vector) = (1,1,1,1)
		_MaskToonColorB2 ("MaskToonColorB2", Vector) = (1,1,1,1)
	}
	//DummyShaderTextExporter
	SubShader{
		Tags { "RenderType"="Opaque" }
		LOD 200
		CGPROGRAM
#pragma surface surf Standard
#pragma target 3.0

		sampler2D _MainTex;
		struct Input
		{
			float2 uv_MainTex;
		};

		void surf(Input IN, inout SurfaceOutputStandard o)
		{
			fixed4 c = tex2D(_MainTex, IN.uv_MainTex);
			o.Albedo = c.rgb;
			o.Alpha = c.a;
		}
		ENDCG
	}
}