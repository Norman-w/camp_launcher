// namespace H1Z1PackTool;
//
// public class Asset
// {
//   public string Name { get; set; }
// public uint Offset { get; set; }
// public uint Length { get; set; }
//
// public uint CRC32 { get; set; }
// public byte[] FileContent { get; set; }
// }

import 'dart:typed_data';

class Asset{
  late String name;
  late int offset;
  late int length;
  late int crc32;
  late Uint8List fileContent;
}