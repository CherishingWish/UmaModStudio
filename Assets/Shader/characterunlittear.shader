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
		Tags { "FORCENOSHADOWCASTING" = "true" "QUEUE" = "AlphaTest-150" "RenderType" = "Transparent" }
		Pass {
		Name "UnlitCheek"
		Tags { "FORCENOSHADOWCASTING" = "true" "QUEUE" = "AlphaTest-150" "RenderType" = "Transparent" }
		Offset [_OffsetFactor], [_OffsetUnits]
		Blend SrcAlpha OneMinusSrcAlpha, SrcAlpha OneMinusSrcAlpha
		ColorMask RGB 0
		ZWrite Off
		Cull Off
		Fog {
		Mode Off
		}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		#define cmp -

		float4 _Global_FogMinDistance;
		float4 _Global_FogLength;
		float _Global_MaxHeight;
		float _Global_MaxDensity;
		float4 _MainTex_ST;
		float4 _TexScrollParam;
		float4 _Global_FogColor;
		float4 _ShadowColor;
		float4 _LightProbeColor;
		float4 _CharaColor;

		sampler2D _MainTex;



		struct a2v {
			float4 v0 : POSITION0;
			float2 v1 : TEXCOORD0;
		};

		struct v2f {
			float4 o0 : SV_POSITION0;
			float2 o1 : TEXCOORD0;
			float2 p1 : TEXCOORD1;
		};

		v2f vert(a2v v) {

			v2f f;
			UNITY_INITIALIZE_OUTPUT(v2f, f);

			float4 r0, r1;
			/*
			r0.xyzw = cb1[1].xyzw * v.v0.yyyy;
			r0.xyzw = cb1[0].xyzw * v.v0.xxxx + r0.xyzw;
			r0.xyzw = cb1[2].xyzw * v.v0.zzzz + r0.xyzw;
			r0.xyzw = cb1[3].xyzw + r0.xyzw;
			*/

			r0 = mul(unity_ObjectToWorld, float4(v.v0.xyz, 1));

			/*
			r1.xyzw = cb2[18].xyzw * r0.yyyy;
			r1.xyzw = cb2[17].xyzw * r0.xxxx + r1.xyzw;
			r1.xyzw = cb2[19].xyzw * r0.zzzz + r1.xyzw;
			f.o0.xyzw = cb2[20].xyzw * r0.wwww + r1.xyzw;
			*/

			f.o0 = mul(unity_MatrixVP, r0);

			/*
			r1.x = cb2[10].z * r0.y;
			r0.x = cb2[9].z * r0.x + r1.x;
			r0.x = cb2[11].z * r0.z + r0.x;
			r0.x = cb2[12].z * r0.w + r0.x;
			*/

			r0.x = mul(unity_MatrixV, r0).z;

			f.p1.y = r0.y / _Global_MaxHeight;
			r0.x = -_Global_FogMinDistance.w + -r0.x;
			f.p1.x = saturate(r0.x / _Global_FogLength.w);
			r0.xy = _TexScrollParam.xy + v.v1.xy;
			f.o1.xy = r0.xy * _MainTex_ST.xy + _MainTex_ST.zw;
			return f;
		}

		fixed4 frag(v2f f) : SV_Target{

			float4 r0,r1;
			float4 result;
			r0.xy = float2(1, 1) + -f.p1.xy;
			r0.x = saturate(r0.x * r0.y + _Global_MaxDensity);
			r0.yzw = _CharaColor.xyz * _LightProbeColor.xyz;

			//r1.xyzw = t0.Sample(s0_s, f.o1.xy).xyzw;
			r1 = tex2D(_MainTex, f.o1.xy);

			r0.yzw = r1.xyz * r0.yzw + -_Global_FogColor.xyz;
			r1.x = _ShadowColor.w * r1.w;
			result.w = _TexScrollParam.w * r1.x;
			result.xyz = r0.xxx * r0.yzw + _Global_FogColor.xyz;
			return result;
		}


		ENDCG
	}
	}
	Fallback "Diffuse"
}