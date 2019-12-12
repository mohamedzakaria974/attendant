import 'package:flutter/material.dart';

import '../../model/Bus.dart';

class Consts {
  Consts._();

  static const double padding = 16.0;
  static const double avatarRadius = 55.0;
}

class BusDialog extends StatelessWidget {
  final Bus bus;

  BusDialog({this.bus});

  @override
  Widget build(BuildContext context) {
    print(bus.capacity);
    print(bus);
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(Consts.padding),
      ),
      elevation: 0.0,
      backgroundColor: Colors.white,
      child: dialogContent(context, bus),
    );
  }
}

dialogContent(BuildContext context, Bus bus) {
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
              image: new ExactAssetImage(
                'assets/images/1.jpg',
              ),
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
                "محمد زكريا",
                style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 0, 147, 112)),
              ),
              padding: EdgeInsets.only(bottom: 10.0),
            ),
            Divider(
              height: 25.0,
              color: Color.fromARGB(255, 0, 147, 132),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 20.0),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: new Text(bus.busNumber,
                            style: TextStyle(
                                fontSize: 14.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54)),
                      ),
                      new Text(" : رقم الاتوبيس ",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 147, 132))),
                    ]),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      new Text(bus.modelName,
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54)),
                      new Container(
                        child: Row(
                          children: <Widget>[
                            new Text(" :  الموديل ",
                                style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 0, 147, 132))),
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
                Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Text(bus.colorName,
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54)),
                      new Text(" : اللون  ",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 147, 132))),
                    ]),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Container(
                        child: new Text(bus.busDriverName,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54)),
                      ),
                      new Text(" :  السائق ",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 147, 132))),
                    ]),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: new Text(bus.routeId,
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54)),
                      ),
                      new Text(" :  الخط ",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 147, 132))),
                    ]),
              ],
            ),
            SizedBox(
              height: 15.0,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      new Container(
                        margin: EdgeInsets.only(bottom: 5.0),
                        child: new Text("5",
                            style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54)),
                      ),
                      new Text(" : عدد المحطات ",
                          style: TextStyle(
                              fontSize: 15.0,
                              fontWeight: FontWeight.bold,
                              color: Color.fromARGB(255, 0, 147, 132))),
                    ]),
              ],
            ),
            SizedBox(
              height: 20.0,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              new RaisedButton(
                  color: Color.fromARGB(255, 0, 147, 132),
                  child: new Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.check_circle,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 15.0,
                      ),
                      new Container(
                        alignment: Alignment.center,
                        child: Text(
                          "تأكيد",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18.0,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                  onPressed: () {})
            ])
          ],
        ),
      )
    ],
  );
}
