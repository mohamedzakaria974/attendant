import 'dart:convert';

import 'package:attendant/model/Attendant.dart';

import '../../helpers/Constants.dart';
import 'package:flutter/material.dart';

class MenuHeader extends StatefulWidget {
  Attendant currentUser;

  MenuHeader({this.currentUser});

  @override
  _MenuHeaderState createState() => _MenuHeaderState();
}

class _MenuHeaderState extends State<MenuHeader> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
          border: new Border(
              bottom: new BorderSide(
                  width: 1.0, color: Colors.white))),
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(widget.currentUser.attendantName, style: TextStyle(color: Colors.white,fontSize: 24.0, fontWeight: FontWeight.bold),),
          SizedBox(width: 15.0,),
          CircleAvatar(
            radius: 40.0,
            backgroundImage: MemoryImage(base64.decode(base64String)),
          ),

//          Image(image: MemoryImage(base64.decode(base64String))),
        ],
      ),
    );
  }
}
