import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

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
                          hintText: 'Nama',
                        ),
                      ),
                      TextFormField(
                        controller: emailController,
                        decoration: InputDecoration(
                          hintText: 'Email',
                        ),
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