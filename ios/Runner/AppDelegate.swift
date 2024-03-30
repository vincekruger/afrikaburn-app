import UIKit
import Flutter

@UIApplicationMain
@objc class AppDelegate: FlutterAppDelegate {
    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        let controller : FlutterViewController = window?.rootViewController as! FlutterViewController
        let afrikaburnChannel = FlutterMethodChannel(
            name: "io.wheresmyshit.afrikaburn/platform",
            binaryMessenger: controller.binaryMessenger
        )
        afrikaburnChannel.setMethodCallHandler({
            (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
            switch call.method {
                case "showStatusBar":
                    result(1)
                    break;
                case "hideStatusBar":
                    result(1)
                    break;
                default:
                    result(FlutterMethodNotImplemented)
            }
        })
        
        GeneratedPluginRegistrant.register(with: self)
        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }
}

