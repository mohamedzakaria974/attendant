import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_circular_chart/flutter_circular_chart.dart';
import 'package:http/http.dart' as http;
import 'package:toast/toast.dart';

import '../../helpers/Constants.dart';
import '../../model/Student.dart';
import '../../screens/NearStudents.dart';
import '../../sevice/GlobalState.dart';
import '../../widget/dialogs/Dialog.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 55.0;
}

class StudentDialog extends StatefulWidget {
  final Student student;
  List<Student> studentsList;
  NearStudentState parent;

  StudentDialog({this.student, this.studentsList, this.parent});

  @override
  _StudentDialogState createState() => _StudentDialogState();
}

class _StudentDialogState extends State<StudentDialog> {
  GlobalState _store = GlobalState.instance;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context, widget.student, widget.studentsList),
    );
  }

  dialogContent(BuildContext context, Student student, List<Student> lst) {
    return Stack(
      children: <Widget>[
        // Image of the user
        Positioned(
          left: Consts.padding,
          right: Consts.padding,
          top: 16.0,
          child: new Container(
            width: 100.0,
            height: 160.0,
            decoration: new BoxDecoration(
              shape: BoxShape.circle,
              image: new DecorationImage(
                fit: BoxFit.contain,
                image: MemoryImage(student.photo),
              ),
            ),
          ),
        ),
        new Container(
          padding: EdgeInsets.only(
            top: 140.0,
            bottom: Consts.padding,
            left: Consts.padding,
            right: Consts.padding,
          ),
          margin: EdgeInsets.only(top: Consts.avatarRadius),
          child: new Column(
            children: <Widget>[
              Padding(
                child: Text(
                  student.studentName,
                  style: TextStyle(
                      fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.orange[800]),
                ),
                padding: EdgeInsets.only(bottom: 10.0),
              ),
              Divider(
                height: 25.0,
                color: Colors.orange[800],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: new Text(student.studentNID.toString(),
                          style: TextStyle(
                              fontSize: 14.0, fontWeight: FontWeight.bold, color: Colors.black54)),
                    ),
                    new Text("  : الرقم القومى",
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800])),
                  ]),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                    new Text(student.studentSchool.schoolName,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black54)),
                    new Container(
                      child: Row(
                        children: <Widget>[
                          new Text("  :  مدرسة ",
                              style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.orange[800])),
                        ],
                      ),
                    ),
                  ]),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                    new Text(student.stopStation.stopName,
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black54)),
                    new Text("  : المحطة",
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800])),
                  ]),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                    new Container(
                      child: new Text(student.studentMobile,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black54)),
                    ),
                    new Text("  :  رقم الموبايل",
                        style: TextStyle(
                            fontSize: 15.0,
                            fontWeight: FontWeight.bold,
                            color: Colors.orange[800])),
                  ]),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: new Text(student.studentClass,
                          style: TextStyle(
                              fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black54)),
                    ),
                    new Text(
                      "  :  السنة الدراسية ",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.orange[800]),
                    ),
                  ]),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Row(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
                    new Container(
                      margin: EdgeInsets.only(bottom: 5.0),
                      child: new Text(
                        "5",
                        style: TextStyle(
                            fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.black54),
                      ),
                    ),
                    new Text(
                      "  : عدد المحطات ",
                      style: TextStyle(
                          fontSize: 15.0, fontWeight: FontWeight.bold, color: Colors.orange[800]),
                    ),
                  ]),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
                (checkStudent(Student.studentsList, student.studentId) != -1)
                    ? RaisedButton(
                        color: Colors.red,
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Transform.rotate(
                              angle: 180 * math.pi / 180,
                              child: Icon(
                                Icons.exit_to_app,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                            new Container(
                              alignment: Alignment.center,
                              child: Text(
                                "نزول",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        onPressed: () async {
                          if (Student.studentsList.length > 0) {
                            setState(() {
                              Navigator.pop(context);
                            });
                            ConfirmAction ans = await Dialogs.ConfirmDialog(
                                context: context, msg: "هل تريد نزول الطالب؟");
                            if (ans == ConfirmAction.ACCEPT) {
                              int index = checkStudent(lst, student.studentId);
                              print(index);
                              if (index != -1) {
                                String dropURL = '$baseURL/dropstudent';
                                var dropBody = json.encode({
                                  'PICKED_UP_STUDENT_SERIAL': lst[index].pickedUpSerial,
                                });
                                var responseDrop = await http.post(dropURL,
                                    headers: {"Content-Type": "application/json"}, body: dropBody);
                                var responseDropData = json.decode(responseDrop.body);
                                if (responseDropData['message'] == 'The student has been dropped') {
                                  int index =
                                      Student.getStudentIndexFromList(student.studentId, lst);

                                  widget.parent.setState(() {
                                    Student.studentsList.removeAt(index);
                                    widget.parent.pickedUpNumber--;
                                    widget.parent.availableCapacity++;
                                    _store.set('bus-capacity', widget.parent.availableCapacity);
                                    widget.parent.chartKey.currentState.updateData([
                                      new CircularStackEntry(
                                        <CircularSegmentEntry>[
                                          new CircularSegmentEntry(
                                            ((widget.parent.pickedUpNumber /
                                                    _store.get('bus').capacity) *
                                                100),
                                            Colors.orange[800],
                                            rankKey: 'completed',
                                          ),
                                          new CircularSegmentEntry(
                                            (((_store.get('bus').capacity -
                                                        widget.parent.pickedUpNumber) /
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
                            }
                          } else {
                            Navigator.pop(context);
                          }
                        })
                    : RaisedButton(
                        color: Colors.green,
                        child: new Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            SizedBox(
                              width: 15.0,
                            ),
                            new Container(
                              alignment: Alignment.center,
                              child: Text(
                                "ركوب",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 15.0,
                            ),
                          ],
                        ),
                        onPressed: () async {
                          setState(() {
                            Navigator.pop(context);
                          });
                          ConfirmAction ans = await Dialogs.ConfirmDialog(
                              context: context, msg: "هل تريد ركوب الطالب؟");
                          if (ans == ConfirmAction.ACCEPT) {
                            widget.parent.busCapacity = _store.get('bus-capacity');
                            bool rideFlag = widget.parent.busCapacity > 0;
                            String url = '$baseURL/scanstudent';

                            var body = json.encode({
                              'STUDENT_ID': student.studentId,
                              'BUS_ROUTE_ID': _store.get('bus').routeSerial,
                              'ROUTE_ID': _store.get('bus').routeId,
                              'RIDEFLAG': rideFlag
                            });

                            var response = await http.post(url,
                                headers: {"Content-Type": "application/json"}, body: body);
                            var responseData = json.decode(response.body);
                            if (responseData['message'] != null) {
                              if (responseData['message'] == "The Student Pickedup") {
                                responseData['STUDENT']['STOP_ID'] = responseData['STOP_ID'];
                                responseData['STUDENT']['STOP_NAME'] = responseData['STOP_NAME'];
                                responseData['STUDENT']['LONGITUDE'] = responseData['LONGITUDE'];
                                responseData['STUDENT']['LATITUDE'] = responseData['LATITUDE'];
                                Student tempStudent = Student.fromJson(responseData['STUDENT']);
                                tempStudent.pickedUpSerial =
                                    responseData['PICKED_UP_STUDENT_SERIAL'];

                                widget.parent.setState(() {
                                  Student.studentsList.add(tempStudent);
                                  widget.parent.availableCapacity--;
                                  widget.parent.pickedUpNumber++;
                                });
                                widget.parent.busCapacity--;
                                _store.set('bus-capacity', widget.parent.busCapacity);
                                widget.parent.chartKey.currentState.updateData([
                                  new CircularStackEntry(
                                    <CircularSegmentEntry>[
                                      new CircularSegmentEntry(
                                        ((widget.parent.pickedUpNumber /
                                                _store.get('bus').capacity) *
                                            100),
                                        Colors.orange[800],
                                        rankKey: 'completed',
                                      ),
                                      new CircularSegmentEntry(
                                        (((_store.get('bus').capacity -
                                                    widget.parent.pickedUpNumber) /
                                                _store.get('bus').capacity) *
                                            100),
                                        Colors.orange[100],
                                        rankKey: 'remaining',
                                      ),
                                    ],
                                    rankKey: 'progress',
                                  ),
                                ]);
                              }
                              if (responseData['message'] == "The Student Already Pickedup") {
                                int pickedUpStudentSerial =
                                    responseData['PICKED_UP_STUDENT_SERIAL'];
                                ConfirmAction ans = await Dialogs.ConfirmDialog(
                                    context: context, msg: "الطالب بالفعل راكب هل تريد انزاله؟");
                                if ((ans == ConfirmAction.ACCEPT) &&
                                    (Student.studentsList.length > 0)) {
                                  String dropURL = '$baseURL/dropstudent';

                                  var dropBody = json.encode({
                                    'PICKED_UP_STUDENT_SERIAL': pickedUpStudentSerial,
                                  });

                                  var responseDrop = await http.post(dropURL,
                                      headers: {"Content-Type": "application/json"},
                                      body: dropBody);
                                  var responseDropData = json.decode(responseDrop.body);
                                  if (responseDropData['message'] ==
                                      'The student has been dropped') {
                                    widget.parent.busCapacity++;
                                    widget.parent.removeStudentFromList(
                                        student.studentId, Student.studentsList); //barcode
                                    setState(() {
                                      widget.parent.availableCapacity++;
                                      widget.parent.pickedUpNumber--;
                                    });
                                    _store.set('bus-capacity', widget.parent.busCapacity);
                                    widget.parent.chartKey.currentState.updateData([
                                      new CircularStackEntry(
                                        <CircularSegmentEntry>[
                                          new CircularSegmentEntry(
                                            ((widget.parent.pickedUpNumber /
                                                    _store.get('bus').capacity) *
                                                100),
                                            Colors.orange[800],
                                            rankKey: 'completed',
                                          ),
                                          new CircularSegmentEntry(
                                            (((_store.get('bus').capacity -
                                                        widget.parent.pickedUpNumber) /
                                                    _store.get('bus').capacity) *
                                                100),
                                            Colors.orange[100],
                                            rankKey: 'remaining',
                                          ),
                                        ],
                                        rankKey: 'progress',
                                      ),
                                    ]);
                                  }
                                }
                              } else if (responseData['message'] ==
                                  'There is no such student in this route') {
                                Toast.show(
                                    'لا يمكن ركوب الطالب على هذا الخط', widget.parent.context,
                                    duration: Toast.LENGTH_LONG, gravity: Toast.BOTTOM);
                              }
                            }
                          }
                        })
              ])
            ],
          ),
        )
      ],
    );
  }

  checkStudent(List<Student> lst, int id) {
    for (int i = 0; i < lst.length; i++) {
      if (lst[i].studentId == id) return i;
    }
    return -1;
  }
}
