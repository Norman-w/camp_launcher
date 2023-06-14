import 'dart:io';
import 'dart:typed_data';

import 'package:camp_launcher/model/pack_file.dart';
import 'package:flutter/material.dart';

import '../model/asset.dart';
import 'pack_files_check_result.dart';
//检查当前进程所在目录
get currentPath => Directory.current.path;
//获取当前路径下的所有文件的目录树
List<FileSystemEntity> get currentFiles => Directory.current.listSync(recursive: true);
//要校验的相对路径+文件名+扩展名 所对应的crc32值
Map<String, int> get crc32Map => {
  //2个mock数据
  'assets/AssetManifest.json': 0x0,
  'assets/NOTICES': 0x0,
};
//校验文件完整性
List<PackageFileCheckResult> checkFileIntegrity() {
  //检查结果
  List<PackageFileCheckResult> result = [];
  //遍历所有文件
  for (var file in currentFiles) {
    //如果是文件
    if (file is File) {
      //获取相对路径
      var relativePath = file.path.replaceAll(currentPath, '');
      //防止map中没有这个key
      if (!crc32Map.containsKey(relativePath)) {
        ///多出来的文件
        PackageFileCheckResult diffInfo = PackageFileCheckResult();
        diffInfo.diffType = DiffType.redundant;
        diffInfo.packagePath = relativePath;
        diffInfo.message = 'D';//多出来的文件 duplicated
        diffInfo.isOk = false;
        result.add(diffInfo);
        continue;
      }
      //获取crc32值
      var crc32 = crc32Map[relativePath];
      //如果crc32值不为空
      if (crc32 != null) {
        //读取文件内容
        // var content = file.readAsStringSync();
        List<int> content = file.readAsBytesSync();
        //计算crc32值
        var crc32Value =  CRC32Helper().getCRC32Bytes(content);
        //如果crc32值不一致
        if (crc32Value != crc32) {
          ///校验不一致的文件
          PackageFileCheckResult diffInfo = PackageFileCheckResult();
          diffInfo.diffType = DiffType.crc32NotEqual;
          diffInfo.packagePath = relativePath;
          diffInfo.message = 'F';//文件校验问题
          diffInfo.isOk = false;
          result.add(diffInfo);
        }
      }
      //给进来的crc32就为空.这通常是服务端问题导致的
      else{
        //添加到差异列表
        PackageFileCheckResult diffInfo = PackageFileCheckResult();
        diffInfo.diffType = DiffType.crc32NotEqual;
        diffInfo.packagePath = relativePath;
        diffInfo.message = 'S P C E';//服务器传递过来的CRC32为空
        diffInfo.isOk = false;
        result.add(diffInfo);
      }
    }
  }
  //验证crc32Map有但是本地没有读取到的,这样的就是本地少的
  for (var key in crc32Map.keys) {
    //如果本地没有这个文件
    if (!currentFiles.any((element) => element.path.replaceAll(currentPath, '') == key)) {
      ///远程有本地没有的文件
      PackageFileCheckResult diffInfo = PackageFileCheckResult();
      diffInfo.diffType = DiffType.missing;
      diffInfo.packagePath = key;
      diffInfo.message = 'M';//missing
      diffInfo.isOk = false;
      result.add(diffInfo);
    }
  }
  //返回结果
  return result;
}
class PackFileChecker{
  // public PackFile LoadPackFile(string packFilePath)
  // {
  //   if (!File.Exists(packFilePath))
  //   {
  //     Console.WriteLine("包件{0}不存在", packFilePath);
  //     return null;
  //   }
  //
  //   PackFile packFile = new PackFile();
  //   packFile.PackFileFullName = System.IO.Path.GetFullPath(packFilePath);
  //   FileStream fs = new FileStream(packFilePath, FileMode.Open, FileAccess.Read, FileShare.ReadWrite);
  //   BinaryReader br = new BinaryReader(fs);
  //   int nextOffset = 0;
  //   do
  //   {
  //     nextOffset = ReadInt32BE(br);
  //     int assetsCount = ReadInt32BE(br);
  //     for (int i = 0; i < assetsCount; i++)
  //     {
  //       Asset asset = new Asset();
  //       var nameLength = ReadUint32BE(br);
  //       asset.Name = ReadString(br, (int)nameLength);
  //       asset.Offset = ReadUint32BE(br);
  //       asset.Length = ReadUint32BE(br);
  //       asset.CRC32 = ReadUint32BE(br);
  //       packFile.Assets.Add(asset.Name, asset);
  //     }
  //
  //     foreach (var current in packFile.Assets)
  //     {
  //       fs.Seek(current.Value.Offset, SeekOrigin.Begin);
  //       var assetFileContent = new List<byte>();
  //       for (int i = 0; i < current.Value.Length; i++)
  //       {
  //         assetFileContent.Add((byte)fs.ReadByte());
  // }
  //
  //   current.Value.FileContent = assetFileContent.ToArray();
  // }
  //
  // fs.Seek(nextOffset, SeekOrigin.Begin);
  // } while (nextOffset != 0);
  //
  //   return packFile;
  // }
  PackFile? loadPackFile(String packFilePath){

    // private int ReadInt32BE(BinaryReader br)
    // {
    //   var bytes = br.ReadBytes(4);
    //   Array.Reverse(bytes);
    //   return BitConverter.ToInt32(bytes,0);
    // }
    int readInt32BE(List<int> bytes){
      bytes = bytes.reversed.toList();
      return bytes[0] << 24 | bytes[1] << 16 | bytes[2] << 8 | bytes[3];
    }
    // private uint ReadUint32BE(BinaryReader br)
    // {
    //   var bytes = br.ReadBytes(4);
    //   Array.Reverse(bytes);
    //   return BitConverter.ToUInt32(bytes,0);
    // }
    int readUint32BE(List<int> bytes){
      bytes = bytes.reversed.toList();
      return bytes[0] << 24 | bytes[1] << 16 | bytes[2] << 8 | bytes[3];
    }
    // private string ReadString(BinaryReader br, int length)
    // {
    //   var bytes = br.ReadBytes(length);
    //   // return Convert.ToString(bytes);
    //   return Encoding.UTF8.GetString(bytes);
    // }
    String readString(List<int> bytes, int length) {
      return String.fromCharCodes(bytes);
    }
    if(!File(packFilePath).existsSync()){
      debugPrint('包文件$packFilePath不存在');
      return null;
    }
    PackFile packFile = PackFile();
    packFile.packFileFullName = File(packFilePath).absolute.path;
    var fs = File(packFilePath).openSync(mode: FileMode.read);
    var needReadCount = fs.lengthSync();
    var br = fs.readSync(needReadCount);
    var nextOffset = 0;
    do{
      nextOffset = readInt32BE(br);
      var assetsCount = readInt32BE(br);
      for(var i = 0; i < assetsCount; i++){
        var asset = Asset();
        var nameLength = readUint32BE(br);
        asset.name = readString(br, nameLength);
        asset.offset = readUint32BE(br);
        asset.length = readUint32BE(br);
        asset.crc32 = readUint32BE(br);
        packFile.assets[asset.name] = asset;
      }for(var current in packFile.assets.entries){
        fs.setPositionSync(current.value.offset);
        var assetFileContent = <int>[];
        for(var i = 0; i < current.value.length; i++){
          assetFileContent.add(fs.readByteSync());
        }
        //convert to uint8list
        var uint8List = Uint8List.fromList(assetFileContent);
        current.value.fileContent = uint8List;
      }
      fs.setPositionSync(nextOffset);
    }while(nextOffset != 0);
    return packFile;
  }
}

//
//
// class CRC32Cls
// {
//   protected ulong[] Crc32Table;
//   //生成CRC32码表
//   public void GetCRC32Table()
//   {
//     ulong Crc;
//     Crc32Table = new ulong[256];
//     int i,j;
//     for(i = 0;i < 256; i++)
//     {
//       Crc = (ulong)i;
//       for (j = 8; j > 0; j--)
//       {
//         if ((Crc & 1) == 1)
//           Crc = (Crc >> 1) ^ 0xEDB88320;
//         else
//           Crc >>= 1;
//       }
//       Crc32Table[i] = Crc;
//     }
//   }
//
//   //获取字符串的CRC32校验值
//   public ulong GetCRC32Str(string sInputString)
//   {
//     //生成码表
//     GetCRC32Table();
//     byte[] buffer = System.Text.ASCIIEncoding.ASCII.GetBytes(sInputString);
//     ulong value = 0xffffffff;
//     int len = buffer.Length;
//     for (int i = 0; i < len; i++)
//     {
//       value = (value >> 8) ^ Crc32Table[(value & 0xFF)^ buffer[i]];
//     }
//     return value ^ 0xffffffff;
//   }
//   public ulong GetCRC32Str(byte[] bytes)
//   {
//   //生成码表
//   GetCRC32Table();
//   byte[] buffer = bytes;
//   ulong value = 0xffffffff;
//   int len = buffer.Length;
//   for (int i = 0; i < len; i++)
//   {
//   value = (value >> 8) ^ Crc32Table[(value & 0xFF)^ buffer[i]];
//   }
//   return value ^ 0xffffffff;
//   }
// }

///crc32,原名CRC32Cls
class CRC32Helper{
  final List<int> _crc32Table = [];
  static final CRC32Helper _crc32Cls = CRC32Helper._internal();
  factory CRC32Helper(){
    return _crc32Cls;
  }
  CRC32Helper._internal(){
    _getCRC32Table();
  }

  void _getCRC32Table(){
    for(var i = 0; i < 256; i++){
      var crc = i;
      for(var j = 8; j > 0; j--){
        if((crc & 1) == 1){
          crc = (crc >> 1) ^ 0xEDB88320;
        }else{
          crc >>= 1;
        }
      }
      _crc32Table.add(crc);
    }
  }
  // int getCRC32Str(String sInputString){
  //   var buffer = sInputString.codeUnits;
  //   var value = 0xffffffff;
  //   var len = buffer.length;
  //   for(var i = 0; i < len; i++){
  //     value = (value >> 8) ^ crc32Table[(value & 0xFF) ^ buffer[i]];
  //   }
  //   return value ^ 0xffffffff;
  // }
  int getCRC32Bytes(List<int> bytes){
    var buffer = bytes;
    var value = 0xffffffff;
    var len = buffer.length;
    for(var i = 0; i < len; i++){
      value = (value >> 8) ^ _crc32Table[(value & 0xFF) ^ buffer[i]];
    }
    return value ^ 0xffffffff;
  }
}