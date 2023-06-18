import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import '../api/model/ProcessInfo.dart';
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

///使用Wmic命令获取进程信息
Future<List<ProcessInfo>> getProcessesByWmic() async {
  //如果当前运行系统不是windows,则直接返回空数组
  if (!Platform.isWindows) {
    //log
    debugPrint('当前系统不是windows,无法使用wmic命令获取进程信息');
    return [];
  }
  List<ProcessInfo> ret = [];
  try {
    var processResult = await Process.run(
        'wmic', ['process', 'get', 'processid,caption,executablepath']);
    if (processResult.exitCode == 0) {
      var output = processResult.stdout;
      var lines = LineSplitter.split(output);
      var processPaths = lines.skip(1)
          .where((line) => line.isNotEmpty)
          .toList();
      for (var processPath in processPaths) {
        debugPrint(processPath);
        // 在这里可以对进程路径进行进一步处理
        //将这种 msedge.exe                        C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe                                                        22132
        //拆分出来作为一个对象
        //然后将这些对象放到一个数组里面
        //最后将这个数组返回
        ProcessInfo processInfo = ProcessInfo();
        processInfo.processId =
            processPath.substring(processPath.lastIndexOf(' ')).trim();
        processInfo.processName =
            processPath.substring(0, processPath.indexOf(' ')).trim();
        processInfo.processPath = processPath.substring(
            processPath.indexOf(' '), processPath.lastIndexOf(' ')).trim();
        //json debug
        // debugPrint(processInfo.toJson().toString());
        ret.add(processInfo);
      }
    } else {
      var error = processResult.stderr;
      debugPrint('Command execution failed with error: $error');
    }
  } catch (e) {
    debugPrint('Error executing command: $e');
  }
  return ret;
}

// ///使用Wmic命令获取服务信息
// ///wmic service where (state=”running”) get caption, name, startmode
// Future<List<ProcessInfo>> getServicesByWmic() async {
//   List<ProcessInfo> ret = [];
//   try {
//     var processResult = await Process.run(
//         'wmic', ['service', 'where', '(state="running")', 'get', 'caption,name,startmode']);
//     if (processResult.exitCode == 0) {
//       var output = processResult.stdout;
//       var lines = LineSplitter.split(output);
//       var processPaths = lines.skip(1)
//           .where((line) => line.isNotEmpty)
//           .toList();
//       for (var processPath in processPaths) {
//         debugPrint(processPath);
//         // 在这里可以对进程路径进行进一步处理
//         //将这种 msedge.exe                        C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe                                                        22132
//         //拆分出来作为一个对象
//         //然后将这些对象放到一个数组里面
//         //最后将这个数组返回
//         ProcessInfo processInfo = ProcessInfo();
//         processInfo.processId =
//             processPath.substring(processPath.lastIndexOf(' ')).trim();
//         processInfo.processName =
//             processPath.substring(0, processPath.indexOf(' ')).trim();
//         processInfo.processPath = processPath.substring(
//             processPath.indexOf(' '), processPath.lastIndexOf(' ')).trim();
//         //json debug
//         // debugPrint(processInfo.toJson().toString());
//         ret.add(processInfo);
//       }
//     } else {
//       var error = processResult.stderr;
//       debugPrint('Command execution failed with error: $error');
//     }
//   } catch (e) {
//     debugPrint('Error executing command: $e');
//   }
//   return ret;
// }