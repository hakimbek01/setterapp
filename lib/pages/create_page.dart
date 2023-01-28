import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:setterapp/model/product_model.dart';
import 'package:setterapp/pages/feed_page.dart';
import 'package:setterapp/service/rtdb_service.dart';

import '../service/store_service.dart';

class CreatePage extends StatefulWidget {
  const CreatePage({Key? key}) : super(key: key);

  @override
  State<CreatePage> createState() => _CreatePageState();
}

class _CreatePageState extends State<CreatePage> {
  final TextEditingController _name=TextEditingController();
  final TextEditingController _price=TextEditingController();
  final TextEditingController _content=TextEditingController();
  final TextEditingController _createCategory=TextEditingController();
  String priceType="USD";
  String _category="Category";
  final List _imagesList=[];


  File? _image;
  final ImagePicker _imagePicker=ImagePicker();
  bool typePrice=false;

  List<PopupMenuEntry<dynamic>> popupMenuItem = [];
  List categories = [];


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
      popupMenuItem.add(
          PopupMenuItem(
            onTap: () async {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                AwesomeDialog(
                  context: context,
                  animType: AnimType.bottomSlide,
                  dialogType: DialogType.noHeader,
                  btnOkOnPress: () async {
                    setState(() {
                      if (_createCategory.text.isEmpty) return;
                      _category=_createCategory.text;
                      categories.add(_category);
                      createPopupMenu();
                      addCategory();
                    });
                  },
                  btnCancelOnPress: () {},
                  body: Column(
                    children: [
                      TextField(
                        controller: _createCategory,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(color: Colors.grey),
                          hintText: "Categoriya Yaratish"
                        ),
                      )
                    ],
                  ),
                ).show();
              });
            },
            child: Column(
              children: [
                Container(color: Colors.blue, width: double.infinity, height: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Category qo'shish",style: TextStyle(fontWeight: FontWeight.w700),),
                    Icon(Icons.add)
                  ],
                )
              ],
            ),
          )
      );
  }

  @override
  void initState() {
    getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme:IconThemeData(
          color: Colors.black,
        ),
        backgroundColor: Colors.white,
        title: Text("Add Product",style: TextStyle(color: Colors.black),),
        actions: [
          IconButton(
            onPressed: () {
              openGallery();
            },
            icon: Icon(Icons.add),

          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //images
              _imagesList.isEmpty?
              Container(
                height: MediaQuery.of(context).size.width-70,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(color: Colors.grey,blurRadius: 3,offset: Offset(0,0))
                    ]
                ),
                child: Image(
                  image: AssetImage("assets/images/img_1.png"),
                  fit: BoxFit.cover,
                ),
              ):
              Container(
                height: MediaQuery.of(context).size.width-70,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black,width: 1)
                ),
                child: ListView(
                  physics: PageScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  children: _imagesList.map((e) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(color: Colors.grey,blurRadius: 3,offset: Offset(0,0))
                          ]
                      ),
                      child: Stack(
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: MediaQuery.of(context).size.height-70,
                            padding: EdgeInsets.symmetric(horizontal: 2),
                            child: Image(
                              image: FileImage(e),
                              fit: BoxFit.cover,
                            ),
                          ),
                          Align(
                            alignment: Alignment.topRight,
                            child: GestureDetector(
                              onTap: (){
                                setState(() {
                                  _imagesList.remove(e);
                                });
                              },
                              child: Container(
                                margin: EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                  borderRadius: BorderRadius.circular(20)
                                ),
                                child: Icon(Icons.highlight_remove,color: Colors.white,),
                              ),
                            ),
                          )
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              SizedBox(height: 20,),
              // product data
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    //product name
                    TextField(
                      controller: _name,
                      decoration: InputDecoration(
                        fillColor: Colors.grey.shade200,
                        filled: true,
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
                        filled: true,
                        fillColor: Colors.grey.shade200,
                        label: Text("Description")
                      ),
                    ),

                    SizedBox(height: 10,),
                    //product price
                    TextField(
                      controller: _price,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey.shade200,
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
              SizedBox(height: 20,),
              //product category
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
              SizedBox(height: 20,),
              //send
              Align(
                alignment: Alignment.bottomCenter,
                child: MaterialButton(
                  color: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5),side: BorderSide(color: Colors.black,width: 1)),
                  minWidth: 170,
                  onPressed: (){
                   addProduct();
                  },
                  child: Icon(Icons.send,),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  void addCategory() async {
    print("$categories");
    await RTDBService.addCategory(categories);
  }

  void getCategory() async {
    await RTDBService.getCategory().then((value) => {
      setState((){
        categories=value;
        print(categories);
      })
    });
    createPopupMenu();
  }

  void addProduct() async {
    String name=_name.text;
    String content=_content.text;
    String price="${_price.text} $priceType";
    List? images= await StoreService.uploadImage(_imagesList);
    if (name.isEmpty || content.isEmpty || price.isEmpty) return;
    Product product=Product(category: _category,price: price,id: "de",name: name,content: content,imgUrls: images,isAvailable: true);

    RTDBService.addProduct(product).then((value) =>{
      Navigator.pop(context)
    });
  }

  void openGallery() async {
    XFile? image=await _imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50
    );
    setState(() {
      _imagesList.add(File(image!.path));
    });
  }
}
