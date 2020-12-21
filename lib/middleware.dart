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
  return parseSongs(response.body);
}