import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quackmo/peternak/daftarproduk/peternak_daftar_produk_buat.dart';

class PeternakDaftarProduk extends StatefulWidget {
  const PeternakDaftarProduk({super.key});

  @override
  State<PeternakDaftarProduk> createState() => _PeternakDaftarProdukState();
}

class _PeternakDaftarProdukState extends State<PeternakDaftarProduk> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Daftar Produk"),
        leading: BackButton(),
      ),
      body: ListView(
        
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return PeternakDaftarProdukBuat();
          }));
        },
        child: Icon(Icons.add),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}