import 'dart:convert';
import 'dart:io';
import 'package:android_intent/android_intent.dart';
import 'package:flutter_appavailability/flutter_appavailability.dart';
import 'package:url_launcher/url_launcher.dart';

class Song {
  final String title;
  final String album;
  final String albumArtUrl;
  final String artist;
  final String previewUrl;
  final String canvasUrl;
  final String uri;

  Song(
      {this.title,
      this.album,
      this.albumArtUrl,
      this.artist,
      this.previewUrl,
      this.canvasUrl,
      this.uri});

  factory Song.fromJson(Map<String, dynamic> json) {
    return Song(
      title: json['song_title'] as String,
      album: json['album_title'] as String,
      albumArtUrl: json['album_art_url'] as String,
      artist: json['artist'] as String,
      previewUrl: json['preview_url'] as String,
      canvasUrl: json['canvas_url'] as String,
      uri: json['uri'] as String,
    );
  }

  /// Returns the song id without the preceding "spotify:track:"
  String songId() {
    return this.uri.substring("spotify:track:".length);
  }

  void openInSpotify() async {
    String url = "https://open.spotify.com/track/" + songId();

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
        if (await canLaunch(url)) {
          print("Spotify launched!");
          await launch(url);
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
      AppAvailability.launchApp(url).then((_) {
        print("Spotify launched!");
      }).catchError((err) {
        print(err);
      });
    }
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
