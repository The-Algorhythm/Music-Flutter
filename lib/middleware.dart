import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:music_app/model/song.dart';
import 'package:music_app/model/user_profile.dart';

enum NetworkResult { success, failure }

String baseUrl = "musicbackend-dev.us-east-1.elasticbeanstalk.com";

Future<List<Song>> getRecommendations({int numSongs = 100,
  bool useCanvases = true}) async {
  SpotifyProfile profile = SpotifyProfile();
  var uri = Uri.http(
      baseUrl, '/recommendations', {
    'num_songs': numSongs.toString(),
    'use_canvases': useCanvases.toString(),
  });
  final headers = {"token": jsonEncode(profile.tokenInfo)};
  final response = await http.get(uri, headers: headers);
  return parseSongs(response.body, "recommendations");
}

/// Send "interaction" request to backend (like, open, share, listen_length,
/// and dislike). Takes Song as the object of the interaction, the type of
/// interaction, and extra data such as listenLength and objType
Future<int> interact(Song song, String type, {int listenLength, String objType="TRACK"}) async {
  SpotifyProfile profile = SpotifyProfile();
  String spotifyId;
  if(objType == "ARTIST") {
    spotifyId = song.artistIds.join(",");
  } else if(objType == "ALBUM") {
    spotifyId = song.albumId;
  } else if(objType == "TRACK") {
    spotifyId = song.songId();
  }
  Map<String, String> params = {
    'interaction_type': type,
    'spotify_id': spotifyId,
    'object_type': objType,
  };
  if(listenLength != null) {
    params['listen_length'] = listenLength.toString();
  }
  var uri = Uri.http(baseUrl, '/interaction/', params);
  final headers = {"token": jsonEncode(profile.tokenInfo)};
  final response = await http.post(uri, headers: headers);
  return response.statusCode;
}

Future<List<Song>> getLikedSongs() async {
  SpotifyProfile profile = SpotifyProfile();
  var uri = Uri.http(baseUrl, '/liked');
  final headers = {"token": jsonEncode(profile.tokenInfo)};
  final response = await http.get(uri, headers: headers);
  return parseSongs(response.body, "tracks");
}