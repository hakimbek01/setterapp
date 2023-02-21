import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:setterapp/pages/editprofile_description.dart';
import 'package:setterapp/service/data_service.dart';
import '../model/admin_model.dart';


class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {

  Admin? admin;
  bool isLoading=false;
  bool isLoadingImg=false;
  String name="";
  String description="";
  String phoneNumber="";
  List myProducts=[];
  List myUpdateP=[];
  List myCreateP=[];
  bool visi=false;
  File? _image;
  final ImagePicker _imagePicker=ImagePicker();
  List<Admin> adminList=[];

  void loadAdmin() async {
    setState(() {
      isLoading=true;
    });
    DataService.loadAdmin().then((value) => {
      setState((){
        admin=value;
        name=value!.fullName!;
        myProducts=value.placedProduct;
        sortMyWork();
      })
    });
  }



  void sortMyWork() async {
    for (var a in myProducts) {
      if (a["status"]=="update") {
        setState(() {
          myUpdateP.add(a);
        });
      }
      else if (a["status"]=="create") {
        setState(() {
          myCreateP.add(a);
        });
      }
    }

    setState(() {
      isLoading=false;
    });
  }

  @override
  void initState() {
    loadAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Text("Profile",style: TextStyle(fontSize: 25,fontFamily: "Aladin",color: Colors.black),),
          ),
          body: SingleChildScrollView(
            child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    Align(
                      alignment: Alignment.topCenter,
                      child: Text(name,style: TextStyle(color: Colors.black54,fontSize: 18,fontWeight: FontWeight.w500),),
                    ),
                    SizedBox(height: 7,),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100,
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      Color.fromRGBO(255, 209, 249, 1.0),
                                      Color.fromRGBO(243, 171, 241, 1.0)
                                    ]
                                )
                            ),
                            child: Text("Joylashtirgan mahsulotlarim: ${myCreateP.length}",style: TextStyle(color: Colors.black54),),
                          ),
                        ),
                        SizedBox(width: 10,),
                        Expanded(
                          child: Container(
                            padding: EdgeInsets.all(7),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: Colors.grey.shade100,
                                gradient: LinearGradient(
                                    begin: Alignment.bottomLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      Color.fromRGBO(255, 209, 249, 1.0),
                                      Color.fromRGBO(243, 171, 241, 1.0)
                                    ]
                                )
                            ),
                            child: Text("Tahrirlagan mahsulotlarim: ${myUpdateP.length}",style: TextStyle(color: Colors.black54),),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    Container(
                      width: double.infinity,
                      height: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: Border.all(width: 1,color: Colors.purpleAccent)
                      ),
                      padding: EdgeInsets.all(5),
                      clipBehavior: Clip.hardEdge,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Ma'lumot: ${description}",maxLines: 4,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text("Telefon raqam: "),
                                  Text(phoneNumber,style: TextStyle(color: Colors.blue),),
                                ],
                              ),
                              GestureDetector(
                                onTap: () async {
                                  await Navigator.push(context, CupertinoPageRoute(builder: (context) => EditDescription(admin: admin),));
                                  loadAdmin();
                                },
                                child: Icon(Icons.edit,color: Colors.grey.shade700,),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                    SizedBox(height: 15,),
                  ],
                ),
              )
          ),
        ),
        isLoading?
        Scaffold(
          backgroundColor: Colors.grey.withOpacity(.2),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ):
        SizedBox()
      ],
    );
  }



}
