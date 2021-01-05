import 'dart:convert';
import 'dart:io';
import 'package:android_intent/android_intent.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class Song {
  final String title;
  final String album;
  final String albumArtUrl;
  final String albumId;
  final String artist;
  final List<String> artistIds;
  final String previewUrl;
  final String canvasUrl;
  final String externUrl;
  final String uri;

  Song({this.title, this.album, this.albumArtUrl, this.albumId, this.artist,
    this.artistIds, this.previewUrl, this.canvasUrl, this.externUrl, this.uri});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['song_title'] as String,
      album: json['album_title'] as String,
      albumArtUrl: json['album_art_url'] as String,
      albumId: json['album_id'] as String,
      artist: json['artist'] as String,
      artistIds: json['artist_ids'].cast<String>(),
      previewUrl: json['preview_url'] as String,
      canvasUrl: json['canvas_url'] as String,
      externUrl: json['extern_url'] as String,
      uri: json['uri'] as String,
    );
  }

  /// Returns the song id without the preceding "spotify:track:"
  String songId() {
    return this.uri.substring("spotify:track:".length);
  }

  void openInSpotify() async {
    if (Platform.isAndroid) {
      List<Map<String, String>> _installedApps =
          await AppAvailability.getInstalledApps();

      bool spotifyInstalled = false;
      for (var app in _installedApps) {
        if (app['app_name'] == 'Spotify') {
          spotifyInstalled = true;
          break;
        }
      }

      if (!spotifyInstalled) {
        if (await canLaunch(externUrl)) {
          print("Spotify launched!");
          await launch(externUrl);
        } else {
          throw 'Could not launch Spotify';
        }
      } else {
        AndroidIntent intent = AndroidIntent(
            action: 'action_view',
            data: uri
        );
        await intent.launch();
      }
    } else if (Platform.isIOS) {
      AppAvailability.launchApp(externUrl).then((_) {
        print("Spotify launched!");
      }).catchError((err) {
        print(err);
      });
    }
  }

  void share() {
    Share.share(externUrl);
  }

  @override
  bool operator ==(Object other) {
    return other is Song && other.uri == this.uri;
  }

  @override
  int get hashCode => uri.hashCode;
}

List<Song> parseSongs(String responseBody, String dataName) {
  final parsed =
      jsonDecode(responseBody)[dataName].cast<Map<String, dynamic>>();

  return parsed.map<Song>((json) => Song.fromJson(json)).toList();
}
