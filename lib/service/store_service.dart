import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StoreService {

  static final _storage=FirebaseStorage.instance.ref();
  static const _folder="post_image";

  static Future<List<String>?> uploadImage(List _image) async {

    List<String>? list=[];


    for (var a in _image) {
      String imageName="image_${DateTime.now()}";
      Reference reference=_storage.child(_folder).child(imageName);
      final UploadTask uploadTask= reference.putFile(a);
      TaskSnapshot taskSnapshot=await uploadTask.whenComplete(() => {});
      final String downloadUrl=await taskSnapshot.ref.getDownloadURL();
      list.add(downloadUrl);
    }

    return list;
  }
}