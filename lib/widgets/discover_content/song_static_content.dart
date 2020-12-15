import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:music_app/widgets/discover_content/actions_toolbar.dart';
import 'package:music_app/widgets/discover_content/progress_indicator.dart';

class SongStaticContent extends StatefulWidget {
  final String albumArtUrl;
  final String songName;
  final String albumArtist;
  final double playerRatio;
  final double lastPlayerRatio;
  final Function togglePause;
  final bool paused;

  SongStaticContent(this.albumArtUrl, this.songName, this.albumArtist,
      this.lastPlayerRatio, this.playerRatio, this.togglePause, this.paused);

  @override
  _SongStaticContentState createState() => _SongStaticContentState();
}

class _SongStaticContentState extends State<SongStaticContent> {

  static MediaQueryData queryData;

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

  Widget _getBlur() {
    return Stack(
      children: [
        OverflowBox(
            maxWidth: double.infinity,
            maxHeight: double.infinity,
            alignment: Alignment.center,
            child: new Container(
                width: 2*queryData.size.width,
                height: queryData.size.height-queryData.viewPadding.top,
                child: Image.network(widget.albumArtUrl, scale: 0.1,),
            )
        ),
        ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 10.0,
              sigmaY: 10.0,
            ),
            child: Container(
              width: queryData.size.width,
              height: queryData.size.height,
              child: Container(color: Colors.black.withOpacity(0),)
            ),
          ),
        )
      ],
    );
  }

  Widget _getMainSection(context) {
    queryData = MediaQuery.of(context);
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Container(
                width: queryData.size.width*0.75,
                child: Image.network(widget.albumArtUrl)),
          ),
        ),
        Text(widget.songName, style: TextStyle(fontSize: 20),),
        Text(widget.albumArtist, style: TextStyle(fontSize: 18),),
        Container(
          height: 67,
        )
      ],
    );
  }

  Widget _getPauseOverlay(context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return widget.paused ? Container(
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

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Stack(
      children: [
        _getBlur(),
        _getGradient(),
        _getMainSection(context),
        GestureDetector(
            onTap: () => widget.togglePause(),
            child: _getPauseOverlay(context)),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ActionsToolbar(),
            ContentProgressIndicator(widget.lastPlayerRatio, widget.playerRatio),
            Container(height: 67.0,),
          ],
        ),
      ],
    );
  }
}