Shader "Custom/Dissolution" {
	Properties {
		_MainTex ("Base (RGB)", 2D) = "white" {}
		_Color ("Disolving Color", Color) = (1.0,1.0,1.0,1.0)
		_DisolvingTex ("Disolving (RGB)", 2D) = "white" {}
		_DisolveAmount ("DisolveAmount", Range (0,1.0)) = 0
	}
	SubShader {
		Pass {
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag

			uniform sampler2D _MainTex;
			uniform float4	_MainTex_ST;
			uniform float4		_Color;
			uniform sampler2D _DisolvingTex;
			uniform float	  _DisolveAmount;

			struct vertexInput {
				float4 vertex : POSITION;
				float4 normal : NORMAL;
				float4 texcoord : TEXCOORD0;
			};

			struct vertexOutput {
				float4 pos : SV_POSITION;
				float4 tex : TEXCOORD1;
			};

			vertexOutput vert(vertexInput v) {
				vertexOutput o;

				o.pos = mul (UNITY_MATRIX_MVP, v.vertex);
				o.tex = v.texcoord;

				return o;
			}

			float4 frag(vertexOutput i) : COLOR {
				float4 color = tex2D(_MainTex, i.tex.xy * _MainTex_ST.xy + _MainTex_ST.zw);
				float4 disolvingColor = tex2D(_DisolvingTex, i.tex.xy);

				clip(disolvingColor - _DisolveAmount);

				if (any(disolvingColor - _DisolveAmount * 1.2 < 0))
					return _Color;
				else
					return color;
			}

			ENDCG
		}
	}
	//fallBack "Diffuse"
}
