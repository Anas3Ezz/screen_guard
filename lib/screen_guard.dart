/// A Flutter plugin to prevent screenshots and screen recording
/// on Android and iOS.
///
/// Uses `FLAG_SECURE` on Android and the `UITextField` secure layer
/// technique on iOS.
library screen_guard;

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

/// A Flutter plugin to prevent screenshots and screen recording
/// on Android and iOS.
class ScreenGuard {
  static const MethodChannel _channel = MethodChannel('dev.anasezz/screen_guard');

  /// Enables screenshot and screen recording prevention.
  ///
  /// On Android, sets [FLAG_SECURE] on the current window.
  /// On iOS, applies the UITextField secure layer trick.
  ///
  /// Throws a [PlatformException] if the operation fails.
  static Future<void> setSecure(bool secure) async {
    if (!_isSupportedPlatform) return;
    await _channel.invokeMethod<void>('setSecure', {'secure': secure});
  }

  /// Enables screenshot prevention. Shorthand for [setSecure(true)].
  static Future<void> enable() => setSecure(true);

  /// Disables screenshot prevention. Shorthand for [setSecure(false)].
  static Future<void> disable() => setSecure(false);

  /// Returns whether the current platform supports this plugin.
  static bool get _isSupportedPlatform =>
      defaultTargetPlatform == TargetPlatform.android ||
      defaultTargetPlatform == TargetPlatform.iOS;
}
