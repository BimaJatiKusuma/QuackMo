import 'package:flutter/material.dart';
import 'package:quackmo/produsen/produsen_daftar_produk.dart';


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
          Text("Jember"),
          Container(
          child: Column(children: [
            InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return ProdusenDaftarProduk();
                }));
              },
              child: Ink(
                color: Colors.blue,
                child: Row(
                  children: [
                    Icon(Icons.square),
                    Column(children: [
                      Text('Peternak Bebek Farhaz'),
                      Text('PT. Jaya Abadi'),
                      Text('Alamat: Jl. Mawar Merah no. 11')
                    ])
                  ],
                ),
              ),
            ),
          ]),
        ),
        ],
      ),
    );
  }
}