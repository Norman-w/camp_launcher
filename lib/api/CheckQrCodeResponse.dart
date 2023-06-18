// namespace wechatServer.model.RequestAndResponse;
//
// public class CheckQrCodeResponse
// {
//   public int? ErrCode { get; set; }
//
// public string? OpenId { get; set; }
//
// // public string? NickName { get; set; }
// //
// // public string? HeadImgUrl { get; set; }
// //
// // public string? UnionId { get; set; }
//
// public string? SessionKey { get; set; }
//
// public string? ErrMsg { get; set; }
//
// public string? GameStartGuid { get; set; }
// }

import 'package:norman_sdk/BaseResponse.dart';

class CheckQrCodeResponse extends BaseResponse {
  String? openId;
  String? sessionKey;
  String? gameStartGuid;

  CheckQrCodeResponse(String? requestId,
      {this.openId, this.sessionKey, this.gameStartGuid, String? errCode, String? errMsg}) {
    super.ErrCode = errCode;
    super.ErrMsg = errMsg;
    super.RequestId = requestId;
  }

  @override
  factory CheckQrCodeResponse.fromJson(Map<String, dynamic> json) {
    return CheckQrCodeResponse(
      json['requestId'],
      openId: json['openId'],
      sessionKey: json['sessionKey'],
      gameStartGuid: json['gameStartGuid'],
      errCode: json['errCode'],
      errMsg: json['errMsg'],
    );
  }
}
