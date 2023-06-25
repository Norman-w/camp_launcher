// using wechatServer.model;
//
// namespace wechatServer.Sdk.RequestAndResponse.WebSocket.LauncherClientToLauncherServer;
//
// /// <summary>
// /// 游戏登录器向游戏登录服务器上报进程列表
// /// </summary>
// public class ProcessListRequest : BaseRequest<ProcessListResponse>
// {
// public List<ProcessInfo> ProcessList { get; set; } = new List<ProcessInfo>();
// }
import './model/ProcessInfo.dart';
import 'package:norman_sdk/baseRequest.dart';

import 'ProcessListResponse.dart';

class ProcessListRequest extends BaseRequest<ProcessListResponse> {
  List<ProcessInfo>? processList;

  @override
  String getApiName() {
    return 'process.list';
  }

  @override
  allocResponse() {
    return ProcessListResponse();
  }

  @override
  Map<String, dynamic> toJson() {
    Map<String, dynamic> data = {};
    data['processList'] = processList;
    return data;
  }
}