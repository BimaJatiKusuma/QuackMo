import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:quackmo/peternak/peternak_login.dart';
import 'package:quackmo/peternak/peternak_transaksi/peternak_transaksi.dart';

class PeternakPesanan extends StatefulWidget {
  const PeternakPesanan({super.key});

  @override
  State<PeternakPesanan> createState() => _PeternakPesananState();
}

class _PeternakPesananState extends State<PeternakPesanan> {
  CollectionReference _pemesananList = FirebaseFirestore.instance.collection('pemesanan');

  late Stream<QuerySnapshot> _streamPemesananList;

  List kondisi_produk = [100,200, 300];
  
  void initState() {
    super.initState();
    _streamPemesananList = _pemesananList
        .where('id_peternak', isEqualTo: userPeternakID)
        .where('id_kondisi', whereIn: List.of(kondisi_produk))
        .snapshots();
  }

  _textKondisi(kondisi) {
    if (kondisi == 100) {
      return Text("Menunggu konfirmasi pemesanan");
    } else if (kondisi == 200) {
      return Text("Telah disetujui", style: TextStyle(color: Colors.green),);
    }
    else if (kondisi == 300) {
      return Text("Pemesanan telah dibatalkan", style: TextStyle(color: Colors.red),);
    }
  }

  _alert(id_pemesanan, id_produk, total_barang, stok_barang) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10)
        ),
        title: Container(
          decoration: BoxDecoration(
            color: Color.fromRGBO(225, 202, 167, 1),
            borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10))
          ),
          child: Text('Pemberitahuan', textAlign: TextAlign.center,)),
        content: const Text('Pemesanan disetujui ?', textAlign: TextAlign.center,),
        titlePadding: EdgeInsets.zero,
        actions: [
          Row(
            children: [
              Flexible(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black),
                    onPressed: () {
                      _pemesananList
                          .doc(id_pemesanan)
                          .update({'id_kondisi': 300});
                      Navigator.pop(context, 'Tidak');
                    },
                    child: const Text('Tidak'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(225, 202, 167, 1),
                        foregroundColor: Colors.black,
                        elevation: 5,
                        ),
                    onPressed: ()  {
                      _pemesananList
                          .doc(id_pemesanan)
                          .update({'id_kondisi': 200});
                          FirebaseFirestore.instance.collection('produk').doc(id_produk).update({'stok': (stok_barang - total_barang)});
                      // _referenceProduk.update({'stok': (dataProduk['stok'] - total_barang)});
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return PeternakTransaksi();
                      }));
                    },
                    child: Text('Ya'),
                  ),
                ],
              ))
            ],
          ),
        ],
      ),
    );
  }


  _iconKondisi(kondisi){
    if (kondisi == 100) {
      return Icon(Icons.check_circle_outline, color: Color.fromRGBO(225, 202, 167, 1),);
    } else if (kondisi == 200) {
      return Icon(Icons.check_circle, color: Color.fromRGBO(225, 202, 167, 1));
    }
    else if (kondisi == 300) {
      return Icon(Icons.close_rounded, color: Color.fromRGBO(225, 202, 167, 1));
    }
  }

  @override
  Widget build(BuildContext context) {
    _pemesananList.snapshots();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(225, 202, 167, 1),
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text("Pesanan Masuk"),
        ),
        body: StreamBuilder(
          stream: _streamPemesananList,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.connectionState == ConnectionState.active) {
              QuerySnapshot querySnapshot = snapshot.data;
              List<QueryDocumentSnapshot> listQueryDocumentSnapshot = querySnapshot.docs;
              
              if (listQueryDocumentSnapshot.length >= 2) {
                listQueryDocumentSnapshot
                    .sort((a, b) => a['id_kondisi'].compareTo(b['id_kondisi']));
              }
              

              return ListView.builder(
                itemCount: listQueryDocumentSnapshot.length,
                itemBuilder: (context, index) {
                late DocumentReference _referenceProduk;
                late Future<DocumentSnapshot> _futureDataProduk;
                late Map dataProduk;

                late DocumentReference _referenceProdusen;
                late Future<DocumentSnapshot> _futureDataProdusen;
                late Map dataProdusen;

                  QueryDocumentSnapshot pemesanan = listQueryDocumentSnapshot[index];
                  var id_pemesanan = pemesanan.id;

                  _referenceProduk = FirebaseFirestore.instance.collection('produk').doc(pemesanan['id_produk']);
                  _futureDataProduk = _referenceProduk.get();

                  _referenceProdusen = FirebaseFirestore.instance.collection('users').doc(pemesanan['id_produsen']);
                  _futureDataProdusen = _referenceProdusen.get();

                  return FutureBuilder(
                    future: _futureDataProduk,
                    builder: (context, snapshot) {
                      if(snapshot.hasError){
                        return Center(child: Text('Terjadi Error ${snapshot.hasError}'),);
                      }
                      if(snapshot.hasData){
                        DocumentSnapshot? documentSnapshotProduk = snapshot.data;
                        dataProduk = documentSnapshotProduk!.data() as Map;
                        
                        return FutureBuilder(
                          future: _futureDataProdusen,
                          builder: (context, snapshotProdusen) {
                            if (snapshotProdusen.hasError){
                              return Center(child: Text('Terjadi error ${snapshotProdusen.hasError}'),);
                            }
                            if (snapshotProdusen.hasData){
                              DocumentSnapshot? documentSnapshotProdusen = snapshotProdusen.data;
                              dataProdusen = documentSnapshotProdusen!.data() as Map;

                              return Container(
                                width: MediaQuery.of(context).size.width*0.9,
                                margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(DateFormat('dd MMMM yyyy, HH:mm').format((pemesanan['waktu']as Timestamp).toDate())),
                                    InkWell(
                                      onTap: () {
                                        if(pemesanan['id_kondisi']==100){
                                          _alert(id_pemesanan, pemesanan['id_produk'], pemesanan['quantity'], dataProduk['stok']);
                                        }
                                      },
                                      child: Ink(
                                        width: double.infinity,
                                        decoration: BoxDecoration(
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
                                          child: Table(
                                            columnWidths: {1:FractionColumnWidth(.8)},
                                            children: [
                                              TableRow(
                                                children: [
                                                  TableCell(
                                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                                    child: Container(
                                                      width: 50,
                                                      child: Icon(Icons.square_rounded, color: Color.fromRGBO(225, 202, 167, 1),),
                                                    ),
                                                  ),
                                                  Container(
                                                    child: Column(
                                                      crossAxisAlignment: CrossAxisAlignment.start,
                                                      children: [
                                                        Text(dataProduk['nama_produk'], style: TextStyle(fontWeight: FontWeight.w600),),
                                                        Text("Produsen Telur Asin ${dataProdusen['nama']}"),
                                                        Text("Pemesanan: ${pemesanan['quantity']} butir telur", style: TextStyle(fontWeight: FontWeight.w500),),
                                                        _textKondisi(pemesanan['id_kondisi'])
                                                      ],
                                                    ),
                                                  ),
                                                  TableCell(
                                                    verticalAlignment: TableCellVerticalAlignment.middle,
                                                    child: Container(
                                                      width: 50,
                                                      child: _iconKondisi(pemesanan['id_kondisi']),
                                                    ),
                                                  )
                                                ]
                                              )
                                            ],
                                          ),
                                      ),

                                    ),
                                  ],
                                ),

                              );
                            }
                            return CircularProgressIndicator();
                          },
                        );


                      }
                      return CircularProgressIndicator();
                    }
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ));
  }
}
