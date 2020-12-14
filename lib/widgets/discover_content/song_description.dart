import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class SongDescription extends StatelessWidget {

  static const double songNameFontSize = 18.0;
  static const double artistAlbumFontSize = 15.0;
  static const double albumArtSize = 100.0;

  static const double textPadding = 5.0;

  final String albumArtUrl;
  final String songName;
  final String albumArtist;

  SongDescription(this.albumArtUrl, this.songName, this.albumArtist);

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child:
        Padding(
          padding: const EdgeInsets.only(left: 10.0, bottom: 15.0),
          child: Row(
              children: [
                CachedNetworkImage(
                  width: albumArtSize, height: albumArtSize,
                  imageUrl: albumArtUrl,
                  errorWidget: (context, url, error) => new Icon(Icons.error),),
              Expanded(
                  child:
                  Padding(
                    padding: const EdgeInsets.only(left: textPadding),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(songName, style: TextStyle(fontSize: songNameFontSize),),
                        Text(albumArtist, style: TextStyle(fontSize: artistAlbumFontSize),)
                    ]),
                  )
          )]
    ),
        ));
  }
}