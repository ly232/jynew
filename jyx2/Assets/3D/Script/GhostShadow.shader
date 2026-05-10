// Upgrade NOTE: replaced 'mul(UNITY_MATRIX_MVP,*)' with 'UnityObjectToClipPos(*)'

Shader "SkillEffect/GhostShadow"
{
	Properties
	{
		_RimColor("RimColor", Color) = (0, 0, 1, 1)
		_RimIntensity("Intensity", Range(0, 2)) = 1
	}

	SubShader
	{
		Tags{ "Queue" = "Transparent" "RenderType" = "Opaque" }

		LOD 200
		
		// 写入深度，修复龙透明效果不正确问题
		Pass
		{
			ColorMask 0

			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
			};

			struct v2f
			{
				float4 pos : SV_POSITION;
			};

			v2f vert(appdata v)
			{
				v2f o;
				o.pos = UnityObjectToClipPos(v.vertex);
				return o;
			}

			fixed4 frag(v2f i) : SV_Target
			{
				return 0;
			}
			ENDCG
		}
		
		Pass
		{
		Blend SrcAlpha One//打开混合模式
		ZWrite off
		Lighting off

		CGPROGRAM
		#pragma vertex vert
		#pragma fragment frag

		#include "UnityCG.cginc"

		struct appdata
		{
			float4 vertex : POSITION;
		};

		struct v2f
		{
			float4 pos : SV_POSITION;
			fixed4 color : COLOR;
		};

		fixed4 _RimColor;
		float _RimIntensity;

		v2f vert(appdata v)
		{
			v2f o;
			o.pos = UnityObjectToClipPos(v.vertex);
			o.color = _RimColor * (1 + _RimIntensity);//计算强度
			return o;
		}

		fixed4 frag(v2f i) : SV_Target
		{
			return i.color;
		}
		ENDCG
	}
	}
}
