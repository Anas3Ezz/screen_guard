import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:screen_guard/screen_guard.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel('dev.anasezz/screen_guard');
  final List<MethodCall> log = [];

  setUp(() {
    log.clear();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (MethodCall call) async {
      log.add(call);
      return null;
    });
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  test('enable() sends setSecure with true', () async {
    await ScreenGuard.enable();
    expect(log.length, 1);
    expect(log.first.method, 'setSecure');
    expect(log.first.arguments, {'secure': true});
  });

  test('disable() sends setSecure with false', () async {
    await ScreenGuard.disable();
    expect(log.length, 1);
    expect(log.first.method, 'setSecure');
    expect(log.first.arguments, {'secure': false});
  });

  test('setSecure(true) sends correct payload', () async {
    await ScreenGuard.setSecure(true);
    expect(log.first.arguments, {'secure': true});
  });

  test('setSecure(false) sends correct payload', () async {
    await ScreenGuard.setSecure(false);
    expect(log.first.arguments, {'secure': false});
  });

  test('multiple calls are sent in order', () async {
    await ScreenGuard.enable();
    await ScreenGuard.disable();
    expect(log.length, 2);
    expect(log[0].arguments['secure'], true);
    expect(log[1].arguments['secure'], false);
  });
}
