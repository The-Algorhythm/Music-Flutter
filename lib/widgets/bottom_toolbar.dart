import 'package:flutter/material.dart';
import 'package:music_app/app_icons.dart';

class BottomToolbar extends StatelessWidget {

  static const double iconContainerSize = 40.0;
  static const double bottomIconSize = 30.0;

  static Color activeColor = Colors.blue[300];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Divider(
            color: Colors.white,
            thickness: 0.5),
        Padding(
          padding: const EdgeInsets.only(bottom: 15.0, top: 5.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
  //          _getIcon(icon: MusicAppIcons.home, active: false),
              _getIcon(icon: MusicAppIcons.discover, active: true),
              _getIcon(icon: MusicAppIcons.profile, active: false),
            ],
        ),
      )]
    );
  }

  Widget _getIcon({IconData icon, bool active}) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: iconContainerSize, height: bottomIconSize-2,
            child: Icon(icon, size: bottomIconSize, color:
              active == true ? activeColor : Colors.grey[300]),
          ),
          (() {
            if(active) {
              return Padding(
                padding: const EdgeInsets.only(left: 5),
                child: Container(
                  width: 20, height: 10,
                  child: Icon(Icons.arrow_drop_up, size: bottomIconSize, color: activeColor),
                ),
              );
            } else {
              return Container(width: 20, height: 10,);
            }
          }())
        ],
      ),
    );
  }
}