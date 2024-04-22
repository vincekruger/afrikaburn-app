//
//  MapboxOffline.swift
//  Afrikaburn
//
//  Created by Vince Kruger on 19/4/24.
//

import Foundation
import MapboxMaps

final class MapboxOfflineAfrikaburn {
    
    private var tileStore: TileStore?
    private var downloads: [Cancelable] = []

    private let afrikaburnCoord = CLLocationCoordinate2D(latitude: -32.51547, longitude: 19.95617)
    private let tileRegionId = "afriakburnSite"

    private lazy var offlineManager: OfflineManager = .init()
    
    func checkDownloads(flutterResult: @escaping FlutterResult) {
        self.tileStore = TileStore.default
        guard let tileStore = tileStore else {
            preconditionFailure()
        }
        tileStore.allTileRegions { result in
            switch result {
                case let .success(tileRegions):
                    var regionsData: [[String: Encodable]] = []
                    for region in tileRegions {
                        regionsData.append([
                            "id": region.id,
                            "completedResourceCount": region.completedResourceCount,
                            "completedResourceSize": region.completedResourceSize,
                        ])
                    }
                    flutterResult(regionsData)
                    
                case let .failure(error) where error is TileRegionError:
                    flutterResult(error)
                    
                case .failure(_):
                    flutterResult(false)
            }
        }
    }

    func downloadTileRegions(flutterResult: @escaping FlutterResult) {
        print("[Mapbox Download] downloadTileRegions called")
        self.tileStore = TileStore.default
        guard let tileStore = tileStore else {
            preconditionFailure()
        }
        
        var downloadError = false

        // 2. Create an offline region with tiles for the outdoors style
        let lightOptions = TilesetDescriptorOptions(styleURI: .light, 
                                                    zoomRange: 14 ... 18,
                                                    tilesets: nil)
        let darkOptions = TilesetDescriptorOptions(styleURI: .dark, 
                                                   zoomRange: 14 ... 18,
                                                   tilesets: nil)
        let lightDescriptor = offlineManager.createTilesetDescriptor(for: lightOptions)
        let darkDescriptor = offlineManager.createTilesetDescriptor(for: darkOptions)

        // Load the tile region
        let tileRegionLoadOptions = TileRegionLoadOptions(
            geometry: .point(Point(afrikaburnCoord)),
            descriptors: [lightDescriptor, darkDescriptor],
            metadata: ["tag": "afrikaburn-tile-region"],
            acceptExpired: true
        )!

        // Use the the default TileStore to load this region. You can create
        // custom TileStores are are unique for a particular file path, i.e.
        // there is only ever one TileStore per unique path.
        let tileRegionDownload = tileStore.loadTileRegion(forId: tileRegionId,
                                                          loadOptions: tileRegionLoadOptions)
        { [weak self] progress in
            // These closures do not get called from the main thread. In this case
            // we're updating the UI, so it's important to dispatch to the main
            // queue.
            DispatchQueue.main.async {
                print("[Mapbox Download] tileRegion = \(progress)")
            }
        } completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case let .success(tileRegion):
                    print("[Mapbox Download] tileRegion downloaded = \(tileRegion)")
                    flutterResult(true)

                case let .failure(error):
                    print("[Mapbox Download] tileRegion download Error = \(error)")
                    downloadError = true
                }
            }
        }
    }
}

// MARK: - Convenience classes for tile and style classes

public extension TileRegionLoadProgress {
    override var description: String {
        "TileRegionLoadProgress: \(completedResourceCount) / \(requiredResourceCount)"
    }
}

public extension StylePackLoadProgress {
    override var description: String {
        "StylePackLoadProgress: \(completedResourceCount) / \(requiredResourceCount)"
    }
}

public extension TileRegion {
    override var description: String {
        "TileRegion \(id): \(completedResourceCount) / \(requiredResourceCount)"
    }
}

public extension StylePack {
    override var description: String {
        "StylePack \(styleURI): \(completedResourceCount) / \(requiredResourceCount)"
    }
}
