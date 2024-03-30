import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
    
    func configureFlutterEngine(_ engine: FlutterEngine) {
        let channel = FlutterMethodChannel(
            name: "io.wheresmyshit.afrikaburn/platform",
            binaryMessenger: engine.binaryMessenger
        )
        channel.setMethodCallHandler({ [weak self] (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            guard let strongSelf = self else { return }
            switch call.method {
                default:
                    result(FlutterMethodNotImplemented)
            }
        })
    }
}

