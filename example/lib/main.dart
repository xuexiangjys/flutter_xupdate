import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _message = '';

  @override
  void initState() {
    super.initState();
    initXUpdate();
  }

  ///初始化
  void initXUpdate() {
    if (Platform.isAndroid) {
      FlutterXUpdate.init(
        ///是否输出日志
        debug: true,
        ///是否使用post请求
        isPost: false,
        ///post请求是否是上传json
        isPostJson: false,
        ///是否开启自动模式
        isWifiOnly: false,
        ///是否开启自动模式
        isAutoMode: false,
        ///需要设置的公共参数
        supportSilentInstall: false,
        ///在下载过程中，如果点击了取消的话，是否弹出切换下载方式的重试提示弹窗
        enableRetry: false
      ).then((value) {
        updateMessage("初始化成功: $value");
      }).catchError((error) {
        print(error);
      });

      FlutterXUpdate.setErrorHandler(
          onUpdateError: (Map<String, dynamic> message) async {
        print(message);
        setState(() {
          _message = "$message";
        });
      });
    } else {
      updateMessage("ios暂不支持XUpdate更新");
    }
  }

  void updateMessage(String message) {
    setState(() {
      _message = message;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('flutter_xupdate Demo'),
        ),
        body: SingleChildScrollView(
            padding: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, //文本是起始端对齐
              children: <Widget>[
                Container(
                  alignment: Alignment.topLeft,
                  height: 150,
                  color: Colors.grey,
                  padding: EdgeInsets.all(10),
                  child: Text(_message,
                      style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
                autoFitWidget(ButtonBar(
                  alignment:
                      MainAxisAlignment.start, //布局方向，默认MainAxisAlignment.end
                  mainAxisSize: MainAxisSize.min, //主轴大小，默认MainAxisSize.max
                  children: <Widget>[
                    RaisedButton(
                      child: Text('默认App更新'),
                      color: Colors.blue,
                      onPressed: checkUpdate,
                    ),
                    RaisedButton(
                      child: Text('默认App更新 + 支持后台更新'),
                      color: Colors.blue,
                      onPressed: checkUpdate1,
                    ),
                  ],
                )),
                autoFitWidget(ButtonBar(
                  alignment:
                      MainAxisAlignment.start, //布局方向，默认MainAxisAlignment.end
                  mainAxisSize: MainAxisSize.min, //主轴大小，默认MainAxisSize.max
                  children: <Widget>[
                    RaisedButton(
                      child: Text('调整宽高比'),
                      color: Colors.blue,
                      onPressed: checkUpdate2,
                    ),
                    RaisedButton(
                      child: Text('强制更新'),
                      color: Colors.blue,
                      onPressed: checkUpdate3,
                    ),
                    RaisedButton(
                      child: Text('自动模式'),
                      color: Colors.blue,
                      onPressed: checkUpdate4,
                    ),
                  ],
                )),
                autoFitWidget(ButtonBar(
                  alignment:
                      MainAxisAlignment.start, //布局方向，默认MainAxisAlignment.end
                  mainAxisSize: MainAxisSize.min, //主轴大小，默认MainAxisSize.max
                  children: <Widget>[
                    RaisedButton(
                      child: Text('下载时点击取消允许切换下载方式'),
                      color: Colors.blue,
                      onPressed: checkUpdate5,
                    ),
                  ],
                )),
              ],
            )),
      ),
    );
  }

  Widget autoFitWidget(Widget child) {
    return Platform.isAndroid ? child : SizedBox();
  }

  String _updateUrl =
      "https://gitee.com/xuexiangjys/XUpdate/raw/master/jsonapi/update_test.json";

  String mUpdateUrl2 =
      "https://gitee.com/xuexiangjys/XUpdate/raw/master/jsonapi/update_forced.json";

  ///默认App更新
  void checkUpdate() {
    FlutterXUpdate.checkUpdate(url: _updateUrl);
  }

  ///默认App更新 + 支持后台更新
  void checkUpdate1() {
    FlutterXUpdate.checkUpdate(url: _updateUrl, supportBackgroundUpdate: true);
  }

  ///调整宽高比
  void checkUpdate2() {
    FlutterXUpdate.checkUpdate(url: _updateUrl, widthRatio: 0.6);
  }

  ///强制更新
  void checkUpdate3() {
    FlutterXUpdate.checkUpdate(url: mUpdateUrl2);
  }

  ///自动模式, 如果需要完全无人干预，自动更新，需要root权限【静默安装需要】
  void checkUpdate4() {
    FlutterXUpdate.checkUpdate(url: _updateUrl, isAutoMode: true);
  }

  ///下载时点击取消允许切换下载方式
  void checkUpdate5() {
    FlutterXUpdate.checkUpdate(
        url: _updateUrl,
        overrideGlobalRetryStrategy: true,
        enableRetry: true,
        retryContent: "Github下载速度太慢了，是否考虑切换蒲公英下载？",
        retryUrl: "https://www.pgyer.com/flutter_learn");
  }
}
