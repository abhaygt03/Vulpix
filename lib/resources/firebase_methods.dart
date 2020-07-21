import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vulpix/models/message.dart';
import 'package:vulpix/models/user.dart';
import 'package:vulpix/provider/image_upload_provider.dart';
import 'package:vulpix/utils/utils.dart';

class FirebaseMethods {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn =GoogleSignIn();
  static final Firestore firestore=Firestore.instance;
  StorageReference _storageReference;
  static final CollectionReference _userCollection= firestore.collection("users");

  User user=User();

  Future<FirebaseUser> getCurrentUser() async {
    FirebaseUser currentUser;
    currentUser = await _auth.currentUser();
    return currentUser;
  }

  Future<User> getUserDetails() async{
        FirebaseUser currentUser=await getCurrentUser();

        DocumentSnapshot documentSnapshot=await _userCollection.document(currentUser.uid).get();

        return User.fromMap(documentSnapshot.data);

  }

  Future<FirebaseUser> signIn() async{
    GoogleSignInAccount _signInAccount=await _googleSignIn.signIn();
    GoogleSignInAuthentication _signInAuthentication=await _signInAccount.authentication;

    final AuthCredential credential=GoogleAuthProvider.getCredential(
      idToken: _signInAuthentication.idToken, 
      accessToken: _signInAuthentication.accessToken
      );

    AuthResult result=await _auth.signInWithCredential(credential);
    FirebaseUser user=result.user;
    return user;
  }

    Future<bool> authenticateUser(FirebaseUser user) async{
      QuerySnapshot result=await firestore.collection("users").where("email",isEqualTo:user.email).getDocuments();
      final List <DocumentSnapshot> docs=result.documents;
      return docs.length==0?true:false;
    }  

    Future<void> addDataToDb(FirebaseUser currentUser) async{
      String username=Utils.getUsername(currentUser.email);
      user=User(
        uid: currentUser.uid,
        name:currentUser.displayName,
        email:currentUser.email,
        profilePhoto:currentUser.photoUrl,
        username:username
      );
      firestore.collection("users")
      .document(currentUser.uid)
      .setData(user.toMap(user));
    }

    Future<void> signOut() async{
      await _googleSignIn.disconnect();
      await _googleSignIn.signOut();
      return await _auth.signOut();
    }

    Future<List<User>> fetchAllUsers(FirebaseUser currentUser) async{
        List<User> userList=List();

        QuerySnapshot querySnapshot=await firestore.collection("users").getDocuments();

        for(var i=0;i<querySnapshot.documents.length;i++)
        {
          if(querySnapshot.documents[i].documentID!=currentUser.uid)
          {
           userList.add(User.fromMap(querySnapshot.documents[i].data));
          }
        }
       
        return userList;
    }

    Future<void> addMessageToDb(Message message,User sender,User receiver) async {
        var map=message.toMap();

        await firestore.collection('messages')
        .document(message.senderId)
        .collection(message.receiverId).add(map);

       return await firestore.collection('messages')
        .document(message.receiverId)
        .collection(message.senderId).add(map);

    }

    Future<String> uploadImageToStorage(File image) async{

      try{ 
        _storageReference=FirebaseStorage.instance
      .ref().child('${DateTime.now().millisecondsSinceEpoch}');

      StorageUploadTask _storageUploadTask=_storageReference.putFile(image);

      var url=await(await _storageUploadTask.onComplete).ref.getDownloadURL();

      return url;
      }
      catch(err)
      {
        print(err);
        return null;
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

        firestore.collection('messages')
        .document(senderId)
        .collection(receiverId)
        .add(map);

        firestore.collection('messages')
        .document(receiverId)
        .collection(senderId)
        .add(map);
    }

    void uploadImage(File image,String senderId,String receiverId,ImageUploadProvider imageUploadProvider) async{
        
        imageUploadProvider.setToLoading();

        String url=await uploadImageToStorage(image);

        imageUploadProvider.setToIdle();

        setImageMsg(url,senderId,receiverId);
    }
}


