import 'package:flutter/material.dart';
import 'package:music_app/app_icons.dart';
import 'package:music_app/discover.dart';
import 'package:like_button/like_button.dart';

class ActionsToolbar extends StatefulWidget {
  final Function onInteraction;
  bool likedCurrentSong;

  ActionsToolbar(this.onInteraction, this.likedCurrentSong, {Key key}): super(key: key);
  @override
  ActionsToolbarState createState() => ActionsToolbarState();
}

class ActionsToolbarState extends State<ActionsToolbar> {

  static const double iconContainerSize = 60.0;
  static const double iconSize = 35.0;
  final GlobalKey<LikeButtonState> _likeButtonState = GlobalKey<LikeButtonState>();

  @override
  Widget build(BuildContext context) {
    var queryData = MediaQuery.of(context);
    return Container(  // Top section
      width: 100.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          _getLike(MusicAppIcons.heart),
          _getAction(icon: MusicAppIcons.spotify),
          _getAction(icon: MusicAppIcons.share),
          _getAction(icon: Icons.more_horiz, size: 40.0),
          Container(height: queryData.size.height / 3.75,),
        ])
    );
  }

  Widget _getLike(IconData icon) {
    return LikeButton(
      key: _likeButtonState,
      size: iconContainerSize,
      circleColor:
      CircleColor(start: Color(0xFFc77dff), end: Color(0xFFAF47FF)),
      bubblesColor: BubblesColor(
        dotPrimaryColor: Color(0xFFc77dff),
        dotSecondaryColor: Color(0xFFAF47FF),
      ),
      likeBuilder: (bool isLiked) {
        return Icon(
          icon,
          color: widget.likedCurrentSong ? Color(0xFFc77dff) : Colors.white,
          size: iconSize,
        );
      },
      onTap: _onLikeButtonTapped,
      isLiked: widget.likedCurrentSong,
    );
  }

  Future<bool> _onLikeButtonTapped(bool isLiked) async {
    bool success;
    if(widget.likedCurrentSong) {
      success = await widget.onInteraction(Interaction.UNLIKE);
    } else {
      success = await widget.onInteraction(Interaction.LIKE);
    }
    if(success) {
      setState(() {
        widget.likedCurrentSong = !widget.likedCurrentSong;
      });
    }
    return widget.likedCurrentSong;
  }

  void externalLike() {
    widget.likedCurrentSong = false;  // Set it to false initially so it will be set to true when onTap is called
    _likeButtonState.currentState.onTap();
    setState(() {
      widget.likedCurrentSong = true;
    });
  }

  Widget _getAction({IconData icon, double size=iconSize, Color color=Colors.white}) {
    return Container(
      width: iconContainerSize, height: iconContainerSize,
      child: IconButton(
          icon: Icon(icon, size: size, color: color),
          onPressed: (){externalLike();},
      ),
    );
  }
}