import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../control/LoginController.dart';
import '../helpers/Constants.dart';
import '../model/Bus.dart';
import '../model/Attendant.dart';
import '../widget/dialogs/Dialog.dart';
import '../sevice/GlobalState.dart';

// ignore: must_be_immutable
class LoginPage extends StatelessWidget {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  static final formKey = GlobalKey<FormState>();
  bool _autovalidate = false;

  GlobalState _store = GlobalState.instance;
  Bus _bus;

  @override
  Widget build(BuildContext context) {
    final username = Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          controller: _usernameController,
          maxLength: 50,
          maxLines: 1,
          autofocus: true,
          decoration: InputDecoration(
              hintText: usernameHintText,
              contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32.0),
              ),
              hintStyle: TextStyle(color: Colors.white)),
          style: TextStyle(
            color: Colors.white,
          ),
        ));

    final password = Directionality(
      textDirection: TextDirection.rtl,
      child: TextFormField(
        controller: _passwordController,
        maxLength: 16,
        maxLines: 1,
        obscureText: true,
        autofocus: true,
        decoration: InputDecoration(
            hintText: passwordHintText,
            contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            hintStyle: TextStyle(color: Colors.white)),
        style: TextStyle(
          color: Colors.white,
        ),
      ),
    );

    final loginButton = Container(
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 16.0),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            onPressed: () async {
              final FormState form = formKey.currentState;
              if (form.validate()) {
                String username = _usernameController.text;
                String password = _passwordController.text;
                Attendant attendant = await Login.login(
                    url: '/login',
                    requestBody: {
                      'USER_NAME': username,
                      'USER_PASSWORD': password
                    });
                if (attendant != null) {
                  _store.set('attendant', attendant);
                  SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  String busRouteID = (prefs.getString('BUS_ROUTE_ID') ?? "");
                  if (busRouteID == "") {
                    Navigator.pushNamedAndRemoveUntil(context, confirmBusTag,
                        ModalRoute.withName(confirmBusTag));
                  } else {
                    String busString = (prefs.getString('bus') ?? "");
                    if (busString == "") {
                      Navigator.pushNamedAndRemoveUntil(context, confirmBusTag,
                          ModalRoute.withName(confirmBusTag));
                    } else {
                      _bus = Bus.fromJson(json.decode(busString));
                      _store.set('bus', _bus);
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          nearStudentsTag, (Route<dynamic> route) => false);
                    }
                  }
                } else {
                  Dialogs.showDialogBox(
                      context: context,
                      msg: " اسم المستخدم او كلمة المرور غير صحيحة");
                }
              } else {
                _autovalidate = true;
              }
            },
            padding: EdgeInsets.all(12),
            color: appGreyColor,
            child: Text(loginButtonText, style: TextStyle(color: Colors.white)),
          ),
        ));

    return Scaffold(
      backgroundColor: appDarkGreyColor,
      body: Center(
          child: Form(
              key: formKey,
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    username,
                    password,
                    SizedBox(height: buttonHeight),
                    loginButton,
                  ],
                ),
              ))

//        ListView(
//          shrinkWrap: true,
//          padding: EdgeInsets.only(left: 24.0, right: 24.0),
//          children: <Widget>[
//            SizedBox(height: bigRadius),
//            username,
//            password,
//            SizedBox(height: buttonHeight),
//            loginButton,
////            RaisedButton(
////              onPressed: () async {
////                Attendant attendant = await Login.login(
////                    url: '/login', requestBody: {'USER_NAME': 'عمرو اشرف', 'USER_PASSWORD': '123'});
//
////              },
////              child: Text('تخطى الدخول'),
////            )
//          ],
//        ),
          ),
    );
  }
}
