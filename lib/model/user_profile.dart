import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'dart:convert';

class SpotifyProfile {

  // Define class as a singleton so the same instance is returned every time.
  // Instantiate with SpotifyProfile profile = SpotifyProfile()
  SpotifyProfile._privateConstructor();
  static final SpotifyProfile _instance = SpotifyProfile._privateConstructor();
  factory SpotifyProfile() {
    _instance.loginFromFile();
    return _instance;
  }

  Map<String, dynamic> tokenInfo;
  String displayName;
  String email;
  String id;
  String picUrl;
  String uri;
  String product;
  String country;
  bool isLoggedIn = false;

  void login(Map<String, dynamic> tokenInfo, String displayName, String email,
      String id, String picUrl, String uri, String product, String country) {
    if(isLoggedIn) {
      throw("User already logged in, cannot login again.");
    } else {
      this.tokenInfo = tokenInfo;
      this.displayName = displayName;
      this.email = email;
      this.id = id;
      this.picUrl = picUrl; //json["images"][0]["url"]
      this.uri = uri;
      this.product = product;
      this.country = country;
      this.isLoggedIn = true;
      _saveToFile();
    }
  }

  void logout() {
    this.displayName = null;
    this.email = null;
    this.id = null;
    this.picUrl = null;
    this.uri = null;
    this.product = null;
    this.country = null;
    this.isLoggedIn = false;
    _wipeFile();
  }

  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/user_profile.json');
  }

  void _saveToFile() async {
    final file = await _localFile;
    Map<String, dynamic> data = {
      'isLoggedIn': true,
      'tokenInfo': tokenInfo,
      'displayName': displayName,
      'email': email,
      'id': id,
      'picUrl': picUrl,
      'uri': uri,
      'product': product,
      'country': country};
    file.writeAsString(jsonEncode(data));
  }

  void _wipeFile() async {
    final file = await _localFile;
    Map<String, dynamic> data = {'isLoggedIn': false};
    file.writeAsString(jsonEncode(data));
  }

  Future<bool> loginFromFile() async {
    try {
      final file = await _localFile;
      Map<String, dynamic> data = jsonDecode(await file.readAsString());
      if(data['isLoggedIn']) {
        tokenInfo = data['tokenInfo'];
        displayName = data['displayName'];
        email = data['email'];
        id = data['id'];
        picUrl = data['picUrl'];
        uri = data['uri'];
        product = data['product'];
        country = data['country'];
        isLoggedIn = true;
      } else {
        isLoggedIn = false;
      }
    } catch (e) {
      debugPrint('Caught error when loading from file: '+e.toString());
      isLoggedIn = false;
    }
    return isLoggedIn;
  }
}