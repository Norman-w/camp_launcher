// import 'package:camp_launcher/api/ProcessListRequest.dart';
// import 'package:camp_launcher/api/model/ProcessInfo.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:norman_sdk/baseResponse.dart';
// import 'package:norman_sdk/websocket_sdk_client.dart';
//
// void main() {
//   // testWidgets('WebSocket Client Test', (WidgetTester tester) async {
//   //   //sdk客户端字典
//   //   Map<String, WebsocketSdkClient> sdkClientMap = {};
//   //   //初始化10个客户端
//   //   for (int i = 0; i < 10; i++) {
//   //     var webSocketSdkClient =
//   //     WebsocketSdkClient("wss://camp.norman.wang:443/ws/", ["GameLauncher"]);
//   //     sdkClientMap["client$i"] = webSocketSdkClient;
//   //   }
//   //   //每个客户端创建10个请求
//   //   for (int i = 0; i < 10; i++) {
//   //     sdkClientMap["client$i"]!.execute(ProcessListRequest()
//   //       ..processList = [
//   //         ProcessInfo()
//   //           ..processName = "x64dbg"
//   //           ..processId = "id123"
//   //           ..processPath = "C:\\test\\x64dbg.exe"
//   //           ..processDescription =
//   //               "x64dbg is a 64-bit assembler-level debugger for Windows."
//   //       ]).then((response) {
//   //       debugPrint("!!!!!!!!!!!!!!!!收到返回的请求消息:$response");
//   //     });
//   //   }
//   //
//   //   // 等待所有请求完成
//   //   await Future.delayed(Duration(seconds: 5));
//   //
//   //   // 等待20秒让它们去执行，每秒输出一次倒计时
//   //   for (int i = 0; i < 20; i++) {
//   //     debugPrint("!!!!!!!!!!!!!!!!等待${20 - i}秒");
//   //     await Future.delayed(Duration(seconds: 1));
//   //   }
//   // });
// }
