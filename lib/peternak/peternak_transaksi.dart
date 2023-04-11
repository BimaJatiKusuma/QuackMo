import 'package:flutter/material.dart';
class TabTransaksiMasuk extends StatelessWidget {
  const TabTransaksiMasuk({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
      children: [
        Text("Semua Transaksi"),
        InkWell(
          child: Column(
            children: [
              Text('1 April 2023'),
              Card(
                child: Row(children: [
                  Image(image: AssetImage('images/transkasi02.png')),
                  Column(children: [
                    Text('Transfer Rupian'),
                    Text('Transfer dari BANK MANDIRI'),
                    Text('FARHAZ NURJANANTO 09183764644')
                  ],),
                  Column(children: [
                    Icon(Icons.access_time_filled_outlined),
                    Text("+ Rp. 20.0000")
                  ],)
                ]),
          ),
            ],
          )
        )
      ],
    ));
  }
}


class TabDetailPenjualan extends StatelessWidget {
  const TabDetailPenjualan({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: ListView(
      children: [
        Text("Semua Penjualan"),
        InkWell(
          onTap: (){
            
          },
          child: Column(
            children: [
              Text('Juni'),
              Card(
                child: Row(children: [
                  Image(image: AssetImage('images/transkasi02.png')),
                  Column(children: [
                    Text('Transfer Rupian'),
                    Text('Transfer dari BANK MANDIRI'),
                    Text('FARHAZ NURJANANTO 09183764644')
                  ],),
                  Column(children: [
                    Icon(Icons.access_time_filled_outlined),
                    Text("+ Rp. 20.0000")
                  ],)
                ]),
          ),
            ],
          )
        )
      ],
    ));
  }
}




class PeternakTransaksi extends StatefulWidget {
  const PeternakTransaksi({super.key});

  @override
  State<PeternakTransaksi> createState() => _PeternakTransaksiState();
}

class _PeternakTransaksiState extends State<PeternakTransaksi> {
  @override
  Widget build(BuildContext context) {
    
    return DefaultTabController(length: 2, child: Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
          },),
        title: Title(color: Colors.indigo, child: Text("Transaksi")),
        bottom: TabBar(
          tabs: [
            Tab(child: Text("Transaksi Masuk"),),
            Tab(child: Text("Detail Penjualan"),)
          ]
        ),
      ),
    body: TabBarView(children: [
      TabTransaksiMasuk(),
      TabDetailPenjualan()
    ],)
    ));
    

  }
}



