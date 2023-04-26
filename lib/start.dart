import 'package:flutter/material.dart';
import 'package:quackmo/login.dart';

class Start extends StatelessWidget {
  const Start({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
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
            style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(225,202,167,1)),
            child: Text("Get Started"))
          ],
        ),
      ),
    );
  }
}