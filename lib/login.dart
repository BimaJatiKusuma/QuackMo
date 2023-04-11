import 'package:flutter/material.dart';
import 'package:quackmo/peternak/peternak_login.dart';
import 'package:quackmo/produsen/produsen_login.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text("Please choose yourself!"),
            Text("Pilih sebagai:"),
            Row(
              children: [
                Column(
                  children: [
                    Image(image: AssetImage('images/peternak_01.png')),
                    Text("Peternak Bebek"),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return PeternakLogin();
                      }));
                    },
                      child: Text("Masuk"),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Image(image: AssetImage('images/produsen_01.png')),
                    Text("Produsen Telur Asin"),
                    ElevatedButton(
                      onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return ProdusenLogin();
                        }));
                      },
                      child: Text("Masuk")
                    ),
                  ],
                )
              ],
            ),
            Text("Lorem ipsum")
          ],
        ),
      ),
    );
  }
}