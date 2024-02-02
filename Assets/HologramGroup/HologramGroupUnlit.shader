Shader "Unlit/HologramGroupUnlit"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
        _TintColor ("Tint Color", Color) = (1, 1, 1, 1)
        _CutoutTex ("Cutout Texture", 2D) = "white" {}
        _CutoutStrength ("Cutout Strength", Range(0.0, 1.0)) = 0.2

        _Distance ("Distance", Float) = 1
        _Frequency ("Frequency", Float) = 1
        _Speed ("Speed", Float) = 1
        _Amount ("Amount", Range(0.0, 1.0)) = 1

        _TransparentTex ("Transparent Texture", 2D) = "white" {}
        _Transparency ("Transparency", Range(0.0, 2.0)) = 0.25
        _TextureMovementSpeed ("Texture Movement Speed", float) = 0.25
    }
    SubShader
    {
        Tags { "Queue"="Transparent" "RenderType"="Transparent" }

        Blend SrcAlpha OneMinusSrcAlpha

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag
            #pragma multi_compile_instancing

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float2 uv_Alpha : TEXCOORD1;
                float4 vertex : SV_POSITION;
                UNITY_VERTEX_INPUT_INSTANCE_ID
            };

            sampler2D _MainTex;
            float4 _MainTex_ST;

            float4 _TintColor;

            sampler2D _CutoutTex;
            float _CutoutStrength;

            float _Distance;
            float _Frequency;
            float _Speed;
            
            UNITY_INSTANCING_BUFFER_START(Props)
                UNITY_DEFINE_INSTANCED_PROP(float, _Amount)
            UNITY_INSTANCING_BUFFER_END(Props)

            sampler2D _TransparentTex;
            float4 _TransparentTex_ST;
            float _Transparency;
            float _TextureMovementSpeed;

            v2f vert (appdata v)
            {
                v2f o;

                UNITY_SETUP_INSTANCE_ID(v);
                UNITY_TRANSFER_INSTANCE_ID(v, o);

                v.vertex.z += sin(_Time.y * _Speed + v.vertex.y * _Frequency) * (_Distance * 0.1) * UNITY_ACCESS_INSTANCED_PROP(Props, _Amount);
                v.vertex.x += sin(_Time.y * _Speed + v.vertex.y * _Frequency) * (_Distance * 0.1) * UNITY_ACCESS_INSTANCED_PROP(Props, _Amount);

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.uv = TRANSFORM_TEX(v.uv, _MainTex);
                o.uv_Alpha = TRANSFORM_TEX(v.uv, _TransparentTex);
                return o;
            }

            fixed4 frag (v2f i) : SV_Target
            {
                fixed4 col = tex2D(_MainTex, i.uv) * _TintColor;

                i.uv_Alpha += _Time.y * _TextureMovementSpeed;
                fixed4 alpha = tex2D(_TransparentTex, i.uv_Alpha);

                col.a = alpha * _Transparency;

                fixed4 cutoutColor = tex2D(_CutoutTex, i.uv);

                clip(cutoutColor - _CutoutStrength);

                return col;
            }
            ENDCG
        }
    }
}
