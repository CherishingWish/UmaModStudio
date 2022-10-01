Shader "Gallop/3D/Chara/MultiplyCheek" {
	Properties{
		_MainTex("Particle Texture", 2D) = "white" {}
		_DirtTex("_DirtTex", 2D) = "black" {}
		_DirtScale("_DirtScale", Range(0, 1)) = 1
		_CheekRate("_CheekRate", Range(0, 1)) = 1
		_Saturation("_Saturation", Range(0, 1)) = 1
	}

	//DummyShaderTextExporter
	SubShader{
		Tags { "FORCENOSHADOWCASTING" = "true" "QUEUE" = "AlphaTest-150" "RenderType" = "Transparent" }
		Pass {
		Name "MultiplyCheek"
		Tags { "FORCENOSHADOWCASTING" = "true" "QUEUE" = "AlphaTest-150" "RenderType" = "Transparent" }
		Blend DstColor Zero, DstColor Zero
		ColorMask RGB 0
		ZWrite Off
		Cull Off
		Offset -1, -1
		Fog {
		Mode Off
		}
		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		float4 _MainTex_ST;

		sampler2D _MainTex;
		sampler2D _DirtTex;

		float _DirtRate[3];

		float4 _GlobalDirtColor;

		float _DirtScale;
		float _CheekRate;
		float _Saturation;

		struct a2v {
			float4 v0 : POSITION0;
			float2 v1 : TEXCOORD0;
		};

		struct v2f {
			float4 o0 : SV_POSITION0;
			float2 o1 : TEXCOORD0;
		};

		v2f vert(a2v v) {

			v2f f;
			float4 r0, r1;

			r0.xyzw = mul(unity_ObjectToWorld, v.v0);
			f.o0 = mul(unity_MatrixVP, r0);
			f.o1 = v.v1.xy * _MainTex_ST.xy + _MainTex_ST.zw;

			return f;
		}

		fixed4 frag(v2f f) : SV_Target{

			float4 r0,r1;
			float4 result;

			//r0.xyzw = t1.Sample(s1_s, v1.xy).xyzw;
			r0 = tex2D(_DirtTex, f.o1.xy);

			r0.xyz = _DirtScale * r0.xyz;
			r0.y = _DirtRate[1] * r0.y;
			r0.x = r0.x * _DirtRate[0] + r0.y;
			r0.x = r0.z * _DirtRate[2] + r0.x;
			r0.y = 1 + -r0.x;

			//r1.xyzw = t0.Sample(s0_s, v1.xy).xyzw;
			r1 = tex2D(_MainTex, f.o1.xy);

			r0.yzw = r1.xyz * r0.yyy;
			result.w = r1.w;
			r0.xyz = _GlobalDirtColor.xyz * r0.xxx + r0.yzw;
			r0.xyz = float3(-1, -1, -1) + r0.xyz;
			r0.xyz = _CheekRate * r0.xyz + float3(1, 1, 1);
			r0.w = dot(r0.xyz, float3(0.212500006, 0.715399981, 0.0720999986));
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