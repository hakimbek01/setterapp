import 'package:flutter/material.dart';

import '../service/auth_service.dart';
import 'home_page.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController _email=TextEditingController();
  TextEditingController _password=TextEditingController();

  Future<void> signUpFunk() async {
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
                  signUpFunk();
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
