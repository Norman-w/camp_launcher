// // ReSharper disable IdentifierTypo
//
// namespace wechatServer.model.RequestAndResponse;
//
// // ReSharper disable InconsistentNaming
// /// <summary>
// /// 二维码记录值
// /// </summary>
// public class GetLoginQRCodeResponse
// {
//   /// <summary>
//   /// 客户端生成的请求ID,后期可以用这个ID进行查询二维码的状态
//   /// </summary>
//   public string? RequestId { get; set; }
//
// /// <summary>
// /// 错误码
// /// </summary>
// public int? ErrCode { get; set; }
//
// /// <summary>
// /// 错误信息
// /// </summary>
// public string? ErrMsg { get; set; }
//
// /// <summary>
// /// 二维码图片的Ticket可以根据这个参数进行拼接url以获取二维码图片
// /// </summary>
// public string? Ticket { get; set; }
//
// /// <summary>
// /// 二维码的到期时间
// /// </summary>
// public DateTime ExpireTime { get; set; }
// }

class GetLoginQRCodeResponse {
  String? requestId;
  int? errCode;
  String? errMsg;
  String? ticket;
  DateTime? expireTime;

  GetLoginQRCodeResponse(
      {this.requestId,
      this.errCode,
      this.errMsg,
      this.ticket,
      this.expireTime});

  GetLoginQRCodeResponse.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
    errCode = json['errCode'];
    errMsg = json['errMsg'];
    ticket = json['ticket'];
    expireTime = json['expireTime'] == null
        ? null
        : DateTime.parse(json['expireTime']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestId'] = requestId;
    data['errCode'] = errCode;
    data['errMsg'] = errMsg;
    data['ticket'] = ticket;
    data['expireTime'] = expireTime?.toUtc().toString();
    return data;
  }
}