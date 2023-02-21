import 'package:flutter/material.dart';
import 'package:setterapp/service/data_service.dart';

import '../model/admin_model.dart';

class EditDescription extends StatefulWidget {
  final String? description;
  final String? phoneNumber;
  final Admin? admin;
  const EditDescription({Key? key, this.description, this.phoneNumber, this.admin}) : super(key: key);

  @override
  State<EditDescription> createState() => _EditDescriptionState();
}

class _EditDescriptionState extends State<EditDescription> {

  TextEditingController _description=TextEditingController();
  TextEditingController _phoneNumber=TextEditingController();
  List descriptionCount=[];
  int length=0;
  bool isLoading=false;

  void updateDescription() async {

    setState(() {
      isLoading=true;
    });

    Admin admin=widget.admin!;
    await DataService.updateAdmin(admin).then((value) => {
      setState((){
        isLoading=false;
      })
    });
  }

  void getInfo() async {
    setState(() {
      isLoading=true;
    });

    await DataService.loadAdmin().then((value) => {
      setState((){
        isLoading=false;
      })
    });
  }

  @override
  void initState() {
    getInfo();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            iconTheme: IconThemeData(
                color: Colors.black
            ),
            backgroundColor: Colors.white,
            title: Text("Malumotnomani to'ldirish",style: TextStyle(fontSize: 20,fontFamily: "Aladin",color: Colors.black),),
          ),
          body: SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          length=value.split("").length;
                        });
                      },
                      controller: _description,
                      maxLines: 4,
                      minLines: 1,
                      decoration: InputDecoration(
                          hintText: "Ma'lumotnoma",
                          label: Text(length.toString()),
                          labelStyle: length>138?TextStyle(color: Colors.red):TextStyle()
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: TextField(
                      controller: _phoneNumber,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          filled: true,
                          fillColor: Colors.grey.shade300
                      ),
                    ),
                  ),
                  MaterialButton(
                    onPressed: (){
                      updateDescription();
                    },
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: BorderSide(color: Colors.purpleAccent.withOpacity(.6),width: 1,)),
                    minWidth: MediaQuery.of(context).size.width-20,
                    child: Text("Saqlash"),
                  )
                ],
              ),
            ),
          ),
        ),
        isLoading?
        Scaffold(
          backgroundColor: Colors.grey.withOpacity(.3),
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ):
        SizedBox()
      ],
    );
  }
}
