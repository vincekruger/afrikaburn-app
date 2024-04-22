package com.nylo.android

import android.content.Context
import android.util.Log
import com.ryanheise.audioservice.AudioServicePlugin
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import com.mapbox.bindgen.Value
import com.mapbox.common.*
import com.mapbox.geojson.Point
import com.mapbox.maps.*

class MainActivity: FlutterActivity() {
    private val TAG = "afrikaburn/platform"
    private val CHANNEL = "io.wheresmyshit.afrikaburn/platform"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            CHANNEL
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "checkOfflineMaps" -> {
                    Log.d(TAG, "checkOfflineMaps Called")
                    val tileStore = TileStore.create()
                    Log.d(TAG, "Create Tile Store")
                    // Get a list of tile regions that are currently available.
                    tileStore.getAllTileRegions { expected ->
                        if (expected.isValue) {
                            expected.value?.let { tileRegionList ->
                                Log.d(TAG, "Existing tile regions: $tileRegionList")
                                if(tileRegionList.isEmpty()) result.success(emptyList<Any>())
                            }
                        }
                        expected.error?.let { tileRegionError ->
                            Log.d(TAG, "TileRegionError: $tileRegionError")
                        }
                    }
                }

                "downloadMapTiles" -> {
                    Log.d(TAG, "downloadMapTiles Called")

                    val TILE_REGION_ID = "afriakburnSite"
                    val AFRIKABURN: Point = Point.fromLngLat(19.95617, -32.51547)

                    val tileStore: TileStore by lazy { TileStore.create() }
                    val offlineManager: OfflineManager by lazy {
                        // Set application-scoped tile store so that all MapViews created from now on will apply these
                        // settings.
                        MapboxOptions.mapsOptions.tileStore = tileStore
                        MapboxOptions.mapsOptions.tileStoreUsageMode = TileStoreUsageMode.READ_ONLY
                        OfflineManager().also {
                            // Revert setting custom tile store
                            MapboxOptions.mapsOptions.tileStore = null
                        }
                    }

                    val lightDescriptor = offlineManager.createTilesetDescriptor(
                        TilesetDescriptorOptions.Builder()
                            .styleURI(Style.LIGHT)
                            .minZoom(14)
                            .maxZoom(18)
                            .build()
                    )
                    val darkDescriptor = offlineManager.createTilesetDescriptor(
                        TilesetDescriptorOptions.Builder()
                            .styleURI(Style.DARK)
                            .minZoom(14)
                            .maxZoom(18)
                            .build()
                    )

                    val tileRegionCancelable = tileStore.loadTileRegion(
                        TILE_REGION_ID,
                        TileRegionLoadOptions.Builder()
                            .geometry(AFRIKABURN)
                            .descriptors(listOf(lightDescriptor, darkDescriptor))
                            .metadata(Value(TILE_REGION_ID))
                            .acceptExpired(false)
                            .networkRestriction(NetworkRestriction.NONE)
                            .build(),
                        { progress ->
                            // Handle the download progress
                            Log.d(TAG, "Download Process $progress")
                        }
                    ) { expected ->
                        if (expected.isValue) {
                            // Tile region download finishes successfully
                            expected.value?.let {
                                Log.d(TAG, "Download Complete")
                                result.success(true)
                            }
                        }
                        expected.error?.let {
                            Log.d(TAG, "Download Failed")
                            result.error("0", "MapTiles Download Failed", null)
                        }
                    }
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
