import 'dart:convert';

class Song {

  final String title;
  final String album;
  final String albumArtUrl;
  final String artist;
  final String previewUrl;
  final String canvasUrl;
  final String uri;

  Song({this.title, this.album, this.albumArtUrl, this.artist, this.previewUrl,
  this.canvasUrl, this.uri});

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
}

List<Song> parseSongs(String responseBody, String dataName) {
  final parsed = jsonDecode(responseBody)[dataName].cast<Map<String, dynamic>>();

  return parsed.map<Song>((json) => Song.fromJson(json)).toList();
}