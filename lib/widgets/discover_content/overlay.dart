import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/app_icons.dart';
import 'package:vector_math/vector_math.dart' as math;

class PostOverlay extends StatefulWidget {
  final OverlayType overlayType;
  final bool isPaused;

  PostOverlay(this.overlayType, {this.isPaused, Key key}): super(key: key);

  @override
  PostOverlayState createState() => PostOverlayState();
}

enum OverlayType {PAUSE, LIKE}

class PostOverlayState extends State<PostOverlay> with TickerProviderStateMixin {

  AnimationController animation;
  Animation<double> _fadeInFadeOut;
  Animation<double> _growShrink;

  Offset _likePosition = new Offset(0, 0);

  @override
  void initState() {
    super.initState();
    animation = AnimationController(vsync: this, duration: Duration(milliseconds: 200),);
    _fadeInFadeOut = Tween<double>(begin: 0.0, end: 0.8).animate(animation);
    _growShrink = Tween<double>(begin: 0.5, end: 1.5).animate(animation);

    animation.addStatusListener((status){
      if(status == AnimationStatus.completed){
        animation.reverse();
      }
    });
  }

  Widget _getPauseOverlay(context) {
    MediaQueryData queryData = MediaQuery.of(context);
    return widget.isPaused ? Container(
        width: queryData.size.width,
        height: queryData.size.height - queryData.viewPadding.top,
        color: Colors.black.withOpacity(0.4),
        child: Icon(Icons.play_arrow, size: 150, color: Colors.white.withOpacity(0.7))
    ) : Container(
      width: queryData.size.width,
      height: queryData.size.height - queryData.viewPadding.top,
      color: Colors.black.withOpacity(0.0),
    );
  }

  void like(Offset tapPosition) {
    setState(() {
      _likePosition = tapPosition;
    });
    animation.forward();
  }

  /// Generates a random integer that can be either positive or negative
  int _randPosNeg(int max) {
    var randomGenerator = Random();

    var positive = randomGenerator.nextBool();
    var randInt = randomGenerator.nextInt(max);
    return positive ? randInt : 0 - randInt;
  }

  Widget _getLikeOverlay(context, likePosition) {
    double iconSize = 75;
    return Positioned(
      top: likePosition.dy - iconSize/2,
      left: likePosition.dx - iconSize/2,
      child: Transform(
        transform: Matrix4.rotationZ(math.radians(_randPosNeg(30).toDouble())),
        child: FadeTransition(
          opacity: _fadeInFadeOut,
          child: ScaleTransition(
            scale: _growShrink,
            child: Icon(MusicAppIcons.heart, size: iconSize, color: Colors.red),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch(widget.overlayType) {
      case OverlayType.PAUSE:
        return _getPauseOverlay(context);
        break;
      case OverlayType.LIKE:
        return _getLikeOverlay(context, _likePosition);
        break;
    }
  }

  @override
  dispose() {
    animation.dispose();
    super.dispose();
  }

}