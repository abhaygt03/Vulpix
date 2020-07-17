import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:image_picker/image_picker.dart';

class Utils{
static String getUsername(String email){
  return "live:${email.split('@')[0]}";
}

static String getInitials(String name){
List<String> nameSplit=name.split(" ");
String fstname=nameSplit[0][0];
String lstname=nameSplit[1][0];
return fstname+lstname;
} 


static Future<File> pickImage({@required ImageSource source}) async{
final _picker = ImagePicker();
PickedFile file=await _picker.getImage(source: source,
                                      maxWidth: 800,maxHeight: 800,imageQuality: 85);

   File selectedImage=File(file.path);
   return selectedImage;                                
}

}