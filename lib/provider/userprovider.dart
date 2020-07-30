import 'package:flutter/material.dart';
import 'package:vulpix/models/user.dart';
import 'package:vulpix/resources/auth_methods.dart';


class UserProvider with ChangeNotifier{
  User _user;
  AuthMethods _authMethods = AuthMethods(); 

  User get getUser=>_user;

  Future<void> refreshUser() async{
    User user =await _authMethods.getUserDetails();
    _user=user;
    notifyListeners();
  }
  
}