import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/widgets/discover_content/music_player.dart';
import 'package:music_app/widgets/discover_content/song_canvas_content.dart';
import 'package:music_app/widgets/discover_content/song_static_content.dart';
import 'package:music_app/page_controller.dart';

class Discover extends StatefulWidget {
  PageStatus discoverStatus;

  Discover(this.discoverStatus);

  @override
  _DiscoverState createState() => _DiscoverState();
}

enum PlayerState { stopped, playing, paused }

class _DiscoverState extends State<Discover> with AutomaticKeepAliveClientMixin {

  static const String videoUrl = "https://canvaz.scdn.co/upload/artist/2oqwwcM17wrP9hBD25zKSR/video/e78b962d504b4c5ba2177304d324d876.cnvs.mp4";
  static const String albumArtUrl = "https://i.scdn.co/image/ab67616d00001e02323b486defbe382273719626";
  static const String songName = "TV";
  static const String albumArtist = "AUGUST - Lewis Del Mar";
  static const String previewUrl = "https://p.scdn.co/mp3-preview/d5cb79333f29ec36a9a163dfc65a62ca142bb5e2?cid=a46f5c5745a14fbf826186da8da5ecc3";

  MusicPlayer _musicPlayer;
  double _playerRatio;
  double _lastPlayerRatio;
  bool _paused = false;
  Duration _lastUpdate = Duration(seconds: 0);
  Widget overlay = Container();

  @override
  void initState() {
    super.initState();
    _musicPlayer = MusicPlayer(previewUrl, _onAudioPositionChanged);
    _musicPlayer.initAudioPlayer();
  }

  void _onAudioPositionChanged(Duration p) {
    if(p != null && (p.inMilliseconds >= _lastUpdate.inMilliseconds + 190 || p.inMilliseconds < _lastUpdate.inMilliseconds)) {
      setState(() {
        _playerRatio = min(1.0,
            max(0.0, p.inMilliseconds / _musicPlayer.duration.inMilliseconds));
        _lastPlayerRatio = min(1.0, max(0.0,
            _lastUpdate.inMilliseconds / _musicPlayer.duration.inMilliseconds));
        _lastUpdate = p;
      });
    }
  }


  void _onPageChanged(int idx) async {
    await _musicPlayer.stop();
    await _musicPlayer.play(previewUrl);
  }

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

  void _togglePause() {
    setState(() {
      _paused = !_paused;
    });
    if(_paused) {
      _musicPlayer.pause();
    } else {
      _musicPlayer.play(_musicPlayer.currentUrl);
      clearOverlay();
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(_paused && widget.discoverStatus == PageStatus.returning) {
      _togglePause();
      widget.discoverStatus = PageStatus.active;
    } else if(!_paused && widget.discoverStatus == PageStatus.inactive) {
      _togglePause();
    }
    return PageView(
      scrollDirection: Axis.vertical,
      onPageChanged: _onPageChanged,
      children: List.generate(5, (index) =>
          SongCanvasContent(videoUrl, albumArtUrl, songName+index.toString(),
              albumArtist, _lastPlayerRatio, _playerRatio, _togglePause, _paused))
//      SongStaticContent(albumArtUrl, songName+index.toString(), albumArtist,
//          _lastPlayerRatio, _playerRatio, _togglePause, _paused))
    );
  }

  @override
  void dispose() {
    _musicPlayer.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
