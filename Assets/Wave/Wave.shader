Shader "Unlit/Wave"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _Speed ("Speed", float) = 0
        _Frequency ("Frequency", float) = 2
        _Amplitude ("Amplitude", float) = 2
        _TextureMovementSpeed ("Texture Movement Speed", float) = 1
        _TextureMovementDirection ("Texture Movement Direction", vector) = (1, 0, 0, 0)
    }
    SubShader
    {
        Tags { "RenderType"="Opaque" }

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
                float4 vertex : SV_POSITION;
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float _Speed;
            float _Frequency;
            float _Amplitude;

            float _TextureMovementSpeed;
            fixed4 _TextureMovementDirection;

            v2f vert (appdata v)
            {
                v2f o;

                float2 uv = sin(v.uv * _Frequency);

                v.vertex.y += sin(uv.x + _Time.y * _Speed) * _Amplitude;
                v.vertex.y += cos(uv.y + _Time.y * _Speed) * _Amplitude;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                i.uv.x += i.uv.x +_Time.y * _TextureMovementSpeed * _TextureMovementDirection.x;
                i.uv.y += i.uv.y +_Time.y * _TextureMovementSpeed * _TextureMovementDirection.y;

                // sample the texture
                fixed4 col = tex2D(_MainTex, i.uv);
                return col;
            }
            ENDCG
        }
    }
}
