// namespace H1Z1PackTool;
//
// public class PackFile
// {
//   private string _packFileFullName = "";
//   public string PackFileFullName
//   {
//   get { return _packFileFullName;}
//   set { _packFileFullName = value; }
// }
//
// public string PackFileName
// {
// get
// {
// return System.IO.Path.GetFileNameWithoutExtension(this._packFileFullName);
// }
// }
//
// public string PackFileDir
// {
// get
// {
// return System.IO.Path.GetDirectoryName(this._packFileFullName);
// } }
// private Dictionary<string, Asset> _assets = new Dictionary<string, Asset>();
// public int AssetCount
// {
// get { return this._assets.Count; }
// }
// public Dictionary<string,Asset> Assets
// {
// get { return _assets;}
// }
//
// public long ByteCount { get; set; }
//
// public int AssetGroupCount { get; set; }
//
// /// <summary>
// /// 文件头信息,包含 文件头便宜位, 包内文件数量 [{文件名长,文件名,偏移,长度,crc32},...]
// /// 可根据文件头的长度分配assets文件的具体开头位置(为了pack文件正在二进制编辑时的可读性,美观性)
// /// </summary>
// public byte[] Header { get; set; }
// }
import 'asset.dart';
class PackFile{
  String _packFileFullName = '';
  String get packFileFullName => _packFileFullName;
  set packFileFullName(String value) => _packFileFullName = value;
  String get packFileName => packFileFullName.split('/').last.split('.').first;
  String get packFileDir => packFileFullName.split('/').last.split('.').first;
  Map<String, Asset> _assets = {};
  int get assetCount => _assets.length;
  Map<String, Asset> get assets => _assets;
  set assets(Map<String, Asset> value) => _assets = value;
  int byteCount = 0;
  int assetGroupCount = 0;
  List<int> header = [];
}
