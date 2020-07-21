import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vulpix/models/call.dart';
import 'package:vulpix/provider/userprovider.dart';
import 'package:vulpix/resources/call_methods.dart';
import 'package:vulpix/screens/call_screens/pick_up/pickupscreen.dart';

class PickupLayout extends StatelessWidget {
  final Widget scaffold;
  final CallMethods callMethods=CallMethods();

  PickupLayout({@required this.scaffold});
  @override
  Widget build(BuildContext context) {

      final UserProvider userProvider=Provider.of<UserProvider>(context);

    return (userProvider!=null&& userProvider.getUser!=null) ?
    StreamBuilder<DocumentSnapshot>(
      stream: callMethods.callStream(uid:userProvider.getUser.uid),
      builder: (context,snapshot){
        if(snapshot.hasData&&snapshot.data.data!=null)
        {
          Call call=Call.fromMap(snapshot.data.data);

            if(!call.hasDialled)
            {
            return PickupScreen(call: call);
            }
            return scaffold;
        }
        return scaffold;
      },
    )
    :Scaffold(
      body:Center(child: CircularProgressIndicator(),)
    );
  }
}