import 'package:flutter/material.dart';
import 'package:setterapp/pages/signup_page.dart';
import 'package:setterapp/service/auth_service.dart';

import 'home_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({Key? key}) : super(key: key);

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {


  void isSignUser() async {
    await Future.delayed(Duration(seconds: 3));
    bool isLogged=AuthService.currentUser();
    if (!isLogged || isLogged==null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignUp(),));
    }
    else {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),));
    }
  }

  @override
  void initState() {
    isSignUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Welcome",style: TextStyle(fontSize: 40),),
      ),
    );
  }
}
