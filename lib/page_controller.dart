import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/app_icons.dart';
import 'package:music_app/discover.dart';
import 'package:music_app/profile.dart';


class PagesHolder extends StatefulWidget {
  final initialSongs;

  PagesHolder(this.initialSongs);

  @override
  _PagesHolderState createState() => _PagesHolderState();
}

enum PageStatus { inactive, returning, active }

class _PagesHolderState extends State<PagesHolder> {

  static MediaQueryData queryData;
  int _currentIdx = 0;
  PageController _pageController = new PageController();
  PageStatus _discoverStatus = PageStatus.active;

  Widget overlay = Container();

  void setOverlay(Widget overlayWidget) {
    setState(() {
      overlay = overlayWidget;
    });
  }

  void clearOverlay() {
    setState(() {
      overlay = Container();
    });
  }


  List<Widget> _screens;

  void _onPageChanged(int idx) {
    setState(() {
      _currentIdx = idx;
      // Update Discover page status
      if(idx == 0) {
        // We are coming to the Discover page
        _discoverStatus = PageStatus.returning;
      } else {
        _discoverStatus = PageStatus.inactive;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _screens = [Discover(widget.initialSongs, _discoverStatus), ProfilePage(setOverlay, clearOverlay)];
    if(_discoverStatus == PageStatus.returning) {
      // if we are returning, change to active so we are only returning once
      setState(() {
        _discoverStatus = PageStatus.active;
      });
    }
    queryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(top: queryData.viewPadding.top),
            child: Stack(
                children: [
                  PageView(
                    controller: _pageController,
                    children: _screens,
                    onPageChanged: _onPageChanged,
                    physics: NeverScrollableScrollPhysics(),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child:
                    Theme(
                      data: Theme.of(context).copyWith(
  //                      canvasColor: _currentIdx == 0 ? Colors.transparent : Colors.blueGrey
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                        Divider(
                            height: 0,
                            color: Colors.white,
                            thickness: 0.5),
                        BottomNavigationBar(
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
                            setState(() {
                              _pageController.jumpToPage(index);
                            });
                          },
                        ),]
                      ),
                    ),
                  ),
                ]),
          ),
          overlay,
        ]),
    );
  }
}