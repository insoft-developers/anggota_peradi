import UIKit
import Flutter

@main
@objc class AppDelegate: FlutterAppDelegate {

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {

    // Init window manual (LEGACY STYLE)
    window = UIWindow(frame: UIScreen.main.bounds)

    let flutterViewController = FlutterViewController()
    window?.rootViewController = flutterViewController
    window?.makeKeyAndVisible()

    // Register plugins
    GeneratedPluginRegistrant.register(with: self)

    // ⚠️ WAJIB panggil super
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
