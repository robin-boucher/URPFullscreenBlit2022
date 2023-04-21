Shader "Custom/ColorMultiply_CustomRT"
{
    Properties
    {
        [HDR] _BlitTexColor("Blit Texture Color", Color) = (1, 1, 1)
        [HDR] _CamTexColor("Camera Texture Color", Color) = (1, 1, 1)
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
                half3 _BlitTexColor;
                half3 _CamTexColor;
            CBUFFER_END

            // RT name set in FullscreenBlitCustomRTRendererFeature
            TEXTURE2D(_CustomTargetTexture);
            SAMPLER(sampler_CustomTargetTexture);

            // Camera color texture
            TEXTURE2D(_CameraColorTexture);
            SAMPLER(sampler_CameraColorTexture);

            half4 frag (Varyings input) : SV_Target
            {
                half4 blitTex = SAMPLE_TEXTURE2D(_CustomTargetTexture, sampler_CustomTargetTexture, input.texcoord);
                half4 camTex = SAMPLE_TEXTURE2D(_CameraColorTexture, sampler_CameraColorTexture, input.texcoord);

                blitTex.rgb *= _BlitTexColor;
                camTex.rgb *= _CamTexColor;

                half4 color;

                // Blend with camTex
                color.rgb = camTex.rgb * (1 - blitTex.a) + blitTex.rgb;
                color.a = 1;

                return color;
            }
            ENDHLSL
        }
    }
}