import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart' hide Query;
import 'package:firebase_database/firebase_database.dart';
import 'package:setterapp/model/product_model.dart';
import 'package:setterapp/service/auth_service.dart';
import 'package:setterapp/service/store_service.dart';

import '../model/admin_model.dart';

class DataService {

  static final _firestore=FirebaseFirestore.instance;
  static String folderAdmin="admin";
  static String folderProduct="products";

  ///admins
  static Future storeAdmin(Admin admin) async {
    await _firestore.collection(folderAdmin).doc(admin.uid).set(admin.toJson());
  }

  static Future<Admin?> loadAdmin() async {
    String uid=AuthService.currentUserId();
    var value = await _firestore.collection(folderAdmin).doc(uid).get();
    Admin admin=Admin.fromJson(value.data()!);
    return admin;
  }

  static Future<List<Admin>> loadAllAdmin() async {
    List<Admin> admins=[];
    var value=await _firestore.collection(folderAdmin).get();
    for (var item in value.docs) {
      Admin admin=Admin.fromJson(item.data());
      admins.add(admin);
    }
    return admins;
  }

  static Future updateAdmin(Admin admin) async {
    String uid=AuthService.currentUserId();
    await _firestore.collection(folderAdmin).doc(uid).update(admin.toJson());
  }


  /// product
  static Future<String?> addProduct(Product product) async {
    var doc = _firestore.collection(folderProduct).doc();
    product.id = doc.id;
    doc.set(product.toJson());
    return product.id;
  }

  static Future<List<Product>> getProduct({int count = 4}) async {
    List<Product> p = [];
    var docs= await _firestore.collection(folderProduct).limit(count).get();
    for (var a in docs.docs) {
      p.add(Product.fromJson(a.data()));
    }
    return p;
  }

  static Future<List<Product>> getStatistic() async {
    List<Product> p = [];
    var docs= await _firestore.collection(folderProduct).get();
    for (var a in docs.docs) {
      p.add(Product.fromJson(a.data()));
    }
    return p;
  }

  static Future updateProduct(Product product) async {
    await _firestore.collection(folderProduct).doc(product.id).update(product.toJson());
  }

  static Future removeProduct(List ids,List imgProduct) async {
    await StoreService.removePostImage(imgProduct);
    for (var id in ids) {
      await _firestore.collection(folderProduct).doc(id).delete();
    }
  }


}

class RTDBService{
  static final _database=FirebaseDatabase.instance.ref();
  static Future<Stream<DatabaseEvent>> addCategory(List category) async {
    Map<String, dynamic> map = {};
    for (int i = 0; i < category.length; i++) {
      map.addAll({'$i' : category[i]});
    }
    _database.child("category").update(map);
    return _database.onChildAdded;
  }

  static Future<List<String>> getCategory() async {
    List<String> items=[];
    Query query=_database.ref.child("category");
    DatabaseEvent event=await query.once();
    var snapshot=event.snapshot;
    int index=0;
    for (var a in snapshot.children) {
      items.add(a.value.toString());
      index+=1;
    }
    return items;
  }
}