import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:setterapp/model/product_model.dart';
import 'package:setterapp/service/rtdb_service.dart';

class UpdatePage extends StatefulWidget {
  final Product? product;
  const UpdatePage({Key? key, this.product}) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {

  Product? product;

  List imgUrls=[];
  TextEditingController _content=TextEditingController();
  TextEditingController _price=TextEditingController();
  TextEditingController _name=TextEditingController();
  String priceType="USD";
  String category="Kiyimlar";
  bool isAvailable=false;
  bool typePrice=false;

  @override
  void initState() {
    print("${widget.product!.category}\n${widget.product!.isAvailable}\n${widget.product!.price}\n${widget.product!.name}\n${widget.product!.imgUrls}\n${widget.product!.id}\n${widget.product!.content}");
    isAvailable=widget.product!.isAvailable!;
    _content.text=widget.product!.content!.toString();
    _name.text=widget.product!.name!.toString();
    _price.text=widget.product!.price!.split(" ").first;
    category=widget.product!.category!;
    imgUrls.add(widget.product!.imgUrls);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.black
        ),
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text("Mahsulot Sozlamalari",style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(
            onPressed: () {
              updateProductInfo();
            },
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // images
            Container(
              height: MediaQuery.of(context).size.width-70,
              width: MediaQuery.of(context).size.width,
              child: Swiper(
                pagination: SwiperPagination(),
                itemCount: widget.product!.imgUrls!.length,
                itemBuilder: (context, index) {
                  return Stack(
                    children: [
                      CachedNetworkImage(
                        width: MediaQuery.of(context).size.width,
                        imageUrl: widget.product!.imgUrls![index],
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(child: CircularProgressIndicator(),),
                        errorWidget: (context, url, error) => Center(child: Icon(Icons.highlight_remove,color: Colors.red,),),
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: GestureDetector(
                          onTap: () {
                            setState(() {
                              imgUrls.remove(widget.product!.imgUrls![index]);
                            });
                          },
                          child: Container(
                            margin: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.black
                            ),
                            child: Icon(Icons.highlight_remove,color:Colors.white),
                          ),
                        ),
                      )
                    ]
                  );
                }
              ),
            ),
            SizedBox(height: 20,),
            // product info
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  // product launch
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: double.infinity,
                    height: 45,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      border: Border.all(color: Colors.lightBlueAccent,width: 1.3)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Mahsulotni vaqtinchalik o'chirish"),
                        Switch(
                          value: isAvailable,
                          onChanged: (value) {
                            setState(() {
                              isAvailable=value;
                              print(isAvailable);

                            });
                          },
                        )
                      ],
                    ),
                  ),

                  //product name
                  TextField(
                    controller: _name,
                    decoration: InputDecoration(
                        label: Text("Name")
                    ),
                  ),
                  SizedBox(height: 10,),
                  //product content,
                  TextField(
                    controller: _content,
                    maxLines: 2,
                    minLines: 1,
                    decoration: InputDecoration(
                        label: Text("Description")
                    ),
                  ),
                  SizedBox(height: 10,),
                  //product price
                  TextField(
                    controller: _price,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                        label: Text("Price"),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              typePrice=!typePrice;
                              typePrice? priceType="UZS":priceType="USD";
                            });
                          },
                          child: Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(7),
                                  border: Border.all(color: Colors.black, width: 1)
                              ),
                              child: Center(
                                child: typePrice?Text("UZS",style: TextStyle(fontSize: 18),):Text("USD",style: TextStyle(fontSize: 18),),
                              )
                          ),
                        )
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }


  void updateProductInfo() {
    print("Update product info");
    RTDBService.isWorkingProduct(_content.text, _name.text, _price.text.split(" ").first+" $priceType", category,isAvailable,widget.product!.id.toString(),imgUrls,);
  }





}
