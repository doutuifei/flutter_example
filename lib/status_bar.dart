import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() {
  runApp(
    MaterialApp(
      home: const App(),
      routes: {
        "/A": (context) => PageA(),
        "/B": (context) => PageB(),
      },
      navigatorObservers: [RouteObserver()],
    ),
  );
}

class RouteObserver extends NavigatorObserver {
  final Map<String, SystemUiOverlayStyle> _map = {};

  RouteObserver() {
    _map["/"] = dark;
    _map["/A"] = light;
    _map["/B"] = dark;
  }

  ///设置亮色状态栏和导航栏
  ///android 默认statusBarColor = Color(0x40000000)，为了满足UI的需求设置为Colors.transparent。只对安卓生[L]及以上生效
  final SystemUiOverlayStyle light =
      SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent);

  ///设置暗色状态栏和导航栏
  ///android 默认statusBarColor = Color(0x40000000)，为了满足UI的需求设置为Colors.transparent。只对安卓生[L]及以上生效
  final SystemUiOverlayStyle dark =
      SystemUiOverlayStyle.dark.copyWith(statusBarColor: Colors.transparent);

  @override
  void didPop(Route route, Route? previousRoute) {
    _setSystemUIOverlayStyle(previousRoute, route);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    _setSystemUIOverlayStyle(route, previousRoute);
  }

  @override
  void didReplace({Route? newRoute, Route? oldRoute}) {
    _setSystemUIOverlayStyle(newRoute, oldRoute);
  }

  void _setSystemUIOverlayStyle(Route? toRoute, Route? formRoute) {
    String? toName = _getRoutNameFromRoute(toRoute);
    String? formName = _getRoutNameFromRoute(formRoute);
    if (toName == null) {
      return;
    }
    SystemUiOverlayStyle? toStyle = _map[toName];
    SystemUiOverlayStyle? fromStyle = _map[formName];
    if (toStyle != null && toStyle != fromStyle) {
      SystemChannels.platform.invokeMethod<void>(
        'SystemChrome.setSystemUIOverlayStyle',
        _style2Map(toStyle),
      );
    }
  }

  Map<String, dynamic> _style2Map(SystemUiOverlayStyle style) {
    return <String, dynamic>{
      'systemNavigationBarColor': style.systemNavigationBarColor?.value,
      'systemNavigationBarDividerColor':
          style.systemNavigationBarDividerColor?.value,
      'systemStatusBarContrastEnforced': style.systemStatusBarContrastEnforced,
      'statusBarColor': style.statusBarColor?.value,
      'statusBarBrightness': style.statusBarBrightness?.toString(),
      'statusBarIconBrightness': style.statusBarIconBrightness?.toString(),
      'systemNavigationBarIconBrightness':
          style.systemNavigationBarIconBrightness?.toString(),
      'systemNavigationBarContrastEnforced':
          style.systemNavigationBarContrastEnforced,
    };
  }

  String? _getRoutNameFromRoute(Route? route) {
    if (route == null) {
      return null;
    }
    RouteSettings routeSettings = route.settings;
    return routeSettings.name;
  }
}

class App extends StatefulWidget {
  const App({Key? key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("当前是默认的状态栏效果"),
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/A");
                  },
                  child: Text("打开PageA-light")),
            ],
          ),
        ),
      ),
    );
  }
}

class PageA extends StatelessWidget {
  const PageA({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.orangeAccent,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text("当前状态栏是黑色图标"),
              OutlinedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed("/B");
                  },
                  child: Text("打开PageA-dark")),
            ],
          ),
        ),
      ),
    );
  }
}

class PageB extends StatefulWidget {
  const PageB({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _PageBState();
}

class _PageBState extends State<PageB> {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.dark);
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: const Text(
            "黑色图标",
            style: TextStyle(color: Colors.black),
          ),
          leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: const Icon(
              Icons.arrow_back_ios,
              color: Colors.black,
            ),
          ),
        ),
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text("状态栏黑色图标"),
            ],
          ),
        ),
      ),
    );
  }
}
