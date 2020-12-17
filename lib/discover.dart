import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/widgets/discover_content/music_player.dart';
import 'package:music_app/widgets/discover_content/song_canvas_content.dart';
import 'package:music_app/widgets/discover_content/song_static_content.dart';
import 'package:music_app/page_controller.dart';

import 'model/song.dart';

class Discover extends StatefulWidget {
  PageStatus discoverStatus;
  final List<Song> initialSongs;

  Discover(this.initialSongs, this.discoverStatus);

  @override
  _DiscoverState createState() => _DiscoverState();
}

enum PlayerState { stopped, playing, paused }

class _DiscoverState extends State<Discover> with AutomaticKeepAliveClientMixin {

  MusicPlayer _musicPlayer;
  double _playerRatio;
  double _lastPlayerRatio;
  bool _paused = false;
  bool _userPaused = false;
  Duration _lastUpdate = Duration(seconds: 0);
  Widget overlay = Container();
  List<Song> _songs;
  int _currentIdx;

  @override
  void initState() {
    super.initState();
    setState(() {
      _songs = widget.initialSongs;
    });
    _musicPlayer = MusicPlayer(_songs[0].previewUrl, _onAudioPositionChanged);
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
    setState(() {
      _paused = false;
      _currentIdx = idx;
      print("Setting current index to: $_currentIdx");
    });
    await _musicPlayer.stop();
    await _musicPlayer.play(_songs[_currentIdx].previewUrl);
    print("Playing song with index: $_currentIdx");
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

  void _togglePause(bool pausedByUser) {
    setState(() {
      _paused = !_paused;
      if(pausedByUser) {
        _userPaused = _paused;
      }
    });
    if(_paused) {
      _musicPlayer.pause();
    } else {
      _musicPlayer.play(_musicPlayer.currentUrl);
      clearOverlay();
    }
  }

  List<Widget> _getSongContentPages() {
    return List.generate(_songs.length,(i){
      Song song = _songs[i];
      String albumArtist = song.album + " - " + song.artist;
      if(song.canvasUrl != null) {
        return SongCanvasContent(song.canvasUrl, song.albumArtUrl, song.title,
            albumArtist, _lastPlayerRatio, _playerRatio, _togglePause, _paused);
      } else {
        return SongStaticContent(song.albumArtUrl, song.title, albumArtist,
            _lastPlayerRatio, _playerRatio, _togglePause, _paused);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    if(_paused && !_userPaused && widget.discoverStatus == PageStatus.returning) {
      _togglePause(false);
      widget.discoverStatus = PageStatus.active;
    } else if(!_paused && widget.discoverStatus == PageStatus.inactive) {
      _togglePause(false);
    }
    return PageView(
      scrollDirection: Axis.vertical,
      onPageChanged: _onPageChanged,
      children: _getSongContentPages()
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
