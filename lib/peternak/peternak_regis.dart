import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PeternakRegis extends StatefulWidget {
  const PeternakRegis({super.key});

  @override
  State<PeternakRegis> createState() => _PeternakRegisState();
}

class _PeternakRegisState extends State<PeternakRegis> {
  String username = "";
  String email= "";
  String password= "";
  bool _obscureText = true;

  TextEditingController usernameController =  TextEditingController();
  TextEditingController emailController =  TextEditingController();
  TextEditingController passwordController =  TextEditingController();
  TextEditingController konfirmasipasswordController =  TextEditingController();

  void _toggle(){
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  _eyePass(_obscureText){
    if (_obscureText == true ){
      return Icon(Icons.remove_red_eye_outlined);
    }
    else{
      return Icon(Icons.remove_red_eye);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          Image(image: AssetImage('images/regis_01.png')),
          Container(
            child: Column(
              children: [
                Text('Sign Up'),
                Form(
                  child: Column(
                    children: [
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: 'username',
                        ),
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                        ),
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffix: IconButton(onPressed: _toggle, icon: _eyePass(_obscureText))
                        ),
                        
                      ),
                      TextFormField(
                        controller: konfirmasipasswordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Konfirmasi Password',
                          suffix: IconButton(onPressed: _toggle, icon: _eyePass(_obscureText))
                        ),
                      ),
                    
                    ElevatedButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("Daftar"))
                    ],
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}