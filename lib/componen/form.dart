import 'package:flutter/material.dart';

class FormGroup extends StatefulWidget {
  final String stringNamaLabel;
  final TextInputType keyboardType;
  final TextEditingController controllerNama;
  final String? validasi;
  final String? validasiRespon;
  final TextEditingController? confirmPassword;
  final bool? hanyaBaca;
  final bool? optionalAnswer;
  
  bool enableObscure;
  FormGroup({
    Key? key,
    required this.stringNamaLabel,
    required this.controllerNama,
    required this.keyboardType,
    this.enableObscure = false,
    this.hanyaBaca = false,
    this.optionalAnswer = false,
    this.validasi,
    this.validasiRespon,
    this.confirmPassword,
  }) : super(key: key);

  @override
  State<FormGroup> createState() => _FormGroupState();
}

class _FormGroupState extends State<FormGroup> {
  obscureOrNot(){
    return IconButton(
      icon: Icon(obscureText ? Icons.visibility:Icons.visibility_off),
      onPressed: () {
        setState(() {
          obscureText = !obscureText;
        });
      },
    );
  }
  bool obscureText = false;
  
  val1(a){
    if(!RegExp(widget.validasi!).hasMatch(a)){
      return widget.validasiRespon;
    }
  }

  confirmPassword(a,b){
    if(a != b){
      return "Password tidak cocok";
    }
  }


  @override
  void initState() {
    if(widget.enableObscure == true){
      setState(() {
        obscureText = true;
      });
    }
    super.initState();
  }
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Text(widget.stringNamaLabel),
          TextFormField(
            readOnly: widget.hanyaBaca!,
            controller: widget.controllerNama,
            obscureText: obscureText,
            keyboardType: widget.keyboardType,
            validator: (value) {
              if (widget.optionalAnswer == false){
                if (value!.isEmpty){
                  return "${widget.stringNamaLabel} kosong";
              }
              }
              if (widget.validasi != null){
                return val1(value);
              }
              if (widget.confirmPassword != null){
                if (widget.controllerNama.text != widget.confirmPassword!.text){
                  return "Password tidak cocok";
                }
              }
              else {return null;};
            },
            onSaved:(newValue) {
              widget.controllerNama.text = newValue!;
            },
            decoration: InputDecoration(
                label: Text(widget.stringNamaLabel),
                suffixIcon: widget.enableObscure != false ? obscureOrNot(): null,
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                labelStyle: TextStyle(color: Color.fromRGBO(164, 119, 50, 1), fontSize: 12),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(164, 119, 50, 1))
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color.fromRGBO(164, 119, 50, 1))
                ),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Color.fromRGBO(164, 119, 50, 1)))),
          )
        ],
      ),
    );
  }
}
