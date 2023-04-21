using UnityEngine;
using UnityEngine.Rendering;
using UnityEngine.Rendering.Universal;

public class FullscreenBlitSwapBufferRendererFeature : ScriptableRendererFeature
{
    [System.Serializable]
    public class FullscreenBlitSwapBufferSettings
    {
        public RenderPassEvent renderPassEvent = RenderPassEvent.AfterRenderingTransparents;
        public Material material = null;
    }

    public class FullscreenBlitSwapBufferRenderPass : ScriptableRenderPass
    {
        private Material material;

        public FullscreenBlitSwapBufferRenderPass(RenderPassEvent renderPassEvent, Material material)
        {
            this.profilingSampler = new ProfilingSampler(nameof(FullscreenBlitSwapBufferRendererFeature));

            this.material = material;

            this.renderPassEvent = renderPassEvent;
        }

        public override void Execute(ScriptableRenderContext context, ref RenderingData renderingData)
        {
            if (this.material == null) {
                return;
            }

            // Run (blit)
            CommandBuffer cmd = CommandBufferPool.Get();
            using (new ProfilingScope(cmd, this.profilingSampler)) {
                context.ExecuteCommandBuffer(cmd);
                cmd.Clear();

                // Blit (swap buffer)
                Blit(cmd, ref renderingData, this.material);
            }
            context.ExecuteCommandBuffer(cmd);

            CommandBufferPool.Release(cmd);
        }
    }

    [SerializeField] private FullscreenBlitSwapBufferSettings settings = new FullscreenBlitSwapBufferSettings();

    private FullscreenBlitSwapBufferRenderPass renderPass;

    public override void Create()
    {
        this.renderPass = new FullscreenBlitSwapBufferRenderPass(
            this.settings.renderPassEvent,
            this.settings.material
        );
    }

    public override void AddRenderPasses(ScriptableRenderer renderer, ref RenderingData renderingData)
    {
        renderer.EnqueuePass(this.renderPass);
    }
}