import 'package:flutter/material.dart';
import 'package:music_app/app_icons.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:music_app/model/song.dart';
import 'package:music_app/model/user_profile.dart';
import 'package:music_app/page_controller.dart';
import 'dart:convert';

import '../middleware.dart';

class GoToLogin extends MaterialPageRoute<Null> {
  GoToLogin(): super(builder: (BuildContext context) {
    return new LoginPage();
  });
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final flutterWebViewPlugin = FlutterWebviewPlugin();
  bool _isLoading = false;

  Widget _getLoader() {
    if(_isLoading) {
      return Column(
        children: [
          Container(height: 100,),
          SizedBox(
            height: 40,
            width: 40,
            child: CircularProgressIndicator(
              strokeWidth: 5,
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFC77DFF)),
            )),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Text("Gathering recommendations...",
              style: TextStyle(fontSize: 20, color: Color(0xFFC77DFF)),),
          )]);
    } else {
      return Container();
    }
  }

  Widget _getLoginButton(ctx) {
    if(_isLoading) {
      return Container();
    } else {
      return Container(
        padding: EdgeInsets.all(25.00),
        child: RaisedButton(
          color: Colors.green,
          onPressed: (){
            _launchURL(ctx);
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 7),
                  child: Text("Login with Spotify",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white)),
                ),
                Icon(MusicAppIcons.spotify, color: Colors.white)],
            ),
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext ctx) {
    return Scaffold(
      backgroundColor: Colors.black,
      body:
      Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Container(
                child: Text("Welcome to The Algorhythm",
                  textAlign: TextAlign.center,
                  style: new TextStyle(color: Colors.white, fontSize: 50, fontWeight: FontWeight.bold),
                ),
              ),
            _getLoginButton(ctx),
            _getLoader()],
          ),
      ),
    );
  }

  _login(ctx, tokenInfo, userInfo) async {
    SpotifyProfile profile = SpotifyProfile();
    profile.login(tokenInfo, userInfo['display_name'], userInfo['email'],
        userInfo['id'], userInfo['images'][0]['url'], userInfo['uri'],
        userInfo['product'], userInfo['country']);
    List<Song> songs = await getRecommendations(numSongs: 10);
    Navigator.pushReplacement(
      ctx, MaterialPageRoute(builder: (ctx) => PagesHolder(songs)),
    );
  }

  _launchURL(ctx) async {
    const url = 'http://musicbackend-dev.us-east-1.elasticbeanstalk.com/login/';
    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      debugPrint('url: '+url);
      _getPageContent(ctx);
    });
    flutterWebViewPlugin.launch(url);
  }

  _getPageContent(ctx) async {
    String js = "window.document.body.innerText";
    String val =  await flutterWebViewPlugin.evalJavascript(js);
    if(val.contains("current_user") && val.contains("token_info")) {
      setState(() {
        _isLoading = true;
      });

      flutterWebViewPlugin.cleanCookies();
      flutterWebViewPlugin.close();
      Map<String, dynamic> data = jsonDecode(jsonDecode(val));
      _login(ctx, data['token_info'], data['current_user']);
    }
  }
}