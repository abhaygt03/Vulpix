import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String senderId;
  String receiverId;
  String type;
  String message;
  String photoUrl;
  Timestamp timestamp;

  Message({
    this.message,
    this.receiverId,
    this.senderId,
    this.timestamp,
    this.type,
  });

  Message.imageMessage({
      this.photoUrl,
      this.message,
      this.receiverId,
      this.senderId,
      this.timestamp,
      this.type,
  });

  Map toMap(){
    var map=Map<String,dynamic>();
    map['senderId']=this.senderId;
    map['recerverid']=this.receiverId;
    map['message']=this.message;
    map['type']=this.type;
    map['timestamp']=this.timestamp;
    return map;
  }

  Map toImagemap(){
     var map=Map<String,dynamic>();
    map['senderId']=this.senderId;
    map['recerverid']=this.receiverId;
    map['message']=this.message;
    map['type']=this.type;
    map['timestamp']=this.timestamp;
    map['photoUrl']=this.photoUrl;
    return map;
  }

  Message.fromMap(Map<String,dynamic> map){

    this.timestamp=map['timestamp'];
    this.senderId=map['senderId'];
    this.receiverId=map['receiverId'];
    this.message=map['message'];
    this.type=map['type'];
    this.photoUrl=map['photoUrl'];
  }

}