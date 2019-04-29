import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';

class FlutterAipocr {
  static const MethodChannel _channel = const MethodChannel('flutter_aipocr');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }

  /// 初始化Ocr
  static Future<bool> init(
      {String iOSAppKey,
      String iOSSecretKey,
      String androidAppKey,
      String androidSecretKey}) async {
    assert((Platform.isAndroid &&
            androidAppKey != null &&
            androidSecretKey != null) ||
        (Platform.isIOS && iOSAppKey != null && iOSSecretKey != null));

    final Map<String, dynamic> params = <String, dynamic>{
      'appKey': Platform.isAndroid ? androidAppKey : iOSAppKey,
      'secretKey': Platform.isAndroid ? androidSecretKey : iOSSecretKey,
    };

    bool res = await _channel.invokeMethod('init', params);
    return res;
  }

  /// 通用文字识别
  static Future<Map<String, dynamic>> generalBasicOCR(
      {String languageType, String detectDirection}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'language_type': languageType != null ? languageType : "CHN_ENG",
      'detect_direction': detectDirection != null ? detectDirection : "true",
    };

    final String jsonStr =
        await _channel.invokeMethod('generalBasicOCR', params);

    Map<String, dynamic> res = json.decode(jsonStr);
    return res;
  }

  /// 通用文字识别(高精度版)
  static Future<Map<String, dynamic>> generalAccurateBasicOCR(
      {String languageType, String detectDirection}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'language_type': languageType != null ? languageType : "CHN_ENG",
      'detect_direction': detectDirection != null ? detectDirection : "true",
    };
    final String jsonStr =
        await _channel.invokeMethod('generalAccurateBasicOCR', params);

    Map<String, dynamic> res = json.decode(jsonStr);
    return res;
  }

  /// 通用文字识别(含位置信息版)
  static Future<Map<String, dynamic>> generalOCR(
      {String languageType, String detectDirection}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'language_type': languageType != null ? languageType : "CHN_ENG",
      'detect_direction': detectDirection != null ? detectDirection : "true",
    };
    final String jsonStr = await _channel.invokeMethod('generalOCR', params);

    Map<String, dynamic> res = json.decode(jsonStr);
    return res;
  }

  /// 通用文字识别(高精度含位置版)
  static Future<Map<String, dynamic>> generalAccurateOCR(
      {String languageType, String detectDirection}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'language_type': languageType != null ? languageType : "CHN_ENG",
      'detect_direction': detectDirection != null ? detectDirection : "true",
    };
    final String jsonStr =
        await _channel.invokeMethod('generalAccurateOCR', params);

    Map<String, dynamic> res = json.decode(jsonStr);
    return res;
  }

  /// 通用文字识别(含生僻字版)
  static Future<Map<String, dynamic>> generalEnchancedOCR(
      {String languageType, String detectDirection}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'language_type': languageType != null ? languageType : "CHN_ENG",
      'detect_direction': detectDirection != null ? detectDirection : "true",
    };
    final String jsonStr =
        await _channel.invokeMethod('generalEnchancedOCR', params);

    Map<String, dynamic> res = json.decode(jsonStr);
    return res;
  }

  /// 网络图片文字识别
  static Future<Map<String, dynamic>> get webImageOCR async {
    final String jsonStr = await _channel.invokeMethod('webImageOCR');

    Map<String, dynamic> res = json.decode(jsonStr);
    return res;
  }

  /// 身份证正面拍照识别
  static Future<Map<String, dynamic>> get idcardOCROnlineFront async {
    final String jsonStr = await _channel.invokeMethod('idcardOCROnlineFront');

    Map<String, dynamic> res = json.decode(jsonStr);
    return res;
  }

  /// 身份证反面拍照识别
  static Future<Map<String, dynamic>> get idcardOCROnlineBack async {
    final String jsonStr = await _channel.invokeMethod('idcardOCROnlineBack');

    Map<String, dynamic> res = json.decode(jsonStr);

    return res;
  }

  /// 身份证正面(嵌入式质量控制+云端识别)
  static Future<Map<String, dynamic>> get localIdcardOCROnlineFront async {
    final String jsonStr =
        await _channel.invokeMethod('localIdcardOCROnlineFront');

    Map<String, dynamic> res = json.decode(jsonStr);
    return res;
  }

  /// 身份证反面(嵌入式质量控制+云端识别)
  static Future<Map<String, dynamic>> get localIdcardOCROnlineBack async {
    final String jsonStr =
        await _channel.invokeMethod('localIdcardOCROnlineBack');

    Map<String, dynamic> res = json.decode(jsonStr);
    return res;
  }

  /// 银行卡正面拍照识别
  static Future<Map<String, dynamic>> get bankCardOCROnline async {
    final String jsonStr = await _channel.invokeMethod('bankCardOCROnline');

    Map<String, dynamic> res = json.decode(jsonStr);
    return res;
  }

  /// 驾驶证识别
  static Future<Map<String, dynamic>> get drivingLicenseOCR async {
    final String jsonStr = await _channel.invokeMethod('drivingLicenseOCR');

    Map<String, dynamic> res = json.decode(jsonStr);

    return res;
  }

  /// 行驶证识别
  static Future<Map<String, dynamic>> get vehicleLicenseOCR async {
    final String jsonStr = await _channel.invokeMethod('vehicleLicenseOCR');

    Map<String, dynamic> res = json.decode(jsonStr);

    return res;
  }

  /// 车牌识别
  static Future<Map<String, dynamic>> get plateLicenseOCR async {
    final String jsonStr = await _channel.invokeMethod('plateLicenseOCR');

    Map<String, dynamic> res = json.decode(jsonStr);

    return res;
  }

  /// 营业执照识别
  static Future<Map<String, dynamic>> get businessLicenseOCR async {
    final String jsonStr = await _channel.invokeMethod('businessLicenseOCR');

    Map<String, dynamic> res = json.decode(jsonStr);

    return res;
  }

  /// 票据识别
  static Future<Map<String, dynamic>> get receiptOCR async {
    final String jsonStr = await _channel.invokeMethod('receiptOCR');

    Map<String, dynamic> res = json.decode(jsonStr);

    return res;
  }

  /// 自定义模板识别
  static Future<Map<String, dynamic>> iOCR(
      {Map<String, dynamic> options}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'options': options != null ? options : <String, dynamic>{},
    };
    final String jsonStr = await _channel.invokeMethod('iOCR', params);

    Map<String, dynamic> res = json.decode(jsonStr);

    return res;
  }
}
