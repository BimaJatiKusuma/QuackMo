import 'package:flutter/material.dart';

class PeternakTransaksi extends StatefulWidget {
  const PeternakTransaksi({super.key});

  @override
  State<PeternakTransaksi> createState() => _PeternakTransaksiState();
}

class _PeternakTransaksiState extends State<PeternakTransaksi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          
          },),
        title: Title(color: Colors.indigo, child: Text("Transaksi Masuk")),
      ),
      body: ListView(
        
      ),
    );
  }
}