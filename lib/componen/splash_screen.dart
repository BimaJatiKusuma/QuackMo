import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  SplashScreen({
    required this.pesan,
    required this.navigator,
    super.key
    });

  final navigator;
  final pesan;
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  
  // @override
  // void initState(){
  //   super.initState();

  //   Timer(Duration(seconds: 1), () {
  //     widget.navigator;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
  String pesan2 = widget.pesan;
  var navigator2 = widget.navigator;
    return Scaffold(
      backgroundColor: Color.fromRGBO(225, 202, 167, 1),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 200, color: Colors.white,),
              Text(pesan2, style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
            ],
          ),
        ),
      ),
    );
  }
}