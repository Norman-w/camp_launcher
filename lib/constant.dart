//可以从全局任意一个地方访问的全局变量

class  Constant {
  //正式环境服务器地址
  static const String _serverUrlProd = "https://camp.norman.wang";
  //测试环境服务器地址
  static const String _serverUrlTest = "https://localhost:7028";
  //当前服务器地址,如果是正式环境,则使用正式环境地址,否则使用测试环境地址
  static const String serverUrl = _serverUrlProd;

  //api路径
  static const String serverUrlApi = "$serverUrl/Common";

  //心跳包上报路径
  static const String serverUrlHeartbeat = "$serverUrlApi/heartbeat";

  //websocket路径
  static const String serverUrlWebSocket = "$serverUrlApi/websocket";

  //获取二维码路径
  static const String serverUrlGetQRCode = "$serverUrlApi/getLoginQrCode";
  // static const String serverUrlGetQRCode = "http://camp.norman.wang/wechat/login/qrcode";

  //获取二维码的超时时间毫秒
  static const int serverUrlGetQRCodeTimeoutMS = 3000;

  //二维码图片的大小
  static const double qrCodeSize = 200;

  //验证登录接口路径
  static const String serverUrlCheckQrCodeScan = "$serverUrlApi/CheckLoginQrCode";
  // static const String serverUrlCheckQrCodeScan = "http://camp.norman.wang/wechat/wxLogin";

  //从游戏启动到检测到进程的超时时间
  static const int gameStartToDetectProcessTimeoutMS = 10000;

  //根据ticket获取微信二维码时的url前缀
  static const String wechatQrCodeGettingWithTicketUrlPrefix = "https://mp.weixin.qq.com/cgi-bin/showqrcode?ticket=";
}


//region 用枚举代替a-z A-Z 字母,让逆向工程更难
enum EnumChar{
  //以错乱的顺序排列,不使用 a b c d e 这样的顺序
  //小写
  n, a, z, b, y, c, x, d, w, e, v, f, u, g, t, h, s, i, r, j, q, k, p, l, o, m,
  //大写
  M, A, Z, B, Y, C, X, D, W, E, V, F, U, G, T, H, S, I, R, J, Q, K, P, L, O, N,
}
//给定一个枚举的数组,把数组中的每个枚举值转换为对应的字符,并返回一个字符串
String enumArrayToString(List<EnumChar> enumArray){
  String result = "";
  for (var item in enumArray) {
    result += item.toString().split(".")[1];
  }
  return result;
}
// //举例: webSocket
// String wsString = enumArrayToString([
//   EnumChar.w,
//   EnumChar.e,
//   EnumChar.b,
//   EnumChar.S,
//   EnumChar.o,
//   EnumChar.c,
//   EnumChar.k,
//   EnumChar.e,
//   EnumChar.t,
// ]);

//endregion