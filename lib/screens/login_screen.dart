import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:vulpix/resources/firebase_repository.dart';
import 'package:vulpix/screens/home_screen.dart';
import 'package:shimmer/shimmer.dart';
import 'package:vulpix/utils/universalvariables.dart';


class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseRepository _repository = FirebaseRepository();
  bool isLoginPressed=false;
  @override
  Widget build(BuildContext context) {
    _repository.signOut();
    return Scaffold(
      backgroundColor: UniversalVariables.blackColor,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
       children: <Widget>[
         loginButton(),
      isLoginPressed?Center(child:CircularProgressIndicator(),):Container(),
       ], 
      ));
  }

  Widget loginButton() {
    return   FlatButton(
      padding: EdgeInsets.all(35),
      child:Shimmer.fromColors(
      child:Text(
        "LOGIN",
        style: TextStyle(
            fontSize: 35, fontWeight: FontWeight.w900, letterSpacing: 1.2),
      ),
      baseColor: Colors.white, 
    highlightColor: UniversalVariables.senderColor),
      onPressed: () { performLogin();},
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    ); 
    
  }

  void performLogin() {
    setState(() {
         isLoginPressed=true;
       });
    _repository.signIn().then((FirebaseUser user) {
      if (user != null)
        authenticateUser(user);
      else
        print("Some error occoured");
    });
  }

  void authenticateUser(FirebaseUser user) {
     setState(() {
      isLoginPressed=false;
    });
    _repository.authenticateUser(user).then((isNewUser) {
      if (isNewUser) {
        _repository.addDataToDb(user).then((value) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return HomeScreen();
          }));
        });
      } else {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return HomeScreen();
        }));
      }
    });
  }
}
