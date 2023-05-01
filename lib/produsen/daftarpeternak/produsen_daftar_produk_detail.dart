import 'package:flutter/material.dart';
import 'package:quackmo/produsen/produsen_login.dart';
import 'package:quackmo/produsen/pesanan/produsen_pesanan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProdusenDaftarProdukDetail extends StatefulWidget {
  ProdusenDaftarProdukDetail(this.produkID, {Key? key}) : super(key: key) {
    _reference = FirebaseFirestore.instance.collection('produk').doc(produkID);
    _futureData = _reference.get();
  }

  String produkID;
  late DocumentReference _reference;
  late Future<DocumentSnapshot> _futureData;
  late Map data;

  @override
  State<ProdusenDaftarProdukDetail> createState() =>
      _ProdusenDaftarProdukDetailState();
}

class _ProdusenDaftarProdukDetailState
    extends State<ProdusenDaftarProdukDetail> {
  late var _produkData = widget.data;
  late int satuan = _produkData['satuan'];
  late int total = satuan;
  late int hargaTotal = 0;
  _add() {
    if (total >= _produkData['stok']) {
      total = total;
    } else {
      total = total + satuan;
    }
    return total;
  }

  _decrease() {
    if (total <= satuan) {
      total = satuan;
    } else {
      total = total - satuan;
    }
    return total;
  }

  _total(total) {
    return Text("$total");
  }

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference pemesanan = firestore.collection('pemesanan');

    // if(total>_produkData['stok']){
    //   total = _produkData['stok'];
    // }

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Telur Bebek Hibrida"),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: widget._futureData,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Terjadi Error ${snapshot.hasError}'));
          }
          if (snapshot.hasData) {
            DocumentSnapshot? documentSnapshot = snapshot.data;
            widget.data = documentSnapshot!.data() as Map;
            if (total > _produkData['stok']) {
              total = _produkData['stok'];
            }
            return ListView(
              children: [
                Image(image: NetworkImage(_produkData['foto_url'])),
                Container(
                  child: Column(
                    children: [
                      Text("Detail Produk"),
                      Container(
                        child: Column(
                          children: [
                            Text("Nama: ${_produkData['nama_produk']}"),
                            Text("Stock: ${_produkData['stok']}"),
                            Text("Berat Satuan: ${_produkData['satuan']}"),
                            Text("Harga: ${_produkData['harga']} / ${_produkData['satuan']} telur"),
                            Text("Keterangan: ${_produkData['keterangan']}")
                          ],
                        ),
                      ),
                      ElevatedButton(
                          onPressed: () async {
                            await showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    content: StatefulBuilder(builder:
                                        (BuildContext context,
                                            StateSetter setState) {
                                      return Container(
                                        //  height: 200,
                                        child: Column(children: [
                                          Row(
                                            children: [
                                              Container(
                                                child: Row(
                                                  children: [
                                                    IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _add();
                                                          });
                                                        },
                                                        icon: Icon(Icons.add)),
                                                    Text("$total"),
                                                    IconButton(
                                                        onPressed: () {
                                                          setState(() {
                                                            _decrease();
                                                          });
                                                        },
                                                        icon:
                                                            Icon(Icons.remove)),
                                                  ],
                                                ),
                                              ),
                                              Text(
                                                  "Stock Total: ${_produkData['stok']}")
                                            ],
                                          ),
                                          Row(
                                            children: [
                                              Text("SubTotal:"),
                                              Text('${_produkData['harga'] * (total / satuan)}'),
                                              // Text('${hargaTotal}')
                                            ],
                                          )
                                        ]),
                                      );
                                    }),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () async {
                                          setState(() {
                                            hargaTotal = (_produkData['harga'] * (total / satuan)).round();
                                          });
                                          CircularProgressIndicator();
                                          await pemesanan.add({
                                            'id_kondisi': 1,
                                            'id_produk': widget.produkID,
                                            'id_produsen': userProdusenID,
                                            'id_peternak':
                                                _produkData['peternak_uid'],
                                            // 'id_transaksi': '',
                                            'quantity': total,
                                            'waktu': DateTime.now(),
                                            'alamat_kirim': '',
                                            'total': hargaTotal,
                                            'url_bukti_pembayaran': '',
                                            'waktu_transaksi': DateTime.now(),
                                            'id_pengiriman':0
                                          });

                                          Navigator.pushReplacement(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return ProdusenPesanan();
                                          }));
                                        },
                                        child: const Text('Pesan Sekarang'),
                                      ),
                                    ],
                                  );
                                });

                            setState(() {});
                          },
                          child: Text("Beli"))
                    ],
                  ),
                )
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );

    // return Scaffold(
    //   appBar: AppBar(
    //     leading: BackButton(
    //       onPressed: () {
    //         Navigator.pop(context);
    //       },
    //     ),
    //     title: Text("Telur Bebek Hibrida"),
    //   ),
    //   body: Column(
    //     children: [
    //       Text('${widget.data}'),
    //       Image(image: AssetImage('images/daftar_produk01.png')),
    //       Container(
    //         child: Column(
    //           children: [
    //             Text("Detail Produk"),
    //             Container(
    //               child: Column(
    //                 children: [
    //                   Text("Kondisi: Baru"),
    //                   Text("Kategori: Telur Bebek"),
    //                   Text("Stock: 100 Telur"),
    //                   Text("Berat Satuan: 1 Butir"),
    //                   Text("Harga: Rp. 2.000 / telur"),
    //                 ],
    //               ),
    //             ),
    //             ElevatedButton(
    //                 onPressed: () async {
    //                   await showDialog(
    //                       context: context,
    //                       builder: (context) {
    //                         return AlertDialog(
    //                           content: StatefulBuilder(builder:
    //                               (BuildContext context, StateSetter setState) {
    //                             return Container(
    //                               //  height: 200,
    //                               child: Column(children: [
    //                                 Row(
    //                                   children: [
    //                                     Container(
    //                                       child: Row(
    //                                         children: [
    //                                           IconButton(
    //                                               onPressed: () {
    //                                                 setState(() {
    //                                                   _add();
    //                                                 });
    //                                               },
    //                                               icon: Icon(Icons.add)),
    //                                           Text("$total"),
    //                                           IconButton(
    //                                               onPressed: () {
    //                                                 setState(() {
    //                                                   _decrease();
    //                                                 });
    //                                               },
    //                                               icon: Icon(Icons.remove)),
    //                                         ],
    //                                       ),
    //                                     ),
    //                                     Text("Stock Total: 100")
    //                                   ],
    //                                 ),
    //                                 Row(
    //                                   children: [
    //                                     Text("SubTotal:"),
    //                                     Text("Rp. 30.000")
    //                                   ],
    //                                 )
    //                               ]),
    //                             );
    //                           }),
    //                           actions: <Widget>[
    //                             TextButton(
    //                               onPressed: () =>
    //                                   Navigator.pushReplacement(context,
    //                                       MaterialPageRoute(builder: (context) {
    //                                 return ProdusenPesanan();
    //                               })),
    //                               child: const Text('Pesan Sekarang'),
    //                             ),
    //                           ],
    //                         );
    //                       });

    //                   setState(() {});
    //                 },
    //                 child: Text("Beli"))
    //           ],
    //         ),
    //       )
    //     ],
    //   ),
    // );
  }
}
