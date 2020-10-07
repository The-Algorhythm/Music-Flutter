import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SongDescription extends StatelessWidget {

  static const double songNameFontSize = 18.0;
  static const double artistAlbumFontSize = 15.0;
  static const double albumArtSize = 100.0;

  static const double albumArtPadding = 10.0;
  static const double textPadding = 5.0;

  static const String imageUrl = "https://i.scdn.co/image/ab67616d0000b2734896429a87abfacd5d90587b";

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child:
        Padding(
          padding: const EdgeInsets.only(left: albumArtPadding, bottom: albumArtPadding),
          child: Row(
//            mainAxisSize: MainAxisSize.max,
//            crossAxisAlignment: CrossAxisAlignment.start,
              children: [
//              Container(height: albumArtSize, width: albumArtSize, color: Colors.pink[300]),
                CachedNetworkImage(
                  width: albumArtSize, height: albumArtSize,
                  imageUrl: imageUrl,
//                  placeholder: (context, url) => new LinearProgressIndicator(),
                  errorWidget: (context, url, error) => new Icon(Icons.error),),
              Expanded(
                  child:
                  Padding(
                    padding: const EdgeInsets.only(left: textPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('Song Name', style: TextStyle(fontSize: songNameFontSize),),
                        Text('Artist Name - Album Name', style: TextStyle(fontSize: artistAlbumFontSize),)
                    ]),
                  )
          )]
    ),
        ));
  }
}