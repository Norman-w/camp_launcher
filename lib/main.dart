import 'dart:io';

import 'package:camp_launcher/utils/win_utils.dart';
import 'package:flutter/material.dart';
import 'barcode_auto_refresh_shower.dart';
import 'component/SettingDialog.dart';

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
        decoration: BoxDecoration(
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
