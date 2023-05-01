import 'package:flutter/material.dart';
import 'package:quackmo/peternak/peternak_login.dart';
import 'package:quackmo/produsen/produsen_login.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          heightFactor: MediaQuery.of(context).size.height,
          widthFactor: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("Pilih karaktermu untuk masuk ke aplikasi!", style: TextStyle(fontWeight: FontWeight.w600),),
              Text("Pilih sebagai:"),
              Row(
                // mainAxisAlignment: MainAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Image(image: AssetImage('images/peternak_01.png')),
                      SizedBox(height: 10,),
                      Text("Peternak Bebek", style: TextStyle(fontWeight: FontWeight.w600),),
                      SizedBox(height: 10,),
                      ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return PeternakLogin();
                        }));
                      },
                      style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(225,202,167,1), foregroundColor: Colors.black),
                        child: Text("Masuk"),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Image(image: AssetImage('images/produsen_01.png')),
                      SizedBox(height: 10,),
                      Text("Produsen Telur Asin", style: TextStyle(fontWeight: FontWeight.w600)),
                      SizedBox(height: 10,),
                      ElevatedButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return ProdusenLogin();
                          }));
                        },
                        style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(225,202,167,1), foregroundColor: Colors.black),
                        child: Text("Masuk")
                      ),
                    ],
                  )
                ],
              ),
      
              
            ],
          ),
        ),
      ),
    );
  }
}