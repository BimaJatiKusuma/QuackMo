import 'package:flutter/material.dart';
import 'package:quackmo/peternak/peternak_homepage.dart';
import 'package:quackmo/peternak/peternak_regis.dart';

class PeternakLogin extends StatefulWidget {
  const PeternakLogin({super.key});

  @override
  State<PeternakLogin> createState() => _PeternakLoginState();
}

class _PeternakLoginState extends State<PeternakLogin> {
  bool isChecked = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Column(
          children: [
            Image(image: AssetImage('images/peternak_01.png')),
            Text("Peternak Bebek"),
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
                      return PeternakHomepage();
                    }));
                  }, child: Text("Sign In")),

                  Row(
                    children: [
                      Text("Don't have an account?"),
                      TextButton(onPressed: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context){
                          return PeternakRegis();
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