//从服务端获取微信生成的带参数二维码信息,请求微信地址获取二维码图片显示到组件上,并且根据数据自动执行倒计时.
//倒计时时间到了以后重新获取二维码并执行上述步骤,周而复始.
//region 导入需要的库
import 'dart:async';

import 'package:camp_launcher/enum.dart';
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
          // _remainingSeconds = response.data['expire_seconds'];
          _remainingSeconds = 5;
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
    //进入程序以后开始获取二维码
    //获取二维码的超时时间为Constant里面定义的
    //获取完了以后展示在页面上,显示倒计时
    //倒计时时间到了以后继续重复获取二维码,并且获取完了以后展示二维码和倒计时
    //如果获取二维码失败了,显示失败,提示点击刷新
    EnumUIState uiState = EnumUIState.loadingBarcode;
    //如果_barcodeImage不为空,说明获取二维码成功了
    if (_barcodeImage != null) {
      //如果剩余时间大于0,说明二维码还没有过期
      if (_remainingSeconds > 0) {
        //设置uiState为显示二维码
        uiState = EnumUIState.barcodeShowing;
      } else {
        //否则,设置uiState为显示二维码过期
        uiState = EnumUIState.barcodeExpired;
      }
    } else {
    }
    //根据uiState的值,返回不同的组件
    switch (uiState) {
    //如果是加载二维码中
      case EnumUIState.loadingBarcode:
      //返回一个加载中的组件
        return const Center(
          child: CircularProgressIndicator(),
        );
    //如果是二维码显示并倒计时中等待扫码
      case EnumUIState.barcodeShowing:
      //返回一个带有二维码图片和倒计时的组件
        return Column(
          children: [
            //二维码图片
            _barcodeImage!,
            //倒计时
            Text('剩余时间:$_remainingSeconds'),
          ],
        );
    //如果是二维码失效等待点击重新获取
      case EnumUIState.barcodeExpired:
      //二维码图片组件
      var barcodeImage = _barcodeImage!;
      //遮罩层组件
      var barcodeImageMask = Container(
        //设置遮罩层的宽度和高度
        width: barcodeImage.width,
        height: barcodeImage.height,
        //设置遮罩层的圆角
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: Colors.black54,
        ),
        //设置遮罩层的内边距
        padding: const EdgeInsets.all(10),
        //遮罩层里面的内容
        child: Column(
          children: [
            //遮罩层里面的上面添加二维码已过期的提示
            const Text('二维码已过期,请点击刷新'),
            //遮罩层里面的下面放一个刷新按钮,点击按钮可以刷新二维码
            ElevatedButton(
              onPressed: () {
                //重新获取二维码
                _getQRCode();
                //开始倒计时
                _startCountdown();
              },
              child: const Text('刷新'),
            ),
          ],
        ),
      );
      //二维码上面添加遮罩层,圆角并且有padding
      return Stack(
        children: [
          //二维码图片
          barcodeImage,
          //遮罩层
          barcodeImageMask,
        ],
      );
      //遮罩层里面的上面添加二维码已过期的提示
      //遮罩层里面的下面放一个刷新按钮,点击按钮可以刷新二维码
    //如果是二维码扫码成功正在登录
      case EnumUIState.barcodeScanned:
      //返回一个带有二维码图片和倒计时的组件
        return Column(
          children: [
            //二维码图片
            _barcodeImage!,
            //倒计时
            Text('二维码已过期,请点击刷新'),
          ],
        );
    //如果是二维码扫码失败提示中
      case EnumUIState.barcodeScanFailed:
      //返回一个带有二维码图片和倒计时的组件
        return Column(
          children: [
            //二维码图片
            _barcodeImage!,
            //倒计时
            Text('二维码已过期,请点击刷新'),
          ],
        );
    //如果是游戏启动中
      case EnumUIState.gameLaunching:
      //返回一个带有二维码图片和倒计时的组件
        return Column(
          children: [
            //二维码图片
            _barcodeImage!,
            //倒计时
            Text('二维码已过期,请点击刷新'),
          ],
        );
    // //如果是游戏启动失败
    // case EnumUIState.gameLaunchFailed:
    //   //返回一个带有二维码图片和倒计时的组件
    //   return Column(
    //     children: [
    //       //二维码图片
    //       _barcodeImage!,
    //       //倒计时
    //       Text('二维码已过期,请点击刷新'),
    //     ],
    //   );
    // //如果是游戏启动成功
    // case EnumUIState.gameLaunched:
    //   //返回一个带有二维码图片和倒计时的组件
    //   return Column(
    //     children: [
    //       //二维码图片
    //       _barcodeImage!,
    //       //倒计时
    //       Text('二维码已过期,请点击刷新'),
    //     ],
    //   );
      default:
        return const Center(
          child: CircularProgressIndicator(),
        );
    }
  }
  //endregion
}
//endregion