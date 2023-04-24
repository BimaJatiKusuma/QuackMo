import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quackmo/produsen/produsen_login.dart';


class ProdusenRegis extends StatefulWidget {
  const ProdusenRegis({super.key});

  @override
  State<ProdusenRegis> createState() => _ProdusenRegisState();
}

class _ProdusenRegisState extends State<ProdusenRegis> {
  String username = "";
  String email= "";
  String password= "";
  bool _obscureText = true;

  final _formkey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;

  TextEditingController usernameController =  TextEditingController();
  TextEditingController emailController =  TextEditingController();
  // TextEditingController noHPController =  TextEditingController();
  // TextEditingController alamatController =  TextEditingController();
  // TextEditingController kotaController =  TextEditingController();
  // TextEditingController negaraController =  TextEditingController();
  // TextEditingController kodePosController =  TextEditingController();
  // TextEditingController usiaController =  TextEditingController();
  // TextEditingController genderController =  TextEditingController();
  TextEditingController passwordController =  TextEditingController();
  TextEditingController konfirmasipasswordController =  TextEditingController();

  var role = 'produsen';
  
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
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: usernameController,
                        decoration: InputDecoration(
                          hintText: 'Nama',
                        ),
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
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
                      ),
                      // TextFormField(
                      //   controller: noHPController,
                      //   decoration: InputDecoration(
                      //     hintText: 'No. Hp',
                      //   ),
                      // ),
                      // TextFormField(
                      //   controller: alamatController,
                      //   decoration: InputDecoration(
                      //     hintText: 'Alamat',
                      //   ),
                      // ),
                      // TextFormField(
                      //   controller: kotaController,
                      //   decoration: InputDecoration(
                      //     hintText: 'Kota',
                      //   ),
                      // ),
                      // TextFormField(
                      //   controller: kodePosController,
                      //   decoration: InputDecoration(
                      //     hintText: 'Kode Pos',
                      //   ),
                      // ),
                      // TextFormField(
                      //   controller: usiaController,
                      //   decoration: InputDecoration(
                      //     hintText: 'Usia (dalam tahun)',
                      //   ),
                      // ),
                      // TextFormField(
                      //   controller: genderController,
                      //   decoration: InputDecoration(
                      //     hintText: 'Jenis Kelamin',
                      //   ),
                      // ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Password',
                          suffix: IconButton(onPressed: _toggle, icon: _eyePass(_obscureText))
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
                      ),
                      TextFormField(
                        controller: konfirmasipasswordController,
                        obscureText: _obscureText,
                        decoration: InputDecoration(
                          hintText: 'Konfirmasi Password',
                          suffix: IconButton(onPressed: _toggle, icon: _eyePass(_obscureText))
                        ),
                        validator: (value) {
                          if (konfirmasipasswordController.text != passwordController.text){
                            return "Password tidak sama";
                          }
                          else {
                            return null;
                          }
                        },
                      ),
                    
                    ElevatedButton(onPressed: (){
                      signUp(usernameController.text, emailController.text, passwordController.text, role);
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


  void signUp(String nama, String email, String password, String role) async {
    CircularProgressIndicator();
    if(_formkey.currentState!.validate()){
      try{
        //fix this
      await _auth
        .createUserWithEmailAndPassword(email: email, password: password)
        .then((value) => {postDetailsToFirestore(nama, email, role)});
        // .catchError((e){});
      }
      on FirebaseAuthException catch (e){
        if(e.code == 'email-already-in-use'){
            print("email sudah digunakan");
            
          }
      }
    }
  }

  postDetailsToFirestore(String nama, String email, String role) async {
    CircularProgressIndicator();
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    var user = _auth.currentUser;
    CollectionReference ref = FirebaseFirestore.instance.collection('users');
    ref.doc(user!.uid).set({'nama':usernameController.text, 'email':emailController.text, 'role': role});
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
      return ProdusenLogin();
    }));
  }



}