Shader "Unlit/SimpleShader"
{
    Properties
    {
        _MainTex("Texture", 2D) = "white" {}
        _Color("Color", Color) = (1, 1, 1, 1)
    }

    SubShader
    {
        Pass
        {
            CGPROGRAM

            sampler2D _MainTex;
            fixed4 _MainTex_ST;
            fixed4 _Color;

            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            appdata_full vert(appdata_full v)
            {
                appdata_full o;

                o.vertex = UnityObjectToClipPos(v.vertex);
                o.texcoord.xy = TRANSFORM_TEX(v.texcoord.xy, _MainTex);

                return o;
            }

            fixed4 frag(appdata_full i) : SV_Target
            {
                return tex2D(_MainTex, i.texcoord.xy);
            }

            ENDCG
        }
    }
}
