import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_ui_firestore/firebase_ui_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:setterapp/pages/create_page.dart';
import 'package:setterapp/pages/searchinfo_page.dart';
import 'package:setterapp/pages/signup_page.dart';
import 'package:setterapp/pages/update_page.dart';
import 'package:setterapp/service/auth_service.dart';
import 'package:setterapp/service/data_service.dart';
import 'package:setterapp/service/utils_service.dart';

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
  String appBarTitle="Mahsulotlar";
  bool isSeries=true;
  bool visiableProduct=true;
  bool remove=false;
  bool removeVisiable=false;
  int removeProductCount=0;
  List removeProductsId=[];
  bool isLoading=false;
  int count = 4;
  List<dynamic> removeImgUrlList=[];
  @override
  void initState() {
    getCategory();
    getProducts();
    super.initState();
  }

  var pps = FirebaseFirestore.instance.collection("products").withConverter(
      fromFirestore: (snapshot, options) => Product.fromJson(snapshot.data()!),
      toFirestore: (value, options) => value.toJson(),);


  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
              color: Colors.black54
            ),
            backgroundColor: removeVisiable? Colors.grey.shade300: Colors.white,
            title: removeVisiable?
            Text(removeProductCount.toString(),style: TextStyle(color: Colors.black54),):
            Row(
              children: [
                PopupMenuButton(
                  child: Text(appBarTitle,style: TextStyle(color: Colors.black),),
                  itemBuilder: (context) {
                    return [
                      PopupMenuItem(
                        child: Text("Mahsulotlar"),
                        onTap: (){
                          setState(() {
                            appBarTitle="Mahsulotlar";
                            visiableProduct=true;
                            isSeries=true;
                          });
                          getProducts();
                        },
                      ),
                      PopupMenuItem(
                        child: Text("Category"),
                        onTap: (){
                          setState(() {
                            appBarTitle="Category";
                            visiableProduct=false;
                            isSeries=false;
                          });
                        },
                      )
                    ];
                  },
                ),
                SizedBox(width: 5,),
                Icon(CupertinoIcons.chevron_down,)
              ],
            ),

            actions: [
              visiableProduct && !removeVisiable?
              GestureDetector(
                onTap: (){
                  setState(() {
                    isSeries=!isSeries;
                  });
                },
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: isSeries?
                  Image(
                    height: 30,
                    image: AssetImage('assets/buttons/series_2.png'),
                  ):
                  Image(
                    height: 30,
                    image: AssetImage('assets/buttons/series_1.png'),
                  ),
                ),
              ):
              SizedBox(),

              removeVisiable?
              Row(
                children: [
                  IconButton(
                    onPressed: (){
                      setState(() {
                        removeVisiable=false;
                        removeProductCount=0;
                        removeProductsId=[];
                      });
                    },
                    icon: Icon(Icons.close,color: Colors.red,),
                  ),
                  IconButton(
                    onPressed: () async {
                      if (removeProductCount!=0) {
                        bool yes= await Utils.commonDialog(context, "Mahsulotlarni o'chirish", "Haqiqatdan bu mahsulotlarni o'chirasizmi?", "HA", "Yo'q");
                        if (yes) {
                          setState(() {
                            isLoading=true;
                          });
                          removeMoreProducts(removeProductsId,removeImgUrlList);
                        }
                      }
                    },
                    icon: Icon(Icons.check,color: Colors.green,),
                  )
                ],
              ):
              SizedBox()
            ],
          ),
          body: SafeArea(
            child:
            visiableProduct ?
            FirestoreQueryBuilder(
              query: pps,
              builder: (context, snapshot, child) {
                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isSeries?2:1,
                    childAspectRatio: isSeries?2/2.4:5.5/1,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: snapshot.docs.length,
                  itemBuilder: (context, index) {
                    bool more = snapshot.hasMore && index + 1 == snapshot.docs.length;
                    if (more) {
                      snapshot.fetchMore();
                    }
                    final user = snapshot.docs[index].data();
                    return itemOfProduct(user);
                  },
                );
              },
            ) :
            ListView(
              children: category.map((e) {
                return itemOfCategory(e);
              }).toList(),
            ),

            /*child: RefreshIndicator(
              onRefresh: () async {
                await getProducts();
              },
              child: Column(
                children: [
                  SizedBox(height: 10,),
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
                  ),

                  !removeVisiable?
                   Align(
                     alignment: Alignment.bottomLeft,
                     child: MaterialButton(
                       height: 10,
                       onPressed: (){
                         getProducts();
                       },
                       child: Text("More"),
                     ),
                   ):
                   SizedBox()
                ],
              ),
            ),*/
          ),
          floatingActionButton: MaterialButton(
            padding: EdgeInsets.zero,
            minWidth: 0,
            onPressed: () async {
              await Navigator.push(context, CupertinoPageRoute(builder: (context) => CreatePage(),));
              getCategory();
              getProducts();
            },
            child: Image(
              height: 47,
              image: AssetImage('assets/buttons/add.png'),
            ),
          ),
        ),
        isLoading?
        Scaffold(
          backgroundColor: Colors.grey.withOpacity(.4),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ):
        SizedBox()
      ],
    );
  }


  Widget itemOfProduct(Product product) {
    removeVisiable==false?
    product.removeVisiable=false:true;
    return removeVisiable?
    //o'chirishi hohlanganproductla
    InkWell(
      onTap: () async {
        if (product.removeVisiable!) {
          setState(() {
            product.removeVisiable = false;
          });
        }
        if (!product.removeVisiable!) {
          setState(() {
            product.removeVisiable = true;
          });
        }

        print(product.removeVisiable);
        if (product.removeVisiable!) {
          setState(() {
            removeProductCount++;
          });
          removeProductsId.add(product.id);
          for (var a in product.imgUrls!) {
            removeImgUrlList.add(a);
          }

        } else {
          removeProductCount--;
          removeProductsId.remove(product.id);
        }
      },
      child: isSeries?
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
        decoration: BoxDecoration(
            border: Border.all(width: 1.3,color: Colors.red),
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
            product.removeVisiable!?
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),topRight: Radius.circular(19))
                ),
                child: Icon(Icons.delete,color: Colors.white.withOpacity(.9),),
              ),
            )
            :SizedBox(),
          ],
        ),
      ):
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
        decoration: BoxDecoration(
            color: Colors.grey.shade100,
            border: Border.all(width: 1,color: Colors.red),
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
            product.removeVisiable!?
            Align(
              alignment: Alignment.topRight,
              child: Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(10),topRight: Radius.circular(10))
                ),
                child: Icon(Icons.delete,color: Colors.white.withOpacity(.9),),
              ),
            )
            :SizedBox(),
          ],
        ),
      ),
    ):
    InkWell(
      onLongPress: () {
        setState(() {
          removeVisiable=true;
        });
      },
      onTap: () async{
        await Navigator.push(context, CupertinoPageRoute(builder: (context) => UpdatePage(product: product),));
        getProducts();
        getCategory();
      },
      child: isSeries?
      // 2 qator bo'lib chiqishi
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        clipBehavior: Clip.hardEdge,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          // border: Border.all(width: 1,color: Colors.deepPurpleAccent),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.grey,blurRadius: 2.5,offset: Offset(0,1)),
            BoxShadow(color: Colors.grey,blurRadius: 1,offset: Offset(0,-.51)),
          ]
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
                  cautionDialog(product.id!,product.imgUrls!);
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
      // 1 qator bo'lib chiqishi
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
                  cautionDialog(product.id!,product.imgUrls!);
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
    count++;
    await DataService.getProduct(count: count).then((value) => {
      setState((){
        items=value;
        items.sort((p1, p2) {
          return Comparable.compare(p1.date.toString(), p2.date.toString());
        });
        items=items.reversed.toList();
      }),
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

  void cautionDialog(String id,List<dynamic> imgUrl) async {
    setState(() {
      remove=true;
    });
    remove = await Utils.commonDialog(context, "Mahsulotni o'chirish", "Haqiqatdan bu mahsulotni o'chirasizmi?", "HA", "Yo'q");
    await Future.delayed(Duration(seconds: 3));
    if (remove) {
      print(id);
      print(imgUrl);
      removeProduct(id,imgUrl,);
    }
  }

  void removeProduct(String id,List imgUrl,) async {
      await DataService.removeProduct([id],imgUrl);
      print("Successfully removed");
      Utils.fToast("Muvofiqiyatli o'chirildi");
      getProducts();
  }

  void removeMoreProducts(List productsId,List imgUrl) async {
    print(productsId);
    await DataService.removeProduct(productsId,imgUrl);
    removeVisiable=false;
    removeProductCount=0;
    setState(() {
      isLoading=false;
    });
    print("Successfully removed");
    Utils.fToast("Muvofiqiyatli o'chirildi");
    getProducts();
  }
}
