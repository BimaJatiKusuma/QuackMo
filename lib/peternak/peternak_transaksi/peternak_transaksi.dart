import 'dart:async';

import 'package:flutter/material.dart';
import 'package:quackmo/peternak/peternak_login.dart';
import 'package:quackmo/peternak/peternak_transaksi/peternak_transaksi_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TabTransaksiMasuk extends StatefulWidget {
  const TabTransaksiMasuk({super.key});

  @override
  State<TabTransaksiMasuk> createState() => _TabTransaksiMasukState();
}

class _TabTransaksiMasukState extends State<TabTransaksiMasuk> {
  CollectionReference _transaksiCollection = FirebaseFirestore.instance.collection('transaksi');
  late Stream<QuerySnapshot> _streamTransaksi;
  
  // List listIDpemesanan = [];
  // String listIDpemesanan2 = '';
  //   getDataPesanan() {
  //   var dataPesanan = FirebaseFirestore.instance
  //       .collection('pemesanan')
  //       .where('id_peternak', isEqualTo: userPeternakID)
  //       .get()
  //       .then((value){
  //         listIDpemesanan = value.docs;
  //         listIDpemesanan2 = value.toString();
  //         print(listIDpemesanan[1]['quantity']);
  //         print(value.docs);
  //         print(value.toString());
  //         print(value.size);
  //       });
  //       // print(dataPesanan);
        
  //   //     .doc()
  //   //     .get()
  //   //     .then((DocumentSnapshot documentSnapshot) {
  //   //   if (documentSnapshot.exists) {
  //   //     setState(() {
  //   //       id_peternak = documentSnapshot.get('id_peternak');
  //   //       id_produk = documentSnapshot.get('id_produk');
  //   //       quantity = documentSnapshot.get('quantity');
  //   //     });

  //   //     var dataProduk = FirebaseFirestore.instance
  //   //         .collection('produk')
  //   //         .doc(id_produk)
  //   //         .get()
  //   //         .then((DocumentSnapshot documentSnapshot) {
  //   //       setState(() {
  //   //         hargaProduk = documentSnapshot.get('harga') * quantity;
  //   //       });
  //   //     });
  //   //   }
  //   // });
  // }


  void initState() {
    super.initState();
    // getDataPesanan();
    _streamTransaksi = _transaksiCollection.where('id_peternak', isEqualTo: userPeternakID).snapshots();
  }

  @override
  Widget build(BuildContext context) {
    _transaksiCollection.snapshots();

    return
    
    StreamBuilder(
      stream: _streamTransaksi,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.active) {
          QuerySnapshot querySnapshot = snapshot.data;
          List<QueryDocumentSnapshot> listQueryDocumentSnapshot =
              querySnapshot.docs;

          return ListView.builder(
            itemCount: listQueryDocumentSnapshot.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot transaksi =
                  listQueryDocumentSnapshot[index];
              var id_transaksi = transaksi.id;
              return Container(
                child: Column(children: [
                  Text('1 April 2023'),
                  Text(id_transaksi),
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PeternakTransaksiDetail();
                      }));
                    },
                    child: Ink(
                      color: Colors.blue,
                      child: Row(
                        children: [
                          Image(
                            image: AssetImage('images/transaksi_02.png'),
                          ),
                          Column(children: [
                            Text('Transfer Rupiah'),
                            Text('Transfer dari BANK MANDIRI'),
                            Text('FARHAZ NURJANANTO 09183764644')
                          ]),
                          Column(
                            children: [
                              Icon(Icons.access_time_filled_outlined),
                              Text("+ Rp. 20.0000")
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ]),
              );
              // Text(produk['nama_produk']);
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}

// class TabTransaksiMasuk extends StatelessWidget {
//   const TabTransaksiMasuk({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         child: ListView(
//       children: [
//         Text("Semua Transaksi"),
//         Container(
//           child: Column(children: [
//             Text('1 April 2023'),
//             InkWell(
//               onTap: () {
//                 Navigator.push(context, MaterialPageRoute(builder: (context) {
//                   return PeternakTransaksiDetail();
//                 }));
//               },
//               child: Ink(
//                 color: Colors.blue,
//                 child: Row(
//                   children: [
//                     Image(
//                       image: AssetImage('images/transaksi_02.png'),
//                     ),
//                     Column(children: [
//                       Text('Transfer Rupiah'),
//                       Text('Transfer dari BANK MANDIRI'),
//                       Text('FARHAZ NURJANANTO 09183764644')
//                     ]),
//                     Column(
//                       children: [
//                         Icon(Icons.access_time_filled_outlined),
//                         Text("+ Rp. 20.0000")
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ]),
//         ),
//         Container(
//           child: Column(children: [
//             Text('1 April 2023'),
//             InkWell(
//               onTap: () {},
//               child: Ink(
//                 color: Colors.blue,
//                 child: Row(
//                   children: [
//                     Image(
//                       image: AssetImage('images/transaksi_02.png'),
//                     ),
//                     Column(children: [
//                       Text('Transfer Rupiah'),
//                       Text('Transfer dari BANK MANDIRI'),
//                       Text('FARHAZ NURJANANTO 09183764644')
//                     ]),
//                     Column(
//                       children: [
//                         Icon(Icons.check_circle),
//                         Text("+ Rp. 20.0000")
//                       ],
//                     )
//                   ],
//                 ),
//               ),
//             ),
//           ]),
//         )
//       ],
//     ));
//   }
// }

class TabDetailPenjualan extends StatelessWidget {
  const TabDetailPenjualan({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
        child: ListView(
      children: [
        Text("Semua Penjualan"),
        InkWell(
            onTap: () {},
            child: Column(
              children: [
                Text('Juni'),
                Card(
                  child: Row(children: [
                    Image(image: AssetImage('images/transaksi_02.png')),
                    Column(
                      children: [
                        Text('Pengeluaran'),
                        Text('Pendapatan'),
                        Text('Untung')
                      ],
                    ),
                    Column(
                      children: [
                        Text("- Rp. 100.0000"),
                        Text("+ Rp. 200.0000"),
                        Text("+ Rp. 100.0000")
                      ],
                    )
                  ]),
                ),
              ],
            ))
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
    return DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              leading: BackButton(
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              title: Title(color: Colors.indigo, child: Text("Transaksi")),
              bottom: TabBar(tabs: [
                Tab(
                  child: Text("Transaksi Masuk"),
                ),
                Tab(
                  child: Text("Detail Penjualan"),
                )
              ]),
            ),
            body: TabBarView(
              children: [TabTransaksiMasuk(), TabDetailPenjualan()],
            )));
  }
}
