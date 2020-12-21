import 'package:flutter/cupertino.dart';
import 'package:music_app/model/song.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';

import 'discover_content/song_canvas_content.dart';
import 'discover_content/song_static_content.dart';

class ContentManager extends StatefulWidget {
  final List<Song> initialSongs;

  final double lastPlayerRatio;
  final double playerRatio;
  final Function togglePause;
  final Function onPageChanged;
  final Function onRefresh;
  final Function onLoadMore;
  final bool paused;
  final Size navBarSize;

  ContentManager(this.initialSongs, this.lastPlayerRatio, this.playerRatio,
      this.togglePause, this.onPageChanged, this.onRefresh, this.onLoadMore,
      this.paused, this.navBarSize);

  @override
  _ContentManagerState createState() => _ContentManagerState();
}

class _ContentManagerState extends State<ContentManager> {
  List<Song> _songs;
  int _lastReportedPage = 0;
  int _currentIdx = 0;
  final PageController _pageController = PageController();
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    setState(() {
      _songs = widget.initialSongs;
    });
  }

  List<Widget> _getSongContentPages() {
    return List.generate(_songs.length,(i){
      Song song = _songs[i];
      String albumArtist = song.album + " - " + song.artist;
      if(song.canvasUrl != null) {
        return SongCanvasContent(song.canvasUrl, song.albumArtUrl, song.title,
            albumArtist, widget.lastPlayerRatio, widget.playerRatio,
            widget.togglePause, widget.paused, widget.navBarSize);
      } else {
        return SongStaticContent(song.albumArtUrl, song.title, albumArtist,
            widget.lastPlayerRatio, widget.playerRatio, widget.togglePause,
            widget.paused, widget.navBarSize);
      }
    });
  }

  void _onRefresh() async {
    List<Song> songs = await widget.onRefresh();
    setState(() {
      _songs = songs;
    });
    _refreshController.refreshToIdle();
  }

  void _onLoadMore() async {
    List<Song> songs = await widget.onLoadMore();
    setState(() {
      _songs = songs;
    });
    _refreshController.loadComplete();
  }

  void _onPageChanged(idx) {
    setState(() {
      _currentIdx = idx;
    });
    widget.onPageChanged(idx);
  }

  bool _handleNotification(ScrollNotification notification) {
    if (notification.depth == 0 &&
        notification is ScrollUpdateNotification) {
      if (notification.metrics is PageMetrics) {
        final PageMetrics metrics = notification.metrics as PageMetrics;
        final int currentPage = metrics.page.round();
        if (currentPage != _lastReportedPage) {
          _lastReportedPage = currentPage;
          _onPageChanged(currentPage);
        }
      }
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return NotificationListener(
      onNotification: _handleNotification,
      child: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        scrollDirection: Axis.vertical,
        header: ClassicHeader(),
        footer: ClassicFooter(),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoadMore,
        child: CustomScrollView(
          physics: PageScrollPhysics(),
          controller: _pageController,
          slivers: <Widget>[
            SliverFillViewport(
                delegate: SliverChildListDelegate(_getSongContentPages())
            )],
        ),
      ),
    );
  }
}