import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:quackmo/produsen/pembayaran/produsen_pembayaran.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quackmo/produsen/produsen_homepage.dart';

import '../produsen_login.dart';

class ProdusenTransaksi extends StatefulWidget {
  const ProdusenTransaksi({super.key});

  @override
  State<ProdusenTransaksi> createState() => _ProdusenTransaksiState();
}

class _ProdusenTransaksiState extends State<ProdusenTransaksi> {
CollectionReference _pemesananList =
      FirebaseFirestore.instance.collection('pemesanan');

  late Stream<QuerySnapshot> _streamPemesananList;
  List kondisi_produk = [400,500,600];

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
    if (kondisi == 400) {
      return Text("menunggu konfirmasi peternak 1x24 jam");
    }
    else if (kondisi == 500) {
      return Text("Pembayaran Disetujui", style: TextStyle(color: Color.fromRGBO(111, 219, 122, 1)),);
    }
    else if (kondisi == 600) {
      return Text("Pembayaran Ditolak");
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
              if(listQueryDocumentSnapshot.length>=2){
                listQueryDocumentSnapshot.sort((a,b)=> a['id_kondisi'].compareTo(b['id_kondisi']));
              }
              // print(listQueryDocumentSnapshot);
              // print(querySnapshot);
              // print(listQueryDocumentSnapshot[1]);

              return ListView.builder(
                itemCount: listQueryDocumentSnapshot.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot pemesanan =
                      listQueryDocumentSnapshot[index];
                      print(index);
                      print(pemesanan);
                  var id_pemesanan = pemesanan.id;
                  DateTime waktuDB = (pemesanan['waktu_transaksi'] as Timestamp).toDate();
                  String formatWaktu =
                      DateFormat('dd LLLL yyyy').format(waktuDB);

                  return InkWell(
                onTap: () {},
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(formatWaktu),
                      Card(
                        color: Colors.grey[200],
                        child: Row(
                          children: [
                            Container(
                              width: 25,
                              child: Image(image: AssetImage('images/transaksi_02.png'))),
                            Container(
                              width: 225,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Pemesanan: ${pemesanan['quantity']} butir telur'),
                                  _textKondisi(pemesanan['id_kondisi'])
                                ],
                              ),
                            ),
                          Expanded(child: Text("- Rp. ${pemesanan['total']}"))
                        ]),
                      ),
                    ],
                  ),
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








// class ProdusenTransaksi extends StatelessWidget {
//   const ProdusenTransaksi({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//           leading: BackButton(
//             onPressed: () {
//               Navigator.pop(context);
//             },
//           ),
//           title: Title(color: Colors.indigo, child: Text("Status Transaksi")),
//         ),
//         body: ListView(
//           children: [
//             Text("Semua Transaksi"),
            
//             InkWell(
//                 onTap: () {},
//                 child: Column(
//                   children: [
//                     Text('1 April 2023'),
//                     Card(
//                       child: Row(children: [
//                         Image(image: AssetImage('images/transaksi_02.png')),
//                         Column(
//                           children: [
//                             Text('Telur Hibrida'),
//                             Text('PT. Jaya Abadi'),
//                             Text('Pemesanan: 1 butir telur'),
//                             Text('Menunggu Verifikasi Peternak')
//                           ],
//                         ),
//                         Text("- Rp. 20.000")
//                       ]),
//                     ),
//                   ],
//                 )),


//                 InkWell(
//                 onTap: () {},
//                 child: Column(
//                   children: [
//                     Text('30 Maret 2023'),
//                     Card(
//                       child: Row(children: [
//                         Image(image: AssetImage('images/transaksi_02.png')),
//                         Column(
//                           children: [
//                             Text('Telur Hibrida'),
//                             Text('PT. Jaya Abadi'),
//                             Text('Pemesanan: 1 butir telur'),
//                             Text('Pembayaran Ditolak')
//                           ],
//                         ),
//                         Text("- Rp. 20.000"),
//                       ]),
//                     ),
//                   ],
//                 )),



//                 InkWell(
//                 onTap: () {
//                   // Navigator.push(context, MaterialPageRoute(builder: (context){
//                   //   return ProdusenPembayaran();
//                   // }));
//                 },
//                 child: Column(
//                   children: [
//                     Text('30 Maret 2023'),
//                     Card(
//                       child: Row(children: [
//                         Image(image: AssetImage('images/transaksi_02.png')),
//                         Column(
//                           children: [
//                             Text('Telur Hibrida'),
//                             Text('PT. Jaya Abadi'),
//                             Text('Pemesanan: 1 butir telur'),
//                             Text('Berhasil, Menunggu Pengiriman')
//                           ],
//                         ),
//                         Text("- Rp. 20.000"),
//                       ]),
//                     ),
//                   ],
//                 )),
//           ],
//         ));
//   }
// }