# flutter_xupdate_example

Demonstrates how to use the flutter_xupdate plugin.

## Demonstration

![演示](./art/demo.gif)

## Screenshot

* Default Update

![](./art/1.png)

* Support Background Update

![](./art/2.png)

* Aspect Ratio Update

![](./art/3.png)

* Force Update

![](./art/4.png)

---

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

### JSON Format

```
{
  "Code": 0, //0代表请求成功，非0代表失败
  "Msg": "", //请求出错的信息
  "UpdateStatus": 1, //0代表不更新，1代表有版本更新，不需要强制升级，2代表有版本更新，需要强制升级
  "VersionCode": 3,
  "VersionName": "1.0.2",
  "ModifyContent": "1、优化api接口。\r\n2、添加使用demo演示。\r\n3、新增自定义更新服务API接口。\r\n4、优化更新提示界面。",
  "DownloadUrl": "https://raw.githubusercontent.com/xuexiangjys/XUpdate/master/apk/xupdate_demo_1.0.2.apk",
  "ApkSize": 2048
  "ApkMd5": "..."  //md5值没有的话，就无法保证apk是否完整，每次都会重新下载。框架默认使用的是md5加密。
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

### Custom JSON Format

1.Setting up a custom update parser

```
FlutterXUpdate.setCustomParseHandler(onUpdateParse: (String json) async {
//Here is the custom JSON parsing
return customParseJson(json);
});

///Resolve the custom JSON content to the UpdateEntity entity class
UpdateEntity customParseJson(String json) {
  AppInfo appInfo = AppInfo.fromJson(json);
  return UpdateEntity(
      hasUpdate: appInfo.hasUpdate,
      isIgnorable: appInfo.isIgnorable,
      versionCode: appInfo.versionCode,
      versionName: appInfo.versionName,
      updateContent: appInfo.updateLog,
      downloadUrl: appInfo.apkUrl,
      apkSize: appInfo.apkSize);
}
```

2.Set the parameter `isCustomParse` to true

```
FlutterXUpdate.checkUpdate(url: _updateUrl3, isCustomParse: true);
```

### Update By UpdateEntity Directly

```
///直接传入UpdateEntity进行更新提示
void checkUpdate8() {
    FlutterXUpdate.updateByInfo(updateEntity: customParseJson(_customJson));
}
```

## Related links

* [XUpdate Android SDK](https://github.com/xuexiangjys/XUpdate)
* [XUpdate Management Service](https://github.com/xuexiangjys/XUpdateService)
* [XUpdate Management System](https://github.com/xuexiangjys/xupdate-management)