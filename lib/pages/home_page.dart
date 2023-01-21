import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:setterapp/pages/create_page.dart';
import 'package:setterapp/pages/signup_page.dart';
import 'package:setterapp/service/auth_service.dart';
import 'package:setterapp/service/rtdb_service.dart';

import '../model/product_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  List<Product> items=[];

  void getPost() {
    RTDBService.getPost().then((value) {
      setState(() {
        items=value;
      });
    });
  }

  @override
  void initState() {
    getPost();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        title: Text("Admin Panel",style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(
            onPressed: () {
              AuthService.signOut().then((value) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp(),));
              });
            },
            icon: Icon(Icons.logout),
          )
        ],
      ),
      body: ListView(
        children: items.map((e) {
          return itemOfPost(e);
        }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, MaterialPageRoute(builder: (context) => CreatePage(),));
          getPost();
        },
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),side: BorderSide(color: Colors.black,width: 1)),
        child: Icon(Icons.add,color: Colors.black,),
      ),
    );
  }

  Widget itemOfPost(Product product) {
    return Container(
      height: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 1,color: Colors.blue),
        borderRadius: BorderRadius.circular(20)
      ),
      clipBehavior: Clip.hardEdge,
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              physics: PageScrollPhysics(),
              scrollDirection: Axis.horizontal,
              itemCount: 1,
              itemBuilder: (context, index) {
                print(product.name);
                print(product.content);
                print(product.price);
                print(product.category);
                print(product.id);
                print(product.imgUrls![index]);
                return Container(
                  child: CachedNetworkImage(
                    imageUrl: product.imgUrls![index],
                    fit: BoxFit.cover,
                  ),
                );
              },
            )
          ),
        ],
      ),
    );
  }

}
