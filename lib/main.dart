import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quackmo/start.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main(List<String> args) async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Color.fromRGBO(225,202,167,1)));
    return MaterialApp(
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(fontSizeFactor: 0.8, fontSizeDelta: 2.0),
        fontFamily: 'Poppins',
      ),

      debugShowCheckedModeBanner: false,
      home: Start(),
    );
  }
}