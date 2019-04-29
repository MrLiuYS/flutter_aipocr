# flutter_aipocr

百度OCR插件,该插件android不支持androidx . iOS的ocr库包.支持模拟器的.上传至AppStore前，必须使用lipo命令移除模拟器架构。[FAQ.2](https://cloud.baidu.com/doc/OCR/OCR-iOS-SDK.html#.2F.CA.88.72.AF.63.B5.6C.D6.D1.39.1E.60.F0.8C.6B)

## 使用

初始化
```
await FlutterAipocr.init(
          iOSAppKey: "",
          iOSSecretKey: "",
          androidAppKey: "",
          androidSecretKey: "");
```

支持功能
```
  List<String> titleStr = [
    "营业执照识别",
    "通用文字识别",
    "通用文字识别(高精度版)",
    "通用文字识别(含位置信息版)",
    "通用文字识别(高精度含位置版)",
    "通用文字识别(含生僻字版)",
    "网络图片文字识别",
    "身份证正面拍照识别",
    "身份证反面拍照识别",
    "身份证正面(嵌入式质量控制+云端识别)-iOS",
    "身份证反面(嵌入式质量控制+云端识别)-iOS",
    "银行卡正面拍照识别",
    "驾驶证识别",
    "行驶证识别",
    "车牌识别",
    "票据识别",
    "自定义模板识别-iOS"
  ];
```

**标明-iOS的是只支持iOS,没有去配置android**


