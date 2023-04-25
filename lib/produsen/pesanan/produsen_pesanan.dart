import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quackmo/produsen/produsen_homepage.dart';
import 'package:quackmo/produsen/produsen_login.dart';
import 'package:quackmo/produsen/produsen_pembayaran.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:quackmo/produsen/transaksi/produsen_transaksi.dart';

class ProdusenPesanan extends StatefulWidget {
  const ProdusenPesanan({super.key});

  @override
  State<ProdusenPesanan> createState() => _ProdusenPesananState();
}

class _ProdusenPesananState extends State<ProdusenPesanan> {
  CollectionReference _pemesananList =
      FirebaseFirestore.instance.collection('pemesanan');

  late Stream<QuerySnapshot> _streamPemesananList;
  List kondisi_produk = [1, 2, 3];

  void initState() {
    super.initState();
    _streamPemesananList = _pemesananList
        .where('id_produsen', isEqualTo: userProdusenID)
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

  _batalIcon(kondisi) {
    if (kondisi == 1) {
      return TextButton(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) => AlertDialog(
                title: const Text('Pemberitahuan'),
                content: const Text('Hapus pemesanan'),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Tidak'),
                    child: const Text('Tidak'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, 'Ya'),
                    child: const Text('Ya'),
                  ),
                ],
              ),
            );
          },
          child: Icon(Icons.delete));
    } else {
      return Text('');
    }
  }

  @override
  Widget build(BuildContext context) {
    _pemesananList.snapshots();
    return Scaffold(
        appBar: AppBar(
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
              List<QueryDocumentSnapshot> listQueryDocumentSnapshot =
                  querySnapshot.docs;

              return ListView.builder(
                itemCount: listQueryDocumentSnapshot.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot pemesanan =
                      listQueryDocumentSnapshot[index];
                  var id_pemesanan = pemesanan.id;
                  DateTime waktuDB = (pemesanan['waktu'] as Timestamp).toDate();
                  String formatWaktu =
                      DateFormat('dd/MM/yyyy, HH:mm').format(waktuDB);

                  return InkWell(
                      onTap: () {
                        if (pemesanan['id_kondisi']==3){
                          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                            return ProdusenTransaksi();
                          }));
                        }
                      },
                      child: Column(
                        children: [
                          Text(formatWaktu),
                          Card(
                            child: Row(children: [
                              Icon(Icons.square),
                              Column(
                                children: [
                                  Text('Telur Hibrida'),
                                  Text(
                                      'Pemesanan: ${pemesanan['quantity']} butir telur'),
                                  _textKondisi(pemesanan['id_kondisi'])
                                ],
                              ),
                              _batalIcon(pemesanan['id_kondisi'])
                            ]),
                          ),
                        ],
                      ));
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














// getNamaPeternak(peternakID) async {
//   var collectionPeternak = FirebaseFirestore.instance.collection('users');
//   var keteranganPeternak = await collectionPeternak.doc(peternakID).get();
//   if (keteranganPeternak.exists) {
//     Map<String, dynamic>? data = keteranganPeternak.data();
//     return data?['nama'];
//   }
// }




// return Stack(
//                     children: [
//                       StreamBuilder(
//                         stream: FirebaseFirestore.instance
//                             .collection('users')
//                             .doc(pemesanan['id_peternak'])
//                             .snapshots(),
//                         builder:
//                             (BuildContext context, AsyncSnapshot snapshot) {
//                           if (snapshot.hasError) {
//                             return Text(snapshot.error.toString());
//                           }
//                           if (snapshot.connectionState ==
//                               ConnectionState.active) {
//                             QuerySnapshot querySnapshot = snapshot.data;
//                             List<QueryDocumentSnapshot>
//                                 listQueryDocumentSnapshot = querySnapshot.docs;

//                               QueryDocumentSnapshot peternak = listQueryDocumentSnapshot[0];
//                             return InkWell(
//                                 onTap: () {},
//                                 child: Column(
//                                   children: [
//                                     Text('1 April 2023'),
//                                     Card(
//                                       child: Row(children: [
//                                         Icon(Icons.square),
//                                         Column(
//                                           children: [
//                                             Text('Telur Hibrida'),
//                                             Text(peternak['nama']),
//                                             Text('Pemesanan: 1 butir telur'),
//                                             Text(
//                                                 'Menunggu konfirmasi peternak (1x24 jam)')
//                                           ],
//                                         ),
//                                         TextButton(
//                                             onPressed: () {
//                                               showDialog(
//                                                 context: context,
//                                                 builder:
//                                                     (BuildContext context) =>
//                                                         AlertDialog(
//                                                   title: const Text(
//                                                       'Pemberitahuan'),
//                                                   content: const Text(
//                                                       'Hapus pemesanan'),
//                                                   actions: <Widget>[
//                                                     TextButton(
//                                                       onPressed: () =>
//                                                           Navigator.pop(
//                                                               context, 'Tidak'),
//                                                       child:
//                                                           const Text('Tidak'),
//                                                     ),
//                                                     TextButton(
//                                                       onPressed: () =>
//                                                           Navigator.pop(
//                                                               context, 'Ya'),
//                                                       child: const Text('Ya'),
//                                                     ),
//                                                   ],
//                                                 ),
//                                               );
//                                             },
//                                             child: Icon(Icons.delete)),
//                                       ]),
//                                     ),
//                                   ],
//                                 ));
//                           }

//                           return Center(
//                             child: CircularProgressIndicator(),
//                           );
//                         },
//                       )
//                     ],
//                   );















// 








// ListView(
//           children: [
//             Text("Semua Pemesanan"),
            
//             InkWell(
//                 onTap: () {},
//                 child: Column(
//                   children: [
//                     Text('1 April 2023'),
//                     Card(
//                       child: Row(children: [
//                         Icon(Icons.square),
//                         Column(
//                           children: [
//                             Text('Telur Hibrida'),
//                             Text('PT. Jaya Abadi'),
//                             Text('Pemesanan: 1 butir telur'),
//                             Text('Menunggu konfirmasi peternak (1x24 jam)')
//                           ],
//                         ),
//                         TextButton(
//                             onPressed: () {
//                               showDialog(
//                                 context: context,
//                                 builder: (BuildContext context) => AlertDialog(
//                                   title: const Text('Pemberitahuan'),
//                                   content: const Text('Hapus pemesanan'),
//                                   actions: <Widget>[
//                                     TextButton(
//                                       onPressed: () =>
//                                           Navigator.pop(context, 'Tidak'),
//                                       child: const Text('Tidak'),
//                                     ),
//                                     TextButton(
//                                       onPressed: () =>
//                                           Navigator.pop(context, 'Ya'),
//                                       child: const Text('Ya'),
//                                     ),
//                                   ],
//                                 ),
//                               );
//                             },
//                             child: Icon(Icons.delete)),
//                       ]),
//                     ),
//                   ],
//                 )),


//                 InkWell(
//                 onTap: () {
//                   Navigator.push(context, MaterialPageRoute(builder: (context){
//                     return ProdusenPembayaran();
//                   }));
//                 },
//                 child: Column(
//                   children: [
//                     Text('30 Maret 2023'),
//                     Card(
//                       child: Row(children: [
//                         Icon(Icons.square),
//                         Column(
//                           children: [
//                             Text('Telur Hibrida'),
//                             Text('PT. Jaya Abadi'),
//                             Text('Pemesanan: 1 butir telur'),
//                             Text('Menunggu Pembayaran')
//                           ],
//                         ),

//                       ]),
//                     ),
//                   ],
//                 )),
//           ],
//         ));