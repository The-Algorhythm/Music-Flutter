import 'package:flutter/material.dart';
import 'package:music_app/app_icons.dart';

class BottomToolbar extends StatelessWidget {

  static const double bottomIconSize = 30.0;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Icon(MusicAppIcons.home, size: bottomIconSize, color: Colors.grey[300]),
        Icon(MusicAppIcons.discover, size: bottomIconSize, color: Colors.grey[300]),
        Icon(MusicAppIcons.profile, size: bottomIconSize, color: Colors.grey[300]),
      ],
    );
  }
}