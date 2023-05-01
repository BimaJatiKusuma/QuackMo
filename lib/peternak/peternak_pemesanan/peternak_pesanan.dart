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

  List kondisi_produk = [1, 2];
  
  void initState() {
    super.initState();
    _streamPemesananList = _pemesananList
        .where('id_peternak', isEqualTo: userPeternakID)
        .where('id_kondisi', whereIn: List.of(kondisi_produk))
        .snapshots();
  }

  _textKondisi(kondisi) {
    if (kondisi == 1) {
      return Text("menunggu konfirmasi peternak 1x24 jam");
    } else if (kondisi == 2) {
      return Text("Pemesanan Ditolak");
    } else if (kondisi == 3) {
      return Text("Pesanan disetujui, Harap dibayar");
    }
  }

  _alert(id_pemesanan) {
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Pemberitahuan'),
        content: const Text('Pemesanan disetujui'),
        actions: [
          Row(
            children: [
              Flexible(
                child: TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Kembali")),
              ),
              Flexible(
                  child: Row(
                children: [
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      _pemesananList
                          .doc(id_pemesanan)
                          .update({'id_kondisi': 2});
                      Navigator.pop(context, 'Tidak');
                    },
                    child: const Text('TIDAK'),
                  ),
                  TextButton(
                    style: TextButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white),
                    onPressed: () {
                      _pemesananList
                          .doc(id_pemesanan)
                          .update({'id_kondisi': 3});
                      Navigator.pushReplacement(context,
                          MaterialPageRoute(builder: (context) {
                        return PeternakTransaksi();
                      }));
                    },
                    child: Text('YA'),
                  ),
                ],
              ))
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _pemesananList.snapshots();
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Title(color: Colors.indigo, child: Text("Pesanan Masuk")),
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
              
              late DocumentReference _referenceProduk;
              late Future<DocumentSnapshot> _futureDataProduk;
              late Map dataProduk;

              late DocumentReference _referenceProdusen;
              late Future<DocumentSnapshot> _futureDataProdusen;
              late Map dataProdusen;

              return ListView.builder(
                itemCount: listQueryDocumentSnapshot.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot pemesanan = listQueryDocumentSnapshot[index];
                  var id_pemesanan = pemesanan.id;

                  _referenceProduk = FirebaseFirestore.instance.collection('produk').doc(pemesanan['id_produk']);
                  _futureDataProduk = _referenceProduk.get();

                  _referenceProdusen = FirebaseFirestore.instance.collection('users').doc(pemesanan['id_produsen']);
                  _futureDataProdusen = _referenceProdusen.get();
                  print(pemesanan['id_produsen']);

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
                              print(dataProdusen);

                              return Container(
                                width: MediaQuery.of(context).size.width*0.9,
                                color: Colors.blue,
                                margin: EdgeInsets.fromLTRB(5, 10, 5, 0),
                                child: InkWell(
                                  child: Row(
                                    children: [
                                      Column(
                                        children: [
                                          Text(DateFormat('dd/MM/yy, HH:mm').format((pemesanan['waktu']as Timestamp).toDate())),
                                          Text(dataProduk['nama_produk']),
                                          Text("Produsen Telur Asin ${dataProdusen['nama']}"),
                                          Text("${pemesanan['quantity']} telur"),
                                          _textKondisi(pemesanan['id_kondisi'])
                                        ],
                                      ),
                                    ],
                                  ),
                                  onTap: () {
                                    if(pemesanan['id_kondisi']==1){
                                      _alert(id_pemesanan);
                                    }
                                    
                                  },
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

    //     // Text('${_streamProduk}'),
    //     Text('${_pemesananList}'),
    //     Text('${_streamPemesananList}'),
    //     Text("Semua Pesanan"),
    //     Column(
    //       children: [
    //         Text("1 April 2023"),
    //         TextButton(
    //         onPressed: () {
    //           showDialog(
    //             context: context,
    //             builder: (BuildContext context) => AlertDialog(
    //               title: const Text('Pemberitahuan'),
    //               content: const Text('Pemesanan disetujui'),
    //               actions: <Widget>[
    //                 TextButton(
    //                   onPressed: () => Navigator.pop(context, 'Tidak'),
    //                   child: const Text('Tidak'),
    //                 ),
    //                 TextButton(
    //                   onPressed: () => Navigator.pop(context, 'Ya'),
    //                   child: const Text('Ya'),
    //                 ),
    //               ],
    //             ),
    //           );
    //         },
    //         child: Card(
    //               child: Row(children: [
    //                 Icon(Icons.square),
    //                 Column(
    //                   children: [
    //                     Text('Telur Hibrida'),
    //                     Text('Produsen Telur Asin Ady'),
    //                     Text('Pemesanan: 1 butir telur'),
    //                     Text('Menunggu konfirmasi pemesanan')
    //                   ],
    //                 ),
    //                 Icon(Icons.check_circle_outline),
    //               ]),
    //             ),
    //         ),
    //       ],
    //     ),

    //     InkWell(
    //         onTap: () {},
    //         child: Column(
    //           children: [
    //             Text('1 April 2023'),
    //             Card(
    //               child: Row(children: [
    //                 Icon(Icons.square),
    //                 Column(
    //                   children: [
    //                     Text('Telur Hibrida'),
    //                     Text('PT. Jaya Abadi'),
    //                     Text('Pemesanan: 1 butir telur'),
    //                     Text('Pemesanan telah dibatalkan')
    //                   ],
    //                 ),
    //                 Icon(Icons.close_rounded),
    //               ]),
    //             ),
    //           ],
    //         )),

    //     InkWell(
    //         onTap: () {},
    //         child: Column(
    //           children: [
    //             Text('1 April 2023'),
    //             Card(
    //               child: Row(children: [
    //                 Icon(Icons.square),
    //                 Column(
    //                   children: [
    //                     Text('Telur Hibrida'),
    //                     Text('PT. Jaya Abadi'),
    //                     Text('Pemesanan: 1 butir telur'),
    //                     Text('Telah disetujui')
    //                   ],
    //                 ),
    //                 Icon(Icons.check_circle),
    //               ]),
    //             ),
    //           ],
    //         )),

    //   ],
    // ));
  }
}
