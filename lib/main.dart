import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import './video.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool completed = false;
  int videoIndex = 0;

  /// 视频集合
  List videoList = [
    'http://192.168.13.101:81/video1.mp4',
    'http://192.168.13.101:81/video2.m4v',
    'http://192.168.13.101:81/video3.m4v',
    'http://192.168.13.101:81/video4.mp4',
  ];

  final PageController _pageController = PageController();

  WebViewController controller1 = WebViewController();
  WebViewController controller2 = WebViewController();
  WebViewController controller3 = WebViewController();

  initWebView(WebViewController controller, String uri) {
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          /// 加载进度
          onPageFinished: (String url) {
            setState(() {
              completed = true;
            });
          },
        ),
      )
      ..loadRequest(Uri.parse(uri));
    if (controller == controller3) {
      controller.setUserAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36');
    }
  }

  _onPageChanged(position) {
    setState(() {
      completed = false;
    });
    switch (position) {
      case 10:
        initWebView(controller1, 'https://monitor-new.grey-ants.com/base/#/authScreen');
        break;
      case 11:
        initWebView(controller2, 'http://192.168.13.101');
        break;
      case 12:
        initWebView(controller3, 'http://192.168.14.102/link/gFuQ0s09');
        break;
      default:
    }
  }

  Widget _builderWebView(WebViewController controller) {
    return completed
        ? WebViewWidget(controller: controller)
        : const CircularProgressIndicator();
  }

  _handleKey(RawKeyEvent event) {
    if (event is RawKeyUpEvent) {
      switch (event.logicalKey.keyLabel) {
        case 'Arrow Down':
          _pageController.nextPage(
            duration: const Duration(microseconds: 100),
            curve: Curves.easeIn,
          );
          break;
        case 'Arrow Up':
          _pageController.previousPage(
            duration: const Duration(microseconds: 100),
            curve: Curves.easeIn,
          );
          break;
        default:
      }
    }
  }

  // 私有方法
  List<Widget> _initListData() {
    var list = videoList.map((e) {
      return Center(child: VideoPlayerScreen(url: e));
    });
    return list.toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RawKeyboardListener(
        focusNode: FocusNode(canRequestFocus: true),
        onKey: _handleKey,
        child: PageView(
          controller: _pageController,
          onPageChanged: _onPageChanged,
          children: [
            ..._initListData(),
            Center(child: Image.network('http://192.168.13.101:81/pk-202406.jpg', fit: BoxFit.cover, width: double.infinity)),
            Center(child: Image.network('http://192.168.13.101:81/pk02.png', fit: BoxFit.cover, width: double.infinity)),
            Center(child: Image.network('http://192.168.13.101:81/pk03.jpg', fit: BoxFit.cover, width: double.infinity)),
            Center(child: Image.network('http://192.168.13.101:81/pk04.png', fit: BoxFit.cover, width: double.infinity)),
            Center(child: Image.network('http://192.168.13.101:81/pk05.jpg', fit: BoxFit.cover, width: double.infinity)),
            Center(child: Image.network('http://192.168.13.101:81/rujia-screen.png', fit: BoxFit.cover, width: double.infinity)),
            Center(child: _builderWebView(controller1)),
            Center(child: _builderWebView(controller2)),
            Center(child: _builderWebView(controller3)),
          ],
        ),
      )
    );
  }
}
