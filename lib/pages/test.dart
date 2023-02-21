import 'package:flip_card/flip_card.dart';
import 'package:flip_card/flip_card_controller.dart';
import 'package:flutter/material.dart';

class Test extends StatefulWidget {
  const Test({Key? key}) : super(key: key);

  @override
  State<Test> createState() => _TestState();
}

class _TestState extends State<Test> {
  FlipCardController? controller;

  @override
  void initState() {
    controller=FlipCardController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              child: FlipCard(
                flipOnTouch: false,
                controller: controller,
                front: Container(
                    child: Text("Hello")
                ),
                back: Container(
                  child: Text('Back'),
                ),
              ),
            ),
            SizedBox(height: 10,),
            MaterialButton(
              onPressed: (){
                controller!.toggleCard();
              },
              child: Text("BOs"),
            )
          ],
        ),
      )
    );
  }
}
