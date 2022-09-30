Shader "Gallop/3D/Chara/UnlitTear" {
	Properties {
		_MainTex ("Particle Texture", 2D) = "white" {}
		_ShadowColor ("Color", Vector) = (1,1,1,1)
		_LightProbeColor ("_LightProbeColor", Vector) = (1,1,1,1)
		_TexScrollParam ("_TexScrollParam", Vector) = (0,0,0,1)
		_CharaColor ("_CharaColor", Vector) = (1,1,1,1)
		_OffsetFactor ("_OffsetFactor", Float) = -1
		_OffsetUnits ("_OffsetUnits", Float) = -1
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