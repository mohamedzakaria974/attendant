import 'package:attendant/login_page.dart';

import 'package:flutter/material.dart';
import './screens/arriveBus.dart';
import './screens/LandingScreen.dart';
import './screens/NearStudents.dart';
import './screens/ConfiemBus.dart';
import './screens/NoInternetConnection.dart';
import './sevice/connectionStatusSingleton.dart';
import './helpers/Constants.dart';
import './generated/i18n.dart';

void main() {
  ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
  connectionStatus.initialize();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final routes = <String, WidgetBuilder>{
    '/': (context) => Landing(),
    loginPageTag: (context) => LoginPage(),
    confirmBusTag: (context) => ConfirmBus(),
    noInterntetTag: (context) => NoInternetConnection(),
    nearStudentsTag: (context) => NearStudent(),
    arrivaBusTag: (context) => ArriveBus(),
  };

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: [S.delegate],
      supportedLocales: S.delegate.supportedLocales,
      debugShowCheckedModeBanner: false,
      title: 'Attendant',
      theme: ThemeData(primaryColor: Colors.orange),
//      home: TestWidget(),
      routes: routes,
    );
  }
}
