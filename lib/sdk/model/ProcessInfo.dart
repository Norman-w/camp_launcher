// namespace wechatServer.model;
//
// public class ProcessInfo
// {
//   //进程名
//   public string? ProcessName { get; set; }
// //进程路径
// public string? ProcessPath { get; set; }
// //进程ID
// public string? ProcessId { get; set; }
// //进程描述
// public string? ProcessDescription { get; set; }
// }

class ProcessInfo {
  String? processName;
  String? processPath;
  String? processId;
  String? processDescription;

  ProcessInfo({
    this.processName,
    this.processPath,
    this.processId,
    this.processDescription,
  });

  ProcessInfo.fromJson(Map<String, dynamic> json) {
    processName = json['processName'];
    processPath = json['processPath'];
    processId = json['processId'];
    processDescription = json['processDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['processName'] = this.processName;
    data['processPath'] = this.processPath;
    data['processId'] = this.processId;
    data['processDescription'] = this.processDescription;
    return data;
  }
}