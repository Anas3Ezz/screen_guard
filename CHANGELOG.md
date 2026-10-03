## 0.0.1

* Initial release.
* Android: prevents screenshots using `FLAG_SECURE` via `WindowManager`.
* iOS: prevents screenshots using the UITextField secure layer technique.
* API: `SecureScreen.enable()`, `SecureScreen.disable()`, `SecureScreen.setSecure(bool)`.
