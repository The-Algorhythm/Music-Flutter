import 'package:flutter/material.dart';

import 'package:music_app/widgets/video_content.dart';
import 'package:music_app/widgets/song_description.dart';
import 'package:music_app/widgets/actions_toolbar.dart';

class DiscoverContent extends StatelessWidget {

  static MediaQueryData queryData;

  final String videoUrl;
  final String albumArtUrl;
  final String songName;
  final String albumArtist;

  DiscoverContent(this.videoUrl, this.albumArtUrl, this.songName, this.albumArtist);

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
            Container(height: 65.0,)
          ],
        ),
      ],
    );
  }
}