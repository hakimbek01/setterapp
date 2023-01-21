import 'dart:convert';

import 'package:firebase_database/firebase_database.dart';
import 'package:setterapp/model/product_model.dart';

class RTDBService {
  static final _database=FirebaseDatabase.instance.ref();

  static Future<Stream<DatabaseEvent>> addPost(Product product) async {
    _database.child("product").push().set(product.toJson());
    return _database.onChildAdded;
  }


  static Future<List<Product>> getPost() async {
    List<Product> items=[];
    Query query=_database.ref.child("product");
    DatabaseEvent event=await query.once();
    var snapshot=event.snapshot;

    for (var child in snapshot.children) {
      var jsonPost=jsonEncode(child.value);
      Map<String,dynamic> map=jsonDecode(jsonPost);
      var post=Product(content: map['content'],category: map['category'],imgUrls: map['imgUrls'],name: map['name'],id: map['id'],price: map['price']);
      items.add(post);
    }

    return items;
  }


}