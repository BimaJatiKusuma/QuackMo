import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quackmo/peternak/peternak_login.dart';

class PeternakPesanan extends StatefulWidget {
  const PeternakPesanan({super.key});

  @override
  State<PeternakPesanan> createState() => _PeternakPesananState();
}

class _PeternakPesananState extends State<PeternakPesanan> {
  CollectionReference _pemesananList =
      FirebaseFirestore.instance.collection('pemesanan');
  CollectionReference _produkPeternak =
      FirebaseFirestore.instance.collection('produk');

  late Stream<QuerySnapshot> _streamPemesananList;
  // late Stream<QuerySnapshot> _streamProduk;
  List kondisi_produk = [1, 2];
  void initState() {
    super.initState();
    // _streamProduk = _produkPeternak.where('peternak_uid', isEqualTo: userPeternakID).snapshots();
    // _getProduk = _streamProduk.
    // _streamPemesananList = _pemesananList.where('id_peternak', isEqualTo: userPeternakID).where('id_kondisi', whereIn: List.of(kondisi_produk)).snapshots();
    _streamPemesananList = _pemesananList
        .where('id_peternak', isEqualTo: userPeternakID)
        .where('id_kondisi', whereIn: List.of(kondisi_produk))
        .snapshots();
    // _streamPemesananList = _pemesananList.where('id_kondisi', whereIn: List.of(kondisi_produk)).snapshots();
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
          title: Title(color: Colors.indigo, child: Text("Transaksi")),
        ),
        body: StreamBuilder(
          stream: _streamPemesananList,
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
                  QueryDocumentSnapshot pemesanan =
                      listQueryDocumentSnapshot[index];
                  var id_pemesanan = pemesanan.id;
                  return Container(
                    margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                    child: ListTile(
                      tileColor: Colors.amber,
                      minVerticalPadding: 10,
                      visualDensity: VisualDensity.adaptivePlatformDensity,
                      // leading: Image(image: NetworkImage(pemesanan['foto_url'])),
                      title: Text(pemesanan['id_produsen']),
                      subtitle: Column(
                        children: [
                          Text(id_pemesanan),
                          Text("${pemesanan['waktu']}"),
                          Text("${pemesanan['quantity']}"),
                          // Text("Stock: ${produk['stok']}"),
                          // Text("Harga: ${produk['harga']} / ${produk['satuan']}  telur")
                        ],
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                            title: const Text('Pemberitahuan'),
                            content: const Text('Pemesanan disetujui'),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () =>
                                    Navigator.pop(context, 'Tidak'),
                                child: const Text('Tidak'),
                              ),
                              TextButton(
                                onPressed: () {
                                  _pemesananList
                                      .doc(id_pemesanan)
                                      .update({'id_kondisi': 3});
                                  Navigator.pop(context, 'Ya');
                                },
                                child: Text('YA'),
                                // onPressed: () => Navigator.pop(context, 'Ya'),
                                // child: const Text('Ya'),
                              ),
                            ],
                          ),
                        );
                        // Navigator.push(context, MaterialPageRoute(builder: (context){
                        //   return PeternakDaftarProdukDetail(id_produk);
                        // }));
                      },
                    ),
                  );
                  // Text(produk['nama_produk']);
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
