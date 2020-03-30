import 'dart:convert';

import 'package:flutter/cupertino.dart';

///
/// 版本更新信息，用于显示版本更新弹窗
///
class UpdateEntity {
  //===========是否可以升级=============//

  ///是否有新版本
  final bool hasUpdate;

  ///是否强制安装：不安装无法使用app
  final bool isForce;

  ///是否可忽略该版本
  final bool isIgnorable;

  //===========升级的信息=============//

  ///版本号
  final int versionCode;

  ///版本名称
  final String versionName;

  ///更新内容
  final String updateContent;

  ///下载地址
  final String downloadUrl;

  ///apk的大小
  final int apkSize;

  ///apk文件的加密值（这里默认是md5值）
  final String apkMd5;

  UpdateEntity({
    @required this.hasUpdate,
    this.isForce,
    this.isIgnorable,
    @required this.versionCode,
    @required this.versionName,
    @required this.updateContent,
    @required this.downloadUrl,
    this.apkSize,
    this.apkMd5,
  });

  Map<String, dynamic> toMap() {
    return {
      'hasUpdate': hasUpdate,
      'isForce': isForce,
      'isIgnorable': isIgnorable,
      'versionCode': versionCode,
      'versionName': versionName,
      'updateContent': updateContent,
      'downloadUrl': downloadUrl,
      'apkSize': apkSize,
      'apkMd5': apkMd5,
    };
  }

  static UpdateEntity fromMap(Map<String, dynamic> map) {
    if (map == null) return null;

    return UpdateEntity(
      hasUpdate: map['hasUpdate'],
      isForce: map['isForce'],
      isIgnorable: map['isIgnorable'],
      versionCode: map['versionCode']?.toInt(),
      versionName: map['versionName'],
      updateContent: map['updateContent'],
      downloadUrl: map['downloadUrl'],
      apkSize: map['apkSize']?.toInt(),
      apkMd5: map['apkMd5'],
    );
  }

  String toJson() => json.encode(toMap());

  static UpdateEntity fromJson(String source) => fromMap(json.decode(source));

  @override
  String toString() {
    return 'UpdateEntity hasUpdate: $hasUpdate, isForce: $isForce, isIgnorable: $isIgnorable, versionCode: $versionCode, versionName: $versionName, updateContent: $updateContent, downloadUrl: $downloadUrl, apkSize: $apkSize, apkMd5: $apkMd5';
  }
}
