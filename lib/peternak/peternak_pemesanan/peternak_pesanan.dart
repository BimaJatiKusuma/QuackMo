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
  
  late DocumentReference _referenceProduk;
  late Future<DocumentSnapshot> _futureDataProduk;
  late Map dataProduk;

  late DocumentReference _referenceProdusen;
  late Future<DocumentSnapshot> _futureDataProdusen;
  late Map dataProdusen;

  List kondisi_produk = [100, 300];
  
  void initState() {
    super.initState();
    _streamPemesananList = _pemesananList
        .where('id_peternak', isEqualTo: userPeternakID)
        .where('id_kondisi', whereIn: List.of(kondisi_produk))
        .snapshots();
  }

  _textKondisi(kondisi) {
    if (kondisi == 100) {
      return Text("menunggu konfirmasi peternak 1x24 jam");
    } else if (kondisi == 300) {
      return Text("Pemesanan Ditolak");
    }
  }

  _alert(id_pemesanan, total_barang) {
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
                          .update({'id_kondisi': 300});
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
                          .update({'id_kondisi': 200});
                      _referenceProduk.update({'stok': (dataProduk['stok'] - total_barang)});
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
              
              if (listQueryDocumentSnapshot.length >= 2) {
                listQueryDocumentSnapshot
                    .sort((a, b) => a['id_kondisi'].compareTo(b['id_kondisi']));
              }
              

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
                                    if(pemesanan['id_kondisi']==100){
                                      _alert(id_pemesanan, pemesanan['quantity']);
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
  }
}
