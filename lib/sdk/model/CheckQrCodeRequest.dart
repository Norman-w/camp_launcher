// namespace wechatServer.model.RequestAndResponse;
//
// public class CheckQrCodeRequest
// {
//     public string? RequestId { get; set; }
// }
class CheckQrCodeRequest {
  String? requestId;

  CheckQrCodeRequest({this.requestId});

  CheckQrCodeRequest.fromJson(Map<String, dynamic> json) {
    requestId = json['requestId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['requestId'] = requestId;
    return data;
  }
}