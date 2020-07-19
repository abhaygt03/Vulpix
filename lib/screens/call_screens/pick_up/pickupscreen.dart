import 'package:flutter/material.dart';
import 'package:vulpix/models/call.dart';
import 'package:vulpix/resources/call_methods.dart';
import 'package:vulpix/screens/call_screens/callscreen.dart';

class PickupScreen extends StatelessWidget {
 final Call call;

 final CallMethods callMethods=CallMethods();

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
                
                Text("Incoming...",
                style: TextStyle(
                  fontSize: 30,
                ),),
                
                SizedBox(height: 50),
                
                Image.network(
                call.callerPic,
                height: 150,
                width: 150),
                
                SizedBox(height: 15),
                
                Text(
                  call.callerName,
                  style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 75),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    IconButton(
                      icon: Icon(Icons.call_end,),
                      color: Colors.redAccent,
                      onPressed: () async{
                        await callMethods.endCall(call:call);
                      },
                    ),

                SizedBox(width: 25),

                 IconButton(
                      icon: Icon(Icons.call),
                      color: Colors.green,
                      onPressed: () {
                        Navigator.push(context, 
                        MaterialPageRoute(
                          builder: (context)=>CallScreen(call: call),
                          ));
                      },
                    ),
                    
                  ],),
          ],
        ),
      ),
    );
  }
}