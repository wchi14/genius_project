package com.example.genius_project

import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.android.RenderMode

/**
 * Default [RenderMode.surface] (SurfaceView) can briefly report 0×0 on some Android emulators
 * (`FlutterRenderer: Width is zero`), which breaks hit-testing until restart.
 * TextureView reports stable dimensions during startup on those images.
 */
class MainActivity : FlutterActivity() {
    override fun getRenderMode(): RenderMode = RenderMode.texture
}
