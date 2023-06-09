//从服务端获取微信生成的带参数二维码信息,请求微信地址获取二维码图片显示到组件上,并且根据数据自动执行倒计时.
//倒计时时间到了以后重新获取二维码并执行上述步骤,周而复始.
//region 导入需要的库
import 'dart:async';

import 'package:flutter/material.dart';
//使用dio库
import 'package:dio/dio.dart';
import 'constant.dart';
//endregion
//region 创建有状态组件
class BarcodeAutoRefreshShower extends StatefulWidget {
  const BarcodeAutoRefreshShower({Key? key}) : super(key: key);
  @override
  createState() => _BarcodeAutoRefreshShowerState();
}
//endregion
//region 创建有状态组件的状态类
class _BarcodeAutoRefreshShowerState extends State<BarcodeAutoRefreshShower> {
  //region 定义需要的变量
  //当前要显示的图片对象,获取二维码时这个值是空的,使用loading展示.
  Image? _barcodeImage;
  //当前剩余时间秒数
  int _remainingSeconds = Constant.serverUrlGetQRCodeTimeout;
  //endregion
  //region 定义需要的方法
  //初始化了组件后就开始获取二维码,获取时使用loading展示,获取失败了再loading位置显示失败
  @override
  void initState() {
    super.initState();
    //获取二维码
    _getQRCode();
    //开始倒计时
    _startCountdown();
  }
  //倒计时
  void _startCountdown() {
    //定义一个计时器,每隔1秒执行一次
    Timer.periodic(const Duration(seconds: 1), (timer) {
      //调试输出剩余时间
      print('剩余时间:$_remainingSeconds');
      //如果剩余时间大于0
      if (_remainingSeconds > 0) {
        //将剩余时间减1
        setState(() {
          _remainingSeconds--;
        });
      } else {
        //否则,停止计时器
        timer.cancel();
        //重新获取二维码
        // _getQRCode();
      }
    });
  }
  //获取二维码
  void _getQRCode() {
    var url = Constant.serverUrlGetQRCode;
    print('请求地址:'+url);
    //执行网络请求,使用dio
    var dio = Dio();
    dio.get(url).then((response) {
      //请求成功
      if (response.statusCode == 200) {
        //调试输出请求
        print('请求成功'+response.data.toString());
        //将返回的二维码图片地址赋值给_barcodeImage
        setState(() {
          _barcodeImage = Image.network(response.data['qrCodeUrl']);
          //将返回的二维码有效时间赋值给_remainingSeconds
          _remainingSeconds = response.data['expire_seconds'];
        });
      }
    }).catchError((error) {
      //调试输出请求
      print('请求失败'+error.toString());
      //请求失败
      setState(() {
        //将_remainingSeconds设置为0
        _remainingSeconds = 0;
        //将_barcodeImage设置为null
        _barcodeImage = null;
      });
    });
  }
  //endregion
  //region 重写构建方法
  @override
  Widget build(BuildContext context) {
    //region 定义需要的组件
    //定义一个组件列表
    List<Widget> children = [];
    //定义一个loading组件
    var loading = const Center(
      child: CircularProgressIndicator(),
    );
    //定义一个失败组件
    var failed = const Center(
      child: Text('获取二维码失败'),
    );
    //定义一个倒计时组件
    var countdown = Center(
      child: Text('$_remainingSeconds'),
    );
    //endregion
    //region 组装组件列表
    //如果_barcodeImage不为空,说明获取到了二维码,将二维码添加到组件列表中
    if (_barcodeImage != null) {
      children.add(_barcodeImage!);
    }
    //如果_remainingSeconds大于0,说明还有剩余时间,将倒计时组件添加到组件列表中
    if (_remainingSeconds > 0) {
      children.add(countdown);
    }
    //如果_barcodeImage为空,说明还没有获取到二维码,将loading组件添加到组件列表中
    if (_barcodeImage == null) {
      children.add(loading);
    }
    //如果_remainingSeconds等于0,说明二维码已经失效,将失败组件添加到组件列表中
    if (_remainingSeconds == 0) {
      children.add(failed);
    }
    //endregion
    //region 返回组件
    return Column(
      children: children,
    );
    //endregion
  }
  //endregion
}
//endregion