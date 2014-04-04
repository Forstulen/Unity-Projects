Shader "Custom/Lambert" {
	Properties {
		_Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
	}
	SubShader {
		Pass {
		Tags { "LightMode" = "ForwardBase" }
		CGPROGRAM

		#pragma vertex vert
		#pragma fragment frag

		uniform float4 _Color;
		uniform float4 _LightColor0;

		struct vertexInput {
			float4 pos : POSITION;
			float4 normal : NORMAL;
		};

		struct vertexOutput {
			float4 pos : SV_POSITION;
			float4 col : COLOR;
		};

		vertexOutput vert(vertexInput i) {
			vertexOutput o;
			float3 normalDirection = normalize (mul (i.normal, _World2Object).xyz);
			float3 lightDirection = normalize (_WorldSpaceLightPos0.xyz);

			float3 diffuseColor = dot (normalDirection, lightDirection) * _Color.rgb * _LightColor0.rgb * UNITY_LIGHTMODEL_AMBIENT.rgb;

			o.pos = mul (UNITY_MATRIX_MVP, i.pos);
			o.col = float4 (diffuseColor, 1.0);

			return o;
		}

		float4 frag(vertexOutput v) : COLOR {
			return v.col;
		}

		ENDCG
		}
	}
}
