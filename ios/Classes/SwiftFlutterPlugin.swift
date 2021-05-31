import Flutter
import UIKit
    
public class SwiftFlutterPlugin: NSObject, Flutter.FlutterPlugin {
  public static func register(with registrar: FlutterPluginRegistrar) {
    let channel = FlutterMethodChannel(name: "com.pichillilorenzo/flutter_appavailability", binaryMessenger: registrar.messenger())
    let instance = SwiftFlutterPlugin()
    registrar.addMethodCallDelegate(instance, channel: channel)
  }

  public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
    var uriSchema = ""
    var args: NSDictionary = [:]
    let arguments = call.arguments as? NSDictionary
    switch call.method {
      case "checkAvailability":
        uriSchema = (arguments!["uri"] as? String)!
        result(checkAvailability(uri: uriSchema))
        break
      case "launchApp":
        uriSchema = (arguments!["uri"] as? String)!
        args = (arguments!["args"] as? NSDictionary)!
        launchApp(uri: uriSchema,args: args, result: result)
        break
      default:
        break
    }
  }
  
  public func checkAvailability (uri: String) -> Bool {
    let url = URL(string: uri)
    return UIApplication.shared.canOpenURL(url!)
  }
  
  public func launchApp (uri: String, args: NSDictionary, result: @escaping FlutterResult) {
    var url = URL(string: uri)
    
    if(!args.allKeys.isEmpty){
        for (k, v) in args {
            let queryItems = [URLQueryItem(name: k as! String, value: v as! String)]
            url = url?.appending(queryItems)!
        }
    }
    if (checkAvailability(uri: uri)) {
      UIApplication.shared.openURL(url!)
      result(true)
    }
    result(false)
 }
  
}

extension URL {
    func appending(_ queryItems: [URLQueryItem]) -> URL? {
        guard var urlComponents = URLComponents(url: self, resolvingAgainstBaseURL: true) else {
            return nil
        }
        urlComponents.queryItems = (urlComponents.queryItems ?? []) + queryItems
        return urlComponents.url
    }
}
