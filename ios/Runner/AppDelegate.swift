import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {


  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    let flutterViewController = FlutterViewController()
    window = UIWindow(frame: UIScreen.main.bounds)
    window?.rootViewController = flutterViewController
    window?.makeKeyAndVisible()

    GeneratedPluginRegistrant.register(with: self)
    return true
  }
}
