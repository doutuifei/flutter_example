import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "手机号分段",
      home: Scaffold(
        body: PhoneTextFiled(),
      ),
    );
  }
}

class PhoneTextFiled extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _PhoneTextFiledState();
}

class _PhoneTextFiledState extends State<PhoneTextFiled> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(20),
        child: TextField(
          controller: controller,
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: Colors.black, fontSize: 16),
          decoration: const InputDecoration(
            hintText: "请输入手机号",
            border: InputBorder.none,
          ),
          textInputAction: TextInputAction.done,
          inputFormatters: <TextInputFormatter>[LengthLimitingTextInputFormatter(13)],
          onChanged: (v) => _splitPhoneNumber(v),
        ));
  }

  int inputLength = 0;

  void _splitPhoneNumber(String text) {
    if (text.length > inputLength) {
      //输入
      if (text.length == 4 || text.length == 9) {
        text = text.substring(0, text.length - 1) + " " + text.substring(text.length - 1, text.length);
        controller.text = text;
        controller.selection = TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: text.length));
      }
    } else {
      //删除
      if (text.length == 4 || text.length == 9) {
        text = text.substring(0, text.length - 1);
        controller.text = text;
        controller.selection = TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: text.length));
      }
    }
    inputLength = text.length;
  }
}
