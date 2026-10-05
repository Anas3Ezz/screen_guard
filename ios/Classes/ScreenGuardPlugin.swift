import Flutter
import UIKit
import AVFoundation

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

    // MARK: - State

    private static let secureFieldTag = 0xAE_55EC
    private static let recordingOverlayTag = 0xAE_55ED
    private var originalSuperlayer: CALayer?
    private var isSecureEnabled = false

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

            self.isSecureEnabled = secure

            if secure {
                self.applySecureLayer(to: window)
                self.startObservingRecording()
                self.updateRecordingOverlay(for: window)
            } else {
                self.removeSecureLayer(from: window)
                self.stopObservingRecording()
                self.removeRecordingOverlay(from: window)
            }

            result(nil)
        }
    }

    // MARK: - Screenshot protection (UITextField secure layer)

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

    // MARK: - Screen recording protection

    private func startObservingRecording() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(screenCapturedDidChange),
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )
    }

    private func stopObservingRecording() {
        NotificationCenter.default.removeObserver(
            self,
            name: UIScreen.capturedDidChangeNotification,
            object: nil
        )
    }

    @objc private func screenCapturedDidChange() {
        DispatchQueue.main.async {
            guard self.isSecureEnabled, let window = self.findKeyWindow() else { return }
            self.updateRecordingOverlay(for: window)
        }
    }

    private func updateRecordingOverlay(for window: UIWindow) {
        if UIScreen.main.isCaptured {
            addRecordingOverlay(to: window)
        } else {
            removeRecordingOverlay(from: window)
        }
    }

    private func addRecordingOverlay(to window: UIWindow) {
        if window.viewWithTag(ScreenGuardPlugin.recordingOverlayTag) != nil { return }

        let overlay = UIView(frame: window.bounds)
        overlay.tag = ScreenGuardPlugin.recordingOverlayTag
        overlay.backgroundColor = .black
        overlay.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        overlay.isUserInteractionEnabled = false
        window.addSubview(overlay)

        muteAudio()
    }

    private func removeRecordingOverlay(from window: UIWindow) {
        guard window.viewWithTag(ScreenGuardPlugin.recordingOverlayTag) != nil else { return }
        window.viewWithTag(ScreenGuardPlugin.recordingOverlayTag)?.removeFromSuperview()
        restoreAudio()
    }

    // MARK: - Audio muting during recording

    private var previousAudioCategory: AVAudioSession.Category?
    private var previousAudioOptions: AVAudioSession.CategoryOptions?

    private func muteAudio() {
        let session = AVAudioSession.sharedInstance()
        previousAudioCategory = session.category
        previousAudioOptions = session.categoryOptions
        try? session.setActive(false, options: .notifyOthersOnDeactivation)
    }

    private func restoreAudio() {
        let session = AVAudioSession.sharedInstance()
        let category = previousAudioCategory ?? .playback
        let options = previousAudioOptions ?? []
        try? session.setCategory(category, options: options)
        try? session.setActive(true)
        previousAudioCategory = nil
        previousAudioOptions = nil
    }

    // MARK: - Helpers

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

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
}
