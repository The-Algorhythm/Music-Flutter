import 'package:flutter/material.dart';
import 'package:music_app/app_icons.dart';

class ActionsToolbar extends StatelessWidget {

  static const double iconContainerSize = 60.0;
  static const double iconSize = 35.0;

  @override
  Widget build(BuildContext context) {
    return Container(  // Top section
      width: 100.0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _getAction(icon: MusicAppIcons.heart),
          _getAction(icon: MusicAppIcons.spotify),
          _getAction(icon: MusicAppIcons.share),
          _getAction(icon: MusicAppIcons.more),
        ])
    );
  }

  Widget _getAction({IconData icon}) {
    return Container(
      width: iconContainerSize, height: iconContainerSize,
      child: Icon(icon, size: iconSize, color: Colors.grey[300]),
    );
  }
}