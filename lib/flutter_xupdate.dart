import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

typedef Future<dynamic> ErrorHandler(Map<String, dynamic> event);

///Android全量更新插件
class FlutterXUpdate {

  static ErrorHandler _onUpdateError;

  FlutterXUpdate._();

  static const MethodChannel _channel =
  const MethodChannel('com.xuexiang/flutter_xupdate');

  ///初始化插件
  static Future<Map> init({
    ///是否输出日志
    bool debug = false,
    ///是否使用post请求
    bool isPost = false,
    ///post请求是否是上传json
    bool isPostJson = false,
    ///是否只在wifi下才能进行更新
    bool isWifiOnly = true,
    ///是否开启自动模式
    bool isAutoMode = false,
    ///是否支持静默安装，这个需要设备有root权限
    bool supportSilentInstall = false,
    ///需要设置的公共参数
    Map params
  }) async {
    if (Platform.isAndroid) {
      Map<String, Object> map = {
        "debug": debug,
        "isGet": !isPost,
        "isPostJson": isPostJson,
        "isWifiOnly": isWifiOnly,
        "isAutoMode": isAutoMode,
        "supportSilentInstall": supportSilentInstall,
        "params": params,
      };
      final Map resultMap = await _channel.invokeMethod('initXUpdate', map);
      return resultMap;
    } else {
      return null;
    }
  }

  ///检查版本更新
  static Future<Null> checkUpdate({
    ///版本检查的地址
    @required String url,
    ///传递的参数
    Map params,
    ///是否支持后台更新
    bool supportBackgroundUpdate = false,
    ///是否开启自动模式
    bool isAutoMode = false,
    ///版本更新提示器宽度占屏幕的比例, 不设置的话不做约束
    double widthRatio,
    ///版本更新提示器高度占屏幕的比例, 不设置的话不做约束
    double heightRatio
  }) async {
    if (Platform.isAndroid) {
      Map<String, Object> map = {
        "url": url,
        "params": params,
        "supportBackgroundUpdate": supportBackgroundUpdate,
        "isAutoMode": isAutoMode,
        "widthRatio": widthRatio,
        "heightRatio": heightRatio,
      };
      await _channel.invokeMethod('checkUpdate', map);
    }
  }

  ///
  /// 设置出错的接口回调
  ///
  static void setErrorHandler({
    ErrorHandler onUpdateError,
  }) {
    _onUpdateError = onUpdateError;
    _channel.setMethodCallHandler(_handleMethod);
  }

  static Future<Null> _handleMethod(MethodCall call) async {
    switch (call.method) {
      case "onUpdateError":
        return _onUpdateError(call.arguments.cast<String, dynamic>());
      default:
        throw new UnsupportedError("Unrecognized Event");
    }
  }


}
