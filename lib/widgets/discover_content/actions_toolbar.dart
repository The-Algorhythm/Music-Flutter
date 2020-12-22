import 'package:flutter/material.dart';
import 'package:music_app/app_icons.dart';

class ActionsToolbar extends StatelessWidget {

  static const double iconContainerSize = 60.0;
  static const double iconSize = 35.0;

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context);
    return Container(  // Top section
      width: 100.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _getAction(icon: MusicAppIcons.heart),
          _getAction(icon: MusicAppIcons.spotify),
          _getAction(icon: MusicAppIcons.share),
          _getAction(icon: Icons.more_horiz, size: 40.0),
          Container(height: queryData.size.height / 3.75,)
        ])
    );
  }

  Widget _getAction({IconData icon, double size=iconSize}) {
    return Container(
      width: iconContainerSize, height: iconContainerSize,
      child: Icon(icon, size: size, color: Colors.white),
    );
  }
}