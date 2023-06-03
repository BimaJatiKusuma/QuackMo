import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quackmo/componen/splash_screen.dart';
import 'package:quackmo/produsen/transaksi/produsen_transaksi.dart';

class ProdusenPembayaranDetail extends StatefulWidget {
  ProdusenPembayaranDetail({
    required this.pesananID,
    required this.total,
    required this.alamat_kirim,
    required this.id_pengiriman,
    super.key
    }) {
      _referencePesanan = FirebaseFirestore.instance.collection('pemesanan').doc(pesananID);
    }
  
  final pesananID;
  final int total;
  final String alamat_kirim;
  final int id_pengiriman;
  late DocumentReference _referencePesanan;
  @override
  State<ProdusenPembayaranDetail> createState() => _ProdusenPembayaranDetailState();
}

class _ProdusenPembayaranDetailState extends State<ProdusenPembayaranDetail> {
  File? buktiFoto;
  String fotoPath = '';
  String fotoBuktiUrl = '';
  String _alertFoto = '';

  Future getImage() async {
    final ImagePicker foto = ImagePicker();
    final XFile? fotoBukti = await foto.pickImage(source: ImageSource.gallery);
    if (fotoBukti == null) return;
    fotoPath = fotoBukti.path;
    buktiFoto = File(fotoBukti.path);
    setState(() {});
  }

  Future uploadBuktiFoto() async {
    String uniqeFileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirFotoBukti = referenceRoot.child('foto_bukti');

    Reference referenceFotoBuktiUpload =
        referenceDirFotoBukti.child(uniqeFileName);

    try {
      await referenceFotoBuktiUpload.putFile(File(fotoPath));
      fotoBuktiUrl = await referenceFotoBuktiUpload.getDownloadURL();
    } catch (error) {
      print(error);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(225, 202, 167, 1),
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Detail Pembayaran"),
        centerTitle: true,
      ),
      body: Container(
        width: double.infinity,
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 20),
              child: Column(
                children: [
                  Text("Total Harga: Rp. ${widget.total}", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),)
                ],
              ),
            ),
            Container(
                    width: 300,
                    child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(225, 202, 167, 1),
                          foregroundColor: Colors.black
                        ),
                        onPressed: () async {
                          await getImage();
                        },
                        child: Text("Masukkan bukti pembayaran")),
                  ),
            SizedBox(height: 40,),
            Expanded(
              child: ListView(
                children: [
                  buktiFoto != null
                ? Container(
                    height: 350,
                    margin: EdgeInsets.all(20),
                    color: Color.fromRGBO(225, 202, 167, 1),
                    width:
                        (MediaQuery.of(context).size.width / 1.2),
                    child: Image.file(
                      buktiFoto!,
                      fit: BoxFit.fitWidth,
                    ))
                : Container(
                  margin: EdgeInsets.all(20),
                  child: Icon(Icons.image, size: 50,),
                  height: 200,
                  width: 200,
                  
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey,
                        spreadRadius: 1,
                        blurRadius: 10,
                      )
                    ]
                  ),
                ),
                SizedBox(height: 5,),
                Text(_alertFoto, style: TextStyle(color: Colors.red),),
                ],
              ),
            ),
            
            Container(
              margin: EdgeInsets.only(bottom: 30),
              width: 300,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(225, 202, 167, 1),
                  foregroundColor: Colors.black
                ),
                onPressed: () async {
                if(buktiFoto != null){
                  await uploadBuktiFoto();
                  await widget._referencePesanan.update({
                    'id_kondisi': 400,
                    'url_bukti_pembayaran': fotoBuktiUrl,
                    'waktu_transaksi': DateTime.now(),
                    'total': widget.total,
                    'alamat_kirim': widget.alamat_kirim,
                    'id_pengiriman': widget.id_pengiriman
                  });
                  Navigator.push(context, MaterialPageRoute(builder: (context){
                    return _ProdusenSplashScreenPembayaranDetail();
                  }));
                  
                }
              }, child: Text("Bayar")),
            )
          ],
        ),
      ),
    );
  }
}


class _ProdusenSplashScreenPembayaranDetail extends StatefulWidget {
  const _ProdusenSplashScreenPembayaranDetail({super.key});

  @override
  State<_ProdusenSplashScreenPembayaranDetail> createState() => __ProdusenSplashScreenPembayaranDetailState();
}

class __ProdusenSplashScreenPembayaranDetailState extends State<_ProdusenSplashScreenPembayaranDetail> {
@override
  void initState(){
    super.initState();

    Timer(Duration(seconds: 1), () {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {return ProdusenTransaksi();}), (route) => false);
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
              Text("'PEMBAYARAN BERHASIL,\nMENUNGGU KONFIRMASI PENJUAL'", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16), textAlign: TextAlign.center,),
            ],
          ),
        ),
      ),
    );
  }
}