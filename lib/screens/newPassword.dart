import 'dart:convert';

import 'package:attendant/helpers/Constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

class NewPassword extends StatefulWidget {
  @override
  _NewPasswordState createState() => _NewPasswordState();
}

class _NewPasswordState extends State<NewPassword> {
  bool _isShowPassWord = false;
  var _passwordController = TextEditingController();
  var _rePasswordController = TextEditingController();

  void _showPassWord() {
    setState(() {
      _isShowPassWord = !_isShowPassWord;
    });
  }

  var passwordField;

  var rePasswordField;

  @override
  Widget build(BuildContext context) {
    final passwordField = Padding(
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: TextFormField(
            controller: _passwordController,
            obscureText: !_isShowPassWord,
            decoration: InputDecoration(
                suffixIcon: IconButton(
                    icon: Icon(
                      _isShowPassWord ? Icons.visibility_off : Icons.visibility,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () => _showPassWord()),
                hintText: 'كلمة المرور الجديدة',
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
      ),
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
    );

    rePasswordField = Padding(
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: TextFormField(
            controller: _rePasswordController,
            obscureText: true,
            decoration: InputDecoration(
                hintText: 'اعادة كلمة المرور',
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
      ),
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
    );

    final resetBtn = Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32, vertical: 15),
        child: FlatButton(
          color: Theme.of(context).primaryColor,
          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
            child: Text(
              'تغيير كلمة المرور',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
          onPressed: () async {
            String newPassword = _passwordController.text.trim();
            String confirmNewPassword = _rePasswordController.text.trim();
            if (newPassword.isNotEmpty && confirmNewPassword.isNotEmpty) {
              if (newPassword == confirmNewPassword) {
                var absoluteURL = '$baseURL/changepassword';
                var body = json.encode({"USER_ID": 11, "USER_PASSWORD": _passwordController.text});
                var response = await http.post(absoluteURL,
                    headers: {"Content-Type": "application/json"}, body: body);
                Map responseData = jsonDecode(response.body);
                if (responseData.containsKey('success')) {
                  if (responseData['success'] == "true") {
                    Navigator.pop(context);
                    Toast.show("تم تغيير كلمة السر", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  } else {
                    Toast.show("يجب المحاولة لاحقا", context,
                        duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                  }
                }
              } else {
                Toast.show("كلمة المرور غير متطابقة", context,
                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
              }
            } else {
              Toast.show("يجب ادخال كلمة المرور وتأكيدها", context,
                  duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
            }
          },
        ),
      ),
    );

    final securityIcon = Container(
      height: 150,
      width: 150,
      child: Image.asset('assets/images/key.png'),
    );

    return Scaffold(
//      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        title: Text('تغيير كلمة المرور'),
      ),
      backgroundColor: Colors.orange[200],
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 30,
            ),
            securityIcon,
            SizedBox(
              height: 30,
            ),
            passwordField,
            rePasswordField,
            resetBtn,
          ],
        ),
      ),
    );
  }
}
