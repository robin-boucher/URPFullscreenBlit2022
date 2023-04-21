==== Unity 2022.2 URP Fullscreen Blit/カスタム Render Targetサンプル

Unity 2022.2以降でURPを使い、Fullscreen Blit及びカスタムRender Targetに書き出しを行うサンプルです。Unity 2021.3以前と実装方法が異なります。

シーン
- Assets/Scenes/SampleScene_Blitter.unity: Blitter APIを用いたBlitのサンプルです。カメラのRender TargetへBlitを行う際、Temporary Render Targetを介する必要があります (i.e. CameraRenderTarget -> TempRenderTarget, TempRenderTarget -> CameraRenderTargetの計2回のBlit)。
- Assets/Scenes/SampleScene_SwapBuffer.unity: Swap Bufferを用いた、1回のBlitを行うサンプルです。
- Assets/Scenes/SampleScene_CustomRT: DrawRenderersを行う際、カスタムRender Targetに書き出しを行うサンプルです。

シェーダー
- Assets/Shaders/ColorMultiply_Blitter.shader: Blitter API用のBlitシェーダー
- Assets/Shaders/ColorMultiply_SwapBuffer.shader: Swap Buffer用のBlitシェーダー
- Assets/Shaders/ColorMultiply_CustomRT.shader: カスタムRender Targetに書き出したテクスチャをカメラのRender Targetとブレンドするシェーダー

RendererData
- Assets/URP/StencilOutlineRendererForward.asset: Forward Renderer Data
- Assets/URP/StencilOutlineRendererDeferred.asset: Deferred Renderer Data (追加Renderer Featureあり)

Renderer Feature
- Assets/Scripts/FullscreenBlitBlitterRendererFeature.cs: Blitter API仕様のFullscreen Blitを行うRenderer Feature
- Assets/Scripts/FullscreenBlitSwapBufferRendererFeature.cs: Swap Buffer仕様のFullscreen Blitを行うRenderer Feature
- Assets/Scripts/DrawRenderersCustomRTRendererFeature.cs: カスタムRender Targetへオブジェクトを描画するRenderer Feature