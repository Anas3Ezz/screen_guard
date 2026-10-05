## 0.0.5

* **iOS**: Block screen recording — show black overlay when `UIScreen.isCaptured` is detected.
* **iOS**: Mute app audio during screen recording via `AVAudioSession` deactivation.
* **Android**: Block audio capture during screen recording via `ALLOW_CAPTURE_BY_NONE` (API 29+).
* **Android**: Re-apply protection on activity recreation (config changes, background resume).
* **Android**: Use `setFlags()` instead of `addFlags()` for more reliable flag application.

## 0.0.4

* Rename iOS podspec to `screen_guard` for consistency.

## 0.0.3

* Rename package from `secure_screen` to `screen_guard`.
* Add Android namespace for AGP 8+ compatibility.
* Add branch protection and repo security.

## 0.0.2

* Add example app.
* Add library-level dartdoc comment.
* Fix iOS deprecated `UIApplication.shared.windows` — use window scene API on iOS 15+.
* Fix iOS layer restoration reliability.

## 0.0.1

* Initial release.
* Android: prevents screenshots using `FLAG_SECURE` via `WindowManager`.
* iOS: prevents screenshots using the UITextField secure layer technique.
* API: `ScreenGuard.enable()`, `ScreenGuard.disable()`, `ScreenGuard.setSecure(bool)`.
