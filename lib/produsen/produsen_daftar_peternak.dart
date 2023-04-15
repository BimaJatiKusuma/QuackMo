import 'package:flutter/material.dart';

class ProdusenDaftarPeternak extends StatelessWidget {
  const ProdusenDaftarPeternak({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        },),
        title: Text("Daftar Peternak Bebek"),
      ),
      body: ListView(
        children: [
          ElevatedButton(onPressed: (){
            
          }, child: Text("Cek Bentuk Pembayaran_Test01"))
        ],
      ),
    );
  }
}