Shader "Gallop/3D/Chara/ToonEye/T" {
	Properties {
		[NoScaleOffset] _MainTex ("Diffuse", 2D) = "white" {}
		[NoScaleOffset] _High0Tex ("High0", 2D) = "black" {}
		[NoScaleOffset] _High1Tex ("High1", 2D) = "black" {}
		[NoScaleOffset] _High2Tex ("High2", 2D) = "black" {}
		[NoScaleOffset] _WetTex ("Wet Texture", 2D) = "black" {}
		_WetRate ("Wet Rate", Range(0, 1)) = 1
		_CharaColor ("_CharaColor", Vector) = (1,1,1,1)
		_Saturation ("_Saturation", Range(0, 1)) = 1
		_LightProbeColor ("_LightProbeColor", Vector) = (1,1,1,1)
		_Limit ("_Limit", Range(0, 1)) = 0.5
		[Header(Stencil)] _StencilMask ("Stencil Mask", Float) = 100
		[Enum(UnityEngine.Rendering.CompareFunction)] _StencilComp ("Stencil Comparison", Float) = 0
		[Enum(UnityEngine.Rendering.StencilOp)] _StencilOp ("Stencil Operation", Float) = 0
		[Header(Toon)] _ToonStep ("_ToonStep", Range(0, 1)) = 0.4
		_ToonFeather ("_ToonFeather", Range(0.0001, 1)) = 0.1
		_ToonBrightColor ("_ToonBrightColor", Vector) = (1,1,1,0)
		_ToonDarkColor ("_ToonDarkColor", Vector) = (1,1,1,0)
		[MaterialToggle] _UseOriginalDirectionalLight ("_UseOriginalDirectionalLight", Float) = 0
		_OriginalDirectionalLightDir ("_OriginalDirectionalLightDir", Vector) = (1,1,1,1)
		_CylinderBlend ("_CylinderBlend", Range(0, 1)) = 0
		[Header(MaskColor)] [NoScaleOffset] _MaskColorTex ("MaskColorTex", 2D) = "gray" {}
		_MaskColorR1 ("MaskColorR1", Vector) = (1,1,1,1)
		_MaskColorR2 ("MaskColorR2", Vector) = (1,1,1,1)
		_MaskColorG1 ("MaskColorG1", Vector) = (1,1,1,1)
		_MaskColorG2 ("MaskColorG2", Vector) = (1,1,1,1)
		_MaskColorB1 ("MaskColorB1", Vector) = (1,1,1,1)
		_MaskColorB2 ("MaskColorB2", Vector) = (1,1,1,1)
		[HideInInspector] _ZWrite ("_ZWrite", Float) = 1
		[HideInInspector] _ZTest ("_ZTest", Float) = 4
		_EyePupliScale ("_EyePupliScale", Float) = 1
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