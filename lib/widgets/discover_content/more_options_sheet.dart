
import 'package:flushbar/flushbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:music_app/middleware.dart';
import 'package:music_app/model/song.dart';

class ModalOptionsSheet {

  final Function skipPage;
  final Song currentSong;

  ModalOptionsSheet(this.skipPage, this.currentSong);

  void showBottomSheet(context) {
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15.0),
                topRight: Radius.circular(15.0))),
        backgroundColor: Color(0xFF101010),
        builder: (builder){
          return new Container(
            height: 180.0,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _getDislike(context, "track"),
                _getDislike(context, "album"),
                _getDislike(context, "artist"),
              ],
            ),
          );
        }
    );
  }

  Widget _getDislike(context, object) {
    bool singular = object != "artist" || currentSong.artistIds.length == 1;  // Change to plural when there are multiple artists
    var message = [
      new TextSpan(text: singular ? "Recommend less like this ": "Recommend less like these "),
      new TextSpan(text: singular ? object: object+'s', style: new TextStyle(color: Color(0xFFc77dff)))
    ];
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 5, left: 8, right: 8),
      child: Container(
        height: 40,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(color: Colors.white),
            borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: FlatButton(
//          color: Colors.red,
          onPressed: () async {
            _dislike(context, object);
          },
          child:
          RichText(
            text: new TextSpan(
              // Note: Styles for TextSpans must be explicitly defined.
              // Child text spans will inherit styles from parent
              style: new TextStyle(
                fontSize: 17.0,
                color: Colors.white,
              ),
              children: message,
            ),
          ),
        ),
      ),
    );
  }

  // Show Flushbar to confirm a feedback request
  void _showConfirmation(context, object) {
    bool singular = object != "artist" || currentSong.artistIds.length == 1;  // Change to plural when there are multiple artists
    String message = singular ? "Got it. We'll show you less like that $object in the future.":
    "Got it. We'll show you less like those "+object+"s in the future.";
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      message: message,
      duration: Duration(seconds: 4),
    )..show(context);
  }

  // Show Flushbar for a duplicate feedback request
  void _showDupMessage(context, object) {
    bool singular = object != "artist" || currentSong.artistIds.length == 1;  // Change to plural when there are multiple artists
    String message = singular ? "We're already recommending you less like that $object.":
    "We're already recommending you less like those "+object+"s.";
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      message:  message,
      duration:  Duration(seconds: 4),
    )..show(context);
  }

  // Show Flushbar for a error with a feedback request
  void _showError(context, object) {
    bool singular = object != "artist" || currentSong.artistIds.length == 1;  // Change to plural when there are multiple artists
    String message = singular ? "Something went wrong when trying to dislike this $object. Try again.":
    "Something went wrong when trying to dislike those "+object+"s. Try again.";
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      message: message,
      duration: Duration(seconds: 4),
    )..show(context);
  }

  void _dislike(context, String object) async {
    int response = await interact(currentSong, "dislike", objType: object.toUpperCase());
    if(response == 200) {
      Navigator.pop(context);
      skipPage();
      _showConfirmation(context, object);
    }
    else if(response == 400) {
      Navigator.pop(context);
      skipPage();
      _showDupMessage(context, object);
    }
    else {
      _showError(context, object);
    }
  }
}