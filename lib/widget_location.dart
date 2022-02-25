import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';

void main() {
  runApp(const MaterialApp(home: App()));
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: const Text("获取Widget位置信息"),
        ),
        body: SafeArea(
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const NotificationExample();
                        },
                      ),
                    );
                  },
                  child: const Text("Notification示例"),
                ),
                OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) {
                          return const GlobalKeyExample();
                        },
                      ),
                    );
                  },
                  child: const Text("GlobalKey示例"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class NotificationExample extends StatefulWidget {
  const NotificationExample({Key? key}) : super(key: key);

  @override
  _NotificationExampleState createState() => _NotificationExampleState();
}

class _NotificationExampleState extends State<NotificationExample> {
  String msg = "目标Widget";

  @override
  Widget build(BuildContext context) {
    return Material(
      child: NotificationListener<PositionedNotification>(
        onNotification: (notification) {
          setState(() {
            msg =
                "目标Widget\nOffset->${notification.offset} \nSize->${notification.size}";
          });
          return true;
        },
        child: Center(
          child: PositionedNotificationNotifier(
            child: Text(msg),
          ),
        ),
      ),
    );
  }
}

class GlobalKeyExample extends StatefulWidget {
  const GlobalKeyExample({Key? key}) : super(key: key);

  @override
  GlobalKeyExampleState createState() => GlobalKeyExampleState();
}

class GlobalKeyExampleState extends State<GlobalKeyExample> {
  GlobalKey key1 = GlobalKey();

  GlobalKey key2 = GlobalKey();

  static GlobalKeyExampleState? of(BuildContext context) {
    final GlobalKeyExampleState? result =
        context.findAncestorStateOfType<GlobalKeyExampleState>();
    if (result != null) {
      return result;
    }
    return null;
  }

  String msg = "";

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance?.addPostFrameCallback((time) {
      RenderBox? renderBox1 = findRenderBoxByKey(key1.currentContext);
      RenderBox? renderBox2 = findRenderBoxByKey(key2.currentContext);

      Offset? offset1 = renderBox1?.localToGlobal(Offset.zero);
      Size? size1 = renderBox1?.paintBounds.size;

      Offset? offset2 = renderBox2?.localToGlobal(Offset.zero);
      Size? size2 = renderBox2?.paintBounds.size;

      setState(() {
        msg =
            "GlobalKey1\n Offset1->${offset1.toString()} \n Size1->${size1.toString()} \n\n GlobalKey2\n Offset2->${offset2.toString()} \n Size2->${size2.toString()}";
      });
    });
  }

  RenderBox? findRenderBoxByKey(BuildContext? context) {
    RenderBox? renderBox = context?.findRenderObject() as RenderBox?;
    return renderBox;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(msg),
            Container(
              key: key1,
              width: 150,
              height: 50,
              margin: const EdgeInsets.only(top: 20),
              alignment: Alignment.center,
              color: Colors.amber,
              child: const Text(
                "GlobalKey1",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const ChildWidget()
          ],
        ),
      ),
    );
  }
}

class ChildWidget extends StatefulWidget {
  const ChildWidget({Key? key}) : super(key: key);

  @override
  _ChildWidgetState createState() => _ChildWidgetState();
}

class _ChildWidgetState extends State<ChildWidget> {
  @override
  Widget build(BuildContext context) {
    GlobalKey? globalKey = GlobalKeyExampleState.of(context)?.key2;
    return Container(
      key: globalKey,
      width: 100,
      height: 60,
      margin: const EdgeInsets.only(top: 20),
      alignment: Alignment.center,
      color: Colors.deepOrange,
      child: const Text(
        "GlobalKey2",
        style: TextStyle(color: Colors.white),
      ),
    );
  }
}

class PositionedNotification extends Notification {
  Offset? offset;
  Size? size;
}

class PositionedNotificationNotifier extends SingleChildRenderObjectWidget {
  const PositionedNotificationNotifier({Widget? child, Key? key})
      : super(key: key, child: child);

  @override
  _PositionedCallback createRenderObject(BuildContext context) {
    return _PositionedCallback(onLayoutChangedCallback: (offset, size) {
      (PositionedNotification()
            ..offset = offset
            ..size = size)
          .dispatch(context);
    });
  }
}

class _PositionedCallback extends RenderProxyBox {
  final Function(Offset?, Size?) onLayoutChangedCallback;
  Offset? tmpOffset;
  Size? tempSize;

  _PositionedCallback({RenderBox? child, required this.onLayoutChangedCallback})
      : super(child);

  @override
  void performLayout() {
    super.performLayout();
    SchedulerBinding.instance?.addPostFrameCallback((time) {
      tmpOffset = localToGlobal(Offset.zero);
      tempSize = paintBounds.size;
      onLayoutChangedCallback(tmpOffset, tempSize);
    });
  }
}
