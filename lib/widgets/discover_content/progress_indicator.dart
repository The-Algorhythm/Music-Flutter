import 'dart:math';

import 'package:flutter/material.dart';

class ContentProgressIndicator extends StatefulWidget {
  double playerRatio;
  double lastPlayerRatio;
  ContentProgressIndicator(this.lastPlayerRatio, this.playerRatio);
  @override
  _ContentProgressIndicatorState createState() => _ContentProgressIndicatorState();
}

class _ContentProgressIndicatorState extends State<ContentProgressIndicator> with TickerProviderStateMixin {

  AnimationController _durationController;
  MediaQueryData queryData;

  @override
  void initState() {
    _initAnimation();
    super.initState();
  }

  void _initAnimation() {
    _durationController = new AnimationController(
      vsync: this,
      duration: new Duration(
        milliseconds: 170,
      )
    );
    _durationController.forward();
  }

  double indentValue(animationValue, begin, end) {
    double distance = end-begin;
    double result = begin + distance.abs()*animationValue;
    if(result == null || result < 0) {
      return 0;
    } else {
      return result;
    }
  }

  AnimatedBuilder _getProgressIndicator(context) {
    queryData = MediaQuery.of(context);
    return new AnimatedBuilder(
        animation: _durationController,
        builder: (context, child) {
          return Divider(
              height: 0,
              endIndent: queryData.size.width - min(queryData.size.width,
                      indentValue(_durationController.value,
                          queryData.size.width*widget.lastPlayerRatio,
                          queryData.size.width*widget.playerRatio)),
              color: Color(0xFFc77dff),
              thickness: 1.5);
        });
  }

  @override
  Widget build(BuildContext context) {
    if(widget.playerRatio == null) {
      widget.playerRatio = 0;
    }
    if(widget.lastPlayerRatio == null) {
      widget.lastPlayerRatio = 0;
    }
    _initAnimation();
    return _getProgressIndicator(context);
  }

  @override
  dispose() {
    _durationController.dispose();
    super.dispose();
  }
}