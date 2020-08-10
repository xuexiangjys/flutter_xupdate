import 'dart:convert';

/// 0:无版本更新
const int NO_NEW_VERSION = 0;

/// 1:有版本更新，不需要强制升级
const int HAVE_NEW_VERSION = 1;

/// 2:有版本更新，需要强制升级
const int HAVE_NEW_VERSION_FORCED_UPLOAD = 2;

///
/// 默认网络请求返回的结果格式
///
class UpdateInfo {
  ///请求返回码
  final int code;

  ///请求错误信息
  final String msg;

  ///更新的状态
  final int updateStatus;

  ///最新版本号[根据版本号来判别是否需要升级]
  final int versionCode;

  ///最新APP版本的名称[用于展示的版本名]
  final String versionName;

  ///APP更新时间
  final String uploadTime;

  ///APP变更的内容
  final String modifyContent;

  ///下载地址
  final String downloadUrl;

  ///Apk MD5值
  final String apkMd5;

  ///Apk大小【单位：KB】
  final int apkSize;

  UpdateInfo(
      {this.code,
      this.msg,
      this.updateStatus,
      this.versionCode,
      this.versionName,
      this.uploadTime,
      this.modifyContent,
      this.downloadUrl,
      this.apkMd5,
      this.apkSize});

  Map<String, dynamic> toMap() {
    return {
      'Code': code,
      'Msg': msg,
      'UpdateStatus': updateStatus,
      'VersionCode': versionCode,
      'VersionName': versionName,
      'UploadTime': uploadTime,
      'ModifyContent': modifyContent,
      'DownloadUrl': downloadUrl,
      'ApkMd5': apkMd5,
      'ApkSize': apkSize,
    };
  }

  static UpdateInfo fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UpdateInfo(
        code: map['Code']?.toInt(),
        msg: map['Msg'],
        updateStatus: map['UpdateStatus']?.toInt(),
        versionCode: map['VersionCode']?.toInt(),
        versionName: map['VersionName'],
        uploadTime: map['UploadTime'],
        modifyContent: map['ModifyContent'],
        downloadUrl: map['DownloadUrl'],
        apkMd5: map['ApkMd5'],
        apkSize: map['ApkSize']?.toInt());
  }

  String toJson() => json.encode(toMap());

  static UpdateInfo fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'UpdateInfo Code: $code, Msg: $msg, UpdateStatus: $updateStatus, VersionCode: $versionCode, VersionName: $versionName, UploadTime: $uploadTime, ModifyContent: $modifyContent, DownloadUrl: $downloadUrl, ApkMd5: $apkMd5, ApkSize: $apkSize';
  }
}
