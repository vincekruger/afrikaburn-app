import Flutter
import UIKit

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        configureFlutterEngine()
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func configureFlutterEngine() {
        let controller: FlutterViewController = window?.rootViewController as! FlutterViewController
        let channel = FlutterMethodChannel(
            name: "io.wheresmyshit.afrikaburn/platform",
            binaryMessenger: controller.binaryMessenger
        )
        channel.setMethodCallHandler { [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) in
            guard let strongSelf = self else { return }
            
            let mapboxOfflineAB: MapboxOfflineAfrikaburn = MapboxOfflineAfrikaburn()
            
            switch call.method {
                case "downloadMapTiles":
                    mapboxOfflineAB.downloadTileRegions(flutterResult: result)
                case "checkOfflineMaps":
                    mapboxOfflineAB.checkDownloads(flutterResult: result)
                default:
                    result(FlutterMethodNotImplemented)
            }
        }
    }
}
