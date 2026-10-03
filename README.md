# screen_guard

[![pub package](https://img.shields.io/pub/v/screen_guard.svg)](https://pub.dev/packages/screen_guard)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://opensource.org/licenses/MIT)

A lightweight Flutter plugin to prevent **screenshots** and **screen recording** on Android and iOS — with a single method call.

Ideal for fintech, healthcare, messaging, and any app that displays sensitive user data.

---

## Features

- **One-line API** — enable or disable protection anywhere in your app
- **Android** — uses `FLAG_SECURE` on the activity window, blocking screenshots and recording at the OS level
- **iOS** — applies the `UITextField` secure layer technique to blur the entire screen during capture
- **Zero dependencies** — only requires Flutter
- **No permissions needed** — works without requesting any runtime permissions

## Platform Support

| Platform | Minimum Version | Status |
|----------|----------------|--------|
| Android  | API 21         | ✅      |
| iOS      | 12.0           | ✅      |
| Web      | —              | No-op  |
| Desktop  | —              | No-op  |

---

## Installation

```yaml
dependencies:
  screen_guard: ^0.0.1
```

```bash
flutter pub get
```

---

## Quick Start

```dart
import 'package:screen_guard/screen_guard.dart';

// Enable protection
await ScreenGuard.enable();

// Disable protection
await ScreenGuard.disable();
```

## Usage

### Protect a single screen

```dart
class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    ScreenGuard.enable();
  }

  @override
  void dispose() {
    ScreenGuard.disable();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(child: Text('Payment details are protected.')),
    );
  }
}
```

### Toggle based on a condition

```dart
await ScreenGuard.setSecure(user.hasSensitiveData);
```

---

## API Reference

| Method                          | Description                              |
|---------------------------------|------------------------------------------|
| `ScreenGuard.enable()`          | Enables screenshot & recording prevention |
| `ScreenGuard.disable()`         | Disables screenshot & recording prevention |
| `ScreenGuard.setSecure(bool)`   | Enables or disables based on the value    |

All methods return `Future<void>` and are safe to call on unsupported platforms (web, desktop) — they resolve as no-ops.

---

## How It Works

### Android

Sets `WindowManager.LayoutParams.FLAG_SECURE` on the current activity's window. The OS prevents all forms of screen capture, including screenshots, screen recording, and the recent apps thumbnail.

### iOS

Injects a zero-size `UITextField` with `isSecureTextEntry = true` into the key window and re-parents the window's `CALayer` under the text field's secure sublayer. UIKit then treats the entire screen as secure content and automatically blurs it during any capture attempt.

---

## FAQ

**Does this block all screenshot methods?**
On Android, `FLAG_SECURE` blocks all system-level capture. On iOS, the secure layer technique works against the built-in screenshot and screen recording — but cannot prevent capture by a jailbroken device.

**Does the user see a black screen or a blur?**
On Android, screenshots produce a black image. On iOS, the screen appears blurred during capture.

**Can I protect only part of the screen?**
No — this plugin applies protection to the entire window. Partial protection is not supported by the underlying OS APIs.

---

## Contributing

Contributions are welcome! Please open an issue or submit a pull request at [github.com/Anas3Ezz/screen_guard](https://github.com/Anas3Ezz/screen_guard).

---

## License

This project is licensed under the MIT License — see the [LICENSE](LICENSE) file for details.
