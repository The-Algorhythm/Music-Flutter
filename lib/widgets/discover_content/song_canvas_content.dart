import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/widgets/discover_content/progress_indicator.dart';

import 'package:music_app/widgets/discover_content/video_content.dart';
import 'package:music_app/widgets/discover_content/song_description.dart';
import 'package:music_app/widgets/discover_content/actions_toolbar.dart';

class SongCanvasContent extends StatelessWidget {

  static MediaQueryData queryData;

  final String canvasUrl;
  final String albumArtUrl;
  final String songName;
  final String albumArtist;
  final double playerRatio;
  final double lastPlayerRatio;
  final Function togglePause;
  final bool paused;
  final Size navBarSize;

  SongCanvasContent(this.canvasUrl, this.albumArtUrl, this.songName,
      this.albumArtist, this.lastPlayerRatio, this.playerRatio,
      this.togglePause, this.paused, this.navBarSize);

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

  Widget _getPauseOverlay(context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return this.paused ? Container(
        width: queryData.size.width,
        height: queryData.size.height - queryData.viewPadding.top,
        color: Colors.black.withOpacity(0.4),
        child: Icon(Icons.play_arrow, size: 200, color: Colors.white.withOpacity(0.7))
    ) : Container(
      width: queryData.size.width,
      height: queryData.size.height - queryData.viewPadding.top,
      color: Colors.black.withOpacity(0.0),
    );
  }

  Widget _getCanvas() {
    if(Uri.parse(canvasUrl).pathSegments.contains("video")) {
      return VideoContent(canvasUrl, paused);
    } else {
      return Container(
        decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(canvasUrl),
          fit: BoxFit.cover,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Stack(
      children: [
        _getCanvas(),
        _getGradient(),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
            children: [
              SongDescription(this.albumArtUrl, this.songName, this.albumArtist),
              Container(height: this.navBarSize.height,)
            ]),
        GestureDetector(
            onTap: () => this.togglePause(true),
            child: _getPauseOverlay(context)),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              alignment: Alignment.bottomRight,
                child: ActionsToolbar()
            ),
            ContentProgressIndicator(this.lastPlayerRatio, this.playerRatio),
            Container(height: this.navBarSize.height,)
          ],
        ),
      ],
    );
  }
}