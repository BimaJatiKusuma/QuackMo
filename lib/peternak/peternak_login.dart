import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quackmo/peternak/peternak_homepage.dart';
import 'package:quackmo/peternak/peternak_regis.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PeternakLogin extends StatefulWidget {
  const PeternakLogin({super.key});

  @override
  State<PeternakLogin> createState() => _PeternakLoginState();
}


String userPeternakID = '';
String alertText = ' ';

class _PeternakLoginState extends State<PeternakLogin> {
  bool _isObscure = true;
  bool visible = false;
  bool isChecked = false;
  final _formkey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  final _auth = FirebaseAuth.instance;

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
              child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    Text("Log In"),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        hintText: 'Email'
                      ),
                      validator: (value) {
                        if (value!.length == 0){
                            return "Email tidak boleh kosong";
                          }
                          if (!RegExp("^[1-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                            return ("Masukkan email secara benar");
                          }
                          else {
                            return null;
                          }
                      },
                      onSaved: (newValue) {
                        emailController.text = newValue!;
                      },
                      keyboardType: TextInputType.emailAddress,
                    ),



                    TextFormField(
                      controller: passwordController,
                      obscureText: _isObscure,
                      decoration: InputDecoration(
                        hintText: 'Password',
                        suffixIcon: IconButton(
                          icon: Icon(_isObscure ? Icons.visibility:Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                        )
                      ),
                      validator: (value) {
                        RegExp regex = RegExp(r'^.{6,}$');
                        if (value!.isEmpty){
                          return "password tidak boleh kosong";
                        }
                        if (!regex.hasMatch(value)){
                          return ("masukkan password minimal 6 karakter");
                        }
                        else {
                          return null;
                        }
                      },
                      onSaved: (newValue) {
                        passwordController.text = newValue!;
                      },
                    ),
            

                    Text("perhatian!!: ${alertText}"),


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
                      setState(() {
                        visible = true;
                      });
                      signIn(emailController.text, passwordController.text);
                      
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
                    ),
                    
                  

                    Visibility(
                            maintainSize: true,
                            maintainAnimation: true,
                            maintainState: true,
                            visible: visible,
                            child: Container(
                                child: CircularProgressIndicator(
                              color: Colors.white,
                            ))),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }





  void route(){
    User? user = FirebaseAuth.instance.currentUser;
    var user_role = FirebaseFirestore.instance
                    .collection('users')
                    .doc(user!.uid)
                    .get()
                    .then((DocumentSnapshot documentSnapshot) {
                      if (documentSnapshot.exists){
                        if(documentSnapshot.get('role')=='peternak'){
                          userPeternakID = user.uid;
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                            return PeternakHomepage();
                          }), (route) => false);
                        }
                        else{
                          setState(() {
                            alertText = 'User Belum mendaftar sebagai peternak';
                          });
                          return print('User Belum mendaftar sebagai peternak');
                        }
                      }
                      else{
                        setState(() {
                          alertText = 'Email tidak terdaftar';
                        });
                        print('Email tidak terdaftar');
                      }
                    });
  }





  void signIn(String email, String password) async {
    if(_formkey.currentState!.validate()){
      try {
        UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password);
        route();
      }
      on FirebaseAuthException catch (e){
        if (e.code == 'user-not-found'){
          setState(() {
            alertText = 'Email tidak terdaftar';
          });
          print('Email tidak terdaftar');
        }
        else if (e.code == 'wrong-password'){
          setState(() {
            alertText = 'Password salah';
          });
          print('Password salah');
        }
      }
    }
  }




}


