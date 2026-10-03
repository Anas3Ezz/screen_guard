import 'package:flutter/material.dart';
import 'package:screen_guard/screen_guard.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const HomeScreen(),
      routes: {
        '/secure': (_) => const SecureScreen(),
      },
    );
  }
}

/// A normal screen with no protection.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('screen_guard example')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(context, '/secure'),
          child: const Text('Go to Secure Screen'),
        ),
      ),
    );
  }
}

/// A protected screen — screenshots and recording are blocked
/// while this screen is visible.
class SecureScreen extends StatefulWidget {
  const SecureScreen({super.key});

  @override
  State<SecureScreen> createState() => _SecureScreenState();
}

class _SecureScreenState extends State<SecureScreen> {
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
    return Scaffold(
      appBar: AppBar(title: const Text('Secure Screen')),
      body: const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'This screen is protected.\n\n'
            'Screenshots will appear black on Android '
            'and blurred on iOS.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),
          ),
        ),
      ),
    );
  }
}
