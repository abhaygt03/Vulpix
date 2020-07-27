import 'package:flutter/material.dart';
import 'package:vulpix/utils/universalvariables.dart';

class NewChatButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: UniversalVariables.fabGradient,
        shape: BoxShape.circle,
        border:Border.all(
          width: 1,
          color: Colors.white,
        ),
      ),
      child: Icon(Icons.message,
      color: Colors.white,
      size: 25,
     ),
     padding: EdgeInsets.all(15),
    );
  }
}