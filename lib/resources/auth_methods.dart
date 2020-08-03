import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:vulpix/enum/user_state.dart';
import 'package:vulpix/models/user.dart';
import 'package:vulpix/utils/utils.dart';

class AuthMethods{
  static final Firestore firestore=Firestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  GoogleSignIn _googleSignIn =GoogleSignIn();

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

  Future<User> getUserDetailsById(id) async{
    try{
      DocumentSnapshot documentSnapshot=await _userCollection.document(id).get();

        return User.fromMap(documentSnapshot.data);

    }
    catch(err)
    {
      print(err);
      return null;
    }
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

     Future<bool> signOut() async{
       try{
      await _googleSignIn.signOut();
      await _auth.signOut();
      return true;
       }
       catch(err){
            print(err);
            return false;
       }
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

    
    void setUserState({@required String userId,@required UserState userState}){
      int stateNum=Utils.stateToNum(userState);
      firestore.collection('users').document(userId).updateData({
        "state":stateNum,
      }
      );
    }

    Stream<DocumentSnapshot> getUserStream({@required String uid})=>
    firestore.collection('users').document(uid).snapshots();    

    void changeUserName({@required String name,@required String userId}) async{
        firestore.collection("users").document(userId).updateData({
          "name":name,
        });
    }

       void changeUserQuote({@required String quote,@required String userId}) async{
        firestore.collection("users").document(userId).updateData({
          "quote":quote,
        });
    }

}