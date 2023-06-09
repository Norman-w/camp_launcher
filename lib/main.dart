import 'package:flutter/material.dart';
import 'constant.dart';
import 'component/header.dart';
import 'barcode_auto_refresh_shower.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  //一个无默认顶部导航栏的MaterialApp,也不带默认的关闭等按钮,而是使用header中的标题和按钮代替,下面目前只显示一个二维码
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camp',
      theme: ThemeData(
        primarySwatch: Colors.blue,
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
        title: const Text('Camp'),
      ),
      body: const BarcodeAutoRefreshShower(),
    );
  }
}
