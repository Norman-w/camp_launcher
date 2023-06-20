// namespace wechatServer.model.RequestAndResponse;
//
// public class CheckQrCodeRequest
// {
//     public string? RequestId { get; set; }
// }
import 'CheckQrCodeResponse.dart';
import 'package:norman_sdk/baseRequest.dart';

class CheckQrCodeRequest extends BaseRequest<CheckQrCodeResponse> {
  CheckQrCodeRequest();

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = super.toJson();
    //若有其他字段可以像这样添加
    // data['requestId'] = RequestId;
    return data;
  }

  @override
  CheckQrCodeResponse allocResponse() {
    return CheckQrCodeResponse(RequestId);
  }

  // @override
  // allocResponse(Map<String, dynamic>? rspJsonObj) {
  //   return CheckQrCodeResponse.fromJson(rspJsonObj!);
  // }
}