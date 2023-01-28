import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:setterapp/service/rtdb_service.dart';

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
    await RTDBService.getProduct().then((value) => {
      setState((){
        product=value;
      })
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
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        backgroundColor: Colors.white,
        title: Text("Shu tipdagi mahsulotlar",style: GoogleFonts.aladin(color: Colors.black,fontSize: 20),),
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
    Container(
      height: MediaQuery.of(context).size.width/5,
      width: double.infinity,
      margin: EdgeInsets.only(right: 10,left: 10,bottom: 10),
      decoration: BoxDecoration(
        border: Border.all(width: 1,color: Colors.red),
        borderRadius: BorderRadius.circular(5)
      ),
      child: Row(
        children: [
          CachedNetworkImage(
            width: 80,
            fit: BoxFit.cover,
            imageUrl: product.imgUrls![0],
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
    ):
    SizedBox();
  }

}
