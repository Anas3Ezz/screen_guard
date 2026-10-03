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
