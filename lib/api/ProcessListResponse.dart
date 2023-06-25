// namespace wechatServer.Sdk.RequestAndResponse.WebSocket.LauncherClientToLauncherServer;
//
// public class ProcessListResponse : BaseResponse
// {
// }
import 'package:norman_sdk/baseResponse.dart';

class ProcessListResponse extends BaseResponse {
  ProcessListResponse({String? errCode, String? errMsg}) {
  }

  @override
  fill(Map<String, dynamic> json) {
    ErrCode = json['errCode'];
    ErrMsg = json['errMsg'];
  }

  // @override
  // factory ProcessListResponse.fromJson(Map<String, dynamic> json) {
  //   return ProcessListResponse(
  //     json['requestId'],
  //     errCode: json['errCode'],
  //     errMsg: json['errMsg'],
  //   );
  // }
}