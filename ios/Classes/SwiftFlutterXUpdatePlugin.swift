import Flutter
import UIKit

public class SwiftFlutterXUpdatePlugin: NSObject, FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.xuexiang/flutter_xupdate", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterXUpdatePlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    result("iOS " + UIDevice.current.systemVersion)
  }
}
