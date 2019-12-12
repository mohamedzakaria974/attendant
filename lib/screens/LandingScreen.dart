import 'dart:convert';
import 'package:attendant/widget/loginWidget.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/Bus.dart';
import '../helpers/Constants.dart';
import '../sevice/GlobalState.dart';
import '../model/Attendant.dart';

class Landing extends StatefulWidget {
  @override
  _LandingState createState() => _LandingState();
}

class _LandingState extends State<Landing> {
  Attendant _attendant;
  Bus _bus;
  GlobalState _store = GlobalState.instance;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String attendantString = (prefs.getString('attendant') ?? "");
    if (attendantString == "") {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => LoginWidget()),
          (Route<dynamic> route) => false);
    } else {
      _attendant = Attendant.fromJson(json.decode(attendantString));
      _store.set('attendant', _attendant);
      String busRouteID = (prefs.getString('BUS_ROUTE_ID') ?? "");
      if (busRouteID == "") {
        Navigator.pushNamedAndRemoveUntil(
            context, confirmBusTag, ModalRoute.withName(confirmBusTag));
      } else {
        String busString = (prefs.getString('bus') ?? "");
        if (busString == "") {
          Navigator.pushNamedAndRemoveUntil(
              context, confirmBusTag, ModalRoute.withName(confirmBusTag));
        } else {
          _bus = Bus.fromJson(json.decode(busString));
          _store.set('bus', _bus);
          Navigator.of(context)
              .pushNamedAndRemoveUntil(nearStudentsTag, (Route<dynamic> route) => false);
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
