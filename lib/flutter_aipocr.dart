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

    var fromRes = await _channel.invokeMethod('generalBasicOCR', params);

    return transferOCRData(fromRes);
  }

  /// 通用文字识别(高精度版)
  static Future<Map<String, dynamic>> generalAccurateBasicOCR(
      {String languageType, String detectDirection}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'language_type': languageType != null ? languageType : "CHN_ENG",
      'detect_direction': detectDirection != null ? detectDirection : "true",
    };
    var fromRes =
        await _channel.invokeMethod('generalAccurateBasicOCR', params);

    return transferOCRData(fromRes);
  }

  /// 通用文字识别(含位置信息版)
  static Future<Map<String, dynamic>> generalOCR(
      {String languageType, String detectDirection}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'language_type': languageType != null ? languageType : "CHN_ENG",
      'detect_direction': detectDirection != null ? detectDirection : "true",
    };
    var fromRes = await _channel.invokeMethod('generalOCR', params);

    return transferOCRData(fromRes);
  }

  /// 通用文字识别(高精度含位置版)
  static Future<Map<String, dynamic>> generalAccurateOCR(
      {String languageType, String detectDirection}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'language_type': languageType != null ? languageType : "CHN_ENG",
      'detect_direction': detectDirection != null ? detectDirection : "true",
    };
    var fromRes = await _channel.invokeMethod('generalAccurateOCR', params);
    return transferOCRData(fromRes);
  }

  /// 通用文字识别(含生僻字版)
  static Future<Map<String, dynamic>> generalEnchancedOCR(
      {String languageType, String detectDirection}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'language_type': languageType != null ? languageType : "CHN_ENG",
      'detect_direction': detectDirection != null ? detectDirection : "true",
    };
    var fromRes = await _channel.invokeMethod('generalEnchancedOCR', params);

    return transferOCRData(fromRes);
  }

  /// 网络图片文字识别
  static Future<Map<String, dynamic>> get webImageOCR async {
    var fromRes = await _channel.invokeMethod('webImageOCR');

    return transferOCRData(fromRes);
  }

  /// 身份证正面拍照识别
  static Future<Map<String, dynamic>> get idcardOCROnlineFront async {
    var fromRes = await _channel.invokeMethod('idcardOCROnlineFront');

    return transferOCRData(fromRes);
  }

  /// 身份证反面拍照识别
  static Future<Map<String, dynamic>> get idcardOCROnlineBack async {
    var fromRes = await _channel.invokeMethod('idcardOCROnlineBack');

    return transferOCRData(fromRes);
  }

  /// 身份证正面(嵌入式质量控制+云端识别)
  static Future<Map<String, dynamic>> get localIdcardOCROnlineFront async {
    var fromRes = await _channel.invokeMethod('localIdcardOCROnlineFront');
    return transferOCRData(fromRes);
  }

  /// 身份证反面(嵌入式质量控制+云端识别)
  static Future<Map<String, dynamic>> get localIdcardOCROnlineBack async {
    var fromRes = await _channel.invokeMethod('localIdcardOCROnlineBack');

    return transferOCRData(fromRes);
  }

  /// 银行卡正面拍照识别
  static Future<Map<String, dynamic>> get bankCardOCROnline async {
    var fromRes = await _channel.invokeMethod('bankCardOCROnline');
    return transferOCRData(fromRes);
  }

  /// 驾驶证识别
  static Future<Map<String, dynamic>> get drivingLicenseOCR async {
    var fromRes = await _channel.invokeMethod('drivingLicenseOCR');

    return transferOCRData(fromRes);
  }

  /// 行驶证识别
  static Future<Map<String, dynamic>> get vehicleLicenseOCR async {
    var fromRes = await _channel.invokeMethod('vehicleLicenseOCR');

    return transferOCRData(fromRes);
  }

  /// 车牌识别
  static Future<Map<String, dynamic>> get plateLicenseOCR async {
    var fromRes = await _channel.invokeMethod('plateLicenseOCR');

    return transferOCRData(fromRes);
  }

  /// 营业执照识别
  static Future<Map<String, dynamic>> get businessLicenseOCR async {
    var fromRes = await _channel.invokeMethod('businessLicenseOCR');

    return transferOCRData(fromRes);
  }

  /// 票据识别
  static Future<Map<String, dynamic>> get receiptOCR async {
    var fromRes = await _channel.invokeMethod('receiptOCR');

    return transferOCRData(fromRes);
  }

  /// 自定义模板识别
  static Future<Map<String, dynamic>> iOCR(
      {Map<String, dynamic> options}) async {
    final Map<String, dynamic> params = <String, dynamic>{
      'options': options != null ? options : <String, dynamic>{},
    };
    var fromRes = await _channel.invokeMethod('iOCR', params);

    return transferOCRData(fromRes);
  }

  static Future<Map<String, dynamic>> transferOCRData(
      Map<Object, Object> fromRes) async {
//    assert(fromRes != null);

    if (fromRes != null) {
      print("ocr: " + fromRes.toString());

      final Map<String, Object> toMap = <String, Object>{};
      for (String key in fromRes.keys) {
        toMap[key] = fromRes[key];
      }
      return toMap;
    } else {
      return fromRes;
    }
  }
}
