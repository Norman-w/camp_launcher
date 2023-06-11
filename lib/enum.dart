//枚举都定义到这里


//region 当前的UI状态
enum EnumUIStatus {
  unknown,
  //加载二维码中
  qrCodeLoading,
  //二维码加载失败,需要用户点击以后才可以继续走到二维码加载中,防止太多的服务器请求.
  qrCodeLoadFailed,
  //二维码显示并倒计时中等待扫码
  qrCodeShowing,
  //二维码失效等待点击重新获取,需要用户交互,仍然是防止太多的服务器请求
  qrCodeExpired,
  //二维码扫码成功正在登录
  qrCodeScanned,
  //用户已登录,主页面空闲中.
  userLoggedIn,
  //用户执行设置中
  userSetting,
  //游戏启动中
  gameLaunching,
  //游戏运行中
  gameRunning,
}
//endregion