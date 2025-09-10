import Flutter
import UIKit
import OpenShareSDK

@main
@objc class AppDelegate: FlutterAppDelegate {
    static var flutterCallbackChannel: FlutterMethodChannel?  // ✅ 添加这个静态变量

  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    GeneratedPluginRegistrant.register(with: self)
    
    /*
    OpenShareInstall.shareInstance().initWithLaunchOptions(options: launchOptions as NSDictionary?)
    
    let controller = window?.rootViewController as! FlutterViewController
    let channel = FlutterMethodChannel(name: "open_share_plugin", binaryMessenger: controller.binaryMessenger)
    channel.setMethodCallHandler { (call, result) in
        if call.method == "getInstallParams" {
//          print("方法调用")
          OpenShareInstall.shareInstance().getInstallParams { totalResult, installResult in
//            print("Total Result: \(totalResult)")
//            print("Install Result: \(installResult)")
            result(totalResult["params"])
          } onError: {
//            print("error")
            result("")
          }
          
        } else {
          result(FlutterMethodNotImplemented)
        }
    }
    */
      let controller = window?.rootViewController as! FlutterViewController
       let channel2 = FlutterMethodChannel(name: "native_webview",
                                           binaryMessenger: controller.binaryMessenger)

        channel2.setMethodCallHandler { [weak self] call, result in
          if call.method == "openWebView", let args = call.arguments as? [String: Any],
             let url = args["url"] as? String , let title = args["title"] as? String {
              self?.openNativeWebView(with: url,with: title)
            result(nil)
          } else {
            result(FlutterMethodNotImplemented)
          }
        }
      AppDelegate.flutterCallbackChannel = FlutterMethodChannel(name: "native_webview_callback", binaryMessenger: controller.binaryMessenger)

    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }

    private func openNativeWebView(with urlString: String,with titleString: String) {
      guard let rootVC = window?.rootViewController else { return }
      let webVC = NativeWebViewController()
      webVC.modalPresentationStyle = .fullScreen

      webVC.urlString = urlString
      webVC.titleString = titleString
      rootVC.present(webVC, animated: true, completion: nil)
    }
}
