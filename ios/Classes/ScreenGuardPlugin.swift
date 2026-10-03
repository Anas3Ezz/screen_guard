import Flutter
import UIKit

public class ScreenGuardPlugin: NSObject, FlutterPlugin {

    // MARK: - Registration

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(
            name: "dev.anasezz/screen_guard",
            binaryMessenger: registrar.messenger()
        )
        let instance = ScreenGuardPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    // MARK: - MethodCall handler

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        switch call.method {
        case "setSecure":
            guard let args = call.arguments as? [String: Any],
                  let secure = args["secure"] as? Bool else {
                result(FlutterError(
                    code: "INVALID_ARGS",
                    message: "Expected {secure: Bool}",
                    details: nil
                ))
                return
            }
            setSecure(secure, result: result)

        default:
            result(FlutterMethodNotImplemented)
        }
    }

    // MARK: - Core logic

    private func setSecure(_ secure: Bool, result: @escaping FlutterResult) {
        DispatchQueue.main.async {
            guard let window = self.findKeyWindow() else {
                result(FlutterError(
                    code: "NO_WINDOW",
                    message: "Could not find a key UIWindow.",
                    details: nil
                ))
                return
            }

            if secure {
                self.applySecureLayer(to: window)
            } else {
                self.removeSecureLayer(from: window)
            }

            result(nil)
        }
    }

    // MARK: - Helpers

    private static let secureFieldTag = 0xAE_55EC
    private var originalSuperlayer: CALayer?

    private func findKeyWindow() -> UIWindow? {
        if #available(iOS 15.0, *) {
            return UIApplication.shared.connectedScenes
                .compactMap { $0 as? UIWindowScene }
                .flatMap { $0.windows }
                .first { $0.isKeyWindow }
        } else {
            return UIApplication.shared.windows.first { $0.isKeyWindow }
                ?? UIApplication.shared.windows.first
        }
    }

    private func applySecureLayer(to window: UIWindow) {
        if window.viewWithTag(ScreenGuardPlugin.secureFieldTag) != nil { return }

        let field = UITextField(frame: .zero)
        field.tag = ScreenGuardPlugin.secureFieldTag
        field.isSecureTextEntry = true
        field.isUserInteractionEnabled = false

        window.addSubview(field)

        if let secureLayer = field.layer.sublayers?.last {
            originalSuperlayer = window.layer.superlayer
            secureLayer.addSublayer(window.layer)
        }
    }

    private func removeSecureLayer(from window: UIWindow) {
        guard let field = window.viewWithTag(ScreenGuardPlugin.secureFieldTag) else { return }

        if let original = originalSuperlayer {
            original.addSublayer(window.layer)
            originalSuperlayer = nil
        }

        field.removeFromSuperview()
    }
}
