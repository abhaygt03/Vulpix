import 'package:flutter/material.dart';
import 'package:vulpix/models/user.dart';
import 'package:vulpix/resources/firebase_repository.dart';

class UserProvider with ChangeNotifier{
  User _user;

  FirebaseRepository _repository=FirebaseRepository();

  User get getUser=>_user;

  void refreshUser() async{
    User user =await _repository.getUserDetails();
    _user=user;
    notifyListeners();
  }
  
}