import 'package:flutter/material.dart';

class ResetPassword extends StatelessWidget {
  var _emailController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final emailField = Padding(
      child: Material(
        elevation: 2.0,
        borderRadius: BorderRadius.all(Radius.circular(30)),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: TextFormField(
            keyboardType: TextInputType.emailAddress,
            autofocus: true,
            controller: _emailController,
            decoration: InputDecoration(
                hintText: 'ادخل البريد الالكترونى',
                prefixIcon: Material(
                  elevation: 0,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  child: Icon(
                    Icons.alternate_email,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 25, vertical: 13)),
          ),
        ),
      ),
      padding: EdgeInsets.symmetric(horizontal: 32, vertical: 20),
    );

    final resetBtn = Container(
      width: double.infinity,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32),
        child: FlatButton(
          color: Theme.of(context).primaryColor,
          shape: new RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0, bottom: 12.0),
            child: Text(
              'إعادة تعيين كلمة المرور',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 20,
              ),
            ),
          ),
          onPressed: () async {},
        ),
      ),
    );

    final securityIcon = Container(
      height: 175,
      width: 175,
      child: Image.asset('assets/images/security.png'),
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
      ),
      backgroundColor: Colors.orange[200],
      body: //Center(
          //   child:
          SingleChildScrollView(
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
            emailField,
            resetBtn,
          ],
        ),
      ),
//      ),
    );
  }
}
