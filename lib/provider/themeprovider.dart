import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
class Theme_Provider with ChangeNotifier{
  var theme="D";
  void changeTheme(){
    (theme=="D")?theme="L":theme="D";
    notifyListeners();
  }
}