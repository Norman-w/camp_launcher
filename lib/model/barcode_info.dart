//微信的带参数二维码返回结果类,根据如下cs代码生成:
// namespace wechatServer.helper;
//
// public class GetQRCodeResponse
// {
//   //{"errcode":41001,"errmsg":"access_token missing rid: 6453c179-24bd1a5e-5d9c3530"}
//   /// <summary>
//   /// 生成的二维码ticket，凭借此ticket可以在有效时间内换取二维码。
//   /// </summary>
//   public string ticket { get; set; } = "";
// /// <summary>
// /// 二维码的有效时间，以秒为单位
// /// </summary>
// public int expire_seconds { get; set; } = 0;
// /// <summary>
// /// 二维码图片解析后的地址，开发者可根据该地址自行生成需要的二维码图片
// /// </summary>
// public string url { get; set; } = "";
// /// <summary>
// /// 错误码
// /// </summary>
// public int errcode { get; set; } = 0;
// /// <summary>
// /// 错误信息
// /// </summary>
// public string errmsg { get; set; } = "";
// /// <summary>
// /// 二维码参数
// /// </summary>
// public string scene_id { get; set; }
// /// <summary>
// /// 二维码地址,可访问此地址直接获取二维码的图片
// /// </summary>
// public string qrCodeUrl { get; set; }
// }


//调用api示例:
// https://localhost:7028/Common?appid=wx36a686b7ef67052f&appsecret=4fb6760edb40e0c48f0d9829ca4ceaa2&sceneid=1

//region 导入需要的库
//endregion

//region 类定义
/// 二维码自动刷新显示器
/// 从服务端获取微信生成的带参数二维码信息,请求微信地址获取二维码图片显示到组件上,并且根据数据自动执行倒计时.
/// 倒计时时间到了以后重新获取二维码并执行上述步骤,周而复始.
class GetQRCodeResponse {
  /// 生成的二维码ticket，凭借此ticket可以在有效时间内换取二维码。
  String ticket = "";

  /// 二维码的有效时间，以秒为单位
  int expireSeconds = 0;

  /// 二维码图片解析后的地址，开发者可根据该地址自行生成需要的二维码图片
  String url = "";

  /// 错误码
  int errCode = 0;

  /// 错误信息
  String errMsg = "";

  /// 二维码参数
  String sceneId = "";

  /// 二维码地址,可访问此地址直接获取二维码的图片
  String qrCodeUrl = "";
}