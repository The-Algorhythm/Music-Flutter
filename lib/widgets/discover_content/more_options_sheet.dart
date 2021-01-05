
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
        backgroundColor: Colors.grey[850],
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
          child: Text("Recommend less like this $object",
            style: TextStyle(fontSize: 17, color: Colors.white),),
        ),
      ),
    );
  }

  static void _showConfirmation(context, object) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      message:  "Got it. We'll show you less like that $object in the future.",
      duration:  Duration(seconds: 4),
    )..show(context);
  }

  static void _showError(context, object) {
    Flushbar(
      flushbarPosition: FlushbarPosition.TOP,
      flushbarStyle: FlushbarStyle.FLOATING,
      margin: EdgeInsets.all(8),
      borderRadius: 8,
      message:  "Something went wrong when trying to dislike this $object. Try again.",
      duration:  Duration(seconds: 4),
    )..show(context);
  }

  void _dislike(context, String object) async {
    bool success = await interact(currentSong, "dislike", objType: object.toUpperCase());
    if(success) {
      Navigator.pop(context);
      skipPage();
      _showConfirmation(context, object);
    } else {
      _showError(context, object);
    }
  }
}