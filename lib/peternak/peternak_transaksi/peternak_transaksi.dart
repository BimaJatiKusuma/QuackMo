import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quackmo/peternak/peternak_login.dart';
import 'package:quackmo/peternak/peternak_transaksi/peternak_transaksi_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TabTransaksiMasuk extends StatefulWidget {
  const TabTransaksiMasuk({super.key});

  @override
  State<TabTransaksiMasuk> createState() => _TabTransaksiMasukState();
}

class _TabTransaksiMasukState extends State<TabTransaksiMasuk> {
  CollectionReference _transaksiCollection =
      FirebaseFirestore.instance.collection('pemesanan');
  late Stream<QuerySnapshot> _streamTransaksi;

  // List kondisi_pesanan = [200, 400, 500, 600];
  List kondisi_pesanan = [200, 400, 500];
  _textKondisi(kondisi) {
    if (kondisi == 200) {
      return Text("Belum Dibayar oleh Pembeli");
    }
    else if (kondisi == 400) {
      return Text("Konfirmasi Pembayaran");
    }
    else if (kondisi == 500) {
      return Text("Pembayaran Disetujui");
    }
    // else if (kondisi == 600) {
    //   return Text("Pembayaran Ditolak");
    // } 
  }

  _iconKondisi(kondisi){
    if(kondisi == 200){
      return Icon(Icons.access_time_rounded);
    }
    else if (kondisi == 400) {
      return Icon(Icons.access_time_filled_outlined);
    } 
    else if (kondisi == 500) {
      return Icon(Icons.verified_rounded);
    }
    // else if (kondisi == 600) {
    //   return Icon(Icons.close);
    // } 
  }

  NumberFormat formatter =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 2);
  
  void initState() {
    super.initState();
    _streamTransaksi = _transaksiCollection
        .where('id_peternak', isEqualTo: userPeternakID)
        .where('id_kondisi', whereIn: List.of(kondisi_pesanan))
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    _transaksiCollection.snapshots();

    return StreamBuilder(
      stream: _streamTransaksi,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        if (snapshot.hasError) {
          return Text(snapshot.error.toString());
        }
        if (snapshot.connectionState == ConnectionState.active) {
          QuerySnapshot querySnapshot = snapshot.data;
          List<QueryDocumentSnapshot> listQueryDocumentSnapshot =
              querySnapshot.docs;
              print(listQueryDocumentSnapshot.length);
              if(listQueryDocumentSnapshot.length>=2){
                listQueryDocumentSnapshot.sort((a,b)=> a['id_kondisi'].compareTo(b['id_kondisi']));
              }
          return ListView.builder(
            itemCount: listQueryDocumentSnapshot.length,
            itemBuilder: (context, index) {
              QueryDocumentSnapshot pemesanan =
                  listQueryDocumentSnapshot[index];
                var id_pemesanan = pemesanan.id;
              
              return Container(
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                decoration:
                    BoxDecoration(color: Color.fromRGBO(225, 202, 167, 1)),
                child: Column(children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) {
                        return PeternakTransaksiDetail(id_pemesanan);
                      }));
                    },
                    child: Ink(
                      color: Colors.blue,
                      child: Column(
                        children: [
                          Text(DateFormat('dd/MM/yy, HH:mm').format((pemesanan['waktu_transaksi']as Timestamp).toDate())),
                          Text(id_pemesanan),
                          Text(pemesanan['id_produsen']),
                          Row(
                            children: [
                              Image(
                                image: AssetImage('images/transaksi_02.png'),
                              ),
                              Column(children: [
                                _textKondisi(pemesanan['id_kondisi'])
                              ]),
                              Column(
                                children: [
                                  _iconKondisi(pemesanan['id_kondisi']),
                                  Text(
                                      "+ ${formatter.format(pemesanan['total'])}")
                                ],
                              )
                            ],
                          ),
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





class TabDetailPenjualan extends StatefulWidget {
  const TabDetailPenjualan({super.key});

  @override
  State<TabDetailPenjualan> createState() => _TabDetailPenjualanState();
}

class _TabDetailPenjualanState extends State<TabDetailPenjualan> {
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
              backgroundColor: Color.fromRGBO(225, 202, 167, 1),
              title: Text("Transaksi"),
              bottom: TabBar(
                indicatorColor: Colors.black,
                tabs: [
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