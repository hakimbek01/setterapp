import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:setterapp/pages/home_page.dart';
import 'package:setterapp/pages/feed_page.dart';
import 'package:setterapp/pages/splash_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashPage(),
    );
  }
}

