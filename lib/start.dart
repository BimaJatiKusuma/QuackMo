import 'package:flutter/material.dart';
import 'package:quackmo/login.dart';

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Image(image: AssetImage('images/open_apps_01.png')),
            Text('QUACKMO'),
            Text('Buy and sell duck eggs easily'),
            Text("Selamat datang di aplikasi QuackMo"),
            ElevatedButton(onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                return Login();
              }));
            },
            child: Text("Get Started"))
          ],
        ),
      ),
    );
  }
}