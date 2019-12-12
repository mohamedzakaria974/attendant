import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:toast/toast.dart';
import '../widget/dialogs/StudentDialog.dart';
import '../sevice/GlobalState.dart';
import '../sevice/connectionStatusSingleton.dart';
import '../helpers/Constants.dart';
import '../model/Student.dart';
import '../widget/dialogs/Dialog.dart';
import '../widget/sidemenu/SideMenu.dart';
import './NoInternetConnection.dart';

class NearStudent extends StatefulWidget {
  @override
  NearStudentState createState() => NearStudentState();
}

class NearStudentState extends State<NearStudent> {
  String barcode;
  List<Student> students = [];
  GlobalState _store = GlobalState.instance;
  int availableCapacity = 0;
  int pickedUpNumber = 0;
  int studentId = 1;
  int busCapacity;
  final SlidableController slidableController = SlidableController();

  NearStudentState() {}

  StreamSubscription _connectionChangeStream;

  bool isOffline = false;

  final _chartSize = const Size(100.0, 100.0);
  final GlobalKey<AnimatedCircularChartState> chartKey =
      new GlobalKey<AnimatedCircularChartState>();

  @override
  initState() {
    super.initState();
    print(_store.get('attendant').attendantName);
    ConnectionStatusSingleton connectionStatus = ConnectionStatusSingleton.getInstance();
    _connectionChangeStream = connectionStatus.connectionChange.listen(connectionChanged);
    connectionChanged(connectionStatus.hasConnection);
    if (!isOffline) {
      Student.studentsList = [];
      loadStudentsInBus();
    }
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
      resizeToAvoidBottomPadding: false,
      body: (isOffline)
          ? NoInternetConnection()
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                SizedBox(
                  height: 5,
                ),
                Container(
                    child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Container(
                        child: new AnimatedCircularChart(
                      key: chartKey,
                      size: _chartSize,
                      initialChartData: <CircularStackEntry>[
                        new CircularStackEntry(
                          <CircularSegmentEntry>[
                            new CircularSegmentEntry(
                              ((pickedUpNumber / _store.get('bus').capacity) * 100),
                              Colors.orange[800],
                              rankKey: 'completed',
                            ),
                            new CircularSegmentEntry(
                              (((_store.get('bus').capacity - pickedUpNumber) /
                                      _store.get('bus').capacity) *
                                  100),
                              Colors.orange[100],
                              rankKey: 'remaining',
                            ),
                          ],
                          rankKey: 'progress',
                        ),
                      ],
                      chartType: CircularChartType.Radial,
                      percentageValues: true,
                      holeLabel: '$pickedUpNumber / ${_store.get('bus').capacity}',
                      labelStyle: new TextStyle(
                        color: Colors.blueGrey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    )),
                    RaisedButton(
                      padding: EdgeInsets.all(15),
                      onPressed: () async {
                        scan().then((val) async {
                        String studentDetailsURL = '$baseURL/getstudentdetails/$studentId';
                        var studentDataResponse = await http
                            .get(studentDetailsURL, headers: {"Content-Type": "application/json"});
                        var studentData = json.decode(studentDataResponse.body);
                        studentId++;
                        if (studentData['Message'] != 'An error has occurred.') {
                          Student tempStudent = Student.fromJson(studentData);
                          showDialog(
                            context: context,
                            builder: (BuildContext context) => StudentDialog(
                              student: tempStudent,
                              studentsList: Student.studentsList,
                              parent: this,
                            ),
                          );
                        } else if (studentData['Message'] == "No Student With this ID") {
                          Toast.show('يجب تسجيل هذا الطالب اولا من قبل المدرسة', context,
                              gravity: Toast.BOTTOM, duration: Toast.LENGTH_LONG);
                        }
                        });
                      },
                      color: Colors.orange[400],
                      child: Image(
                        image: AssetImage('assets/images/qr-code.png'),
                        width: 50,
                        height: 50,
                      ),
                    )
                  ],
                )),
                SizedBox(
                  height: 3,
                ),
                Flexible(
                  child: Container(
                    child: ListView(
                        children: Student.studentsList
                            .map((data) => _buildListItem(context, data))
                            .toList()),
                  ),
                )
              ],
            ),
    );
  }

  Widget _buildListItem(BuildContext context, Student student) {
    return Slidable(
      key: Key(student.studentName),
      controller: slidableController,
      actionPane: SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Card(
          key: ValueKey(student.studentName),
          elevation: 8.0,
          margin: new EdgeInsets.symmetric(horizontal: 10.0, vertical: 4.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.orange[700]),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 15.0, vertical: 4.0),
              title: Text(
                student.studentName,
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              subtitle: Row(
                children: <Widget>[
                  new Flexible(
                      child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                        RichText(
                          text: TextSpan(
                            text: student.stopStation.stopName,
                            style: TextStyle(color: Colors.white),
                          ),
                          maxLines: 3,
                          softWrap: true,
                        )
                      ]))
                ],
              ),
              trailing: Container(
                  padding: EdgeInsets.only(right: 5.0),
                  //decoration: new BoxDecoration(
                  //  border: new Border(right: new BorderSide(width: 1.0, color: Colors.white24))),
                  child: Hero(
                    tag: "avatar_" + student.studentName,
                    child: Container(
                        width: 60,
                        height: 100,
                        child: CircleAvatar(
                          radius: 10,
                          backgroundImage: MemoryImage(student.photo),
                        )
                        //Image.memory(student.photo,width: 45,height:90 ,fit: BoxFit.fill,),
                        ),
//                      CircleAvatar(
////                        radius: 50,
//                        backgroundImage: MemoryImage(student.photo),
//                      )
                  )),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) => StudentDialog(
                    student: student,
                    studentsList: Student.studentsList,
                    parent: this,
                  ),
                );
                setState(() {
                  Student.studentsList.length;
                });
              },
            ),
          ),
        ),
      ),
      secondaryActions: <Widget>[
        IconSlideAction(
            caption: 'نزول',
            color: Colors.red,
            icon: Icons.exit_to_app,
            onTap: () async {
              ConfirmAction ans =
                  await Dialogs.ConfirmDialog(context: context, msg: "هل تريد نزول الطالب؟");
              if (ans == ConfirmAction.ACCEPT) {
                String dropURL = '$baseURL/dropstudent';
                var dropBody = json.encode({
                  'PICKED_UP_STUDENT_SERIAL': student.pickedUpSerial,
                });
                var responseDrop = await http.post(dropURL,
                    headers: {"Content-Type": "application/json"}, body: dropBody);
                var responseDropData = json.decode(responseDrop.body);
                if (responseDropData['message'] == 'The student has been dropped') {
                  int index =
                      Student.getStudentIndexFromList(student.studentId, Student.studentsList);
                  setState(() {
                    Student.studentsList.removeAt(index);
                    pickedUpNumber--;
                    availableCapacity++;
                    _store.set('bus-capacity', availableCapacity);
                    chartKey.currentState.updateData([
                      new CircularStackEntry(
                        <CircularSegmentEntry>[
                          new CircularSegmentEntry(
                            ((pickedUpNumber / _store.get('bus').capacity) * 100),
                            Colors.orange[800],
                            rankKey: 'completed',
                          ),
                          new CircularSegmentEntry(
                            (((_store.get('bus').capacity - pickedUpNumber) /
                                    _store.get('bus').capacity) *
                                100),
                            Colors.orange[100],
                            rankKey: 'remaining',
                          ),
                        ],
                        rankKey: 'progress',
                      ),
                    ]);
                  });
                }
              }
            }),
      ],
    );
  }

  Future scan() async {
    try {
      var barcode = await BarcodeScanner.scan();
      setState(() {
        this.barcode = barcode;
        List splittedBarcode = this.barcode.split('##');
        this.studentId = int.parse(splittedBarcode[0]);
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

  loadStudentsInBus() async {
    final response = await http
        .get('$baseURL/getpickedupstudents/1', headers: {"Content-type": "application/json"});
    var responseData = json.decode(response.body);
    for (var studentJson in responseData) {
      Student student = Student.fromJson(studentJson);
      student.pickedUpSerial = studentJson["PICKED_UP_STUDENT_SERIAL"];
      setState(() {
        Student.studentsList.add(student);
      });
    }
    int tempCapacity = _store.get('bus').capacity;
    tempCapacity -= Student.studentsList.length;
    setState(() {
      availableCapacity = tempCapacity;
      pickedUpNumber = _store.get('bus').capacity - availableCapacity;
    });
    _store.set('bus-capacity', tempCapacity);
    setState(() {
      chartKey.currentState.updateData([
        new CircularStackEntry(
          <CircularSegmentEntry>[
            new CircularSegmentEntry(
              ((pickedUpNumber / _store.get('bus').capacity) * 100),
              Colors.orange[800],
              rankKey: 'completed',
            ),
            new CircularSegmentEntry(
              (((_store.get('bus').capacity - pickedUpNumber) / _store.get('bus').capacity) * 100),
              Colors.orange[100],
              rankKey: 'remaining',
            ),
          ],
          rankKey: 'progress',
        ),
      ]);
    });
  }

  removeStudentFromList(int id, List<Student> lst) {
    for (int i = 0; i < lst.length; i++) {
      if (lst[i].studentId == id) {
        setState(() {
          lst.removeAt(i);
        });
        break;
      }
    }
  }
}
