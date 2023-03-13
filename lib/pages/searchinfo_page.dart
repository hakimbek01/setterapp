import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:setterapp/pages/update_page.dart';
import 'package:setterapp/service/data_service.dart';

import '../model/product_model.dart';

class SearchInfoPage extends StatefulWidget {
  final String? categoryName;
  const SearchInfoPage({Key? key, this.categoryName}) : super(key: key);

  @override
  State<SearchInfoPage> createState() => _SearchInfoPageState();
}

class _SearchInfoPageState extends State<SearchInfoPage> {

  List<Product> product=[];

  void getProductCategoryName() async {
    await DataService.getProduct().then((value) => {
      for (var a in value) {
        if (a.category==widget.categoryName) {
          setState((){
            product.add(a);
          })
        }
      }

    });
  }


  @override
  void initState() {
    getProductCategoryName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.white,
        title: Text(widget.categoryName!,style: TextStyle(fontFamily: "Aladin",color: Colors.black,fontSize: 20),),
        actions: [
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.edit,color: Colors.blue,),
          ),
          IconButton(
            onPressed: (){},
            icon: Icon(Icons.delete,color: Colors.red,),
          )
        ],
      ),
      body: ListView(
        children: product.map((e) {
          return itemOfCategoryProduct(e);
        }).toList(),
      ),
    );
  }

  Widget itemOfCategoryProduct(Product product) {
    return widget.categoryName==product.category?
    GestureDetector(
      onTap: () async {
       await Navigator.push(context, MaterialPageRoute(builder: (context) => UpdatePage(product: product),)) ;
       getProductCategoryName();
       },
      child: Container(
        height: MediaQuery.of(context).size.width/5,
        width: double.infinity,
        margin: EdgeInsets.only(right: 10,left: 10,bottom: 10),
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(color: Colors.grey,blurRadius: 2.5,offset: Offset(0,1)),
              BoxShadow(color: Colors.grey,blurRadius: 1,offset: Offset(0,-.51)),
            ]
        ),
        child: Row(
          children: [
            product.imgUrls!.isNotEmpty?
            CachedNetworkImage(
              width: 80,
              height: MediaQuery.of(context).size.width/5,
              fit: BoxFit.cover,
              imageUrl: product.imgUrls![0],
              placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
              errorWidget: (context, url, error) => Center(child: Icon(Icons.highlight_remove,color: Colors.red,),),
              ):
            Image(
              height: MediaQuery.of(context).size.width/5,
              width: 80,
              fit: BoxFit.cover,
              image: AssetImage("assets/images/placeholder.png"),
            ),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(product.name!,style: TextStyle(fontSize: 15,fontStyle: FontStyle.italic),overflow: TextOverflow.ellipsis,),
                    Text(product.price!,style: TextStyle(fontWeight: FontWeight.bold),)
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    ):
    SizedBox();
  }

}
