import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';
import './video.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

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

enum TvType { video, image, web }

extension MonthExtension on TvType {
  int get value => index + 1;

  int get position => [0, 1, 2][index];
}

/// 使用的时候只需要修改以下集合就可以了
/// 不需要的模块可以自行删除
class _MyHomePageState extends State<MyHomePage> {
  bool completed = false;
  int index = 0;
  int pagePosition = 0; // PageView页码

  /// 视频集合
  List videoList = [
    'http://192.168.13.101:81/video1.mp4',
    'http://192.168.13.101:81/video2.m4v',
    'http://192.168.13.101:81/video3.m4v',
    'http://192.168.13.101:81/video4.mp4',
  ];

  /// 图片集合
  List imageList = [
    'http://192.168.13.101:81/pk-202406.jpg',
    'http://192.168.13.101:81/pk02.png',
    'http://192.168.13.101:81/pk03.jpg',
    'http://192.168.13.101:81/pk04.png',
    'http://192.168.13.101:81/pk05.jpg',
    'http://192.168.13.101:81/rujia-screen.png',
  ];

  /// 网页集合
  List webUrlList = [
    'https://monitor-new.grey-ants.com/base/#/authScreen',
    'http://192.168.13.101',
    'http://192.168.14.102/link/gFuQ0s09',
  ];

  final PageController _pageController = PageController();

  WebViewController controller = WebViewController();

  _onPageChanged(position) {
    setState(() {
      pagePosition = position;
    });
  }

  Widget _builderWebView() {
    controller
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(webUrlList[pagePosition == TvType.web.position ? index : 0]));
    /// 特殊处理
    if (index == 2) {
      controller.setUserAgent('Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36');
    }

    return WebViewWidget(controller: controller);
  }

  /// 遥控器事件
  _handleKey(RawKeyEvent event) {
    if (event is RawKeyUpEvent) {
      switch (event.logicalKey.keyLabel) {
        case 'Arrow Down':
          _pageController.nextPage(
            duration: const Duration(microseconds: 100),
            curve: Curves.easeIn,
          );
          if (pagePosition < TvType.web.position) {
            setState(() {
              index = 0;
              pagePosition++;
            });
          }
          break;
        case 'Arrow Up':
          _pageController.previousPage(
            duration: const Duration(microseconds: 100),
            curve: Curves.easeIn,
          );
          if (pagePosition > TvType.video.position) {
            setState(() {
              index = 0;
              pagePosition--;
            });
          }
          break;
        case 'Arrow Right':
          int maxLength = _handleIndex();
          if (index == maxLength - 1) {
            setState(() {
              index = 0;
            });
          } else {
            setState(() {
              index++;
            });
          }
          break;
        case 'Arrow Left':
          int maxLength = _handleIndex();
          if (index == 0) {
            setState(() {
              index = maxLength - 1;
            });
          } else {
            setState(() {
              index--;
            });
          }
          break;
        default:
      }
    }
  }

  /// 获取视频/图标/web 长度
  int _handleIndex() {
    int maxLength = 0;
    switch(pagePosition) {
      case 0:
        maxLength = videoList.length;
        break;
      case 1:
        maxLength = imageList.length;
        break;
      case 2:
        maxLength = webUrlList.length;
        break;
      default:
    }
    return maxLength;
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
            Center(
              child: VideoPlayerScreen(
                url: videoList[pagePosition == TvType.video.position ? index : 0]
              )
            ), /// 渲染视频
            Center(
              child: Image.network(
                imageList[pagePosition == TvType.image.position ? index : 0],
                fit: BoxFit.cover,
                width: double.infinity
              )
            ), /// 渲染图片
            Center(child: _builderWebView()),
          ],
        ),
      )
    );
  }
}
