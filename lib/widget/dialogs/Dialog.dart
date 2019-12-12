import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Dialogs {
  static Future<ConfirmAction> ConfirmDialog(
      {BuildContext context, String msg}) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Directionality(
              textDirection: TextDirection.rtl, child: Text('تأكيد')),
          content: Directionality(
              textDirection: TextDirection.rtl, child: Text(msg)),
          actions: <Widget>[
            FlatButton(
              child: const Text('لا'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('نعم'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.ACCEPT);
              },
            )
          ],
        );
      },
    );
  }

  static void showDialogBox({BuildContext context, String msg}) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Directionality(
              textDirection: TextDirection.rtl, child: Text("تحذير")),
          content: Directionality(
              textDirection: TextDirection.rtl, child: Text(msg)),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            FlatButton(
              child: Directionality(
                  textDirection: TextDirection.rtl, child: Text("اغلاق")),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<Departments> _asyncSimpleDialog(BuildContext context) async {
    return await showDialog<Departments>(
        context: context,
        barrierDismissible: true,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: const Text('Select Departments '),
            children: <Widget>[
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Production);
                },
                child: const Text('Production'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Research);
                },
                child: const Text('Research'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Purchasing);
                },
                child: const Text('Purchasing'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Marketing);
                },
                child: const Text('Marketing'),
              ),
              SimpleDialogOption(
                onPressed: () {
                  Navigator.pop(context, Departments.Accounting);
                },
                child: const Text('Accounting'),
              )
            ],
          );
        });
  }

  Future<String> _asyncInputDialog(BuildContext context) async {
    String teamName = '';
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      // dialog is dismissible with a tap on the barrier
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter current team'),
          content: new Row(
            children: <Widget>[
              new Expanded(
                  child: new TextField(
                autofocus: true,
                decoration: new InputDecoration(
                    labelText: 'Team Name', hintText: 'eg. Juventus F.C.'),
                onChanged: (value) {
                  teamName = value;
                },
              ))
            ],
          ),
          actions: <Widget>[
            FlatButton(
              child: Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop(teamName);
              },
            ),
          ],
        );
      },
    );
  }
}

enum ConfirmAction { CANCEL, ACCEPT }
enum Departments { Production, Research, Purchasing, Marketing, Accounting }
