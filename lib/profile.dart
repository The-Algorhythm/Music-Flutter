import 'package:flutter/material.dart';
import 'package:music_app/model/user_profile.dart';
import 'package:music_app/settings.dart';
import 'package:music_app/app_icons.dart';
import 'package:music_app/widgets/liked_songs_overlay.dart';

class ProfilePage extends StatelessWidget {

  static MediaQueryData queryData;
  SpotifyProfile profile;
  final Function overlayCallback;
  final Function clearOverlayCallback;

  static const String albumArtUrl = "https://i.scdn.co/image/ab67616d00001e02323b486defbe382273719626";
  List<String> likedSongs = List.generate(100, (index) {
    return albumArtUrl;
  });

  ProfilePage(this.overlayCallback, this.clearOverlayCallback);

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
          child:Image.network(albumArtUrl))
    );
  }

  void _likedSongPressed(idx) {
    overlayCallback(LikedSongsOverlay(idx, likedSongs, clearOverlayCallback));
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
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(right: 8, left: 8),
                    child: GridView.count(
                      crossAxisCount: 4,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      children: List.generate(100, (index) {
                        return _getChild(index);
                      }),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}