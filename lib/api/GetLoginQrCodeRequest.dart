// namespace wechatServer.model.RequestAndResponse;
//
// public class GetLoginQrCodeRequest
// {
//   //请求的Id,这个值由客户端负责生成
//   public string? ClientSideRequestId { get; set; }
//   //所在的公网IP地址,这个在客户端获取不到,但是可以在请求这边服务器的时候获取到,获取后设置到这个字段
//   public string? PublicIp { get; set; }
//   //sceneId,这个值由服务端负责生成
//   //设备信息
//   public DeviceInfo? DeviceInfo { get; set; }
//   //进程列表
//   public List<ProcessInfo>? ProcessList { get; set; }
//   //玩家信息
//   public PlayerInfo? PlayerInfo { get; set; }
//   //登录时间
//   public DateTime? LoginTime { get; set; }
// }

//根据如上C#类生成的dart代码:
import 'package:camp_launcher/api/GetLoginQrCodeResponse.dart';

import 'model/DeviceInfo.dart';
import 'model/PlayerInfo.dart';
import 'model/ProcessInfo.dart';
import 'package:norman_sdk/BaseRequest.dart';

class GetLoginQrCodeRequest extends BaseRequest<GetLoginQRCodeResponse>{
  String? clientSideRequestId;
  String? publicIp;
  DeviceInfo? deviceInfo;
  List<ProcessInfo>? processList;
  PlayerInfo? playerInfo;
  DateTime? loginTime;

  GetLoginQrCodeRequest({
    this.clientSideRequestId,
    this.publicIp,
    this.deviceInfo,
    this.processList,
    this.playerInfo,
    this.loginTime,
  });

  GetLoginQrCodeRequest.fromJson(Map<String, dynamic> json) {
    clientSideRequestId = json['clientSideRequestId'];
    publicIp = json['publicIp'];
    deviceInfo = json['deviceInfo'] != null
        ? DeviceInfo.fromJson(json['deviceInfo'])
        : null;
    if (json['processList'] != null) {
      processList = <ProcessInfo>[];
      json['processList'].forEach((v) {
        processList!.add(ProcessInfo.fromJson(v));
      });
    }
    playerInfo = json['playerInfo'] != null
        ? PlayerInfo.fromJson(json['playerInfo'])
        : null;
    loginTime = json['loginTime'] != null
        ? DateTime.fromMillisecondsSinceEpoch(json['loginTime'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['clientSideRequestId'] = clientSideRequestId;
    data['publicIp'] = publicIp;
    if (deviceInfo != null) {
      data['deviceInfo'] = deviceInfo!.toJson();
    }
    if (processList != null) {
      data['processList'] = processList!.map((v) => v.toJson()).toList();
    }
    if (playerInfo != null) {
      data['playerInfo'] = playerInfo!.toJson();
    }
    data['loginTime'] = loginTime?.millisecondsSinceEpoch;
    return data;
  }

  @override
  allocResponse(Map<String, dynamic>? rspJsonObj) {
    return GetLoginQRCodeResponse.fromJson(rspJsonObj);
  }
}