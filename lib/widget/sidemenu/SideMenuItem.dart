import 'package:flutter/material.dart';
import '../../model/menuItem.dart';

class SideItem extends StatefulWidget {
  MenuItem item;

  @override
  _SideItemState createState() => _SideItemState();

  SideItem({this.item});
}

class _SideItemState extends State<SideItem> {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        widget.item.title,
        style: TextStyle(
          fontSize: 20.0,
          color: Colors.white
        ),
        textDirection: TextDirection.rtl,
      ),
      onTap: widget.item.onTap,
    );
  }
}
