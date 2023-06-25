import 'dart:io';

class ClientSceneCommunicator{
  static ClientSceneCommunicator? _instance;
  static ClientSceneCommunicator get instance => _instance??ClientSceneCommunicator._();
  Future<WebSocket>? webSocket;
  ClientSceneCommunicator._(){
    _instance = this;
  }
  //每次发送心跳包的间隔时间,如果发送心跳包失败了以后自动重连
  static const int HEART_BEAT_INTERVAL = 1000;
  //上次发送心跳包的时间
  static DateTime? lastHeartBeatTime;
  //request超时时间
  static const int REQUEST_TIMEOUT = 5000;
  //是否正在连接,防止同一时期过多的服务器连接
  bool isConnecting = false;
}

ClientSceneCommunicator clientSceneCommunicator = ClientSceneCommunicator.instance;