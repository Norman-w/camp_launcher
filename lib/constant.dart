//可以从全局任意一个地方访问的全局变量

class  Constant {
  //正式环境服务器地址
  static const String _serverUrlProd = "https://camp.norman.wang";
  //测试环境服务器地址
  static const String _serverUrlTest = "https://camp.norman.wang";
  //当前服务器地址,如果是正式环境,则使用正式环境地址,否则使用测试环境地址
  static const String serverUrl = _serverUrlTest;

  //api路径
  static const String serverUrlApi = "$serverUrl/api";

  //心跳包上报路径
  static const String serverUrlHeartbeat = "$serverUrlApi/heartbeat";

  //获取二维码路径
  static const String serverUrlGetQRCode = "$serverUrlApi/getQRCode";

  //获取二维码的超时时间
  static const int serverUrlGetQRCodeTimeout = 60;
}