//构建一个设置窗口,在玩家点击了设置按钮的时候弹出,里面包含一个输入框
//玩家可以输入一个32之前获取到的GameStartGuid(不是从本应用中获取的)
//输入完了以后可以保存.
//构造时,如果玩家已经有这个值,传入这个值,并且保存按钮不可以编辑,保存按钮悬停上去以后提示如更换游戏码需联系管理员.
//保存时候再次弹出一个提示框说明该值一旦设定不可更改,请确认,确认后就不可以修改了,保存按钮不可用,只可以关闭窗口.

import 'package:flutter/material.dart';

class SettingDialog extends StatefulWidget {
  final String? gameStartGuid;
  const SettingDialog({Key? key, this.gameStartGuid}) : super(key: key);

  @override
  createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  late TextEditingController _controller;
  bool _isSaveButtonEnable = false;
  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.gameStartGuid);
    _controller.addListener(() {
      setState(() {
        _isSaveButtonEnable = _controller.text.length == 32 &&
            _controller.text != widget.gameStartGuid;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      contentPadding: const EdgeInsets.fromLTRB(40.0, 20.0, 40.0, 40.0),
      title: const Text('设置'),
      content: SizedBox(
        width: 350.0,
        child: TextField(
          //默认可以输入64个字符,最少32个字符
          maxLength: 32,
          controller: _controller,
          decoration: const InputDecoration(
            labelText: '请输入游戏码',
            hintText: '请输入游戏码',
            prefixIcon: Icon(Icons.gamepad),
          ),
        ),
      ),
      actions: <Widget>[
        //保存按钮
        TextButton(
          //当可以保存的时候,按钮是蓝色的,当不可以保存的时候,按钮是灰色的
          style: TextButton.styleFrom(
              foregroundColor: _isSaveButtonEnable ? Colors.blue : Colors.grey),
          onPressed: _isSaveButtonEnable
              ? () {
            //输出输入的值
            //       debugPrint(_controller.text);
                  //关闭当前窗口,并且返回输入的值
                  Navigator.of(context).pop(_controller.text);
                }
              : null,
          child: const Text('保存'),
        ),
        //关闭按钮
        TextButton(
          //颜色是蓝色的,但是不是主题色,而是一个深蓝色
          style: TextButton.styleFrom(foregroundColor: Colors.blue),
          child: const Text('关闭'),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
}