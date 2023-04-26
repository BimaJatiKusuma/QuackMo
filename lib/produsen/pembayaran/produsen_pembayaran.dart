import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quackmo/produsen/produsen_login.dart';
import 'package:quackmo/produsen/transaksi/produsen_transaksi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

enum SingingCharacter { lafayette, jefferson }

class ProdusenPembayaran extends StatefulWidget {
  ProdusenPembayaran(this.pesananID) {
    _referencePesanan = FirebaseFirestore.instance.collection('pemesanan').doc(pesananID);
    _futureData1 = _referencePesanan.get();
  }

  String pesananID;
  late DocumentReference _referencePesanan;
  late Future<DocumentSnapshot> _futureData1;
  late Map dataPesanan;

  @override
  State<ProdusenPembayaran> createState() => _ProdusenPembayaranState();
}

enum MetodeKirim { Diantar, TidakDiantar }

enum MetodeBayar { Dana, BankMandiri, PembayaranDitempat }



class _ProdusenPembayaranState extends State<ProdusenPembayaran> {
  final formKey = GlobalKey<FormState>();
  String alamat = "";
  MetodeKirim? _metodeKirim = MetodeKirim.Diantar;
  MetodeBayar? _metodeBayar = MetodeBayar.Dana;

  File? buktiFoto;
  String fotoPath = '';
  String fotoBuktiUrl = '';

  Future getImage() async {
    final ImagePicker foto = ImagePicker();
    final XFile? fotoBukti = await foto.pickImage(source: ImageSource.gallery);
    fotoPath = fotoBukti!.path;
    buktiFoto = File(fotoBukti.path);
    if (buktiFoto == null) return;
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

  String id_peternak = '';
  late String id_produk = '';
  late int hargaProduk = 0;
  int quantity = 0;
  late String namaProduk='';
  // String id_transaksi='';
  
  Future getDataPesanan() async {
    var dataPesanan = FirebaseFirestore.instance
        .collection('produk')
        .doc(widget.pesananID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        setState(() {
          id_produk = documentSnapshot.get('id_produk');
          hargaProduk = documentSnapshot.get('total');
        });

        // var dataProduk = FirebaseFirestore.instance
        //     .collection('produk')
        //     .doc(id_produk)
        //     .get()
        //     .then((DocumentSnapshot documentSnapshot) {
        //   setState(() {
        //     namaProduk = documentSnapshot.get('nama_produk');
        //   });
        // });
      }
    });
  }


  TextEditingController alamat_kirimController = TextEditingController();
  _alamatPengiriman(x) {
    if (x == MetodeKirim.Diantar) {
      alamat_kirimController.text = '';
      return Container(
        child: Form(
            key: formKey,
            child: TextFormField(
              controller: alamat_kirimController,
              decoration: InputDecoration(
                  prefixIcon: Padding(
                    padding: EdgeInsets.all(2),
                    child: Icon(Icons.location_on),
                  ),
                  hintText: 'masukkan alamat anda'),
            )),
      );
    } else if (x == MetodeKirim.TidakDiantar) {
      alamat_kirimController.text = 'ini alamat peternak';
      return Container(
        child: Text('Ini alamat peternak'),
      );
    }
  }
  
  // Future getDataProduk(ProdukID) async {
  //   var dataProduk = FirebaseFirestore.instance
  //       .collection('produk')
  //       .doc(ProdukID)
  //       .get()
  //       .then((DocumentSnapshot documentSnapshot) {
  //     setState(() {
  //       hargaProduk = documentSnapshot.get('harga');
  //     });
  //   });
  // }

  
  NumberFormat formatter =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 2);
  @override
  void initState() {
    super.initState();
    getDataPesanan();
  }

  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    // CollectionReference transaksiCollection = firestore.collection('transaksi');
    CollectionReference pemesananCollection = firestore.collection('pemesanan');

    // getDataProduk(id_produk);

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Pembayaran"),
        // backgroundColor: Colors.deepOrangeAccent,
      ),
      body: Container(
        child: FutureBuilder<DocumentSnapshot>(
          future: widget._futureData1,
          builder: (context, snapshot){
            if (snapshot.hasError){
              return Center(child: Text('Terjadi Error ${snapshot.hasError}'));
            }
            if (snapshot.hasData){
              DocumentSnapshot? documentSnapshot = snapshot.data;
              widget.dataPesanan = documentSnapshot!.data() as Map;
              return ListView(
                children: [
                  Text(widget.dataPesanan['id_produk'])
                ],
              );
            }
            return CircularProgressIndicator();
          }
          
          
        ),
      ),
    );
  }
}











// child: ListView(
//             children: [
//               Container(
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     Text(id_peternak),
//                     Text(id_produk),
//                     Text('harga produk = ${formatter.format(hargaProduk)}'),
//                     Text(alamat),
//                     Text(
//                       "Metode Pengiriman",
//                       style: TextStyle(fontSize: 18),
//                     ),
//                     // Divider(),
//                     RadioListTile(
//                       title: Text("Diantar"),
//                       value: MetodeKirim.Diantar,
//                       groupValue: _metodeKirim,
//                       onChanged: (MetodeKirim? value) {
//                         setState(() {
//                           _metodeKirim = value;
//                         });
//                       },
//                     ),
//                     RadioListTile(
//                       title: Text("Diambil Sendiri"),
//                       value: MetodeKirim.TidakDiantar,
//                       groupValue: _metodeKirim,
//                       onChanged: (MetodeKirim? value) {
//                         setState(() {
//                           _metodeKirim = value;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               // Text(widget.pesananID),
//               // Text('${widget._futureData1}'),
              
//               _alamatPengiriman(_metodeKirim),
              
//               Container(
//                 padding: EdgeInsets.all(20),
//                 child: Column(
//                   children: [
//                     Text(
//                       "Metode Pembayaran",
//                       style: TextStyle(fontSize: 18),
//                     ),
//                     // Divider(),
//                     RadioListTile(
//                       title: Text("Dana"),
//                       value: MetodeBayar.Dana,
//                       groupValue: _metodeBayar,
//                       onChanged: (MetodeBayar? value) {
//                         setState(() {
//                           _metodeBayar = value;
//                         });
//                       },
//                     ),
//                     RadioListTile(
//                       title: Text("Bank Mandiri"),
//                       value: MetodeBayar.BankMandiri,
//                       groupValue: _metodeBayar,
//                       onChanged: (MetodeBayar? value) {
//                         setState(() {
//                           _metodeBayar = value;
//                         });
//                       },
//                     ),
              
//                     RadioListTile(
//                       title: Text("Dibayar Ditempat"),
//                       value: MetodeBayar.PembayaranDitempat,
//                       groupValue: _metodeBayar,
//                       onChanged: (MetodeBayar? value) {
//                         setState(() {
//                           _metodeBayar = value;
//                         });
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//               Container(
//                 child: Column(
//                   children: [
//                     // Text(id_produk),
//                     // Text(namaProduk),
//                     Text("Harga: 30.000"),
//                     Text("Ongkos Kirim"),
//                     Text("Total Pembayaran: Rp. 35.000")
//                   ],
//                 ),
//               ),
//               Container(
//                 child: Column(
//                   children: [
//                     ElevatedButton(
//                         onPressed: () async {
//                           await getImage();
//                         },
//                         child: Text("Masukkan bukti pembayaran")),
//                     buktiFoto != null
//                         ? Container(
//                             height: 500,
//                             width: MediaQuery.of(context).size.width,
//                             child: Image.file(
//                               buktiFoto!,
//                               fit: BoxFit.cover,
//                             ))
//                         : Container(),
//                   ],
//                 ),
//               ),
//               ElevatedButton(
//                   onPressed: () async {
//                     CircularProgressIndicator();
//                     await uploadBuktiFoto();
//                     await widget._referencePesanan.update({
//                       'id_kondisi':4,
//                       'url_bukti_pembayaran': fotoBuktiUrl,
//                       'waktu_transaksi': DateTime.now(),
//                       'total': hargaProduk,
//                       'alamat_kirim': alamat_kirimController.text,
//                       'id_produsen':userProdusenID,
//                       'id_peternak': id_peternak
//                     });
//                     // .then((DocumentReference doc) async{
//                     //   FirebaseFirestore.instance.collection('pemesanan').doc(widget.pesananID).update({'id_transaksi':doc.id});
//                     // });
//                     // Navigator.pushReplacement(context,
//                     //     MaterialPageRoute(builder: (context) {
//                     //   return ProdusenTransaksi();
//                     // }));
//                   },
//                   child: Text("Bayar"))
//             ],
//           ),