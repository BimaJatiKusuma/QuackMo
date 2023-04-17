import 'package:flutter/material.dart';
import 'package:quackmo/produsen/produsen_homepage.dart';
import 'package:quackmo/produsen/produsen_regis.dart';

class ProdusenLogin extends StatefulWidget {
  const ProdusenLogin({super.key});

  @override
  State<ProdusenLogin> createState() => _ProdusenLoginState();
}

class _ProdusenLoginState extends State<ProdusenLogin> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            Image(image: AssetImage('images/produsen_01.png')),
            Text("Produsen Telur Asin"),
            Container(
              child: Column(
                children: [
                  Text("Log In"),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Email'
                    ),
                  ),
                  TextField(
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Password'
                    ),
                  ),
                  
                  Row(
                    children: [
                      Container(child: CheckboxListTile(
                            value: isChecked,
                            onChanged: (bool? value){
                              setState(() {
                                isChecked = value!;
                              });
                            },
                            title: Text("Remember me"),
                            ),
                        width: 200,
                            ),
                      
                      Text("forgot password?")
                    ],
                  ),

                  ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return ProdusenHomepage();
                    }));
                  }, child: Text("Sign In")),

                  Row(
                    children: [
                      Text("Don't have an account?"),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return ProdusenRegis();
                        }));
                      }, child: Text("daftar"))
                    ],
                  ),

                  Column(
                    children: [
                      Text('or sign in with'),
                      Row(
                        children: [
                          ElevatedButton(onPressed: (){}, child: Text("Google")),
                          ElevatedButton(onPressed: (){}, child: Text("Facebook"))
                        ],
                      )
                    ],
                  )
                  
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}