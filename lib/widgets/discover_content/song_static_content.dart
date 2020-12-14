import 'dart:ui';
import 'package:flutter/material.dart';

import 'package:music_app/widgets/discover_content/song_description.dart';
import 'package:music_app/widgets/discover_content/actions_toolbar.dart';

class SongStaticContent extends StatelessWidget {

  static MediaQueryData queryData;

  final String albumArtUrl;
  final String songName;
  final String albumArtist;

  SongStaticContent(this.albumArtUrl, this.songName, this.albumArtist);

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
                child: Image.network(albumArtUrl, scale: 0.1,),
            )
        ),
        ClipRect(  // <-- clips to the 200x200 [Container] below
          child: BackdropFilter(
            filter: ImageFilter.blur(
              sigmaX: 5.0,
              sigmaY: 5.0,
            ),
            child: Container(
              width: queryData.size.width,
              height: queryData.size.height,
              child: Container(color: Colors.black.withOpacity(0),)
            ),
          ),
        ),
        _getGradient()
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
                child: Image.network(albumArtUrl)),
          ),
        ),
        Text(songName, style: TextStyle(fontSize: 20),),
        Text(albumArtist, style: TextStyle(fontSize: 18),),
        Container(
          height: 67,
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
        _getMainSection(context),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ActionsToolbar(),
            Container(height: 65.0,),
          ],
        ),
      ],
    );
  }
}