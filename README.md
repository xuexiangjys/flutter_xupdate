# flutter_xupdate

[![Version](https://img.shields.io/badge/version-0.0.1-blue.svg)](https://pub.dev/packages/flutter_xupdate)
[![Build Status](https://travis-ci.org/xuexiangjys/flutter_xupdate.svg?branch=master)](https://travis-ci.org/xuexiangjys/flutter_xupdate)
[![Coverage](https://codecov.io/gh/xuexiangjys/flutter_xupdate/branch/master/graph/badge.svg)](https://codecov.io/gh/xuexiangjys/flutter_xupdate)

A Flutter plugin for Android Version Update.

## Getting Started

You should ensure that you add the `flutter_xupdate` as a dependency in your flutter project.

```
// pub 集成
dependencies:
  flutter_xupdate: ^0.0.1

//github  集成
dependencies:
  flutter_xupdate:
    git:
      url: git://github.com/xuexiangjys/flutter_xupdate.git
      ref: master
```

## Setting up

Modify the Main App Theme to AppCompat，For example:

```
<resources>
    <style name="LaunchTheme" parent="Theme.AppCompat.Light.NoActionBar">
        <item name="android:windowBackground">@drawable/launch_background</item>
    </style>
</resources>
```

## UseCase

### Initialization

```
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

```

### CheckUpdate

```
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
```
