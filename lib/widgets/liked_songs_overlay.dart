import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:music_app/app_icons.dart';
import 'package:music_app/middleware.dart';
import 'package:music_app/model/song.dart';

class LikedSongsOverlay extends StatefulWidget {
  List<Song> likedSongs;
  final Function clearOverlayCallback;
  final int initialIndex;
  LikedSongsOverlay(this.initialIndex, this.likedSongs, this.clearOverlayCallback);

  @override
  _LikedSongsOverlayState createState() => _LikedSongsOverlayState();
}

class _LikedSongsOverlayState extends State<LikedSongsOverlay> {
  static MediaQueryData queryData;
  int _index;
  List<int> _unlikedSongIdxs;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _unlikedSongIdxs = new List();
  }

  Widget _swiper(context) {
    return Container(
        height: 265,
        width: queryData.size.width,
        child: new Swiper(
          index: _index,
          itemBuilder: (BuildContext context, int index) {
            return new Image.network(
              widget.likedSongs[index].albumArtUrl,
              fit: BoxFit.fill,
            );
          },
          loop: false,
          itemCount: widget.likedSongs.length,
          viewportFraction: 0.7,
          scale: 0.9,
          onIndexChanged: (index){
            setState(() {
              _index = index;
            });
          },
        ),
      );
  }

  Widget _getButtons(context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Wrap(
        spacing: 10,
        children: [
          IconButton(
            iconSize: 50,
            icon: Icon(MusicAppIcons.heart,
                color: _unlikedSongIdxs.contains(_index) ? Colors.white : Color(0xFFc77dff)),
            onPressed: (){_heartPressed();},
          ),
          IconButton(
            iconSize: 50,
            icon: Icon(MusicAppIcons.spotify, color: Colors.white),
            onPressed: () async {
              bool response = await interact(widget.likedSongs[_index], "open");
              widget.likedSongs[_index].openInSpotify();
            },
          ),
          IconButton(
            iconSize: 50,
            icon: Icon(MusicAppIcons.share, color: Colors.white),
            onPressed: () async {
              bool response = await interact(widget.likedSongs[_index], "share");
              widget.likedSongs[_index].share();
            },
          ),
        ],
      ),
    );
  }

  void _heartPressed() async {
    if(_unlikedSongIdxs.contains(_index)) {
      // we have already unliked it, so relike it
      bool success = await interact(widget.likedSongs[_index], "like");
      if(success) {
        setState(() {
          _unlikedSongIdxs.remove(_index);
        });
      } else {
        print("ERROR: could not like song");
      }
    } else {
      // We have liked it, so add it to the unliked songs list
      bool success = await interact(widget.likedSongs[_index], "unlike");
      if(success) {
        setState(() {
          _unlikedSongIdxs.add(_index);
        });
      } else {
        print("ERROR: could not unlike song");
      }
    }
  }

  Widget _getGradient() {
    return Container(
        height: queryData.size.height*0.3,
        decoration: BoxDecoration(
        color: Colors.white,
        gradient: LinearGradient(
          begin: FractionalOffset.topCenter,
          end: FractionalOffset.bottomCenter,
          colors: [
            Colors.black.withOpacity(0.0),
            Colors.black.withOpacity(0.6),
          ],
          stops: [
            0.0,
            1.0
          ])
        )
    );
  }

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
    Song song = widget.likedSongs[_index];
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
            alignment: Alignment.bottomRight,
            width: queryData.size.width,
            height: queryData.size.height - queryData.viewPadding.top,
            color: Colors.black.withOpacity(0.7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Container(
                      height: 45,
//                      color: Colors.red,
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: new Icon(Icons.close, color: Colors.white, size: 35),
                        onPressed: (){widget.clearOverlayCallback(_unlikedSongIdxs);},
                      )),
                ),
                Stack(
                  children: [
                    Container(
                      height: queryData.size.height - (65 + queryData.viewPadding.top),
                      alignment: Alignment.center,
                      padding: EdgeInsets.all(25.00),
                      child: Column(
                        children: [
                          Container(height: queryData.size.height*0.1,),
                          _swiper(context),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 5, top: 10),
                            child: Text(song.title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 20),),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 15, right: 15),
                            child: Text(song.album + " - " + song.artist,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 4,
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 18),),
                          ),
                        ],
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: _getGradient(),
                      ),
                    ),
                    Positioned.fill(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: _getButtons(context),
                      ),
                    )
                  ],
                ),
              ],
            ),
        ),
      ],
    );
  }

}