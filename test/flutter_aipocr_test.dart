import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_aipocr/flutter_aipocr.dart';

void main() {
  const MethodChannel channel = MethodChannel('flutter_aipocr');

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await FlutterAipocr.platformVersion, '42');
  });
}
