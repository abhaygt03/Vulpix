import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vulpix/models/call.dart';

class CallMethods{
  
  final CollectionReference callCollection=
        Firestore.instance.collection("call");

  Future<bool> makeCall({Call call}) async {

      try{
        call.hasDialled=true;
    Map<String,dynamic> hasDialled=call.toMap(call);
      call.hasDialled=false;
    Map<String,dynamic> hasNotDialled=call.toMap(call);

    await callCollection.document(call.callerId).setData(hasDialled);
    await callCollection.document(call.receiverId).setData(hasNotDialled);
     
     return true;
      }

      catch(err){
        print(err);
        return false;
      }

    }

    Future<bool> endCall({Call call}) async{

      try{
        callCollection.document(call.callerId).delete();
      callCollection.document(call.receiverId).delete();
      return true;
      }
        catch(err){
          print(err);
          return false;
        }
    } 
}