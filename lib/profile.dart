import 'package:flutter/material.dart';
import 'package:music_app/model/user_profile.dart';
import 'package:music_app/widgets/login.dart';

class ProfilePage extends StatelessWidget {

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
              padding: EdgeInsets.all(25.00),
              child: RaisedButton(
                color: Colors.green,
                onPressed: () {
                  _logout(ctx);
                },
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
          ],
        ),
      ),
    );
  }

  _logout(ctx) {
    SpotifyProfile profile = SpotifyProfile();
    profile.logout();
    Navigator.pushReplacement(ctx, GoToLogin());
  }
}