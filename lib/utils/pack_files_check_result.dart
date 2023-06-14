import 'dart:typed_data';

import 'package:camp_launcher/model/asset.dart';

//资源包文件校验结果
class PackageFileCheckResult{
  late bool isOk;
  late String message;
  late String packagePath;
  late DiffType diffType;
  List<AssetDiffInfo> assetsDiffInfoList = [];
  PackageFileCheckResult();
}

//资源文件差异信息
class AssetDiffInfo extends Asset{
  //正确的crc32应该是什么
  late int correctCrc32;
  //正确的文件是什么,通常置空
  late Uint8List? correctFileContent;
  //文件差异类型
  late DiffType diffType;
  AssetDiffInfo(Asset? asset){
    if(asset == null) {
      return;
    }
    name = asset.name;
    offset = asset.offset;
    length = asset.length;
    crc32 = asset.crc32;
  }
}

//文件差异的类型
enum DiffType{
  //缺少
  missing,
  //多余
  redundant,
  //crc32不一致
  crc32NotEqual,
  //服务器传过来的crc为空
  crc32FromServerIsNull,
}