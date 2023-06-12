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

class CheckQrCodeResponse {
  int? errCode;
  String? openId;
  String? sessionKey;
  String? errMsg;
  String? gameStartGuid;

  CheckQrCodeResponse(
      {this.errCode,
      this.openId,
      this.sessionKey,
      this.errMsg,
      this.gameStartGuid});

  CheckQrCodeResponse.fromJson(Map<String, dynamic> json) {
    errCode = json['errCode'];
    openId = json['openId'];
    sessionKey = json['sessionKey'];
    errMsg = json['errMsg'];
    gameStartGuid = json['gameStartGuid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['errCode'] = errCode;
    data['openId'] = openId;
    data['sessionKey'] = sessionKey;
    data['errMsg'] = errMsg;
    data['gameStartGuid'] = gameStartGuid;
    return data;
  }
}
