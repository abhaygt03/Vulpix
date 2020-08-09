import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:vulpix/enum/user_state.dart';
import 'package:vulpix/models/user.dart';
import 'package:vulpix/provider/themeprovider.dart';
import 'package:vulpix/resources/auth_methods.dart';
import 'package:vulpix/utils/universalvariables.dart';
import 'package:vulpix/utils/utils.dart';

class OnlineDotIndicator extends StatelessWidget {
  
  final String uid;
  
  OnlineDotIndicator({
    @required this.uid,
  });
  @override
  Widget build(BuildContext context) {
    final Theme_Provider themeProvider=Provider.of<Theme_Provider>(context);

  AuthMethods _authMethods=AuthMethods();

    getColor(int state){
      switch(Utils.numToState(state)){
        case UserState.Offline:
        return Colors.red[700];

        case UserState.Online:
        return Colors.green;

        default:
        return Colors.red[700];
      }
    }
    return StreamBuilder<DocumentSnapshot>(
      stream: _authMethods.getUserStream(uid: uid),
      builder: (context,snapshot){
        User user;
        
        if(snapshot.hasData&& snapshot.data.data!=null){
          user=User.fromMap(snapshot.data.data);
        }
        return Container(
            height: 14.5,
            width: 14.5,
            margin: EdgeInsets.only(right:8,top: 8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:getColor(user?.state),
              border: Border.all(
          color: (themeProvider.theme=="D")?UniversalVariables.blackColor:Colors.white,
                           width: 2.2,
                         )
            ),
        );
      },);
  }
}