import 'dart:convert';
import 'dart:io';

import 'package:camp_launcher/constant.dart';
import 'package:norman_sdk/request_package.dart';
import 'package:norman_sdk/websocket_sdk_client.dart';
import 'package:camp_launcher/utils/win_utils.dart';
import 'package:flutter/material.dart';
import 'api/ProcessListRequest.dart';
import 'barcode_auto_refresh_shower.dart';
import 'component/SettingDialog.dart';
import 'api/model/ProcessInfo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initWindow();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  //一个无默认顶部导航栏的MaterialApp,也不带默认的关闭等按钮,而是使用header中的标题和按钮代替,下面目前只显示一个二维码
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camp',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  //初始化
  @override
  void initState() {
    super.initState();
    //打开一个WebSocket连接到GameLauncher 的 SubProtocol: "GameLauncher"
    var webSocketSdkClient = WebsocketSdkClient("wss://camp.norman.wang:443/ws/",["GameLauncher"]);
    webSocketSdkClient.execute(ProcessListRequest()
      ..processList = [ProcessInfo()
        ..processName = "x64dbg"
        ..processId = "id123"
        ..processPath = "C:\\test\\x64dbg.exe"
        ..processDescription = "x64dbg is a 64-bit assembler-level debugger for Windows."
      ]).then((response){

      debugPrint("!!!!!!!!!!!!!!!!收到返回的请求消息:$response");
    });
    // var url = Constant.serverUrlWebSocket;
    // debugPrint("连接到服务器:$url");
    // var subProtocol = "GameLauncher";
    // //如果出现WebSocketException: Connection to '连接地址,#结尾,如果不指定端口号,还会显示域名:0端口号' was not upgraded to websocket
    // //在nginx中添加如下设置:
    // // proxy_http_version 1.1;
    // // proxy_set_header Upgrade $http_upgrade;
    // // proxy_set_header Connection 'upgrade';
    // var webSocket = WebSocket.connect("wss://camp.norman.wang:443/ws/", protocols: [subProtocol]);
    // webSocket.then((value) {
    //   debugPrint("连接成功");
    //   //连接成功后,发送一个消息,消息内容是"Hello"
    //   //定义一个RequestPackage,apiName是 process.list
    //   //Data是一个json保存的字符串,里面有一个xxx字段,值是123456
    //   //这个RequestPackage会被转换成json字符串发送到服务器
    //   //region 构建请求
    //   var processListRequest = ProcessListRequest()
    //   ..processList = [ProcessInfo()
    //       ..processName = "x64dbg"
    //       ..processId = "id123"
    //       ..processPath = "C:\\test\\x64dbg.exe"
    //       ..processDescription = "x64dbg is a 64-bit assembler-level debugger for Windows."
    //   ];
    //   //endregion
    //   //region 将请求转换成json字符串
    //   var packageJson = RequestPackage(
    //       apiName:"process.list",
    //       requestId: "123456",
    //       data: const JsonEncoder().convert(processListRequest)
    //   ).toJson();
    //   var packageJsonStr = const JsonEncoder().convert(packageJson);
    //   //endregion
    //   value.add(packageJsonStr);
    //   //监听消息
    //   value.listen((event) {
    //     debugPrint("收到消息:$event");
    //   });
    // });
  }
  //build直接用barcode_auto_refresh_shower.dart中的组件
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("Camp"),
            IconButton(onPressed: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return const SettingDialog();
                  }).then((value) {
                if (value != null) {
                  debugPrint("输入的游戏启动码是:$value");
                }
              });
            },
                tooltip: "设置",
                icon: const Icon(Icons.settings)
            ),
            IconButton(
              icon: const Icon(Icons.close),
              color: Colors.black,
              tooltip: "退出",
              onPressed: () {
                exit(0);
              },
            )
          ],
        )
      ),
      body:
      Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage('assets/back.jpeg')
          )
        ),
        child: const BarcodeAutoRefreshShower(),
      ),

    );
  }
}
