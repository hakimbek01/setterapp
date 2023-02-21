import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:setterapp/pages/create_page.dart';
import 'package:setterapp/pages/searchinfo_page.dart';
import 'package:setterapp/pages/signup_page.dart';
import 'package:setterapp/pages/update_page.dart';
import 'package:setterapp/service/auth_service.dart';
import 'package:setterapp/service/data_service.dart';

import '../model/product_model.dart';
import '../service/prefs_service.dart';

class ProductsPage extends StatefulWidget {
  const ProductsPage({Key? key}) : super(key: key);

  @override
  State<ProductsPage> createState() => _ProductsPageState();
}

class _ProductsPageState extends State<ProductsPage> {

  List<Product> items=[];
  List<String> category=[];
  bool isSeries=true;
  bool visiableProduct=false;
  bool remove=false;

  @override
  void initState() {
    getProducts();
    getCategory();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await getProducts();
          },
          child: Column(
            children: [
              SizedBox(height: 10,),
              Padding(
                padding: EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: (){
                        setState(() {
                          visiableProduct=true;
                          isSeries=true;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                            border: visiableProduct?Border.all(width: .6,color: Colors.blue): Border(),
                          borderRadius: BorderRadius.circular(7)
                        ),
                        child: Image(
                          height: 40,
                          image: AssetImage("assets/buttons/all.png"),
                        )
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        setState(() {
                          visiableProduct=false;
                          isSeries=false;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          border: visiableProduct? Border():Border.all(width: .6,color: Colors.blue),
                          borderRadius: BorderRadius.circular(7)
                        ),
                        child: Image(
                          height: 40,
                          image: AssetImage('assets/buttons/category.png'),
                        ),
                      ),
                    ),

                    InkWell(
                      onTap: () async {
                        await Navigator.push(context, CupertinoPageRoute(builder: (context) => CreatePage(),));
                        getProducts();
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(7)
                        ),
                        child: Image(
                          height: 40,
                          image: AssetImage('assets/buttons/add.png'),
                        ),
                      ),
                    ),

                    visiableProduct?
                    InkWell(
                      onTap: () {
                        setState(() {
                          isSeries=!isSeries;
                        });
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(7)
                        ),
                        child: isSeries?
                        Image(
                          height: 40,
                          image: AssetImage('assets/buttons/series_2.png'),
                        ):
                        Image(
                          height: 40,
                          image: AssetImage('assets/buttons/series_1.png'),
                        )
                        ,
                      ),
                    ):
                    SizedBox()
                  ],
                ),
              ),
              Expanded(
                child: visiableProduct?
                GridView.count(
                  crossAxisCount: isSeries?2:1,
                  childAspectRatio: isSeries?2/2.4:5.5/1,
                  mainAxisSpacing: 10,
                  children: items.map((e) {
                    return itemOfProduct(e);
                  }).toList(),
                ):
                ListView(
                  children: category.map((e) {
                    return itemOfCategory(e);
                  }).toList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget itemOfProduct(Product product) {
    return InkWell(
      onTap: () async{
        await Navigator.push(context, CupertinoPageRoute(builder: (context) => UpdatePage(product: product),));
        getProducts();
      },
      child: isSeries?
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 1,color: Colors.deepPurpleAccent),
            borderRadius: BorderRadius.circular(20)
        ),
        child: Stack(
          children: [
            Column(
              children: [
                Expanded(
                  child: product.imgUrls!.isNotEmpty?
                  Swiper(
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
                  ):
                  Image(
                    image: AssetImage("assets/images/placeholder.png"),
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
            Align(
              alignment: Alignment.bottomRight,
              child: InkWell(
                onTap: () {
                  bottomMessage(product.id!);
                },
                child: Container(
                  padding: EdgeInsets.all(1),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomRight: Radius.circular(10))
                  ),
                  child: Icon(Icons.delete,color: Colors.white.withOpacity(.9),),
                ),
              ),
            )
          ],
        ),
      ):
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          border: Border.all(width: .7,color: Colors.purpleAccent.shade100),
          borderRadius: BorderRadius.circular(10)
        ),
        child: Row(
          children: [
            Expanded(
              child: Container(
                width: 100,
                child: product.imgUrls!.isNotEmpty?
                Swiper(
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
                ):
                Image(
                  fit: BoxFit.cover,
                  image: AssetImage("assets/images/placeholder.png"),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name!,maxLines: 1,style: TextStyle(overflow: TextOverflow.ellipsis,color: Colors.red,fontWeight: FontWeight.bold),),
                    Text(product.price!,style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: Text(product.content!,maxLines: 3,style: TextStyle(color: Colors.black54,overflow: TextOverflow.ellipsis),)),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                onPressed: () async {
                  bottomMessage(product.id!);
                },
                icon: Icon(Icons.delete,color: Colors.black.withOpacity(.66),),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget itemOfCategory(String categoryName) {
    return InkWell(
      onTap: () {
        Navigator.push(context, CupertinoPageRoute(builder: (context) => SearchInfoPage(categoryName: categoryName),));
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 10,right: 10,left: 10),
        padding: EdgeInsets.symmetric(horizontal: 20),
        height: MediaQuery.of(context).size.width/6.5,
        width: double.infinity,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            border: Border.all(width: .7,color: Colors.grey.withOpacity(.5))
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(categoryName,maxLines: 3,overflow: TextOverflow.ellipsis,),
            ),
            Icon(CupertinoIcons.right_chevron)
          ],
        ),
      ),
    );
  }


  // getProducts refreshindicatorga qo'yilgani uchun future qilingan
  Future<void> getProducts() async {
    await DataService.getProduct().then((value) => {
      setState((){
        items=value;
      })
    });
  }

  void getCategory() async {
    await RTDBService.getCategory().then((value) => {
      setState((){
        category=value;
        PrefsService.storeCategory(category);
      })
    });
    storePrefsCategory();
  }

  void storePrefsCategory() {
    PrefsService.loadCategory().then((value) => {
      setState((){
        category=value!;
      })
    });
  }

  void bottomMessage(String id) async {
    setState(() {
      remove=true;
    });

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 3),
          clipBehavior: Clip.hardEdge,
          padding: EdgeInsets.zero,
          content: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10)
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 10),
                  child: Text("Mahsulotni o'chirishni "),
                ),
                TextButton(
                    onPressed: (){
                      setState(() {
                        remove=false;
                      });
                    },
                    child: Text("Bekor qilish",style: TextStyle(color: Colors.blue,),)
                )
              ],
            ),
          ),
          behavior: SnackBarBehavior.floating,
          backgroundColor:Colors.transparent,
          elevation: 0,
        )
    );
    await Future.delayed(Duration(seconds: 3));
    removeProduct(id, remove);
  }


  void removeProduct(String id, bool remove) async {
    if (remove) {
      DataService.removeProduct(id);
      getProducts();
    }
  }
}
