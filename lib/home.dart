import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/widgets/song_description.dart';
import 'package:music_app/widgets/actions_toolbar.dart';
import 'package:music_app/widgets/bottom_toolbar.dart';
import 'package:music_app/widgets/video_content.dart';

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {

  MediaQueryData queryData;

  Widget get middleSection => Expanded(
    child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [SongDescription(), ActionsToolbar()]
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
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          VideoContent(),
          Stack(
            children: [
              _getGradient(),
              Column(
                children: [
                  middleSection,
                  BottomToolbar(),
                ],
              ),
            ],
          ),
        ],
      )
    );
  }
}
