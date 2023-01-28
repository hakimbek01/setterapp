import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:setterapp/model/product_model.dart';

class RTDBService {
  static final _database=FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> addProduct(Product product) async {
    var doc = _database.child("product").push();
    product.id = doc.key;
    doc.set(product.toJson());
    return _database.onChildAdded;
  }


  static Future<List<Product>> getProduct() async {
    List<Product> items=[];
    Query query=_database.ref.child("product");
    DatabaseEvent event=await query.once();
    var snapshot=event.snapshot;

    for (var child in snapshot.children) {
      var jsonPost=jsonEncode(child.value);
      Map<String,dynamic> map=jsonDecode(jsonPost);
      var post=Product(content: map['content'],category: map['category'],imgUrls: map['imgUrls'],name: map['name'],id: map['id'],price: map['price'],isAvailable: map['isAvailable']);
      items.add(post);
    }

    return items;
  }


  static Future<Stream<DatabaseEvent>> isWorkingProduct(String content,name,price,category,bool isAvailable,String id,List imgUrls) async {
    var doc = _database.child("product").child(id).update(
        {
          "content":content,
          "imgUrls":imgUrls,
          "name":name,
          "price":price,
          "category":category,
          "isAvailable":isAvailable
        }
    );
    return _database.onChildAdded;
  }

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