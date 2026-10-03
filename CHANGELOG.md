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
