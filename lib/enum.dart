//枚举都定义到这里


//region 当前的UI状态
//当前想到的有:
// 加载二维码中,二维码显示并倒计时中等待扫码,二维码失效等待点击重新获取,二维码扫码成功正在登录,二维码扫码失败提示中
// 游戏启动中,游戏运行中...
enum EnumUIState {
  //加载二维码中
  loadingBarcode,
  //二维码显示并倒计时中等待扫码
  barcodeShowing,
  //二维码失效等待点击重新获取
  barcodeExpired,
  //二维码扫码成功正在登录
  barcodeScanned,
  //二维码扫码失败提示中
  barcodeScanFailed,
  //游戏启动中
  gameLaunching,
  //游戏运行中
  gameRunning,
}
//endregion