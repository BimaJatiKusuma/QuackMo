import 'package:flutter/material.dart';
import 'package:quackmo/produsen/produsen_homepage.dart';
import 'package:quackmo/produsen/produsen_pembayaran.dart';

class ProdusenPesanan extends StatelessWidget {
  const ProdusenPesanan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                return ProdusenHomepage();
              }), (route) => false);

            },
          ),
          title: Title(color: Colors.indigo, child: Text("Pemesanan")),
        ),
        body: ListView(
          children: [
            Text("Semua Pemesanan"),
            
            InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    Text('1 April 2023'),
                    Card(
                      child: Row(children: [
                        Icon(Icons.square),
                        Column(
                          children: [
                            Text('Telur Hibrida'),
                            Text('PT. Jaya Abadi'),
                            Text('Pemesanan: 1 butir telur'),
                            Text('Menunggu konfirmasi peternak (1x24 jam)')
                          ],
                        ),
                        TextButton(
                            onPressed: () {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Pemberitahuan'),
                                  content: const Text('Hapus pemesanan'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Tidak'),
                                      child: const Text('Tidak'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'Ya'),
                                      child: const Text('Ya'),
                                    ),
                                  ],
                                ),
                              );
                            },
                            child: Icon(Icons.delete)),
                      ]),
                    ),
                  ],
                )),


                InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return ProdusenPembayaran();
                  }));
                },
                child: Column(
                  children: [
                    Text('30 Maret 2023'),
                    Card(
                      child: Row(children: [
                        Icon(Icons.square),
                        Column(
                          children: [
                            Text('Telur Hibrida'),
                            Text('PT. Jaya Abadi'),
                            Text('Pemesanan: 1 butir telur'),
                            Text('Menunggu Pembayaran')
                          ],
                        ),

                      ]),
                    ),
                  ],
                )),
          ],
        ));
  }
}
