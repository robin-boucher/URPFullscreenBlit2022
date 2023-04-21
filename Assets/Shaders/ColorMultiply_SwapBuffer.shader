Shader "Custom/ColorMultiply_SwapBuffer"
{
    Properties
    {
        [HDR] _Color("Color", Color) = (1, 1, 1)
    }

    SubShader
    {
        Pass
        {
            HLSLPROGRAM

            #pragma vertex Vert  // Vertex function from Blit.hlsl
            #pragma fragment frag

            #include "Packages/com.unity.render-pipelines.universal/ShaderLibrary/Core.hlsl"
            #include "Packages/com.unity.render-pipelines.core/Runtime/Utilities/Blit.hlsl"

            CBUFFER_START(UnityPerMaterial)
                half3 _Color;
            CBUFFER_END

            // Camera color texture
            TEXTURE2D(_CameraColorTexture);
            SAMPLER(sampler_CameraColorTexture);

            half4 frag (Varyings input) : SV_Target
            {
                half4 blitTex = SAMPLE_TEXTURE2D(_CameraColorTexture, sampler_CameraColorTexture, input.texcoord);

                half4 color;

                color.rgb = blitTex.rgb * _Color;
                color.a = 1;

                return color;
            }
            ENDHLSL
        }
    }
}