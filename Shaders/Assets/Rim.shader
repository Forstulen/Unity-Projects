Shader "Custom/Rim" {
	Properties {
		_Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_RimColor ("RimColor", Color) = (1.0, 1.0, 1.0, 1.0)
		_RimPower ("RimPower", Range(0.0, 10)) = 1.0
	}
	SubShader {
		Pass {
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			uniform float4 _Color;
			uniform float4 _RimColor;
			uniform float  _RimPower;
			uniform float4 _LightColor0;

			struct vertexInput {
				float4 pos : POSITION;
				float4 normal : NORMAL;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 posWorld : TEXCOORD0;
				float3 normal : TEXCOORD1;
			};

			vertexOutput vert(vertexInput i) {
				vertexOutput o;

				o.pos = mul (UNITY_MATRIX_MVP, i.pos);
				o.posWorld = mul (_Object2World, i.pos);
				o.normal = normalize (mul (i.normal, _World2Object).xyz);

				return o;
			}

			float4 frag(vertexOutput v) : COLOR {
				float3 lightDirection = normalize (_WorldSpaceLightPos0.xyz);
				float3 normalDirection = normalize (v.normal.xyz);
				float3 viewDirection = normalize (_WorldSpaceCameraPos.xyz - v.posWorld.xyz);
				float3 diffuseColor = max (0.0, dot (normalDirection, lightDirection)) * _LightColor0.rgb * UNITY_LIGHTMODEL_AMBIENT;
				
				fixed rimLighting = 1 - max (0.0, dot (viewDirection, normalDirection));
				float3 rim = diffuseColor * pow (rimLighting, _RimPower) * _RimColor.rgb;

				return float4 (rim + diffuseColor, 1.0);
			}

			ENDCG
		}
	}
}