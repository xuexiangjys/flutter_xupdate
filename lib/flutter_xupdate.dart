import 'dart:async';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'update_entity.dart';
import 'update_info.dart';
export 'update_entity.dart';
export 'update_info.dart';

typedef ErrorHandler = Future<dynamic> Function(Map<String, dynamic>? event);
typedef ParseHandler = Future<UpdateEntity> Function(String? json);

///Android全量更新插件
class FlutterXUpdate {
  static ErrorHandler? _onUpdateError;
  static ParseHandler? _onUpdateParse;

  FlutterXUpdate._();

  static const MethodChannel _channel =
      MethodChannel('com.xuexiang/flutter_xupdate');

  ///初始化插件(Android Only)
  static Future<Map?> init(
      {

      ///是否输出日志
      bool debug = false,

      ///是否使用post请求
      bool isPost = false,

      ///post请求是否是上传json
      bool isPostJson = false,

      ///请求超时响应时间(单位:毫秒)
      int timeout = 20000,

      ///是否只在wifi下才能进行更新
      bool isWifiOnly = true,

      ///是否开启自动模式
      bool isAutoMode = false,

      ///是否支持静默安装，这个需要设备有root权限
      bool supportSilentInstall = false,

      ///在下载过程中，如果点击了取消的话，是否弹出切换下载方式的重试提示弹窗
      bool enableRetry = false,

      ///重试提示弹窗的提示内容
      String retryContent = '',

      ///重试提示弹窗点击后跳转的url
      String retryUrl = '',

      ///需要设置的公共参数
      Map? params}) async {
    if (Platform.isAndroid) {
      final Map<String, Object?> map = {
        'debug': debug,
        'isGet': !isPost,
        'isPostJson': isPostJson,
        'timeout': timeout,
        'isWifiOnly': isWifiOnly,
        'isAutoMode': isAutoMode,
        'supportSilentInstall': supportSilentInstall,
        'enableRetry': enableRetry,
        'retryContent': retryContent,
        'retryUrl': retryUrl,
        'params': params,
      };
      final Map? resultMap = await _channel.invokeMethod('initXUpdate', map);
      return resultMap;
    } else {
      return null;
    }
  }

  ///检查版本更新(Android Only)
  static Future<Null> checkUpdate(
      {

      ///版本检查的地址
      required String url,

      ///传递的参数
      Map? params,

      ///是否支持后台更新
      bool supportBackgroundUpdate = false,

      ///是否开启自动模式
      bool isAutoMode = false,

      ///是否是自定义解析协议
      bool isCustomParse = false,

      ///应用弹窗的主题色
      String themeColor = '',

      ///应用弹窗的顶部图片资源名
      String topImageRes = '',

      ///按钮文字的颜色
      String buttonTextColor = '',

      ///版本更新提示器宽度占屏幕的比例, 不设置的话不做约束
      double? widthRatio,

      ///版本更新提示器高度占屏幕的比例, 不设置的话不做约束
      double? heightRatio,

      ///是否覆盖全局的重试策略
      bool overrideGlobalRetryStrategy = false,

      ///在下载过程中，如果点击了取消的话，是否弹出切换下载方式的重试提示弹窗
      bool enableRetry = false,

      ///重试提示弹窗的提示内容
      String retryContent = '',

      ///重试提示弹窗点击后跳转的url
      String retryUrl = ''}) async {
    assert(Platform.isAndroid);

    final Map<String, Object?> map = {
      'url': url,
      'params': params,
      'supportBackgroundUpdate': supportBackgroundUpdate,
      'isAutoMode': isAutoMode,
      'isCustomParse': isCustomParse,
      'themeColor': themeColor,
      'topImageRes': topImageRes,
      'buttonTextColor': buttonTextColor,
      'widthRatio': widthRatio,
      'heightRatio': heightRatio,
      'overrideGlobalRetryStrategy': overrideGlobalRetryStrategy,
      'enableRetry': enableRetry,
      'retryContent': retryContent,
      'retryUrl': retryUrl,
    };
    await _channel.invokeMethod('checkUpdate', map);
  }

  ///检查版本更新(Android Only)
  static Future<Null> updateByInfo(
      {required UpdateEntity updateEntity,

      ///是否支持后台更新
      bool supportBackgroundUpdate = false,

      ///是否开启自动模式
      bool isAutoMode = false,

      ///应用弹窗的主题色
      String themeColor = '',

      ///应用弹窗的顶部图片资源名
      String topImageRes = '',

      ///按钮文字的颜色
      String buttonTextColor = '',

      ///版本更新提示器宽度占屏幕的比例, 不设置的话不做约束
      double? widthRatio,

      ///版本更新提示器高度占屏幕的比例, 不设置的话不做约束
      double? heightRatio,

      ///是否覆盖全局的重试策略
      bool overrideGlobalRetryStrategy = false,

      ///在下载过程中，如果点击了取消的话，是否弹出切换下载方式的重试提示弹窗
      bool enableRetry = false,

      ///重试提示弹窗的提示内容
      String retryContent = '',

      ///重试提示弹窗点击后跳转的url
      String retryUrl = ''}) async {
    assert(Platform.isAndroid);

    final Map<String, Object?> map = {
      'updateEntity': updateEntity.toMap(),
      'supportBackgroundUpdate': supportBackgroundUpdate,
      'isAutoMode': isAutoMode,
      'themeColor': themeColor,
      'topImageRes': topImageRes,
      'buttonTextColor': buttonTextColor,
      'widthRatio': widthRatio,
      'heightRatio': heightRatio,
      'overrideGlobalRetryStrategy': overrideGlobalRetryStrategy,
      'enableRetry': enableRetry,
      'retryContent': retryContent,
      'retryUrl': retryUrl,
    };
    await _channel.invokeMethod('updateByInfo', map);
  }

  ///
  /// 设置出错的接口回调(Android Only)
  /// 返回内容 {
  ///   code：错误码
  ///   message：错误信息
  ///   detailMsg：错误详细信息
  /// }
  static void setErrorHandler({
    ErrorHandler? onUpdateError,
  }) {
    _onUpdateError = onUpdateError;
    _channel.setMethodCallHandler(_handleMethod);
  }

  /// 设置自定义解析json的接口(Android Only)
  static void setCustomParseHandler({
    ParseHandler? onUpdateParse,
  }) {
    _onUpdateParse = onUpdateParse;
    _channel.setMethodCallHandler(_handleMethod);
  }

  /// 设置版本更新的回调接口(Android Only)
  static void setUpdateHandler({
    ErrorHandler? onUpdateError,
    ParseHandler? onUpdateParse,
  }) {
    _onUpdateError = onUpdateError;
    _onUpdateParse = onUpdateParse;
    _channel.setMethodCallHandler(_handleMethod);
  }

  static Future _handleMethod(MethodCall call) async {
    switch (call.method) {
      case 'onUpdateError':
        return _onUpdateError!(call.arguments.cast<String, dynamic>());
      case 'onCustomUpdateParse':
        final UpdateEntity updateEntity = await _onUpdateParse!(
            call.arguments.cast<String, dynamic>()['update_json']);
        return updateEntity.toMap();
      default:
        throw UnsupportedError('Unrecognized Event');
    }
  }

  ///显示重试提示弹窗(Android Only)
  static Future<Null> showRetryUpdateTipDialog(
      {

      ///重试提示弹窗的提示内容
      String retryContent = '',

      ///重试提示弹窗点击后跳转的url
      required String retryUrl}) async {
    assert(Platform.isAndroid);

    final Map<String, Object> map = {
      'retryContent': retryContent,
      'retryUrl': retryUrl,
    };
    await _channel.invokeMethod('showRetryUpdateTipDialog', map);
  }

  ///默认的版本更新检查返回JsonFormat的解析方法
  static Future<UpdateEntity?> defaultUpdateParser(String json) async {
    final UpdateInfo? updateInfo = UpdateInfo.fromJson(json);
    if (updateInfo == null || updateInfo.code != 0) {
      return null;
    }

    //进行二次校验
    bool hasUpdate = updateInfo.updateStatus != NO_NEW_VERSION;
    if (hasUpdate) {
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      //服务器返回的最新版本小于等于现在的版本，不需要更新
      if (updateInfo.versionCode! <= int.parse(packageInfo.buildNumber)) {
        hasUpdate = false;
      }
    }

    return UpdateEntity(
        hasUpdate: hasUpdate,
        isForce: updateInfo.updateStatus == HAVE_NEW_VERSION_FORCED_UPLOAD,
        versionCode: updateInfo.versionCode,
        versionName: updateInfo.versionName,
        updateContent: updateInfo.modifyContent,
        downloadUrl: updateInfo.downloadUrl,
        apkSize: updateInfo.apkSize,
        apkMd5: updateInfo.apkMd5);
  }
}
