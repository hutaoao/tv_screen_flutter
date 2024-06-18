import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoPlayerScreen extends StatefulWidget {
  final String url;

  const VideoPlayerScreen({super.key, required this.url});

  @override
  State<StatefulWidget> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  bool completed = false;
  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _initVideo(widget.url);
  }

  @override
  void didUpdateWidget(covariant VideoPlayerScreen oldWidget) {
    // TODO: implement didUpdateWidget
    super.didUpdateWidget(oldWidget);
    if (oldWidget.url != widget.url) {
      _initVideo(widget.url);
    }
  }

  void _initVideo(String url) {
    _controller = VideoPlayerController.networkUrl(Uri.parse(url));
    _controller.initialize().then((value) {
      setState(() {
        completed = true;
      });
      _controller.play();
      _controller.setLooping(true);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();

    super.dispose();
  }

  Widget _builderVideoPlayer() {
    return completed
        ? VideoPlayer(_controller)
        : const CircularProgressIndicator();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _builderVideoPlayer(),
      ),
    );
  }
}
