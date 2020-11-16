import 'package:flutter/material.dart';
import 'package:music_app/discover.dart';
import 'package:music_app/app_icons.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

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

  _launchURL(ctx) async {
    const url = 'https://flutter.dev';
    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      Navigator.push(ctx, GotoDiscover());
      flutterWebViewPlugin.close();
    });
    flutterWebViewPlugin.launch(url);
  }
}