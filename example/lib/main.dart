import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_aipocr/flutter_aipocr.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final navigatorKey = GlobalKey<NavigatorState>();

  String _platformVersion = 'Unknown';

  bool _isAipOCR = false;

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
  List<String> typeStr = [
    "businessLicenseOCR",
    "generalBasicOCR",
    "generalAccurateBasicOCR",
    "generalOCR",
    "generalAccurateOCR",
    "generalEnchancedOCR",
    "webImageOCR",
    "idcardOCROnlineFront",
    "idcardOCROnlineBack",
    "localIdcardOCROnlineFront",
    "localIdcardOCROnlineBack",
    "bankCardOCROnline",
    "drivingLicenseOCR",
    "vehicleLicenseOCR",
    "plateLicenseOCR",
    "receiptOCR",
    "iOCR"
  ];

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    bool isAipOCR;

    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await FlutterAipocr.platformVersion;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }
    try {
      isAipOCR = await FlutterAipocr.init(
          iOSAppKey: "",
          iOSSecretKey: "",
          androidAppKey: "",
          androidSecretKey: "");
    } on PlatformException {
      isAipOCR = false;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
      _isAipOCR = isAipOCR;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: CustomScrollView(
          // 手动维护semanticChildCount,用于判断是否没有更多数据
          semanticChildCount: titleStr.length,
          slivers: <Widget>[
            SliverAppBar(
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                    'AipOcr初始化:${_isAipOCR ? "yes" : "no"} \n 终端系统: $_platformVersion\n '),
              ),
            ),
            SliverPadding(
              padding: EdgeInsets.all(0.0),
              sliver: SliverFixedExtentList(
                  itemExtent: 70.0,
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _buildItem(index);
                    },
                    childCount: titleStr.length,
                  )),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(onPressed: () {
          _showMyMaterialDialog('asdfasf');
        }),
      ),
    );
  }

  Widget _buildItem(int index) {
    String type = typeStr[index];
    String title = titleStr[index];
    return GestureDetector(
      onTap: () {
        _btnClick(type);
      },
      child: Container(
        height: 50,
        child: Center(
          child: Text(title),
        ),
      ),
    );
  }

  void _btnClick(String type) async {
    print("_btnClick");

    Map<String, dynamic> res;

    try {
      if (type == "businessLicenseOCR") {
        res = await FlutterAipocr.businessLicenseOCR;
      } else if (type == "generalBasicOCR") {
        res = await FlutterAipocr.generalBasicOCR();
      } else if (type == "generalAccurateBasicOCR") {
        res = await FlutterAipocr.generalAccurateBasicOCR();
      } else if (type == "generalOCR") {
        res = await FlutterAipocr.generalOCR();
      } else if (type == "generalAccurateOCR") {
        res = await FlutterAipocr.generalAccurateOCR();
      } else if (type == "generalEnchancedOCR") {
        res = await FlutterAipocr.generalEnchancedOCR();
      } else if (type == "webImageOCR") {
        res = await FlutterAipocr.webImageOCR;
      } else if (type == "idcardOCROnlineFront") {
        res = await FlutterAipocr.idcardOCROnlineFront;
      } else if (type == "idcardOCROnlineBack") {
        res = await FlutterAipocr.idcardOCROnlineBack;
      } else if (type == "localIdcardOCROnlineFront") {
        res = await FlutterAipocr.localIdcardOCROnlineFront;
      } else if (type == "localIdcardOCROnlineBack") {
        res = await FlutterAipocr.localIdcardOCROnlineBack;
      } else if (type == "bankCardOCROnline") {
        res = await FlutterAipocr.bankCardOCROnline;
      } else if (type == "drivingLicenseOCR") {
        res = await FlutterAipocr.drivingLicenseOCR;
      } else if (type == "vehicleLicenseOCR") {
        res = await FlutterAipocr.vehicleLicenseOCR;
      } else if (type == "plateLicenseOCR") {
        res = await FlutterAipocr.plateLicenseOCR;
      } else if (type == "receiptOCR") {
        res = await FlutterAipocr.receiptOCR;
      } else if (type == "iOCR") {
        res = await FlutterAipocr.receiptOCR;
      }
    } on FlutterError catch (e) {
      res = <String, dynamic>{"错误": e.message};
    }
    print(res.toString());

    _showMyMaterialDialog(res.toString());
  }

  Future<void> _showMyMaterialDialog(String msg) {
    final context = navigatorKey.currentState.overlay.context;

    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('回调数据'),
          content: Text(msg),
          actions: <Widget>[
            FlatButton(
              child: Text("确定"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
