import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vulpix/models/contact.dart';
import 'package:vulpix/models/message.dart';
import 'package:vulpix/models/user.dart';

class ChatMethods{

  static final Firestore _firestore=Firestore.instance;

     
     
      Future<void> addMessageToDb(Message message,User sender,User receiver) async {
        var map=message.toMap();

        await _firestore.collection('messages')
        .document(message.senderId)
        .collection(message.receiverId).add(map);

        addToContacts(senderId:message.senderId,receiverId:message.receiverId);

       return await _firestore.collection('messages')
        .document(message.receiverId)
        .collection(message.senderId).add(map);

    }

    DocumentReference getContactsDocument(String of,String forContact){
      return _firestore.
      collection('users')
      .document(of)
      .collection('contacts')
      .document(forContact);
    }

    addToContacts({String senderId,String receiverId}) async {
        Timestamp currentTime=Timestamp.now();
        await addToSendersContact(senderId, receiverId, currentTime);
        await addToReceiversContact(senderId, receiverId, currentTime);
    }

    Future<void> addToSendersContact(String sendersId,String receiversId,currenttime)async{
      DocumentSnapshot snapshot= await getContactsDocument(sendersId, receiversId).get();

      if(!snapshot.exists)
      {
        Contact receiverContact=Contact(
          uid: receiversId,
          addedOn: currenttime
          );
          var receiverMap=receiverContact.toMap(receiverContact);

          getContactsDocument(sendersId,receiversId).setData(receiverMap);
      }
    }

Future<void> addToReceiversContact(String sendersId,String receiversId,currenttime)async{
      DocumentSnapshot snapshot= await getContactsDocument(receiversId,sendersId).get();

      if(!snapshot.exists)
      {
        Contact senderContact=Contact(
          uid: sendersId,
          addedOn: currenttime
          );
          var senderMap=senderContact.toMap(senderContact);

          getContactsDocument(receiversId,sendersId).setData(senderMap);
      }
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

    Stream<QuerySnapshot> fetchContacts({String userId}) {
        return _firestore.collection('users')
        .document(userId)
        .collection('contacts')
        .snapshots();
    }

    Stream<QuerySnapshot> fetchLastMessage({String senderId,String recerverId})=>
    _firestore.collection('messages').document(senderId).collection(recerverId).orderBy('timestamp').snapshots();
}