import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/widgets/song_description.dart';
import 'package:music_app/widgets/actions_toolbar.dart';
import 'package:music_app/widgets/bottom_toolbar.dart';

/// Empty page widget fo developers that want to follow along with the tutorial
/// on breaking down and implementing the Tik Tok UI (BLOG_LINK)
class Home extends StatelessWidget {

  Widget get topSection => Container(
    height: 100.0,
    color: Colors.yellow[300],
  );



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
      body: Column(
        children: [
          topSection,
          middleSection,
          BottomToolbar()
        ],
      )
    );
  }
}
