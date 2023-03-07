import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:setterapp/model/product_model.dart';
import 'package:setterapp/service/data_service.dart';

import '../model/admin_model.dart';
import '../model/my_work.dart';
import '../service/prefs_service.dart';
import '../service/store_service.dart';

class UpdatePage extends StatefulWidget {
  final Product? product;
  const UpdatePage({Key? key, this.product}) : super(key: key);

  @override
  State<UpdatePage> createState() => _UpdatePageState();
}

class _UpdatePageState extends State<UpdatePage> {

  Product? product;

  TextEditingController _content=TextEditingController();
  TextEditingController _price=TextEditingController();
  TextEditingController _name=TextEditingController();
  final TextEditingController _createCategory=TextEditingController();
  String priceType="USD";
  String _category="Kiyimlar";
  bool isAvailable=false;
  bool typePrice=false;
  List<PopupMenuEntry<dynamic>> popupMenuItem = [];
  List<String> categories = [];
  bool isLoading=false;
  List imgUrls=[];
  List newImg=[];
  File? _image;
  final ImagePicker _imagePicker=ImagePicker();


  @override
  void initState() {
    getCategory();
    print("${widget.product!.category}\n${widget.product!.isAvailable}\n${widget.product!.price}\n${widget.product!.name}\n${widget.product!.imgUrls}\n${widget.product!.id}\n${widget.product!.content}");
    isAvailable=widget.product!.isAvailable!;
    _content.text=widget.product!.content!.toString();
    _name.text=widget.product!.name!.toString();
    _price.text=widget.product!.price!.split(" ").first;
    _category=widget.product!.category!;
    imgUrls = widget.product!.imgUrls!;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
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
              child: widget.product!.imgUrls!.isNotEmpty?
              Swiper(
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
              ):
              Stack(
                children: [
                  Image(
                    fit: BoxFit.cover,
                    image: AssetImage("assets/images/placeholder.png"),
                  ),
                  isLoading?
                  Center(
                    child: CircularProgressIndicator(),
                  ):
                  SizedBox()
                ],
              ),
            ),
            SizedBox(height: 20,),
            // product info
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  //open images
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(10),bottomLeft: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(offset: Offset(0,1),blurRadius: 1.6,color: Colors.grey,)
                            ]
                          ),
                          child: ListTile(
                            onTap: (){
                              openGallery();
                            },
                            title: Text("Open Gallery",style: TextStyle(color: Colors.grey.shade700),),
                            leading: Icon(Icons.image_outlined),
                          ),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(topRight: Radius.circular(10),bottomRight: Radius.circular(10)),
                            boxShadow: [
                              BoxShadow(offset: Offset(0,1),blurRadius: 1.6,color: Colors.grey,)
                            ]
                          ),
                          child: ListTile(
                            onTap: (){
                              openCamera();
                            },
                            title: Text("Open Camera",style: TextStyle(color: Colors.grey.shade700),),
                            leading: Icon(Icons.camera_alt),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 17,),
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
                        Text(isAvailable?"Sotuvda":"Sotuvdan chiqarilgan",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
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
                  SizedBox(height: 10,),
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
            ),
            Container(
              width: double.infinity,
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(7),
                  border: Border.all(width: 1,color: Colors.blue)
              ),
              child: Center(
                child: PopupMenuButton(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(7),),
                  elevation: 3,
                  child: Text(_category,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                  itemBuilder: (context) => popupMenuItem,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }



  Future<void> getCategory() async {
    await RTDBService.getCategory().then((value) => {
      setState((){
        categories=value;
        print(categories);
        PrefsService.storeCategory(categories);
      })
    });
    storePrefsCategory();
  }


  void updateProductInfo() async {
    Product product=Product(
        isAvailable: isAvailable,
        imgUrls: imgUrls,
        content: _content.text,
        name: _name.text,
        id: widget.product!.id,
        price: "${_price.text.split(" ").first} $priceType",
        category: widget.product!.category,
        buyCount: 1,
    );
    DataService.updateProduct(product);
    Admin? admin=await DataService.loadAdmin();
    List myProducts=admin!.placedProduct;
    MyWork myWork=MyWork(id: product.id,date: DateTime.now().toString(),status: "update");
    myProducts.add(myWork.toJson());
    await DataService.updateAdmin(admin);
  }


  void storePrefsCategory() async {
    await PrefsService.loadCategory().then((value) => {
      setState((){
        categories=value!;
      })
    });
    createPopupMenu();

  }

  void createPopupMenu() {
    popupMenuItem = [];
    for (var item in categories) {
      popupMenuItem.add(PopupMenuItem(
        onTap: () {
          setState(() {
            _category=item;
          });
        },
        child: Text(item),
      ));
    }
  }

  void openGallery() async {
    XFile? image=await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 50
    );
    setState(() {
      newImg.add(File(image!.path));
    });

    setState(() {
      isLoading=true;
    });
    List? images = await StoreService.uploadImage(newImg);
    for (var a in images) {
      imgUrls.add(a);
    }
    setState(() {
      isLoading=false;
    });
  }

  void openCamera() async {
    XFile? image = await _imagePicker.pickImage(
      source: ImageSource.camera,
      imageQuality: 50,
    );

    setState(() {
      newImg.add(File(image!.path));
    });

    List? images=await StoreService.uploadImage(newImg);
    for (var a in images) {
      imgUrls.add(a);
    }

    setState(() {
      isLoading=false;
    });
  }

}
