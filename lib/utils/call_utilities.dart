import 'dart:math';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:vulpix/models/call.dart';
import 'package:vulpix/models/user.dart';
import 'package:vulpix/resources/call_methods.dart';
import 'package:vulpix/screens/call_screens/callscreen.dart';

class CallUtils{
static final CallMethods callMethods=CallMethods();

static dial({User from,User to,context}) async {
  Call call=Call(
    callerId: from.uid,
    callerName: from.name,
    callerPic: from.profilePhoto,
    receiverId: to.uid,
    receiverName: to.name,
    receiverPic: to.profilePhoto,
    channelId: Random().nextInt(100000).toString(),
  );

  bool callMade=await callMethods.makeCall(call: call);
  call.hasDialled=true;

  if(callMade){
    Navigator.push(context,
    MaterialPageRoute(builder: (context)=>CallScreen(call: call,role: ClientRole.Broadcaster,)));
  }
}
}