import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoContent extends StatefulWidget {

  final String url;

  VideoContent(this.url);

  @override
  _VideoContentState createState() => _VideoContentState();
}

class _VideoContentState extends State<VideoContent> {
  VideoPlayerController _controller;
  MediaQueryData queryData;
//  static const String videoUrl = "https://canvaz.scdn.co/upload/artist/3kkoYvxvV00UXPJCqMCljL/video/e76b441968db401394ad4b1818a6d2be.cnvs.mp4";

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.url)
      ..initialize().then((_) {
        setState(() {
          _controller.setLooping(true);
          _controller.play();
        });
      });
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Center(
      child: _controller.value.initialized
          ? AspectRatio(
        aspectRatio: queryData.size.width / (queryData.size.height - queryData.viewPadding.top),
        child: VideoPlayer(_controller),
      )
          : Container(),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}