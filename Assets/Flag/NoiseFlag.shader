Shader "Unlit/NoiseFlag"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _NoiseTex ("NoiseTex", 2D) = "white" {}
        _Speed ("Speed", float) = 0
        _Frequency ("Frequency", float) = 2
        _Amplitude ("Amplitude", float) = 2
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }
        Cull off

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                UNITY_FOG_COORDS(1)
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            sampler2D _NoiseTex;
            float4 _NoiseTex_ST;

            float _Speed;
            float _Frequency;
            float _Amplitude;

            v2f vert (appdata v)
            {
                v2f o;
                
                o.uv = TRANSFORM_TEX(v.uv, _NoiseTex);

                float x = o.uv.x * _Frequency + _Time.x * _Speed;
                float y = o.uv.y * _Frequency + _Time.x * _Speed;
                
                fixed4 noise = tex2Dlod(_NoiseTex, fixed4(x, y, 0, 0)) * _Amplitude;

                v.vertex.y += noise.x * v.uv.x;
                v.vertex.z += noise.x * v.uv.x * 10;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
