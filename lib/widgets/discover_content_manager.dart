import 'package:flutter/cupertino.dart';
import 'package:music_app/model/song.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter/material.dart';

import 'discover_content/song_canvas_content.dart';
import 'discover_content/song_static_content.dart';

import 'package:music_app/discover.dart';

class ContentManager extends StatefulWidget {
  final List<Song> initialSongs;

  final double lastPlayerRatio;
  final double playerRatio;
  final String playingUrl;
  final Function onInteraction;
  final bool paused;
  final bool likedCurrentSong;
  final Size navBarSize;

  ContentManager(this.initialSongs, this.lastPlayerRatio, this.playerRatio,
  this.playingUrl, this.onInteraction, this.paused, this.likedCurrentSong,
  this.navBarSize, {Key key}) : super(key: key);

  @override
  ContentManagerState createState() => ContentManagerState();
}

class ContentManagerState extends State<ContentManager> {
  List<Song> _songs;
  int _lastReportedPage = 0;
  int _currentIdx = 0;
  final PageController _pageController = PageController();
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);
  static const double preloadBuffer = 15;  // The minimum number of unseen posts to try to maintain
  bool _doJump = false;

  // the Unix timestamp for when loadMore can be called again. Used to prevent it being called twice in a row
  int loadMoreTime = -1;

  @override
  void initState() {
    super.initState();
    setState(() {
      _songs = widget.initialSongs;
    });
  }

 void jumpToTop() {
    setState(() {
      _currentIdx = 0;
      _doJump = true;
    });
 }

  List<Widget> _getSongContentPages(songs) {
    return List.generate(songs.length,(i){
      Song song = songs[i];
      String albumArtist = song.album + " - " + song.artist;
      double lastPlayerRatio = widget.lastPlayerRatio;
      double playerRatio = widget.playerRatio;
      bool likedSong = (_currentIdx == i) && (widget.likedCurrentSong);
      if(widget.playingUrl != song.previewUrl) {
        lastPlayerRatio = 0.0;
        playerRatio = 0.0;
      }
      if(song.canvasUrl != null && song.canvasUrl != "") {
        return SongCanvasContent(song.canvasUrl, song.albumArtUrl, song.title,
            albumArtist, lastPlayerRatio, playerRatio, widget.onInteraction,
            widget.paused, likedSong, widget.navBarSize);
      } else {
        return SongStaticContent(song.albumArtUrl, song.title, albumArtist,
            lastPlayerRatio, playerRatio, widget.onInteraction, widget.paused,
            likedSong, widget.navBarSize);
      }
    });
  }

  void _onRefresh() async {
    List<Song> songs = await widget.onInteraction(Interaction.REFRESH);
    setState(() {
      _songs = songs;
    });
    _refreshController.refreshToIdle();
  }

  void _onLoadMore() async {
    int timestamp = DateTime.now().millisecondsSinceEpoch;
    if(timestamp >= loadMoreTime) {
      Map<String, dynamic> response = await widget.onInteraction(Interaction.LOAD_MORE);
      setState(() {
        _songs = response["songs"];
        _currentIdx = response["currentIdx"];
        _doJump = true;
      });
      _refreshController.loadComplete();
      loadMoreTime = DateTime.now().millisecondsSinceEpoch + 500;
    } else {
      // This should only happen when the discover.dart's onLoadMore removes songs
      _refreshController.loadComplete();
      ScrollPosition position = _pageController.position;
      double offset = position.maxScrollExtent % position.viewportDimension;
      double newPos = (_currentIdx - 1) * position.viewportDimension;
      _pageController.jumpTo(newPos + offset);
      setState(() {
        _currentIdx++;
        _doJump = true;
      });
    }
  }

  void _onPageChanged(idx) async {
    setState(() {
      _currentIdx = idx;
    });
    widget.onInteraction(Interaction.CHANGE_PAGE, idx: idx);
    //Fetch more songs if there are only a few left in the buffer
    if (_currentIdx >= (_songs.length - preloadBuffer)) {
      print("Fetching more songs to keep buffer...");
      Map<String, dynamic> response = await widget.onInteraction(Interaction.LOAD_MORE);
      setState(() {
        _songs = response["songs"];
        _currentIdx = response["currentIdx"] - 1;
      });
    }
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
    if(_doJump) {
      _pageController.animateToPage(_currentIdx, duration: Duration(milliseconds: 500), curve: Curves.ease);
      _doJump = false;
    }
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
                delegate: SliverChildListDelegate(_getSongContentPages(_songs))
            )],
        ),
      ),
    );
  }
}