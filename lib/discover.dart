import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/widgets/bottom_toolbar.dart';
import 'package:music_app/widgets/discover_content.dart';

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> {

  static MediaQueryData queryData;

  static const String videoUrl = "https://canvaz.scdn.co/upload/artist/2oqwwcM17wrP9hBD25zKSR/video/e78b962d504b4c5ba2177304d324d876.cnvs.mp4";
  static const String albumArtUrl = "https://i.scdn.co/image/ab67616d00001e02323b486defbe382273719626";
  static const String songName = "TV";
  static const String albumArtist = "AUGUST - Lewis Del Mar";

  Widget _getDiscoverPage() {

    return PageView(
      scrollDirection: Axis.vertical,
      children: List.generate(5, (index) =>
          DiscoverContent(videoUrl, albumArtUrl, songName, albumArtist)
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Padding(
        padding: EdgeInsets.only(top: queryData.viewPadding.top),
        child: Stack(
          children: [
            _getDiscoverPage(),
            BottomToolbar(),
          ]),
        ),
      );
  }
}
