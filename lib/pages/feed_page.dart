import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);

  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("Home",style: GoogleFonts.aladin(color: Colors.black,fontSize: 25),),
      ),
      body: SingleChildScrollView(
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
              margin: EdgeInsets.symmetric(horizontal: 10),
              padding: EdgeInsets.all(7),
              height: MediaQuery.of(context).size.width-180,
              width: double.infinity,
              decoration: BoxDecoration(
                border: Border.all(width: 1.7,color: Colors.blue),
                borderRadius: BorderRadius.circular(20)
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Top 5",style: TextStyle(fontWeight: FontWeight.bold,color: Colors.deepOrangeAccent),),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: (MediaQuery.of(context).size.width-180)/5,
                            width: 10,
                            color: Colors.blue,
                          ),
                          Container(
                            height: (MediaQuery.of(context).size.width-180)/4,
                            width: 10,
                            color: Colors.blue,
                          ),
                          Container(
                            width: 10,
                            height: (MediaQuery.of(context).size.width-180)/3,
                            color: Colors.blue,
                          ),
                          Container(
                            width: 10,
                            height: (MediaQuery.of(context).size.width-180)/2,
                            color: Colors.blue,
                          ),
                          Container(
                            width: 10,
                            height: (MediaQuery.of(context).size.width-180)/1.3,
                            color: Colors.blue,
                          ),
                        ],
                      ),
                    ],
                  ),


                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
