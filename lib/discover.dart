import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/widgets/discover_content/music_player.dart';
import 'package:music_app/page_controller.dart';
import 'package:music_app/widgets/discover_content_manager.dart';

import 'middleware.dart';
import 'model/song.dart';

class Discover extends StatefulWidget {
  PageStatus discoverStatus;
  final List<Song> initialSongs;
  final Size navBarSize;

  Discover(this.initialSongs, this.discoverStatus, this.navBarSize);

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
  int _currentIdx = 0;
  bool _fetchingSongs = false;

  static const int maxSongs = 200;
  static const double preloadBuffer = 10;  // The minimum number of unseen posts to try to maintain

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
    });
    await _musicPlayer.stop();
    await _musicPlayer.play(_songs[_currentIdx].previewUrl);

    //Fetch more songs if there are only a few left in the buffer
    if(_currentIdx >= (_songs.length - preloadBuffer) && !_fetchingSongs) {
      print("Fetching more songs to keep buffer...");
      _fetchingSongs = true;
      List<Song> songs = await getRecommendations(numSongs: 50);
      setState(() {
        _songs.addAll(songs);
      });
      _fetchingSongs = false;
    }
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

  Future<List<Song>> _onRefresh() async {
    print("Discover onRefresh");
    if(!_fetchingSongs) {
      // Initially get a small amount of songs to reduce load time
      _fetchingSongs = true;
      List<Song> songs = await getRecommendations(numSongs: 20);
      setState(() {
        _songs = songs;
        _currentIdx = 0;
      });
      _onPageChanged(0);
      _fetchingSongs = false;
    }
    return _songs;
  }

  Future<List<Song>> _onLoadMore() async {
    print("Discover onLoadMore");
    if(!_fetchingSongs) {
      _fetchingSongs = true;
      List<Song> songs = await getRecommendations(numSongs: 50);
      setState(() {
        _songs.addAll(songs);
      });
      if(_songs.length > maxSongs && (_currentIdx > maxSongs - _songs.length)) {
        // Remove songs far back in list so we don't need to keep track of too many
        int cutoff = maxSongs - _songs.length;
        List<Song> sublist = _songs.sublist(cutoff);
        setState(() {
          _songs = sublist;
          _currentIdx -= cutoff;
        });
      }
      _fetchingSongs = false;
    }
    return _songs;
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
    return ContentManager(_songs, _lastPlayerRatio, _playerRatio, _togglePause,
        _onPageChanged, _onRefresh, _onLoadMore, _paused, widget.navBarSize);
  }

  @override
  void dispose() {
    _musicPlayer.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;
}
