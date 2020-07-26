import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:vulpix/models/user.dart';
import 'package:vulpix/provider/image_upload_provider.dart';
import 'chat_methods.dart';

class StorageMethods{
  static final Firestore firestore=Firestore.instance;

  StorageReference _storageReference;
  User user = User();


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

      void uploadImage(File image,String senderId,String receiverId,ImageUploadProvider imageUploadProvider) async{
        final ChatMethods chatMethods = ChatMethods();
        imageUploadProvider.setToLoading();

        String url=await uploadImageToStorage(image);

        imageUploadProvider.setToIdle();

        chatMethods.setImageMsg(url,senderId,receiverId);
    }
 
}