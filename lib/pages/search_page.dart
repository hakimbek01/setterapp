import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:setterapp/pages/searchinfo_page.dart';
import 'package:setterapp/service/prefs_service.dart';
import 'package:setterapp/service/rtdb_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  List<String>?  itemCategory=[];

  void storePrefsCategory() {
    PrefsService.loadCategory().then((value) => {
      itemCategory=value
    });
  }

  Future<void> getCategory() async {
    await RTDBService.getCategory().then((value) => {
      setState((){
        itemCategory=value;
        PrefsService.storeCategory(itemCategory!);
      })
    });
    storePrefsCategory();
  }

  @override
  void initState() {
    storePrefsCategory();
    getCategory();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text("Search",style: GoogleFonts.aladin(color: Colors.black,fontSize: 28,),),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await getCategory();
        },
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              padding: EdgeInsets.symmetric(horizontal: 10),
              height: 55,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: Colors.deepOrangeAccent,width: 1.2)
              ),
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "Search"
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Text("Categories",style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic),),
              ),
            ),
            SizedBox(height: 10,),
            Expanded(
              child: ListView(
                children: itemCategory!.map((e)  {
                  return itemOfCategory(e);
                }).toList(),
              )
            )
          ],
        ),
      ),
    );
  }

  Widget itemOfCategory(String categoryName) {
    return GestureDetector(
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

}
