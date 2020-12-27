import 'package:flutter/material.dart';
import 'package:music_app/model/user_profile.dart';
import 'package:music_app/settings.dart';
import 'package:music_app/app_icons.dart';
import 'package:music_app/widgets/liked_songs_overlay.dart';

import 'middleware.dart';
import 'model/song.dart';

class ProfilePage extends StatefulWidget {
  final Function overlayCallback;
  final Function clearOverlayCallback;

  ProfilePage(this.overlayCallback, this.clearOverlayCallback);
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  static MediaQueryData queryData;
  SpotifyProfile profile;

  static const String albumArtUrl = "https://i.scdn.co/image/ab67616d00001e02323b486defbe382273719626";
  List<Song> _likedSongs;
  bool _loading = true;


  @override
  void initState() {
    _fetchLikedSongs();
  }

  void _fetchLikedSongs() async {
    List<Song> res = await getLikedSongs();
    setState(() {
      _likedSongs = res;
      _loading = false;
    });
  }

  Widget _likedSongsSection(ctx) {
    if(_loading) {
      return Column(
        children: [
          Container(height: MediaQuery.of(ctx).size.height/6,),
          CircularProgressIndicator(
            strokeWidth: 5,
            valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC77DFF)),
          ),
        ],
      );
    } else {
      if(_likedSongs.length == 0) {
        return Padding(
          padding: const EdgeInsets.all(12.0),
          child: Text("You haven't liked any songs yet. When you do, you can review them here.",
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center),
        );
      } else {
        return Expanded(
          child: Padding(
            padding: const EdgeInsets.only(right: 8, left: 8),
            child: GridView.count(
              crossAxisCount: 4,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              children: List.generate(_likedSongs.length, (index) {
                return _getChild(index);
              }),
            ),
          ),
        );
      }
    }
  }

  Widget _topSection(ctx) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF3C096C), Color(0xFF10002B)],
        ),
      ),
      child: Stack(
          children: [
            Container(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: IconButton(icon: new Icon(Icons.settings,
                        size: 40.0,
                        color: Colors.white),
                    onPressed: (){_settingsPressed(ctx);},),
              ),),
            Container(
              width: double.infinity,
              height:  queryData.size.height / 3.5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    backgroundImage: NetworkImage(profile.picUrl),
                    radius: 50.0,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Text(profile.displayName,
                        style: new TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  )
                ],
              ),
            ),]
      ),
    );
  }

  Route settingsRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SettingsPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.5, 0.0);
        var end = Offset.zero;
        var tween = Tween(begin: begin, end: end);
        var offsetAnimation = animation.drive(tween);

        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    );
  }

  void _settingsPressed(ctx) {
    Navigator.push(ctx, settingsRoute());
  }

  Widget _getChild(index) {
    return Container(
      width: 50,
      height: 50,
      child: GestureDetector(
          onTap: (){_likedSongPressed(index);},
          child:Image.network(_likedSongs[index].albumArtUrl))
    );
  }

  void _likedSongPressed(idx) {
    widget.overlayCallback(LikedSongsOverlay(idx, _likedSongs, _clearOverlayWrapper));
  }

  void _clearOverlayWrapper(List<int> unlikedSongIdx) async {
    widget.clearOverlayCallback();
    setState(() {
      _loading = true;
    });
    for(final idx in unlikedSongIdx) {
      bool success = await interact(_likedSongs[idx], "unlike");
    }
    List<Song> newSongs = await getLikedSongs();
    setState(() {
      _likedSongs = newSongs;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext ctx) {
    queryData = MediaQuery.of(ctx);
    profile = SpotifyProfile();
    return Scaffold(
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _topSection(ctx),
          Expanded(
            child: Column(
              children: [
                Container(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 25, top: 25, bottom: 10),
                      child: Text("Liked Songs",
                          style: new TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                    )
                ),
                _likedSongsSection(ctx)
              ],
            ),
          ),
        ],
      ),
    );
  }

}