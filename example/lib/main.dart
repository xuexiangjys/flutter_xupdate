import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_xupdate/flutter_xupdate.dart';
import 'package:flutter_xupdate_example/app_info.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _message = '';

  String _customJson = '';

  @override
  void initState() {
    super.initState();
    initXUpdate();
    loadJsonFromAsset();
  }

  Future<void> loadJsonFromAsset() async {
    _customJson = await rootBundle.loadString('assets/update_custom.json');
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
              enableRetry: false)
          .then((value) {
        updateMessage("初始化成功: $value");
      }).catchError((error) {
        print(error);
      });

//      FlutterXUpdate.setErrorHandler(
//          onUpdateError: (Map<String, dynamic> message) async {
//        print(message);
//        //下载失败
//        if (message["code"] == 4000) {
//          FlutterXUpdate.showRetryUpdateTipDialog(
//              retryContent: "Github被墙无法继续下载，是否考虑切换蒲公英下载？",
//              retryUrl: "https://www.pgyer.com/flutter_learn");
//        }
//        setState(() {
//          _message = "$message";
//        });
//      });

//      FlutterXUpdate.setCustomParseHandler(onUpdateParse: (String json) async {
//        //这里是自定义json解析
//        return customParseJson(json);
//      });

      FlutterXUpdate.setUpdateHandler(
          onUpdateError: (Map<String, dynamic> message) async {
        print(message);
        //下载失败
        if (message["code"] == 4000) {
          FlutterXUpdate.showRetryUpdateTipDialog(
              retryContent: "Github被墙无法继续下载，是否考虑切换蒲公英下载？",
              retryUrl: "https://www.pgyer.com/flutter_learn");
        }
        setState(() {
          _message = "$message";
        });
      }, onUpdateParse: (String json) async {
        //这里是自定义json解析
        return customParseJson(json);
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

  ///将自定义的json内容解析为UpdateEntity实体类
  UpdateEntity customParseJson(String json) {
    AppInfo appInfo = AppInfo.fromJson(json);
    print(appInfo);
    return UpdateEntity(
        hasUpdate: appInfo.hasUpdate,
        isIgnorable: appInfo.isIgnorable,
        versionCode: appInfo.versionCode,
        versionName: appInfo.versionName,
        updateContent: appInfo.updateLog,
        downloadUrl: appInfo.apkUrl,
        apkSize: appInfo.apkSize);
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
                      onPressed: checkUpdateDefault,
                    ),
                    RaisedButton(
                      child: Text('默认App更新 + 支持后台更新'),
                      color: Colors.blue,
                      onPressed: checkUpdateSupportBackground,
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
                      onPressed: checkUpdateRatio,
                    ),
                    RaisedButton(
                      child: Text('强制更新'),
                      color: Colors.blue,
                      onPressed: checkUpdateForce,
                    ),
                    RaisedButton(
                      child: Text('自动模式'),
                      color: Colors.blue,
                      onPressed: checkUpdateAutoMode,
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
                      onPressed: enableChangeDownLoadType,
                    ),
                    RaisedButton(
                      child: Text('显示重试提示弹窗'),
                      color: Colors.blue,
                      onPressed: showRetryDialogTip,
                    ),
                  ],
                )),
                autoFitWidget(ButtonBar(
                  alignment:
                      MainAxisAlignment.start, //布局方向，默认MainAxisAlignment.end
                  mainAxisSize: MainAxisSize.min, //主轴大小，默认MainAxisSize.max
                  children: <Widget>[
                    RaisedButton(
                      child: Text('使用自定义json解析'),
                      color: Colors.blue,
                      onPressed: customJsonParse,
                    ),
                    RaisedButton(
                      child: Text('直接传入UpdateEntity进行更新'),
                      color: Colors.blue,
                      onPressed: checkUpdateByUpdateEntity,
                    ),
                  ],
                )),
                autoFitWidget(ButtonBar(
                  alignment:
                  MainAxisAlignment.start, //布局方向，默认MainAxisAlignment.end
                  mainAxisSize: MainAxisSize.min, //主轴大小，默认MainAxisSize.max
                  children: <Widget>[
                    RaisedButton(
                      child: Text('自定义更新弹窗样式'),
                      color: Colors.blue,
                      onPressed: customPromptDialog,
                    ),
                  ],
                ))
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

  String _updateUrl2 =
      "https://gitee.com/xuexiangjys/XUpdate/raw/master/jsonapi/update_forced.json";

  String _updateUrl3 =
      "https://gitee.com/xuexiangjys/XUpdate/raw/master/jsonapi/update_custom.json";

  ///默认App更新
  void checkUpdateDefault() {
    FlutterXUpdate.checkUpdate(url: _updateUrl);
  }

  ///默认App更新 + 支持后台更新
  void checkUpdateSupportBackground() {
    FlutterXUpdate.checkUpdate(url: _updateUrl, supportBackgroundUpdate: true);
  }

  ///调整宽高比
  void checkUpdateRatio() {
    FlutterXUpdate.checkUpdate(url: _updateUrl, widthRatio: 0.6);
  }

  ///强制更新
  void checkUpdateForce() {
    FlutterXUpdate.checkUpdate(url: _updateUrl2);
  }

  ///自动模式, 如果需要完全无人干预，自动更新，需要root权限【静默安装需要】
  void checkUpdateAutoMode() {
    FlutterXUpdate.checkUpdate(url: _updateUrl, isAutoMode: true);
  }

  ///下载时点击取消允许切换下载方式
  void enableChangeDownLoadType() {
    FlutterXUpdate.checkUpdate(
        url: _updateUrl,
        overrideGlobalRetryStrategy: true,
        enableRetry: true,
        retryContent: "Github下载速度太慢了，是否考虑切换蒲公英下载？",
        retryUrl: "https://www.pgyer.com/flutter_learn");
  }

  ///显示重试提示弹窗
  void showRetryDialogTip() {
    FlutterXUpdate.showRetryUpdateTipDialog(
        retryContent: "Github下载速度太慢了，是否考虑切换蒲公英下载？",
        retryUrl: "https://www.pgyer.com/flutter_learn");
  }

  ///使用自定义json解析
  void customJsonParse() {
    FlutterXUpdate.checkUpdate(url: _updateUrl3, isCustomParse: true);
  }

  ///直接传入UpdateEntity进行更新提示
  void checkUpdateByUpdateEntity() {
    FlutterXUpdate.updateByInfo(updateEntity: customParseJson(_customJson));
  }


  ///自定义更新弹窗样式
  void customPromptDialog() {
    FlutterXUpdate.checkUpdate(url: _updateUrl, themeColor: '#FFFFAC5D', topImageRes: 'bg_update_top', buttonTextColor: '#FFFFFFFF');
  }

}
