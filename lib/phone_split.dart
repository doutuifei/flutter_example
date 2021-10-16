import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title:const Text("手机号分段",textDirection: TextDirection.ltr,)),
        body: const PhoneTextFiled(),
      ),
    );
  }
}

class PhoneTextFiled extends StatefulWidget {
  const PhoneTextFiled({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PhoneTextFiledState();
}

class _PhoneTextFiledState extends State<PhoneTextFiled> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20),
        child: TextField(
          autofocus: true,
          controller: controller,
          keyboardType: TextInputType.phone,
          style: const TextStyle(color: Colors.black, fontSize: 16),
          decoration: const InputDecoration(
            hintText: "请输入手机号"
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
