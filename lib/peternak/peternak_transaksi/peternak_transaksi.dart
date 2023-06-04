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
      return Icon(Icons.access_time_rounded, color: Color.fromRGBO(225, 202, 167, 1),);
    }
    else if (kondisi == 400) {
      return Icon(Icons.access_time_filled_outlined, color: Color.fromRGBO(225, 202, 167, 1));
    } 
    else if (kondisi == 500) {
      return Icon(Icons.verified_rounded, color: Color.fromRGBO(225, 202, 167, 1));
    }
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
              QueryDocumentSnapshot pemesanan = listQueryDocumentSnapshot[index];
              var id_pemesanan = pemesanan.id;
              late Map dataProdusen;
              late var _futureDataProdusen;

              _futureDataProdusen = FirebaseFirestore.instance.collection('users').doc(pemesanan['id_produsen']).get();
              return FutureBuilder(
                future: _futureDataProdusen,
                builder: (context, AsyncSnapshot snapshot) {
                  if(snapshot.hasError){
                    return Center(child: Text("${snapshot.hasError}"),);
                  }
                  if(snapshot.hasData){
                    DocumentSnapshot? documentSnapshotProdusen = snapshot.data;
                    dataProdusen = documentSnapshotProdusen!.data() as Map;
                    return 
                      Container(
                        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                        decoration:BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey,
                              spreadRadius: 1,
                              blurRadius: 2,
                                )
                              ]
                          ),
                        child: Column(children: [
                          Text(DateFormat('dd MMMM yyyy, HH:mm').format((pemesanan['waktu_transaksi']as Timestamp).toDate())),
                          InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return PeternakTransaksiDetail(id_pemesanan);
                              }));
                            },
                            child: Ink(
                              child: Table(
                                columnWidths: {
                                  0: FlexColumnWidth(1),
                                  1: FlexColumnWidth(7),
                                  2: FlexColumnWidth(3)
                                },
                                children: [
                                  TableRow(
                                    children: [
                                      Container(
                                        child: Image(
                                          image: AssetImage('images/transaksi_02.png'),),
                                      ),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Transfer Rupiah"),
                                            Text("id: ${id_pemesanan}"),
                                            Text("atas nama: ${dataProdusen['nama']}", style: TextStyle(fontWeight: FontWeight.w600),),
                                            _textKondisi(pemesanan['id_kondisi'])
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.end,
                                          children: [
                                            _iconKondisi(pemesanan['id_kondisi']),
                                            Text("+ ${formatter.format(pemesanan['total'])}")
                                          ],
                                        ),
                                      )
                                    ]
                                  )
                                ],
                              ),
                            ),
                          ),
                        ]),
                      );

                  }
                  return CircularProgressIndicator();
                },
              );
              
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
  Future<List<Map<String, dynamic>>> getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance.collection('pemesanan').where('id_peternak', isEqualTo: userPeternakID).where('id_kondisi', isEqualTo: 500).get();
    
    List<Map<String, dynamic>> data = [];

    for (QueryDocumentSnapshot documentSnapshot in querySnapshot.docs) {
      DateTime dateTime = documentSnapshot['waktu_pembayaran'].toDate();
// Text(DateFormat('dd MMMM yyyy, HH:mm').format((pemesanan['waktu_transaksi']as Timestamp).toDate())),
      String monthYear = DateFormat('MMMM yyyy').format(dateTime);
      // String monthYear = '${dateTime.month}-${dateTime.year}';
      double value = documentSnapshot['total'].toDouble();
      int existingIndex = data.indexWhere((entry) => entry['monthYear'] == monthYear);
      if (existingIndex != -1) {
        data[existingIndex]['sum'] += value;
      } else {
        data.add({'monthYear': monthYear, 'sum': value});
      }
    }

    return data;
  }

  
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: getData(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('');
        } else {
          List<Map<String, dynamic>> data = snapshot.data!;
          return ListView.builder(
            itemCount: data.length,
            itemBuilder: (context, index) {
              String monthYear = data[index]['monthYear'];
              double sum = data[index]['sum'];
              return Container(
                padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Bulan $monthYear'),
                    Container(
                      height: 50,
                      padding: EdgeInsets.fromLTRB(20, 0, 10, 0),
                      decoration:BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            spreadRadius: 1,
                            blurRadius: 2,
                              )
                            ]
                        ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Pendapatan :", style: TextStyle(fontWeight: FontWeight.w900),),
                          Text("Rp. $sum", style: TextStyle(fontWeight: FontWeight.w900))
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          );
        }
      },
    );
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
              leading: PreferredSize(
                preferredSize: Size(10, 10),
                child: ElevatedButton(onPressed: (){
                  Navigator.pop(context);
                },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(225, 202, 167, 1),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(60),
                      side: BorderSide(color: Colors.white),
                    ),
                  ),
                  child: Icon(Icons.arrow_back_ios_new,)),
              ),
              backgroundColor: Color.fromRGBO(225, 202, 167, 1),
              title: Text("Transaksi"),
              centerTitle: true,
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

