import 'package:flutter/material.dart';

class ContentProgressIndicator extends StatefulWidget {
  @override
  _ContentProgressIndicatorState createState() => _ContentProgressIndicatorState();
}

class _ContentProgressIndicatorState extends State<ContentProgressIndicator> with TickerProviderStateMixin {

  AnimationController _durationController;
  MediaQueryData queryData;

  @override
  void initState() {
    _durationController = new AnimationController(
      vsync: this,
      duration: new Duration(
        milliseconds: 30*1000,
      ),
    );
    _durationController.addStatusListener((animationStatus) {
      switch (animationStatus) {
        case AnimationStatus.completed:
          _durationController.value = 0;
          _durationController.forward();
          break;
        case AnimationStatus.dismissed:
          break;
        case AnimationStatus.forward:
          break;
        case AnimationStatus.reverse:
          break;
      }
    });
    _durationController.forward();
    super.initState();
  }

  AnimatedBuilder _getProgressIndicator(context) {
    queryData = MediaQuery.of(context);
    return new AnimatedBuilder(
        animation: _durationController,
        builder: (context, child) {
          return Divider(
              height: 0,
              endIndent: queryData.size.width - _durationController.value*queryData.size.width,
              color: Color(0xFFc77dff),
              thickness: 1.5);
        });
  }

  @override
  Widget build(BuildContext context) {
    return _getProgressIndicator(context);
  }

  @override
  dispose() {
    _durationController.dispose();
    super.dispose();
  }
}