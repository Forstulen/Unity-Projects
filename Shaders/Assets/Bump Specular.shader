Shader "Custom/Bump Specular" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Bump ("Normal Map", 2D) = "bump" {}
		_BumpDepth ("Depth", Range(-2.0, 2.0)) = 1.0
		_Color ("Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Specular ("Specular Color", Color) = (1.0, 1.0, 1.0, 1.0)
		_Shininess ("Shininess", Range(0.0, 100)) = 10
	}
	SubShader {
		Pass {
			Tags { "LightMode" = "ForwardBase" }
			CGPROGRAM

			#pragma vertex vert
			#pragma fragment frag

			// User Properties
			uniform sampler2D	_MainTex;
			uniform float4		_MainTex_ST;
			uniform sampler2D	_Bump;
			uniform float4		_Bump_ST;
			uniform float4		_Color;
			uniform float4		_Specular;
			uniform float		_Shininess;
			uniform float		_BumpDepth;
			// Unity Properties
			uniform float4		_LightColor0;

			struct vertexInput {
				float4 vertex : POSITION;
				float3 normal : NORMAL;
				float4 texCoord : TEXCOORD0;
				float4 tangent : TANGENT;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 texCoord : TEXCOORD0;
				float3 posWorld : TEXCOORD1;
				float3 tangentWorld : TEXCOORD2;
				float3 coTangentWorld : TEXCOORD3;
				float3 normalWorld : TEXCOORD4;
			};

			vertexOutput vert(vertexInput v) {
				vertexOutput o;

				o.pos = mul(UNITY_MATRIX_MVP, v.vertex);
				o.texCoord = v.texCoord;
				o.posWorld = mul(_Object2World, v.vertex);

				o.tangentWorld = normalize(mul(_Object2World, v.tangent).xyz);
				o.normalWorld = normalize(mul(_Object2World, float4(v.normal, 0.0)).xyz);
				o.coTangentWorld = normalize(cross(o.normalWorld, o.tangentWorld));

				return o;
			}

			float4 frag(vertexOutput i) : COLOR {
				float3 tex = tex2D(_MainTex, i.texCoord.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				float4 bump = tex2D(_Bump, i.texCoord.xy * _Bump_ST.xy + _Bump_ST.zw);

				float3x3 rotateNormalMatrix = float3x3(
					i.tangentWorld,
					i.coTangentWorld,
					i.normalWorld
				);

				float3	lightDirection= normalize(_WorldSpaceLightPos0.xyz);
				float3	viewDirection = normalize (_WorldSpaceCameraPos.xyz - i.posWorld.xyz);
				float	attenuation = 1.0;

				if (_WorldSpaceLightPos0.w == 0.0) {
					attenuation = 1.0;
					lightDirection = normalize(_WorldSpaceLightPos0.xyz);
				} else {
					float3 lightPos = _WorldSpaceLightPos0.xyz - i.posWorld.xyz;
					float3 distance = length(lightPos);
					attenuation = 1.0 / distance;
					lightDirection = normalize(lightPos);
				}

				float3 normalCoord = float3(2.0 * bump.ag - float2(1.0, 1.0), 0.0);
				normalCoord.z = _BumpDepth;
				
				float3 normalDirection = normalize(mul(normalCoord, rotateNormalMatrix));
				//float3 normalDirection = normalize(i.normalWorld);

				float3 diffuseColor = max (0.0, dot (normalDirection, lightDirection)) * _Color.rgb * _LightColor0.rgb * UNITY_LIGHTMODEL_AMBIENT.rgb;
				float3 specularColor = diffuseColor * pow (max (0.0, dot (reflect (-lightDirection, normalDirection), viewDirection)), _Shininess) * _Specular.rgb;

				float4 finalColor = float4 ((specularColor + diffuseColor) * tex.xyz, 1.0);

				return finalColor;
			}

			ENDCG
		}
	}
	//FallBack "Bumped Specular"
}
