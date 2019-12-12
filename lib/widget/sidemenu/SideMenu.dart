import 'package:attendant/screens/newPassword.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';
import 'dart:async';
import '../../sevice/connectionStatusSingleton.dart';
import '../../helpers/Constants.dart';
import '../../model/Attendant.dart';
import '../../model/menuItem.dart';
import './sidemenuitem.dart';
import './SideMenuHeader.dart';

// ignore: must_be_immutable
class SideMenu extends StatefulWidget {
  Attendant currentUser;

  SideMenu({this.currentUser});

  @override
  _SideMenuState createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  StreamSubscription _connectionChangeStream;

  bool isOffline = false;

  @override
  initState() {
    super.initState();

    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);
    connectionChanged(connectionStatus.hasConnection);
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          color: appGreyColorLight,
          child: ListView(
              //sideItems
              children: <Widget>[
                MenuHeader(
                  currentUser: widget.currentUser,
                ),
                SizedBox(
                  height: 10,
                ),
                SideItem(
                    item: MenuItem(
                        title: 'الصفحة الرئيسية',
                        onTap: () => Navigator.of(context).pushNamedAndRemoveUntil(
                            nearStudentsTag, (Route<dynamic> route) => false))),
                SideItem(
                    item:
                        MenuItem(title: 'التحدث مع الاداره', onTap: () => Navigator.pop(context))),
                SideItem(
                    item: MenuItem(
                        title: 'التحدث مع ولى الامر', onTap: () => Navigator.pop(context))),
                SideItem(
                    item: MenuItem(
                        title: 'تغيير الرقم السرى',
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.of(context)
                              .push(MaterialPageRoute(builder: (context) => NewPassword()));
                        })),
                SideItem(
                    item: MenuItem(
                        title: 'وصول الخط',
                        onTap: () {
                          Navigator.of(context).pushNamedAndRemoveUntil(
                              arrivaBusTag, (Route<dynamic> route) => false);
                        })),
                SideItem(
                    item: MenuItem(
                        title: 'تسجيل الخروج',
                        onTap: () async {
                          if (!isOffline) {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.remove('attendant');
                            prefs.remove('current_user_id');
                            Navigator.of(context).pushNamedAndRemoveUntil(
                                loginPageTag, (Route<dynamic> route) => false);
                          } else
                            Toast.show('اعد الاتصال بالانترنت اولا', context,
                                gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
                        })),
              ])),
    );
  }
}
