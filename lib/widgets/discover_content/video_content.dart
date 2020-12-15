import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoContent extends StatefulWidget {

  final String url;
  final bool paused;

  VideoContent(this.url, this.paused);

  @override
  _VideoContentState createState() => _VideoContentState();
}

class _VideoContentState extends State<VideoContent> {
  VideoPlayerController _controller;
  MediaQueryData queryData;
  bool _wasPaused = false;

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
    if(widget.paused && !_wasPaused) {
      _controller.pause();
      _wasPaused = true;
    } else if(!widget.paused && _wasPaused) {
      _controller.play();
      _wasPaused = false;
    }
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