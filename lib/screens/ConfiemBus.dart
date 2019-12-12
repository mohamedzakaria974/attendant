import 'dart:async';
import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import './NoInternetConnection.dart';
import '../helpers/Constants.dart';
import '../model/Bus.dart';
import '../model/Student.dart';
import '../sevice/GlobalState.dart';
import '../sevice/connectionStatusSingleton.dart';
import '../widget/dialogs/Dialog.dart';

class ConfirmBus extends StatefulWidget {
  @override
  _ConfirmBusState createState() => _ConfirmBusState();
}

class _ConfirmBusState extends State<ConfirmBus> {
  GlobalState _store = GlobalState.instance;
  String barcode = "";
  Bus bus = Bus(
      routeId: '',
      routeSerial: '',
      busRouteStartTime: '',
      busDriverEndDate: '',
      busDriverDriveDate: '',
      busDriverId: '',
      busDriverSerial: '',
      capacity: 0,
      modelName: '',
      colorName: '',
      busNumber: '',
      busId: '',
      busRouteArrivalTime: '',
      busDriverName: '');

  int busId = 0;
  bool scanned = false;

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
    return Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          actions: <Widget>[
            new IconButton(
              icon: new Icon(Icons.exit_to_app),
              tooltip: 'Logout',
              onPressed: () async {
                if (!isOffline) {
                  SharedPreferences prefs = await SharedPreferences.getInstance();
                  prefs.remove('attendant');
                  Navigator.of(context)
                      .pushNamedAndRemoveUntil(loginPageTag, (Route<dynamic> route) => false);
                } else
                  Toast.show('اعد الاتصال بالانترنت اولا', context,
                      gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
              },
            ),
          ],
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orange[700],
          title: Text(appTitle),
        ),
        body: (isOffline)
            ? NoInternetConnection()
            : Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                new Container(
                  height: 75,
                  width: 175,
                  child: RaisedButton(
                      padding: EdgeInsets.all(15),
                      onPressed: () async {
                  scan().then((val) async {
//                        busId = 1;
                        final response = await http
                            .get('$baseURL/busdetails?id=$busId', // '$baseURL/busdetails?id=$busId'
                                headers: {"Content-type": "application/json"});
                        if (response.statusCode == 200) {
                          // If the call to the server was successful, parse the JSON.
                          setState(() {
                            scanned = true;
                            bus = Bus.fromJson(json.decode(response.body));
                            _store.set('bus', bus);
                            _store.set('bus-capacity', bus.capacity);
                          });
                        } else {
                          // If that call was not successful, throw an error.
                          Toast.show('افحص الاتوبيس الصحيح', context,
                              duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                        }
                  });
                      },
                      color: Colors.orange[400],
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: <Widget>[
                          Image(
                            image: AssetImage('assets/images/qr-code.png'),
                            width: 75,
                            height: 75,
                          ),
                          Text("Scan")
                        ],
                      )),
                ),
                SizedBox(
                  height: 25,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      bus.busNumber,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "رقم الاتوبيس : ",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      bus.colorName,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "لون الاتوبيس : ",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      bus.busDriverName,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "سائق الاتوبيس : ",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      "${_store.get('attendant').attendantName}",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "مرافق الاتوبيس : ",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      bus.routeSerial,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "رقم الخط : ",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                SizedBox(
                  height: 25,
                ),
                RaisedButton(
                  onPressed: () async {
                    if (scanned) {
                      String url = '$baseURL/stopendroute';
                      var body = json.encode({
                        'ATTENDANT_ID': _store.get('attendant').attendantId,
                        'BUS_ROUTE_ID': bus.routeSerial,
                        'START_FLAG': true
                      });

                      var response = await http.post(url,
                          headers: {"Content-Type": "application/json"}, body: body);
                      var responseDate = json.decode(response.body);

                      if (responseDate['success'] == 'true') {
                        SharedPreferences prefs = await SharedPreferences.getInstance();
                        prefs.setString('BUS_ROUTE_ID', bus.routeSerial);
                        addBusData(bus: bus.toMap());
                        Student.studentsList = [];
                        Navigator.of(context).pushNamedAndRemoveUntil(
                            nearStudentsTag, (Route<dynamic> route) => false);
                      }
                    } else {
                      Dialogs.showDialogBox(context: context, msg: 'يجب فحص الاتوبيس اولا');
                    }
                  },
                  color: Colors.orange[400],
                  child: Container(
                    width: 60,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(Icons.save),
                        SizedBox(width: 5,),
                        Text("حفظ"),
                      ],
                    ),
                  ),
                )
              ]));
  }

  Future scan() async {
    try {
      var barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
        List splittedBarcode = this.barcode.split('##');
        this.busId = int.parse(splittedBarcode[0]);
      });
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        this.barcode = 'The user did not grant the camera permission!';
      } else {
        this.barcode = 'Unknown error: $e';
      }
    } on FormatException {
      this.barcode =
          'null (User returned using the "back"-button before scanning anything. Result)';
    } catch (e) {
      this.barcode = 'Unknown error: $e';
    }
  }

  addBusData({Map bus}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    String busString = json.encode(bus);
    preferences.setString('bus', busString);
  }
}
