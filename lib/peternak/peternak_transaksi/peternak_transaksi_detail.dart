import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:intl/intl.dart';
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

  _kondisiPengiriman(id_kondisi, id_pengiriman, alamat) {
    if(id_kondisi!=200){
      if (id_pengiriman == 100) {
        return Text(
            'Pesanan akan diambil oleh produsen telur asin di ${alamat}');
      }
      if (id_pengiriman == 200) {
        return Text('Peternak Mengirim barang ke alamat ${alamat}');
      }
    }
    else {
      return Text("");
    }
  }

  _buktiFoto(id_kondisi) {
    if (id_kondisi == 200) {
      return Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text('Belum ada bukti Pembayaran', style: TextStyle(fontWeight: FontWeight.w600),)),
            Container(
              width: double.infinity,
              height: 300,
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color.fromRGBO(255, 202, 167, 1)
              ),
              child: Icon(Icons.image, color: Colors.grey, size: 150,),
            )
            
          ],
        ),
      );

    } else if (id_kondisi == 400 || id_kondisi==500 ||id_kondisi==600) {
      return Container(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 10),
              child: Text('Bukti Transaksi', style: TextStyle(fontWeight: FontWeight.w600),)),
            Container(
              width: double.infinity,
              height: 300,
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color.fromRGBO(255, 202, 167, 1)
              ),
              child: Image(image: NetworkImage(pesanan['url_bukti_pembayaran'])),
            )
            
          ],
        ),
      );
    }
  }

  _AlertDetail(id_kondisi) {
    if (id_kondisi == 200) {
      return Text("Belum Dibayar");

    }
    else if (id_kondisi == 400) {
      return Text("Menunggu Konfirmasi Peternak");
    }
    else if (id_kondisi==500 ||id_kondisi==600) {
      return Text("Transfer Berhasil!");
    }
  }


  _konfirmasi(id_kondisi){
    if (id_kondisi == 400){
      return
      Container(
        width: double.infinity,
        child: Row(

          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ElevatedButton(
            //     onPressed: () {
            //       widget._referencePesanan
            //           .update({'id_kondisi': 600});
            //       Navigator.pop(context);
            //     },
            //     child: Text('Tolak Pembayaran')),
            Container(
              child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(225, 202, 167, 1), foregroundColor: Colors.black),
                  onPressed: () {
                    widget._referencePesanan
                        .update({
                          'id_kondisi': 500,
                          'waktu_pembayaran': DateTime.now()
                        });
                        // harus menambah datetime di database
                    Navigator.pushReplacement(context,
                        MaterialPageRoute(builder: (context) {
                      return _PeternakSplashScreenTransaksiDetailDone();
                    }));
                  },
                  child: Text('Setujui Pembayaran')),
            )
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
        backgroundColor: Color.fromRGBO(225, 202, 167, 1),
        title: Text('Detail Transaksi'),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 10, 0, 0),
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
                  // Container(
                  //   child: Column(
                  //     children: [
                  //       Text("ID Produsen Telur Asin"),
                  //       Text(pesanan['id_produsen']),
                  //     ],
                  //   ),
                  // ),

                  // Container(
                  //   child: Column(
                  //     children: [
                  //       Text("ID Peternak"),
                  //       Text(pesanan['id_peternak']),
                  //     ],
                  //   ),
                  // ),
                  SizedBox(
                    height: 10,
                  ),

                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    padding: EdgeInsets.all(10),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Transfer Rupiah'),
                        _AlertDetail(pesanan['id_kondisi']),
                        Text(DateFormat('dd MMMM yyyy, HH:mm:ss').format((pesanan['waktu_transaksi']as Timestamp).toDate())),
                        Text("No. Ref ${widget.pesananID}"),
                      ],
                    ),
                  ),

                  SizedBox(height: 15,),

                  Container(
                    margin: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    padding: EdgeInsets.all(10),
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total harga = Rp.${pesanan['total']}'),
                        Text('alamat kirim:'),
                        _kondisiPengiriman(pesanan['id_kondisi'], pesanan['id_pengiriman'], pesanan['alamat_kirim']),

                      ],
                    )
                  ),

                  SizedBox(height: 20,),

                  _buktiFoto(pesanan['id_kondisi']),

                  _konfirmasi(pesanan['id_kondisi'])
                
                ],
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}




class _PeternakSplashScreenTransaksiDetailDone extends StatefulWidget {
  const _PeternakSplashScreenTransaksiDetailDone({super.key});

  @override
  State<_PeternakSplashScreenTransaksiDetailDone> createState() => __PeternakSplashScreenTransaksiDetailDoneState();
}

class __PeternakSplashScreenTransaksiDetailDoneState extends State<_PeternakSplashScreenTransaksiDetailDone> {
  @override
  void initState(){
    super.initState();

    Timer(Duration(seconds: 1), () {
      Navigator.pop(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(225, 202, 167, 1),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, size: 200, color: Colors.white,),
              Text("TRANSAKSI BEERHASIL DI TAMBAHKAN", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
            ],
          ),
        ),
      ),
    );
  }
}