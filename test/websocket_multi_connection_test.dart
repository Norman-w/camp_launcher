/*
WebSocket多连接测试方法.
开始后将生成多个客户端
多个客户端还会持续的发送请求以验证服务器和网络的性能.

如果看不到debugPrint的输出结果,只有在结束测试后才可以看到,那么请在命令行中运行flutter test --machine test/websocket_multi_connection_test.dart
* */

import 'dart:async';
import 'dart:math';

import 'package:camp_launcher/api/ProcessListRequest.dart';
// import 'package:camp_launcher/api/ProcessListResponse.dart';
import 'package:camp_launcher/api/model/ProcessInfo.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norman_sdk/websocket_sdk_client.dart';

Future testPerWebsocketClientSendMultiRequest() async {
  //打开一个WebSocket连接到GameLauncher 的 SubProtocol: "GameLauncher"
  var webSocketSdkClient = WebsocketSdkClient(
      "wss://camp.norman.wang:443/ws/", ["GameLauncher"]);
  for(int i = 0; i < 10000; i++) {
    test("测试执行WebSocket${i+1}", () async {
      await webSocketSdkClient.execute(ProcessListRequest()
        ..processList = [ProcessInfo()
          ..processName = "x64dbg"
          ..processId = "id123"
          ..processPath = "C:\\test\\x64dbg.exe"
          ..processDescription = "x64dbg is a 64-bit assembler-level debugger for Windows."
        ])
          .then((response) {
        debugPrint("!!!!!!!!!!!!!!!!收到返回的请求消息:$response");
      })
          .catchError((e) {
        debugPrint('测试WebSocket出错:$e');
      });
    });
  }
}
var totalRequestCount = 0;
var successResponseCount = 0;
var failedResponseCount = 0;
testMultiWebsocketClientAndMultiRequest({
  //客户端数量
  required int clientCount,
  //每个连接之间的间隔
  required int perClientInterval,
  //每个连接的请求次数
  required int perClientRequestCount,
  //每个请求之间的最小间隔
  required int perRequestMinInterval,
  //每个请求之间的最大间隔
  required int perRequestMaxInterval
}
    ) {

  test("启动客户端", () {
    Timer.periodic(Duration(milliseconds: perClientInterval), (clientTimer) {
      if (clientCount <= 0) {
        clientTimer.cancel();
        return;
      }
      clientCount--;
      //打开一个WebSocket连接到GameLauncher 的 SubProtocol: "GameLauncher"
      var webSocketSdkClient = WebsocketSdkClient(
          "wss://camp.norman.wang:443/ws/", ["GameLauncher"]);
      var maxRequestCount = perClientRequestCount;
      Timer.periodic(Duration(milliseconds: Random().nextInt(perRequestMaxInterval-perRequestMinInterval) + perRequestMinInterval), (requestTimer) {
        if (maxRequestCount <= 0) {
          requestTimer.cancel();
          return;
        }
        maxRequestCount--;
        totalRequestCount ++;
        webSocketSdkClient.execute(ProcessListRequest()
          ..processList = [ProcessInfo()
            ..processName = "x64dbg"
            ..processId = "id123"
            ..processPath = "C:\\test\\x64dbg.exe"
            ..processDescription = "x64dbg is a 64-bit assembler-level debugger for Windows."
          ])
            .then((response) {
          successResponseCount ++;
          // debugPrint("!!!!!!!!!!!!!!!!收到返回的请求消息:$response");
        })
            .catchError((e) {
              failedResponseCount ++;
          // debugPrint('测试WebSocket出错:$e');
        });
      });
    });
  });
}

void main() async {
  //测试连续请求
  // await testPerWebsocketClientSendMultiRequest();

  //region 测试一分钟能执行多少个请求(多个链接)
  testMultiWebsocketClientAndMultiRequest(
      clientCount: 300,
      perClientInterval: 100,
      perClientRequestCount: 5,
      perRequestMinInterval: 100,
      perRequestMaxInterval: 1000
  );
  //使用另外一个test,执行等待1分钟,看最后一共执行了多少次请求
  test("指定时间多端多请求", () async {
    for (int i = 0; i < 60; i++) {
      debugPrint("剩余${60 - i}秒");
      await Future.delayed(const Duration(seconds: 1));
      debugPrint("*************请求结果: $successResponseCount/$totalRequestCount*************");
    }
  });
  //endregion
}