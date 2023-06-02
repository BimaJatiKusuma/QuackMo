import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quackmo/produsen/produsen_login.dart';

class ProdusenPremium extends StatefulWidget {
  final idProdusen;
  const ProdusenPremium({
    required this.idProdusen,
    super.key
    });

  @override
  State<ProdusenPremium> createState() => _ProdusenPremiumState();
}

class _ProdusenPremiumState extends State<ProdusenPremium> {
  bool terbayar = false;
  _konfirmasi(){
    return showDialog(
      context: context,
              builder: (_){
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  titlePadding: EdgeInsets.zero,
                  backgroundColor: Color.fromRGBO(250, 250, 250, 1),
                  title: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                      color: Color.fromRGBO(225, 202, 167, 1),
                    ),
                    alignment: Alignment.center,
                    height: 30,
                    child: Text("Pemberitahuan", textAlign: TextAlign.center,),
                  ),
                  content: Text("Lanjutkan Pembayaran ?", textAlign: TextAlign.center,),
                  actions: [
                    ElevatedButton(onPressed: (){
                      Navigator.pop(context);
                    }, child: Text("Tidak"), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),),
                    ElevatedButton(onPressed: (){
                      
                      FirebaseFirestore.instance.collection('users').doc(widget.idProdusen).update({
                        'premium':"y"
                      }).then((value){
                        FirebaseFirestore.instance.collection('users').doc(widget.idProdusen).get().then((value){
                            premiumProdusen = value.get('premium');
                            terbayar = true;
                            setState(() {});
                            Navigator.pop(context);
                            return Navigator.pop(context);
                        });
                      });
                    }, child: Text("Ya"), style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(225, 207, 167, 1), foregroundColor: Colors.black),)
                  ],
                  actionsAlignment: MainAxisAlignment.spaceAround,
                );
              }
            );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menuju Premium"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(225, 202, 167, 1),
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey,
                    spreadRadius: 1,
                    blurRadius: 2,
                      )
                    ],
                borderRadius: BorderRadius.circular(15)
              ),
              child: ListView(
                children: [
                  Text("Cara Pembayaran Akun Premium", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16), textAlign: TextAlign.center,),
                  SizedBox(height: 20,),
                  Text("Rp. 109.000", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800), textAlign: TextAlign.center,),
                  SizedBox(height: 20,),
                  Text("Pembayaran Melalui Transfer Rekening Mandiri", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                  Text(
                    "1. Masukkan kartu ATM dan PIN ATM\n"+
                    "2. Pilih menu Bayar/Beli\n"+
                    "3. Pilih opsi Lainnya > Multipayment\n"+
                    "4. Masukkan kode perusahaan: 23456\n"+
                    "5. Masukkan nomor Virtual account > Benar\n"+
                    "6. Cek data pemesanan, jika sesuai tekan Benar\n"+
                    "7. Transaksi berhasil\n", style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
          ),
          Container(
            height: 75,
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(225, 202, 167, 1),
                    foregroundColor: Colors.black
                  ),
                  onPressed: (){
                  Navigator.pop(context);
                }, child: Text("Batal")),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(225, 202, 167, 1),
                    foregroundColor: Colors.black
                  ),
                  onPressed: (){
                    _konfirmasi();
                  
                  // print(premium);
                }, child: Text("Bayar")),
              ],
            ),
          )
        ],
      ),
    );
  }
}

