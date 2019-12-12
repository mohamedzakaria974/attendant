import 'dart:convert';

import 'package:attendant/screens/resetPassword.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import './control/LoginController.dart';
import './helpers/Constants.dart';
import './model/Attendant.dart';
import './model/Bus.dart';
import './sevice/GlobalState.dart';
import './widget/dialogs/Dialog.dart';
import './widget/login_wave_clippers.dart';

class LoginPage extends StatefulWidget {
  static const ROUTE_NAME = "/login";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  GlobalKey<FormState> _loginFormKey = new GlobalKey();
  FocusNode _passwordFocusNode, _loginFocusNode;
  bool _isShowPassWord = false;
  String _username = '';
  String _password = '';
  bool _isLoading = false;

  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  GlobalState _store = GlobalState.instance;
  Bus _bus;

  @override
  void initState() {
    super.initState();
    _passwordFocusNode = FocusNode();
    _loginFocusNode = FocusNode();
  }

  void _showPassWord() {
    setState(() {
      _isShowPassWord = !_isShowPassWord;
    });
  }

  @override
  Widget build(BuildContext context) {
    final header = Stack(
      fit: StackFit.loose,
      overflow: Overflow.visible,
      children: <Widget>[
        ClipPath(
          clipper: WaveClipper2(),
          child: Container(
            child: Column(),
            width: double.infinity,
            height: 290,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.orange.withOpacity(0.3),
                  Colors.orangeAccent.withOpacity(0.3)
                ])),
          ),
        ),
        ClipPath(
          clipper: WaveClipper3(),
          child: Container(
            child: Column(),
            width: double.infinity,
            height: 290,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                  Colors.orange.withOpacity(0.6),
                  Colors.orangeAccent.withOpacity(0.6)
                ])),
          ),
        ),
        ClipPath(
          clipper: WaveClipper1(),
          child: Container(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 55,
                ),
                Image.asset(
                  'assets/images/logo.png',
                  width: 125,
                  height: 125,
                ),
              ],
            ),
            width: double.infinity,
            height: 290,
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.orange, Colors.orange])),
          ),
        ),
      ],
    );

    final usernameField = Material(
      elevation: 2.0,
      borderRadius: BorderRadius.all(Radius.circular(30)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          autofocus: true,
          onEditingComplete: () => FocusScope.of(context).requestFocus(_passwordFocusNode),
//          validator: (value) {
//            return value.isEmpty ? "يجب ادخال اسم المستخدم" : null;
//          },
          onSaved: (value) {
            print(value);
            this._username = value;
          },
          controller: _usernameController,
          decoration: InputDecoration(
              hintText: 'اسم المستخدم',
              prefixIcon: Material(
                elevation: 0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Icon(
                  Icons.account_circle,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
        ),
      ),
    );

    final passwordField = Material(
      elevation: 2.0,
      borderRadius: BorderRadius.all(Radius.circular(30)),
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: TextFormField(
          controller: _passwordController,
          focusNode: _passwordFocusNode,
          onEditingComplete: () => FocusScope.of(context).requestFocus(_loginFocusNode),
//          validator: (value) {
//            return value.isEmpty ? "يجب ادخال كلمة المرور" : null;
//          },
          onSaved: (value) {
            print(value);
            this._password = value;
          },
          obscureText: !_isShowPassWord,
          decoration: InputDecoration(
              suffixIcon: IconButton(
                  icon: Icon(
                    _isShowPassWord ? Icons.visibility_off : Icons.visibility,
                    color: Theme.of(context).primaryColor,
                  ),
                  onPressed: () => _showPassWord()),
              hintText: 'كلمة المرور',
              prefixIcon: Material(
                elevation: 0,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                child: Icon(
                  Icons.lock,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
        ),
      ),
    );

    final loginBtn = Stack(
      children: <Widget>[
        Positioned(

          child: Padding(
            padding: EdgeInsets.only(top: 50),
            child: Opacity(
              child: Image.asset("assets/images/back.png"),
              opacity: 0.1,
            ),
          ),
        ),
        Positioned(
          child: Padding(
            padding: EdgeInsets.only(top: 0),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              transitionBuilder: (Widget child, Animation<double> animation) {
                return ScaleTransition(
                  child: child,
                  scale: animation,
                );
              },
              child: _isLoading ? _buildLoginLoading() : _buildLoginButton(),
            ),
          ),
        ),
        Positioned(
            bottom: 80,
            right: 100,
            left: 100,
            child: Center(
              child: InkWell(
                child: Text('نسيت كلمة المرور؟', style: TextStyle(fontSize: 18,),),
                onTap: () {
                  Navigator.of(context)
                      .push(MaterialPageRoute(builder: (context) => ResetPassword()));
                },
              ),
            )),
      ],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            header,
            Padding(
              padding: EdgeInsets.only(left: 32, right: 32, top: 0, bottom: 0),
              child: Form(
                key: _loginFormKey,
                child: Column(
                  children: <Widget>[
                    usernameField,
                    SizedBox(
                      height: 20,
                    ),
                    passwordField,
                  ],
                ),
              ),
            ),
            loginBtn,
          ],
        ),
      ),
    );
  }

  Widget _buildLoginLoading() {
    return CircularProgressIndicator();
  }

  Widget _buildLoginButton() {
    return Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 30),
        child: FlatButton(
          color: Theme.of(context).primaryColor,
          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          focusNode: _loginFocusNode,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
            child: Text(
              'تسجيل الدخول',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
          onPressed: () async {
            _username = _usernameController.text;
            _password = _passwordController.text;
            if (_username.isNotEmpty && _password.isNotEmpty) {
              Attendant attendant = await Login.login(
                  url: '/login', requestBody: {'USER_NAME': _username, 'USER_PASSWORD': _password});
              if (attendant != null) {
                _store.set('attendant', attendant);
                SharedPreferences prefs = await SharedPreferences.getInstance();
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
              } else {
                Dialogs.showDialogBox(
                    context: context, msg: " اسم المستخدم او كلمة المرور غير صحيحة");
              }
            } else if (_username.isEmpty && _password.isEmpty) {
              Toast.show("يجب ادخال اسم المستخدم وكلمة المرور", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            } else if (_username.isEmpty) {
              Toast.show("يجب ادخال اسم المستخدم", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            } else if (_password.isEmpty) {
              Toast.show("يجب ادخال المرور", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            }
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _passwordFocusNode.dispose();
    _loginFocusNode.dispose();
    super.dispose();
  }
}
