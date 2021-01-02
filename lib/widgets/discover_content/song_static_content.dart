import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:music_app/discover.dart';
import 'package:music_app/widgets/discover_content/actions_toolbar.dart';
import 'package:music_app/widgets/discover_content/overlay.dart';
import 'package:music_app/widgets/discover_content/progress_indicator.dart';

class SongStaticContent extends StatefulWidget {
  final String albumArtUrl;
  final String songName;
  final String albumArtist;
  final double playerRatio;
  final double lastPlayerRatio;
  final Function onInteraction;
  final bool paused;
  final bool likedCurrentSong;
  final Size navBarSize;

  SongStaticContent(this.albumArtUrl, this.songName, this.albumArtist,
      this.lastPlayerRatio, this.playerRatio, this.onInteraction, this.paused,
      this.likedCurrentSong, this.navBarSize);
  @override
  _SongStaticContentState createState() => _SongStaticContentState();
}

class _SongStaticContentState extends State<SongStaticContent> {

  final GlobalKey<PostOverlayState> _likeOverlayState = GlobalKey<PostOverlayState>();
  Widget _likeOverlay;
  final GlobalKey<ActionsToolbarState> _actionsToolbarState = GlobalKey<ActionsToolbarState>();

  static MediaQueryData queryData;

  @override
  void initState() {
    super.initState();
    _likeOverlay = PostOverlay(OverlayType.LIKE, key: _likeOverlayState);
  }

  Widget _getVerticalGradient() {
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

  Widget _getHorizontalGradient() {
    return Container(
      height: queryData.size.height,
      decoration: BoxDecoration(
          color: Colors.white,
          gradient: LinearGradient(
              begin: FractionalOffset.centerLeft,
              end: FractionalOffset.centerRight,
              colors: [
                Colors.black.withOpacity(0.0),
                Colors.black.withOpacity(0.1),
                Colors.black.withOpacity(0.3),
              ],
              stops: [
                0.0,
                0.7,
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
          child: Container(
              width: queryData.size.width*0.75,
              child: Image.network(widget.albumArtUrl)),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5),
          child: Text(widget.songName,
            overflow: TextOverflow.ellipsis,
            maxLines: 7,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 20),),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15, right: 15),
          child: Text(widget.albumArtist,
            overflow: TextOverflow.ellipsis,
            maxLines: 4,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18),),
        ),
        Container(
          height: widget.navBarSize.height,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Stack(
      children: [
        _getBlur(),
        _getVerticalGradient(),
        _getMainSection(context),
        _getHorizontalGradient(),
        GestureDetector(
            onTap: (){widget.onInteraction(Interaction.PAUSE, byUser: true);},
            onDoubleTap: () async {
              _likeOverlayState.currentState.like();
              bool success = await widget.onInteraction(Interaction.LIKE);
              if(success) {
                _actionsToolbarState.currentState.externalLike();
              }
            },
            child: Stack(
              children: [
                PostOverlay(OverlayType.PAUSE, isPaused: widget.paused),
                _likeOverlay,
              ],
            )),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: ActionsToolbar(
                  widget.onInteraction,
                  widget.likedCurrentSong,
                  key: _actionsToolbarState),
            ),
            ContentProgressIndicator(widget.lastPlayerRatio, widget.playerRatio),
            Container(height: widget.navBarSize.height,),
          ],
        ),
      ],
    );
  }
}