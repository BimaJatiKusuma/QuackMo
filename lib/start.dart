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
            SizedBox(height: 10,),
            Text('QUACKMO', style: TextStyle(fontWeight: FontWeight.w900),),
            SizedBox(height: 20,),
            Text('Jual Beli Telur Bebek Dengan Mudah', style: TextStyle(fontWeight: FontWeight.w900),),
            SizedBox(height: 10,),
            ElevatedButton(onPressed: (){
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                return Login();
              }));
            },
            style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(225,202,167,1)),
            child: Text("Mulai"))
          ],
        ),
      ),
    );
  }
}