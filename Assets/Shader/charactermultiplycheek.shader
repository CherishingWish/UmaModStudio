Shader "Gallop/3D/Chara/MultiplyCheek" {
	Properties {
		_MainTex ("Particle Texture", 2D) = "white" {}
		_DirtTex ("_DirtTex", 2D) = "black" {}
		_DirtScale ("_DirtScale", Range(0, 1)) = 1
		_CheekRate ("_CheekRate", Range(0, 1)) = 1
		_Saturation ("_Saturation", Range(0, 1)) = 1
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