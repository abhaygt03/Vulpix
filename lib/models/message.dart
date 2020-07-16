import 'package:cloud_firestore/cloud_firestore.dart';

class Message{
  String senderId;
  String receiverId;
  String type;
  String message;
  String photoUrl;
  FieldValue timestamp;

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

  Message fromMap(Map<String,dynamic> map){
    Message _message=Message();
    _message.timestamp=map['timestamp'];
    _message.senderId=map['senderId'];
    _message.receiverId=map['receiverId'];
    _message.message=map['message'];
    _message.type=map['type'];

    return _message;
  }

}