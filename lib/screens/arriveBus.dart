import 'dart:async';
import 'dart:convert';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as intl;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toast/toast.dart';

import './NoInternetConnection.dart';
import '../helpers/Constants.dart';
import '../model/Bus.dart';
import '../sevice/GlobalState.dart';
import '../sevice/connectionStatusSingleton.dart';
import '../widget/dialogs/Dialog.dart';
import '../widget/sidemenu/SideMenu.dart';

class ArriveBus extends StatefulWidget {
  @override
  _ArriveBusState createState() => _ArriveBusState();
}

class _ArriveBusState extends State<ArriveBus> {
  GlobalState _store = GlobalState.instance;
  String barcode = "";
  String _timeString;
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
      busNumber: ' ',
      busId: '',
      busRouteArrivalTime: '',
      busDriverName: '');
  Bus storedBus;
  int busId = 1;
  bool scanned = false;
  int studentsNumber = 0;

  StreamSubscription _connectionChangeStream;

  bool isOffline = false;

  @override
  initState() {
    super.initState();

    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);
    connectionChanged(connectionStatus.hasConnection);
    studentsNumber = (_store.get('bus').capacity - (_store.get('bus-capacity') ?? 0));
  }

  void connectionChanged(dynamic hasConnection) {
    setState(() {
      isOffline = !hasConnection;
    });
  }

  @override
  Widget build(BuildContext context) {
    _timeString = _formatDateTime(DateTime.now());
    return Scaffold(
        backgroundColor: Colors.orange[50],
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.orange[700],
          title: Text(appTitle),
        ),
        endDrawer: Theme(
          data: Theme.of(context).copyWith(
            // Set the transparency here
            canvasColor:
                Colors.transparent, //or any other color you want. e.g Colors.blue.withOpacity(0.5)
          ),
          child: SideMenu(
            currentUser: _store.get('attendant'),
          ),
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
                        bus = null;
                        scan().then((val) async {
                        final response = await http.get('$baseURL/busdetails?id=$busId',
                            headers: {"Content-type": "application/json"});
                        print(response.statusCode);
                        print(response.body);
                        if (response.statusCode == 200) {
                          // If the call to the server was successful, parse the JSON.
                          print(response.body);
                          setState(() {
                            bus = Bus.fromJson(json.decode(response.body));
                            showToast("رقم الاتوبيس: ${bus.busNumber}",
                                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);

                            storedBus = _store.get('bus');
                            if (bus.busId == storedBus.busId) {
                              setState(() {
                                scanned = true;
                                studentsNumber =
                                    (_store.get('bus').capacity - _store.get('bus-capacity'));
                              });
                            } else {
                              Dialogs.showDialogBox(
                                  context: context, msg: 'يجب فحص الاتوبيس المسجل');
                            }
                          });
                        } else {
                          // If that call was not successful, throw an error.
                          throw Exception('Failed to load post');
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
                      bus == null ? "" : bus.busNumber.toString(),
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
                      studentsNumber.toString(),
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold),
                    ),
                    Text(
                      "عدد الطلاب : ",
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _timeString,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: Colors.brown[800], fontWeight: FontWeight.bold),
                    ),
                    Text(
                      " الوقت الحالى : ",
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
                    print('save pressed');
                    if (scanned) {
                      if ((_store.get('bus').capacity - _store.get('bus-capacity')) == 0) {
                        var absoluteURL = '$baseURL/endAttendantRoute';
                        var body = json.encode({
                          "attendant_id": _store.get('attendant').attendantId,
                          "bus_route_serial": _store.get('bus').routeSerial
                        });

                        var response = await http.post(absoluteURL,
                            headers: {"Content-Type": "application/json"}, body: body);
                        if (response.statusCode == 200) {
                          var responseData = json.decode(response.body);
                          print(responseData);
                          if (responseData['success'] == "true") {
                            SharedPreferences prefs = await SharedPreferences.getInstance();
                            prefs.remove('BUS_ROUTE_ID');

                            Navigator.of(context).pushNamedAndRemoveUntil(
                                confirmBusTag, (Route<dynamic> route) => false);
                            showToast("تم انهاء الخط",
                                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                          } else {
                            showToast("الرجاء المحاولة وقت اخر",
                                duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                          }
                        }
                      } else {
                        Dialogs.showDialogBox(
                            context: context, msg: 'لا يمكن انهاء الخط قبل مغادرة جميع الطلاب');
                      }
                    } else {
                      Dialogs.showDialogBox(context: context, msg: 'يجب فحص الاتوبيس اولا');
                    }
                  },
                  color: Colors.orange[400],
                  child: Text("انـهـاء",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),),
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

  String _formatDateTime(DateTime dateTime) {
    return intl.DateFormat('hh:mm:ss a').format(dateTime);
  }

  void showToast(String msg, {int duration, int gravity}) {
    Toast.show(msg, context, duration: duration, gravity: gravity);
  }
}
