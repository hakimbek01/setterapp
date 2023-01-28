import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:setterapp/pages/create_page.dart';
import 'package:setterapp/pages/signup_page.dart';
import 'package:setterapp/pages/update_page.dart';
import 'package:setterapp/service/auth_service.dart';
import 'package:setterapp/service/rtdb_service.dart';

import '../model/product_model.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  List<Product> items=[];
  bool productVisiableType=true;


  Future<void> getPost() async {
    await  RTDBService.getProduct().then((value) {
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
        title: Text("Products and editing",style: GoogleFonts.aladin(color: Colors.black,fontSize: 25),),
        actions: [
          IconButton(
            onPressed: () {
              AuthService.signOut().then((value) {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUpPage(),));
              });
            },
            icon: Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () {
              setState(() {
                productVisiableType=!productVisiableType;
              });
            },
            icon: productVisiableType? Icon(Icons.menu):Icon(Icons.apps),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getPost();
        },
        child: Column(
          children: [
            SizedBox(height: 10,),
            Expanded(
              child: GridView.count(
                crossAxisCount: productVisiableType?2:1,
                childAspectRatio: productVisiableType?2/2.4:2/2,
                mainAxisSpacing: 10,
                children: items.map((e) {
                  return itemOfProduct(e);
                }).toList(),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(context, CupertinoPageRoute(builder: (context) => CreatePage(),));
          getPost();
        },
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),side: BorderSide(color: Colors.deepOrangeAccent.withOpacity(.8),width: 1)),
        child: Icon(Icons.add,color: Colors.black,),
      ),
    );
  }

  Widget itemOfProduct(Product product) {
    return GestureDetector(
      onTap: () async{
        await Navigator.push(context, CupertinoPageRoute(builder: (context) => UpdatePage(product: product),));
        getPost();
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 1,color: Colors.deepOrangeAccent),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Column(
          children: [
            Expanded(
              child: Swiper(
                itemCount: product.imgUrls!.length,
                itemBuilder: (context, index) {
                  return CachedNetworkImage(
                    imageUrl: product.imgUrls![index],
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Text("Yuklnamoqda...",style: TextStyle(fontSize: 12),)
                        ],
                      ),
                    ),
                    errorWidget: (context, url, error) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.highlight_remove,color: Colors.red,),
                          Text("Xatolik yuz berdi!",style: TextStyle(fontSize: 12),)
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 5,),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(child: Text(product.name!,maxLines: 1,style: TextStyle(overflow: TextOverflow.ellipsis,color: Colors.red,fontWeight: FontWeight.bold),)),
                      Text(product.price!,style: TextStyle(fontWeight: FontWeight.bold),)
                    ],
                  ),
                  Text(product.content!,maxLines: 3,textAlign: TextAlign.left,overflow: TextOverflow.ellipsis)
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

}
