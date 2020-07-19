import 'package:flutter/material.dart';
import 'package:vulpix/models/call.dart';

class PickupScreen extends StatelessWidget {
 final Call call;

  PickupScreen({
    this.call,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(vertical: 100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[

          ],
        ),
      ),
    );
  }
}