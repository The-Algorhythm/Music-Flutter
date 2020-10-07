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

  Widget get middleSection => Expanded(
    child: Row(
        mainAxisSize: MainAxisSize.max,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [SongDescription(), ActionsToolbar()]
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          VideoContent(),
          Column(
            children: [
              middleSection,
              BottomToolbar(),
            ],
          ),
        ],
      )
    );
  }
}
