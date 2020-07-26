import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vulpix/models/message.dart';
import 'package:vulpix/models/user.dart';

class ChatMethods{

  static final Firestore _firestore=Firestore.instance;

     
     
      Future<void> addMessageToDb(Message message,User sender,User receiver) async {
        var map=message.toMap();

        await _firestore.collection('messages')
        .document(message.senderId)
        .collection(message.receiverId).add(map);

       return await _firestore.collection('messages')
        .document(message.receiverId)
        .collection(message.senderId).add(map);

    }



    void setImageMsg(String url,String senderId,String receiverId){

        Message _message;
        _message=Message.imageMessage(
         message:"Image",
         receiverId: receiverId,
         senderId: senderId,
         type: 'image',
         photoUrl: url,
         timestamp: Timestamp.now(),
        );

        var map=_message.toImagemap();

        _firestore.collection('messages')
        .document(senderId)
        .collection(receiverId)
        .add(map);

        _firestore.collection('messages')
        .document(receiverId)
        .collection(senderId)
        .add(map);
    }
}