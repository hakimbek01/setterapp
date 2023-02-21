import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:setterapp/model/product_model.dart';
import 'package:setterapp/pages/statistik_infos.dart';
import 'package:setterapp/service/data_service.dart';
import 'package:setterapp/service/utils_service.dart';
import 'package:syncfusion_flutter_charts/charts.dart';


class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Product> list=[];
  bool isLoading=true;
  List<VisiableProductMoreBuy> statistikaList=[];
  List<VisiableProductMoreBuy> productInfo = [];
  late TooltipBehavior tooltipBehavior;


  @override
  void initState() {
    tooltipBehavior=TooltipBehavior(enable: true,);
    getProduct();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Home",style: TextStyle(fontFamily: "Aladin",color: Colors.black,fontSize: 25),),
      ),
      body: RefreshIndicator(
        onRefresh: ()async{
          getProduct();
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal:10),
              child: Text('Statistika',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w500),),
            ),
            SizedBox(height: 10,),
            Container(
              height: MediaQuery.of(context).size.width-150,
              width: double.infinity,
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.only(top: 5),
              decoration: BoxDecoration(
                border: Border.all(width: 1.7,color: Colors.blue.withOpacity(.6)),
                borderRadius: BorderRadius.circular(20)
              ),
              child: SfCircularChart(
                tooltipBehavior: tooltipBehavior,
                legend: Legend(
                  isVisible: true,
                  overflowMode: LegendItemOverflowMode.wrap
                ),
                series: [
                  PieSeries(
                    dataSource: statistikaList,
                    xValueMapper: (datum, index) => statistikaList[index].category,
                    yValueMapper: (datum, index) => statistikaList[index].buyCount,
                    dataLabelSettings: DataLabelSettings(
                      isVisible: true,
                    ),
                    enableTooltip: true
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => StatistikInfoPage(),));
                },
                child: Text("Batafsil"),
              ),
            )
          ],
        ),
      ),
    );
  }



  void getProduct() async {
    setState(() {
      isLoading = true;
    });

    /// bazaviy malumotlarni yani productlarni chaqirish
    await DataService.getProduct().then((value) => {
      value.sort((a, b) => a.buyCount!.compareTo(b.buyCount!)),
      setState(() {
        list = value;
      })
    });

    list.sort((a, b) => a.buyCount!.compareTo(b.buyCount!));
    List<String> categoryName = [];
    List<int> buy = [];
    int count = 0;

    // productlarning categoriya va uning ichidagi mahsulotlarini qancha sotib olinganini tekshirib categoriyaga uyg'unlashtirib alohida qilib olish
    for (var a in list) {
      for (var b in list) {
        if (a.category == b.category) {
          count += b.buyCount!;
        }
      }
      categoryName.add(a.category!);
      buy.add(count);
      count = 0;
    }

    //malumotlar for da ortiqcha bo'lishi mumkin va ularni saralab bittadan qilib olish uchun setCategoryName va setBuy fieldlari
    Set<String> setCategoryName = categoryName.toSet();
    Set setBuy = buy.toSet();

    for (var a =0; setCategoryName.length > a; a++) {
      print(categoryName);
      productInfo.add(VisiableProductMoreBuy(isMoreBuy: true,category: categoryName.toList()[a], buyCount: buy.toList()[a]));
    }

    productInfo.sort((a, b) => a.buyCount!.compareTo(b.buyCount!));

    for (var a =0;productInfo.length-1>=a;a++) {
      if (productInfo.length<=3) {
        if (a>(productInfo.length-1)-1) {
          statistikaList.add(VisiableProductMoreBuy(buyCount: productInfo[a].buyCount,category: productInfo[a].category,isMoreBuy: true));
        } else {
          productInfo[a].isMoreBuy=false;
        }
      }
      else if (productInfo.length>3 && 7>=productInfo.length) {
        if (a>(productInfo.length-1)-2) {
          print(productInfo[a].buyCount);
          statistikaList.add(VisiableProductMoreBuy(buyCount: productInfo[a].buyCount,category: productInfo[a].category,isMoreBuy: true));
        } else {
          productInfo[a].isMoreBuy=false;
        }
      }
      else if (productInfo.length>=7 && productInfo.length<12) {
        if (a>(productInfo.length-1)-3) {
          statistikaList.add(VisiableProductMoreBuy(buyCount: productInfo[a].buyCount,category: productInfo[a].category,isMoreBuy: true));
        } else {
          productInfo[a].isMoreBuy=false;
        }
      }
      else if (12<productInfo.length) {
        if (a>(productInfo.length-1)-5) {
          statistikaList.add(VisiableProductMoreBuy(buyCount: productInfo[a].buyCount,category: productInfo[a].category,isMoreBuy: true));
        } else {
          productInfo[a].isMoreBuy=false;
        }
      }
    }


    productInfo.reversed;
    var reverse=productInfo.reversed;
    productInfo=reverse.toList();
    setState(() {
      isLoading = false;
    });
  }
}


