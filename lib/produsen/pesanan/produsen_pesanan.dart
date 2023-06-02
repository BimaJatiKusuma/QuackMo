import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quackmo/produsen/produsen_homepage.dart';
import 'package:quackmo/produsen/produsen_login.dart';
import 'package:quackmo/produsen/pembayaran/produsen_pembayaran.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:quackmo/produsen/transaksi/produsen_transaksi.dart';

class ProdusenPesanan extends StatefulWidget {
  const ProdusenPesanan({super.key});

  @override
  State<ProdusenPesanan> createState() => _ProdusenPesananState();
}

class _ProdusenPesananState extends State<ProdusenPesanan> {
  CollectionReference _pemesananList = FirebaseFirestore.instance.collection('pemesanan');

  late Stream<QuerySnapshot> _streamPemesananList;
  List kondisi_produk = [100, 200, 300];

  String _orderBy = 'id_kondisi';
  bool _isDescending = false;
  void initState() {
    super.initState();
    _streamPemesananList = _pemesananList
        .where('id_produsen', isEqualTo: userProdusenID)
        .where('id_kondisi', whereIn: List.of(kondisi_produk))
        .snapshots();
  }

  _textKondisi(kondisi) {
    if (kondisi == 100) {
      return Text("menunggu konfirmasi peternak 1x24 jam");
    } else if (kondisi == 200) {
      return Text("Pesanan disetujui, Harap dibayar", style: TextStyle(color: Colors.green),);
    } else if (kondisi == 300) {
      return Text("Pemesanan Ditolak", style: TextStyle(color: Colors.red));
    }
  }

  _batalIcon(kondisi, id_pemesanan) {
    if (kondisi == 100) {
      return TextButton(
          onPressed: () {
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
                content: const Text('Hapus pemesanan'),
                titlePadding: EdgeInsets.zero,
                actionsAlignment: MainAxisAlignment.spaceAround,
                actions: <Widget>[
                  TextButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(225, 202, 167, 1),
                        foregroundColor: Colors.black,
                        elevation: 5,
                        ),
                    onPressed: () => Navigator.pop(context, 'Tidak'),
                    child: const Text('Tidak'),
                  ),
                  TextButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromRGBO(225, 202, 167, 1),
                        foregroundColor: Colors.black,
                        elevation: 5,
                        ),
                    onPressed: () {
                      _pemesananList.doc(id_pemesanan).delete();
                      Navigator.pop(context, 'Ya');
                    },
                    child: Text('Ya'),
                  ),
                ],
              ),
            );
          },
          child: Icon(Icons.delete, color: Color.fromRGBO(225, 202, 167, 1),));
    } else {
      return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    _pemesananList.snapshots();
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(225,202,167,1),
          leading: BackButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(context,
                  MaterialPageRoute(builder: (context) {
                return ProdusenHomepage();
              }), (route) => false);
            },
          ),
          title: Title(color: Colors.indigo, child: Text("Pemesanan")),
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
                listQueryDocumentSnapshot.sort((a, b) => a['id_kondisi'].compareTo(b['id_kondisi']));
              }

              return ListView.builder(
                itemCount: listQueryDocumentSnapshot.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot pemesanan =
                      listQueryDocumentSnapshot[index];
                  // print(index);
                  // print(pemesanan);
                  var id_pemesanan = pemesanan.id;
                  DateTime waktuDB = (pemesanan['waktu'] as Timestamp).toDate();
                  String formatWaktu = DateFormat('dd/MM/yyyy, HH:mm').format(waktuDB);
                  late var _futureDataProduk;
                  late Map dataProduk;
                  _futureDataProduk = FirebaseFirestore.instance.collection('produk').doc(pemesanan['id_produk']).get();

                  return FutureBuilder(
                    future: _futureDataProduk,
                    builder: (context, AsyncSnapshot snapshot) {
                      if(snapshot.hasError){
                        return Text("${snapshot.hasError}");
                      }
                      if(snapshot.hasData){
                        dataProduk = snapshot.data!.data() as Map;
                        return 
                          Container(
                            margin: EdgeInsets.fromLTRB(0, 10, 0, 0),
                            child: Column(
                              children: [
                                Container(
                                  child: Text(formatWaktu),
                                ),
                                InkWell(
                                  splashColor: Colors.grey,
                                    onTap: () {
                                      if (pemesanan['id_kondisi'] == 200) {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (context) {
                                          return ProdusenPembayaran(id_pemesanan);
                                        }));
                                      }
                                    },
                                    child: Ink(
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
                                      child: Table(
                                        columnWidths: {
                                          0: FlexColumnWidth(1),
                                          1: FlexColumnWidth(7),
                                          2: FlexColumnWidth(1)
                                        },
                                        children: [
                                          TableRow(
                                            children: [
                                              Icon(Icons.square, color: Color.fromRGBO(225, 202, 167, 1),),
                                              Container(
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(dataProduk['nama_produk']),
                                                    Text(
                                                        'Pemesanan: ${pemesanan['quantity']} butir telur'),
                                                    _textKondisi(pemesanan['id_kondisi'])
                                                  ],
                                                ),
                                              ),
                                              _batalIcon(pemesanan['id_kondisi'], id_pemesanan)
                                            ]
                                          )
                                        ],
                                      ),
                                    )
                                ),
                              ],
                            ),
                          );
                      }
                      return Center(child: CircularProgressIndicator(),);
                    },
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