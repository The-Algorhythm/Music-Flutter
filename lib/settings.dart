import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:music_app/model/user_profile.dart';
import 'package:music_app/widgets/login.dart';

class SettingsPage extends StatelessWidget {

  static MediaQueryData queryData;

  @override
  Widget build(BuildContext ctx) {
    queryData = MediaQuery.of(ctx);
    return Scaffold(
      backgroundColor: Colors.black,
      body:
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: queryData.viewPadding.top + 15),
              child: Container(
                  height: 45,
                  alignment: Alignment.topLeft,
                  child: IconButton(
                      icon: new Icon(CupertinoIcons.back, color: Colors.white, size: 30),
                      onPressed: (){Navigator.pop(ctx);},
                  )),
            ),
            Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: queryData.size.height - (60 + queryData.viewPadding.top),
                    alignment: Alignment.center,
                    padding: EdgeInsets.all(25.00),
                    child: RaisedButton(
                      color: Colors.green,
                      onPressed: () {_logout(ctx);},
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child:
                        Text("Logout",
                            style: TextStyle(fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                    ),
                  ),
            ]),
          ],
        ),
      ),
    );
  }

  _logout(ctx) {
    SpotifyProfile profile = SpotifyProfile();
    profile.logout();
    Navigator.of(ctx).pushAndRemoveUntil(
        MaterialPageRoute(builder: (ctx) => LoginPage()),
            (Route<dynamic> route) => false);
  }
}