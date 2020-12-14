import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:flutter/cupertino.dart';

class LikedSongsOverlay extends StatefulWidget {
  List<String> imagedatamodel;
  final Function clearOverlayCallback;
  final int initialIndex;
  LikedSongsOverlay(this.initialIndex, this.imagedatamodel, this.clearOverlayCallback);

  @override
  _LikedSongsOverlayState createState() => _LikedSongsOverlayState();
}

class _LikedSongsOverlayState extends State<LikedSongsOverlay> {
  static MediaQueryData queryData;
  int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
  }

  static const String albumArtUrl = "https://i.scdn.co/image/ab67616d00001e02323b486defbe382273719626";

  Widget _swiper(context) {
    return Container(
        height: 275,
        width: queryData.size.width,
        child: new Swiper(
          index: _index,
          itemBuilder: (BuildContext context, int index) {
            return new Image.network(
              widget.imagedatamodel[index],
              fit: BoxFit.fill,
            );
          },
          itemCount: widget.imagedatamodel.length,
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

  @override
  Widget build(BuildContext context) {
    queryData = MediaQuery.of(context);
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
                        onPressed: (){widget.clearOverlayCallback();},
                      )),
                ),
                Column(
                    children: <Widget>[
                      Container(
                        height: queryData.size.height - (65 + queryData.viewPadding.top),
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(25.00),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            _swiper(context),
                            Text("$_index")
                          ],
                        ),
                      ),
                    ]),
              ],
            ),
        ),
      ],
    );
  }

}