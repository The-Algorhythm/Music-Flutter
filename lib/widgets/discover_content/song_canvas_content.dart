import 'package:flutter/material.dart';
import 'package:music_app/widgets/discover_content/progress_indicator.dart';

import 'package:music_app/widgets/discover_content/video_content.dart';
import 'package:music_app/widgets/discover_content/song_description.dart';
import 'package:music_app/widgets/discover_content/actions_toolbar.dart';

class SongCanvasContent extends StatelessWidget {

  static MediaQueryData queryData;

  final String videoUrl;
  final String albumArtUrl;
  final String songName;
  final String albumArtist;
  final double playerRatio;
  final double lastPlayerRatio;

  SongCanvasContent(this.videoUrl, this.albumArtUrl, this.songName, this.albumArtist, this.lastPlayerRatio, this.playerRatio);

  Widget get middleSection => Expanded(
    child: Row(
      mainAxisSize: MainAxisSize.max,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SongDescription(this.albumArtUrl, this.songName, this.albumArtist),
        ActionsToolbar()]
    ),
  );

  Widget _getGradient() {
    return Container(
      height: queryData.size.height,
      decoration: BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
              begin: FractionalOffset.topCenter,
              end: FractionalOffset.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.0),
                Colors.black.withOpacity(0.6),
              ],
              stops: [
                0.0,
                1.0
              ])),
    );
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Stack(
      children: [
        VideoContent(videoUrl),
        _getGradient(),
        Column(
          children: [
            middleSection,
            ContentProgressIndicator(this.lastPlayerRatio, this.playerRatio),
            Container(height: 67.0,)
          ],
        ),
      ],
    );
  }
}