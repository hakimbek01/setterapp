import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class StoreService {

  static final _storage=FirebaseStorage.instance.ref();
  static const _folder="post_image";
  static const folderAdmin="admin_image";


  static Future<List> uploadImage(List _image) async {
    List? list=[];

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

  static Future<String?> uploadAdminImage(File image) async {
    String imgName="image_"+DateTime.now().toString();
    var firebaseStorageRef = _storage.child(folderAdmin).child(imgName);
    var uploadTask=firebaseStorageRef.putFile(image);
    final TaskSnapshot taskSnapshot=await uploadTask.whenComplete(() => {});
    String downloadUrl= await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }
}