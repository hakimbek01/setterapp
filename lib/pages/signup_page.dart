import 'package:flutter/material.dart';

import '../service/auth_service.dart';
import 'home_page.dart';
import 'feed_page.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  TextEditingController _email=TextEditingController();
  TextEditingController _password=TextEditingController();

  Future<void> SignUpPageFunk() async {
    String email=_email.text;
    String password=_password.text;

    if (email.isEmpty || password.isEmpty) return;


    await AuthService.signUp(email, password).then((value) => {
      if (value!=null) {
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomePage(),))
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _email,
                decoration: InputDecoration(
                    label: Text("email")
                ),
              ),
              TextField(
                controller: _password,
                decoration: InputDecoration(
                    label: Text("pasowrd")
                ),
              ),
              ElevatedButton(
                onPressed: (){
                  print("object");
                  SignUpPageFunk();
                },
                child: Text("Sign Up"),
              )
            ],
          ),
        ),
      )
    );
  }
}
