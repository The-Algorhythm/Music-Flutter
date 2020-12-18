import 'package:flutter/material.dart';
import 'package:music_app/app_icons.dart';

class AppNavBar extends StatelessWidget {
  final _currentIdx;
  final Function onTap;

  const AppNavBar(this._currentIdx, this.onTap);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: _currentIdx == 0 ? Colors.transparent : Color(0xFF101010),
      type: BottomNavigationBarType.fixed,
      currentIndex: _currentIdx,
      iconSize: 27.0,
      selectedFontSize: 14.0,
      unselectedFontSize: 14.0,
      elevation: 0,
      selectedItemColor: Color(0xFFc77dff),
      items: [
        BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 3),
              child: Icon(MusicAppIcons.discover),
            ),
            title: Text("Discover")),
        BottomNavigationBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(top: 6, bottom: 3),
              child: Icon(MusicAppIcons.profile),
            ),
            title: Text("Profile")),
      ],
      onTap: (index) {
        this.onTap(index);
      },
    );
  }
}