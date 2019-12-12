import 'package:flutter/material.dart';

class NoInternetConnection extends StatefulWidget {
  @override
  _NoInternetConnectionState createState() => _NoInternetConnectionState();
}

class _NoInternetConnectionState extends State<NoInternetConnection> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: Colors.orange[400],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            height: 400,
            width: 400,
            child: Image.asset('assets/images/no_internet_connection.png',fit: BoxFit.fill,),
          ),
//          SizedBox(height: 50,),
//          Text("أعد الاتصال بالإنترنت للوصول إلى هذا الجزء من التطبيق",style: TextStyle(color: Colors.brown[800],fontWeight: FontWeight.bold,fontSize: 24, ),textAlign: TextAlign.center,textDirection: TextDirection.rtl,)

        ],
      ),
    );
  }
}
