Shader "Custom/Specular" {
	Properties {
		_Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Specular ("Specular", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shininess ("Shininess", Range(0.0, 100)) = 10
	}
	SubShader {
		Pass {
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			uniform float4 _Color;
			uniform float4 _Specular;
			uniform float  _Shininess;
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
				float3 diffuseColor = max (0.0, dot (normalDirection, lightDirection)) * _Color.rgb * _LightColor0.rgb * UNITY_LIGHTMODEL_AMBIENT.rgb;
				//float3 specularColor = diffuseColor * pow (max (0.0, dot (reflect (-lightDirection, normalDirection), viewDirection)), _Shininess) * _Specular.rgb;
				float3 specularColor = diffuseColor * pow (max (0.0, dot (normalize (lightDirection + viewDirection), normalDirection)), _Shininess) * _Specular.rgb;


				float4 finalColor = float4 (specularColor + diffuseColor, 1.0);

				return finalColor;
			}


			ENDCG
		}
	}
}