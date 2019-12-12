import 'dart:async';
import 'package:flutter/material.dart';
import '../login_page.dart';
import '../sevice/connectionStatusSingleton.dart';
import '../screens/NoInternetConnection.dart';

class LoginWidget extends StatefulWidget {
  @override
  LoginWidgetState createState() => new LoginWidgetState();
}

class LoginWidgetState extends State<LoginWidget> {
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
    if (mounted) {
      setState(() {
        isOffline = !hasConnection;
      });
    }
  }

  @override
  Widget build(BuildContext ctxt) {
    return (isOffline) ? NoInternetConnection() : LoginPage();
  }
}
