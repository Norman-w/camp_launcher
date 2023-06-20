//从服务端获取微信生成的带参数二维码信息,请求微信地址获取二维码图片显示到组件上,并且根据数据自动执行倒计时.
//倒计时时间到了以后重新获取二维码并执行上述步骤,周而复始.
//region 导入需要的库
import 'dart:async';
import 'dart:ui';

import 'package:camp_launcher/enum.dart';
import 'api/CheckQrCodeRequest.dart';
import 'api/model/DeviceInfo.dart';
import 'api/model/ProcessInfo.dart';
import 'api/GetLoginQrCodeRequest.dart';
import 'package:flutter/material.dart';
import 'package:norman_sdk/sdkClient.dart';
//使用dio库
// import 'package:dio/dio.dart';
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
  //当前的UI状态
  EnumUIStatus uiStatus = EnumUIStatus.unknown;
  //当前要显示的图片对象,获取二维码时这个值是空的,使用loading展示.
  Image? _qrCodeImage;
  //获取二维码的开始时间,搭配serverUrlGetQRCodeTimeout检查是否超时
  DateTime? _getQRCodeStartTime;
  //获取到当前二维码的时间是啥时候
  DateTime? qrCodeStartTime;
  //获取到的二维码的过期时间是啥时候
  DateTime? qrCodeExpireTime;
  //二维码下面的提示文字,用于显示二维码的剩余时间
  String? _tipUnderQrCode;
  //二维码遮罩层上的提示文字,用于在二维码失效的时候显示在遮罩层上方
  //根据这个值是否为null,判断是否显示mask,另外显示这个tip的时候都会顺带显示一个 重新获取 的按钮
  String? _tipOnQrCodeMask;
  //本次启动的requestId
  String? requestId;


  //endregion
  //region 定义需要的方法
  //初始化了组件后就开始获取二维码,获取时使用loading展示,获取失败了再loading位置显示失败
  @override
  void initState() {
    super.initState();
    //开始异步获取二维码
    _getQRCode(Constant.serverUrlGetQRCodeTimeoutMS);
  }
  //当网络错误或者二维码过期以后,点击重新获取的那个按钮时候的回调.
  void _onClickReGetQrCode(){
    //执行_getQRCode
    _getQRCode(Constant.serverUrlGetQRCodeTimeoutMS);
    //通过设置_tipOnQrCodeMask隐藏mask,提示,和按钮
    setState(() {
      _tipOnQrCodeMask = null;
    });
  }
  //开始执行二维码的剩余时间倒计时动态显示.
  void _startQrCodeRemainingCountDown(DateTime start, Duration duration){
    //结束时间
    var end = start.add(duration);
    //开始倒计时_tipUnderQrCode上显示倒计时时间
    Timer.periodic(const Duration(seconds: 1), (timer) {
      var now = DateTime.now();
      //如果已经超时了,显示超时信息,停止计时器
      if(now.isAfter(end)){
        //倒计时结束后,_tipUnderQrCode消失,_tipOnQrCodeMask显示二维码已过期
        setState(() {
          uiStatus = EnumUIStatus.qrCodeExpired;
          _getQRCodeStartTime = null;
          qrCodeStartTime = null;
          // qrCodeExpireTime = DateTime.now();
          _tipOnQrCodeMask = "二维码已过期,请重新获取";
          _tipUnderQrCode = null;
        });
        timer.cancel();
        return;
      }
      //每一秒刷新一次
      var remainingSeconds = end.difference(now).abs().inSeconds;
      setState(() {
        _tipUnderQrCode = "请在$remainingSeconds秒内扫描二维码";
      });
      //每秒请求一次登录是否成功
      if(uiStatus != EnumUIStatus.userLoggedIn) {
        //登录尚未成功,仍然需要检查
        _checkLoginResult();
      }
      else{
        timer.cancel();
        debugPrint('已经登录成功了,不检查了,定时器也销毁了');
      }
    });
  }
  //检查登录结果
  void _checkLoginResult(){
    if(requestId == null){
      debugPrint('还没有生成requestId呢检查什么登录:::???');
      return;
    }
    var request = CheckQrCodeRequest()
    ..RequestId = requestId;

    var sdkClient = SDKClient(Constant.serverUrlApi);
    sdkClient.execute(request, method: HttpMethod.post).then((rsp) {
      debugPrint('登录校验结果:${rsp.gameStartGuid}');
      var loginSuccess = rsp.gameStartGuid != null;
      if(loginSuccess){
        //登录成功
        setState(() {
          uiStatus = EnumUIStatus.userLoggedIn;
          _tipUnderQrCode = null;
          _tipOnQrCodeMask = null;
        });
      }
    }).catchError((error){
      debugPrint('登录校验失败:$error');
    });
  }
  //获取二维码
  void _getQRCode(int timeoutMS) {
    //如果已经在获取了,返回
    if(_getQRCodeStartTime!= null || uiStatus == EnumUIStatus.qrCodeLoading){
      //已经在获取了,重复的请求.
      return;
    }
    //开始获取的时间设置为当前时间.
    _getQRCodeStartTime = DateTime.now();
    uiStatus = EnumUIStatus.qrCodeLoading;

    //生成一个新的sceneId
    // sceneId = const Uuid().v4();
    requestId = DateTime.now().millisecondsSinceEpoch.toString();
    debugPrint('生成的requestId:$requestId');

    try {
      //region 获取设备信息
      //TODO
      var deviceInfo = DeviceInfo()
      ..baseBoard = "baseBoard"
      ..cpu = "cpu"
      ..hardDisk = "hardDisk"
      ..memory = "memory"
      ..networkCard = "networkCard"
      ..gpu = "gpu";
      //endregion
      //region 获取进程列表信息
      //TODO
      var processList = <ProcessInfo>[];
      var mockSelfProcess = ProcessInfo()
      ..processId = "123"
      ..processName = "CampLauncher.exe"
      ..processPath = "d:\\Camp\\"
      ..processDescription = "mockSelfProcessDescription";
      processList.add(mockSelfProcess);
      //endregion
      var request = GetLoginQrCodeRequest()
      ..clientSideRequestId = requestId
      ..loginTime = DateTime.now()
      ..deviceInfo = deviceInfo
      ..processList = processList;
      //执行异步请求.
      // dio.post(Constant.serverUrlGetQRCode,data: request.toJson()).then((value) {
      var sdkClient = SDKClient(Constant.serverUrlApi);
      sdkClient.execute(request, method: HttpMethod.post).then((value) {
        //解析value到GetLoginQrCodeResponse
        // var response = GetLoginQRCodeResponse.fromJson(value.data);
        debugPrint('执行sdkClient的返回:$value');
        var response = value;
        //网络层面请求成功,但是接口返回的数据内容现在还不确定
        var errCode = response.errCode;
        var errMsg = response.errMsg;
        //如果errCode不是0的话,检查errCode的内容,把errMsg显示在_tipOnQrCodeMask
        if (errCode != null && errCode != 0 || response.ticket == null || response.ticket!.isEmpty) {
          setState(() {
            _tipOnQrCodeMask = "获取二维码错误:\r\n$errMsg";
            uiStatus = EnumUIStatus.qrCodeLoadFailed;
            _getQRCodeStartTime = null;
          });
          return;
        }
        //如果errCode是0的话,提取图片链接
        // var imgUrl = "${value.data["qrCodeUrl"]}";
        var imgUrl = Constant.wechatQrCodeGettingWithTicketUrlPrefix + response.ticket!;
        debugPrint('图片地址:$imgUrl');
        //加载图片
        try {
          var img = Image.network(imgUrl,
              width: Constant.qrCodeSize,
              height: Constant.qrCodeSize,
              errorBuilder: (_, __, ___) => Text('图片加载错误,地址:$imgUrl')
          );
          //加载图片成功后显示在上面_tipOnQrCodeMask的内容清空
          // _tipOnQrCodeMask = null;
          //qrCodeStartTime是当前时间
          var start = DateTime.now();
          // var end = response.expireTime ?? start.add(const Duration(seconds: 300));
          Duration duration = response.expireTime == null? const Duration(seconds: 300)
          :response.expireTime!.difference(start);
          //开始倒计时
          _startQrCodeRemainingCountDown(start, duration);
          setState(() {
            _qrCodeImage = img;
            uiStatus = EnumUIStatus.qrCodeShowing;
            qrCodeStartTime = start;
          });
        } on Exception catch (e) {
          //加载图片失败后再页面上的_tipOnQrCodeMask显示错误内容
          setState(() {
            _tipOnQrCodeMask = '获取二维码图片错误:\r\n$e';
          });
        }
      }
      ).
      //网络请求错误如果是因为请求超时了,设置_tipOnQrCodeMask为请求超时

      //网络请求错误如果是因为其他原因了,设置_tipOnQrCodeMask上为网络错误+具体错误信息

      //输出错误信息:
      catchError((error) {
        debugPrint('catchError捕获到错误:$error');
          setState(() {
            _tipOnQrCodeMask = "请求二维码图像发生错误";
            uiStatus = EnumUIStatus.qrCodeLoadFailed;
            _getQRCodeStartTime = null;
          });
      }
      );
    } catch (e)
    {
       debugPrint('请求错误:$e');
       setState(() {
         _tipOnQrCodeMask = "请求二维码图像发生异常";
         uiStatus = EnumUIStatus.qrCodeLoadFailed;
         _getQRCodeStartTime = null;
       });
    }
  }
  //endregion
  //region 重写构建方法
  @override
  Widget build(BuildContext context) {
    if(uiStatus == EnumUIStatus.userLoggedIn){
      return const Center(
        child: Text("登录成功"),
      );
    }
    if (uiStatus == EnumUIStatus.qrCodeLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    //遮罩层,当获取二维码失败时,显示错误信息并提供重新获取按钮,虚化已经失效的二维码
    var mask = _tipOnQrCodeMask == null ? null
        : Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey, width: 0.01),
      ),
      child: SizedBox(width: 200, height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_tipOnQrCodeMask!),
            const SizedBox(height: 20,),
            ElevatedButton(
                onPressed: _onClickReGetQrCode, child: const Text("重新获取")),
          ],
        ),),
    );
    return Container(
      decoration: BoxDecoration(border: Border.all(color: Colors.grey, width: 0.01)),
      child: Column(
        // mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        //上面显示二维码和错误信息的一个层
          children:
          [
            Stack(
            children: [
              Center(
                child: _qrCodeImage == null
                    ? const SizedBox()
                    : _qrCodeImage!,
              ),
              if(mask != null)
                Center(
                  child: ClipRect(
                    child: BackdropFilter(
                    // 过滤器
                    filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                    // 必须设置一个空容器
                    child: const SizedBox(width: Constant.qrCodeSize,height: Constant.qrCodeSize,),
                    ),
                  ),
                ),
              //在屏幕中心显示mask,让mask不是靠顶端对齐
              if(mask != null)
                Center(
                  child: mask,
                ),
            ],
          ),
            // 下面显示提示信息的
            Text(_tipUnderQrCode??"⏳")
          ]
      ),
    );
  }
  //endregion
}
//endregion