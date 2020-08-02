import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';
import 'package:vulpix/enum/user_state.dart';

class Utils{
static String getUsername(String email){
  return "live:${email.split('@')[0]}";
}

static String getInitials(String name){
  if(name.contains(new RegExp(r'\s+(?=\S{1})'))&&!(name.contains("  ")))
  {
List<String> nameSplit=name.split(' ');
String fstname=nameSplit[0][0].toUpperCase();
String lstname=nameSplit[1][0].toUpperCase();
return fstname+lstname;
  }
  else
  return name[0].toUpperCase();
} 


static Future<File> pickImage({@required ImageSource source}) async{
final _picker = ImagePicker();
PickedFile file=await _picker.getImage(source: source,
                                      maxWidth: 800,maxHeight: 800,imageQuality: 85);

   File selectedImage=File(file.path);
   return selectedImage;                                
}

static int stateToNum(UserState userState){
  switch(userState)
  {
    case UserState.Offline:
    return 0;
    
    case UserState.Online:
    return 1;
    
    default:
    return 2;
  }
}

static numToState(int num){
    switch(num)
    {
      case 0:
      return UserState.Offline;

      case 1:
      return UserState.Online;

      default:
      return UserState.Waiting;
    }
}

}