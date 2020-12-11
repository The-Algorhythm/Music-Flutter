import 'package:flutter/material.dart';
import 'package:music_app/app_icons.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:music_app/model/user_profile.dart';
import 'package:music_app/page_controller.dart';
import 'dart:convert';

class GoToLogin extends MaterialPageRoute<Null> {
  GoToLogin(): super(builder: (BuildContext context) {
    return new LoginPage();
  });
}

class LoginPage extends StatelessWidget {

  final flutterWebViewPlugin = FlutterWebviewPlugin();

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
              Container(
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
                )],
          ),
      ),
    );
  }

  _login(ctx, tokenInfo, userInfo) {
    SpotifyProfile profile = SpotifyProfile();
    profile.login(tokenInfo, userInfo['display_name'], userInfo['email'],
        userInfo['id'], userInfo['images'][0]['url'], userInfo['uri'],
        userInfo['product'], userInfo['country']);
    Navigator.pushReplacement(ctx, GoToMainScreen());
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
      flutterWebViewPlugin.cleanCookies();
      flutterWebViewPlugin.close();
      Map<String, dynamic> data = jsonDecode(jsonDecode(val));
      _login(ctx, data['token_info'], data['current_user']);
    }
  }
}