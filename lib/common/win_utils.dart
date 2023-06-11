import 'dart:ui';
import 'package:win32/win32.dart';

import 'package:window_manager/window_manager.dart';

Future<void> initWindow () async {
  await windowManager.ensureInitialized();
  windowManager.waitUntilReadyToShow().then(
      (value) async{
        await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
        await windowManager.setSize(const Size(800, 500));
        await windowManager.setResizable(false);
        await windowManager.setClosable(false);
        await windowManager.setMinimizable(false);
      }
  );
}
