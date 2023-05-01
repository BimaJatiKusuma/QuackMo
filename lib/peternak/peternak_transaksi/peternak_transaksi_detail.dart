import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
import 'package:quackmo/peternak/peternak_transaksi/peternak_transaksi_detail_done.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PeternakTransaksiDetail extends StatefulWidget {
  PeternakTransaksiDetail(this.pesananID) {
    _referencePesanan =
        FirebaseFirestore.instance.collection('pemesanan').doc(pesananID);
    _futureDataPesanan = _referencePesanan.get();
  }
  String pesananID;
  late DocumentReference _referencePesanan;
  late Future<DocumentSnapshot> _futureDataPesanan;
  late Map dataPesanan;

  @override
  State<PeternakTransaksiDetail> createState() =>
      _PeternakTransaksiDetailState();
}

class _PeternakTransaksiDetailState extends State<PeternakTransaksiDetail> {
  late Map pesanan = widget.dataPesanan;

  _kondisiPengiriman(id_pengiriman, alamat) {
    if (id_pengiriman == 100) {
      return Text(
          'Pesanan akan diambil oleh produsen telur asin di  (alamat peternak) : ${alamat}');
    }
    if (id_pengiriman == 200) {
      return Text('Peternak Mengirim barang ke alamat ${alamat}');
    }
  }

  _buktiFoto(id_kondisi) {
    if (id_kondisi == 3) {
      return Container(
        child: Column(
          children: [
            Text('Belum ada Bukti Pembayaran'),
          ],
        ),
      );
    } else if (id_kondisi == 4 || id_kondisi==5 ||id_kondisi==6) {
      return Container(
        child: Column(
          children: [
            Text('Bukti Transaksi'),
            Image(image: NetworkImage(pesanan['url_bukti_pembayaran'])),
          ],
        ),
      );
    }
  }

  _konfirmasi(id_kondisi){
    if (id_kondisi == 4){
      return
      Container(
        child: Row(
          children: [
            ElevatedButton(
                onPressed: () {
                  widget._referencePesanan
                      .update({'id_kondisi': 5});
                  Navigator.pop(context);
                },
                child: Text('Tolak Pembayaran')),
            ElevatedButton(
                onPressed: () {
                  widget._referencePesanan
                      .update({'id_kondisi': 6});
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) {
                    return PeternakTransaksiDetailDone();
                  }));
                },
                child: Text('Setujui Pembayaran'))
          ],
        ),
      );
    }

    else {return SizedBox();};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail Transaksi'),
      ),
      body: Container(
        child: FutureBuilder<DocumentSnapshot>(
          future: widget._futureDataPesanan,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Terjadi error ${snapshot.hasError}'),
              );
            }
            if (snapshot.hasData) {
              DocumentSnapshot? documentSnapshotPesanan = snapshot.data;
              widget.dataPesanan = documentSnapshotPesanan!.data() as Map;

              return ListView(
                children: [

                  Container(
                    child: Column(
                      children: [
                        Text("ID Produsen Telur Asin"),
                        Text(pesanan['id_produsen']),
                      ],
                    ),
                  ),

                  Container(
                    child: Column(
                      children: [
                        Text("ID Peternak"),
                        Text(pesanan['id_peternak']),
                      ],
                    ),
                  ),

                  Container(
                    child: _kondisiPengiriman(
                        pesanan['id_pengiriman'], pesanan['alamat_kirim']),
                  ),

                  SizedBox(
                    height: 20,
                  ),

                  Container(
                    child: Column(
                      children: [
                        Text('Detail Transaksi'),
                        Text(DateFormat('dd/MM/yy, HH:mm').format((pesanan['waktu_transaksi']as Timestamp).toDate())),
                        Text('${pesanan['total']}')
                      ],
                    ),
                  ),

                  _buktiFoto(pesanan['id_kondisi']),

                  _konfirmasi(pesanan['id_kondisi'])
                
                ],
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}



























// class PeternakTransaksiDetail extends StatelessWidget {
//   const PeternakTransaksiDetail({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: BackButton(
//           onPressed: (){
//             Navigator.pop(context);
//           },
//         ),
//         title: Text('Detail Transaksi'),
//       ),
//       body: Column(
//         children: [
//           Container(
//             child: Column(
//               children: [
//                 Text('Transfer Rupiah'),
//                 Text('Transfer Berhasil!'),
//                 Text('30 April 2023 - 23:16:04 - No. Ref 193243453857')
//               ],
//             ),
//           ),
//           Container(
//             child: Column(
//               children: [
//                 Text('Penerima'),
//                 Text('Farlin Nurjananti'),
//                 Text('Bank Mandiri - 2433539556669')
//               ],
//             ),
//           ),
//           Container(
//             child: Column(
//               children: [
//                 Text('Detail Transaksi'),
//                 Row(
//                   children: [
//                     Column(
//                       children: [
//                         Text("Metode Transfer"),
//                         Text("Total Transaksi")
//                       ],
//                     ),
//                     Column(
//                       children: [
//                         Text('Sesama Bank Mandiri'),
//                         Text('Rp. 20.000')
//                       ],
//                     )
//                   ],
//                 )
//               ],
//             ),
//           ),

//           Container(
//             child: Column(
//               children: [
//                 Text('Bukti Transaksi'),
//                 Image(image: AssetImage('images/bukti_transaksi.png')),
//                 ElevatedButton(onPressed: (){
//                   Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
//                     return PeternakTransaksiDetailDone();
//                   }));
//                 }, child: Text('Setujui Pembayaran'))
//               ],
//             ),
//           )
//         ],
//       ),
//     );
//   }
// }