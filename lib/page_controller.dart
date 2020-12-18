import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/discover.dart';
import 'package:music_app/profile.dart';
import 'package:music_app/widgets/bottom_navbar.dart';
import 'package:music_app/widgets/widget_size.dart';


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
  Size _navBarSize = Size(0, 0);

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

  void onNavBarTap(index) {
    setState(() {
      _pageController.jumpToPage(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    _screens = [
      Discover(widget.initialSongs, _discoverStatus, _navBarSize),
      ProfilePage(setOverlay, clearOverlay)];
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
                        WidgetSize(
                          onChange: (Size size) {
                            setState(() {
                              _navBarSize = new Size(size.width, size.height-1);
                            });
                          },
                          child: AppNavBar(_currentIdx, this.onNavBarTap),
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