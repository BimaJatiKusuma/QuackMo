import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quackmo/produsen/produsen_daftar_produk_detail.dart';

class ProdusenDaftarProduk extends StatefulWidget {
  const ProdusenDaftarProduk({super.key});

  @override
  State<ProdusenDaftarProduk> createState() => _ProdusenDaftarProdukState();
}

class _ProdusenDaftarProdukState extends State<ProdusenDaftarProduk> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Daftar Peternak Bebek"),
      ),
      body: Column(
        children: [
          Row(
            children: [
              Container(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProdusenDaftarProdukDetail();
                    }));
                  },
                  child: Ink(
                    color: Colors.blue,
                    child: Column(
                      children: [
                        Image(image: AssetImage('images/daftar_produk01.png')),
                        Column(children: [
                          Text('TELUR BEBEK HIBRIDA'),
                          Text('Stok: 100 telur'),
                          Text('Harga: Rp. 2.000 / telur')
                        ])
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                child: InkWell(
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ProdusenDaftarProdukDetail();
                    }));
                  },
                  child: Ink(
                    color: Colors.blue,
                    child: Column(
                      children: [
                        Image(image: AssetImage('images/daftar_produk01.png')),
                        Column(children: [
                          Text('TELUR BEBEK HIBRIDA'),
                          Text('Stok: 100 telur'),
                          Text('Harga: Rp. 2.000 / telur')
                        ])
                      ],
                    ),
                  ),
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
