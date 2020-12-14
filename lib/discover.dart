import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/widgets/discover_content/song_canvas_content.dart';
import 'package:music_app/widgets/discover_content/song_static_content.dart';

class Discover extends StatefulWidget {
  @override
  _DiscoverState createState() => _DiscoverState();
}

class _DiscoverState extends State<Discover> with AutomaticKeepAliveClientMixin {

  static const String videoUrl = "https://canvaz.scdn.co/upload/artist/2oqwwcM17wrP9hBD25zKSR/video/e78b962d504b4c5ba2177304d324d876.cnvs.mp4";
  static const String albumArtUrl = "https://i.scdn.co/image/ab67616d00001e02323b486defbe382273719626";
  static const String songName = "TV";
  static const String albumArtist = "AUGUST - Lewis Del Mar";

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return PageView(
      scrollDirection: Axis.vertical,
      children: List.generate(5, (index) =>
//          SongCanvasContent(videoUrl, albumArtUrl, songName+index.toString(), albumArtist)
          SongStaticContent(albumArtUrl, songName+index.toString(), albumArtist)
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
