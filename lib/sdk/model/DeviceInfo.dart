// // ReSharper disable InconsistentNaming
// namespace wechatServer.model;
//
// public class DeviceInfo
// {
//   //主板
//   public string? BaseBoard { get; set; }
// //BIOS
// public string? BIOS { get; set; }
// //CPU
// public string? CPU { get; set; }
// //显卡
// public string? GPU { get; set; }
// //硬盘
// public string? HardDisk { get; set; }
// //内存
// public string? Memory { get; set; }
// //网卡
// public string? NetworkCard { get; set; }
// //操作系统
// public string? OS { get; set; }
// //声卡
// public string? SoundCard { get; set; }
// //显示器
// public string? Monitor { get; set; }
// //USB
// public string? USB { get; set; }
// //其他
// public string? Other { get; set; }
// }
class DeviceInfo {
  String? baseBoard;
  String? bios;
  String? cpu;
  String? gpu;
  String? hardDisk;
  String? memory;
  String? networkCard;
  String? os;
  String? soundCard;
  String? monitor;
  String? usb;
  String? other;

  DeviceInfo({
    this.baseBoard,
    this.bios,
    this.cpu,
    this.gpu,
    this.hardDisk,
    this.memory,
    this.networkCard,
    this.os,
    this.soundCard,
    this.monitor,
    this.usb,
    this.other,
  });

  DeviceInfo.fromJson(Map<String, dynamic> json) {
    baseBoard = json['baseBoard'];
    bios = json['bios'];
    cpu = json['cpu'];
    gpu = json['gpu'];
    hardDisk = json['hardDisk'];
    memory = json['memory'];
    networkCard = json['networkCard'];
    os = json['os'];
    soundCard = json['soundCard'];
    monitor = json['monitor'];
    usb = json['usb'];
    other = json['other'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['baseBoard'] = this.baseBoard;
    data['bios'] = this.bios;
    data['cpu'] = this.cpu;
    data['gpu'] = this.gpu;
    data['hardDisk'] = this.hardDisk;
    data['memory'] = this.memory;
    data['networkCard'] = this.networkCard;
    data['os'] = this.os;
    data['soundCard'] = this.soundCard;
    data['monitor'] = this.monitor;
    data['usb'] = this.usb;
    data['other'] = this.other;
    return data;
  }
}