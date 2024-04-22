package com.nylo.android

import android.content.Context
import com.mapbox.common.TileStore
import com.mapbox.maps.OfflineManager
import com.ryanheise.audioservice.AudioServicePlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "io.wheresmyshit.afrikaburn/platform"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkOfflineMaps" -> {
//                    val tileStore = TileStore.create()
                    print("Checking file store")
                    // Get a list of tile regions that are currently available.
//                    tileStore.getAllTileRegions { expected ->
//                        if (expected.isValue) {
//                            expected.value?.let { tileRegionList ->
//                                print("Existing tile regions: $tileRegionList")
//                            }
//                        }
//                        expected.error?.let { tileRegionError ->
//                            print("TileRegionError: $tileRegionError")
//                        }
//                    }
//                    result.success(true)
                    result.success([])
                }

                "downloadMapTiles" -> {
//                    result.success(true)
                }

                else -> {
                    result.notImplemented()
                }
            }
        }
    }

    override fun provideFlutterEngine(context: Context): FlutterEngine {
        return AudioServicePlugin.getFlutterEngine(context)
    }
}
