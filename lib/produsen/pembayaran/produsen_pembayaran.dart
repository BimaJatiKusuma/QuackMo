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
    _referencePesanan =
        FirebaseFirestore.instance.collection('pemesanan').doc(pesananID);
    _futureData1 = _referencePesanan.get();
  }

  String pesananID;
  late DocumentReference _referencePesanan;
  late Future<DocumentSnapshot> _futureData1;
  late Map dataPesanan;

  late DocumentReference _referenceProduk;
  late Future<DocumentSnapshot> _futureData2;
  late Map dataProduk;

  @override
  State<ProdusenPembayaran> createState() => _ProdusenPembayaranState();
}

enum MetodeKirim { Diantar, TidakDiantar }

// enum MetodeBayar { Dana, BankMandiri, PembayaranDitempat }

class _ProdusenPembayaranState extends State<ProdusenPembayaran> {
  final formKey = GlobalKey<FormState>();
  String alamat = "";
  MetodeKirim? _metodeKirim = MetodeKirim.Diantar;
  // MetodeBayar? _metodeBayar = MetodeBayar.Dana;

  File? buktiFoto;
  String fotoPath = '';
  String fotoBuktiUrl = '';
  int id_pengiriman = 0;

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

  TextEditingController alamat_kirimController = TextEditingController();

  _alamatPengiriman(x) {
    if (x == MetodeKirim.Diantar) {
      id_pengiriman = 200;
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
      alamat_kirimController.text = '${widget.dataProduk['alamat']}';
      id_pengiriman = 100;
      return Container(
        child: Text(widget.dataProduk['alamat']),
      );
    }
  }

  NumberFormat formatter =
      NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 2);

  @override
  Widget build(BuildContext context) {
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
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                    child: Text('Terjadi Error ${snapshot.hasError}'));
              }
              if (snapshot.hasData) {
                DocumentSnapshot? documentSnapshot = snapshot.data;
                widget.dataPesanan = documentSnapshot!.data() as Map;

                widget._referenceProduk = FirebaseFirestore.instance
                    .collection('produk')
                    .doc(widget.dataPesanan['id_produk']);
                widget._futureData2 = widget._referenceProduk.get();

                return FutureBuilder(
                  future: widget._futureData2,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(
                          child: Text('Terjadi Error ${snapshot.hasError}'));
                    }
                    if (snapshot.hasData) {
                      DocumentSnapshot? documentSnapshot2 = snapshot.data;
                      widget.dataProduk = documentSnapshot2!.data() as Map;
                      return ListView(
                        children: [
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                    'harga produk total adalah ${formatter.format(widget.dataPesanan['total'])}'),
                                Text(alamat),
                                Text(
                                  "Metode Pengiriman",
                                  style: TextStyle(fontSize: 18),
                                ),
                                // Divider(),
                                RadioListTile(
                                  title: Text("Diantar"),
                                  value: MetodeKirim.Diantar,
                                  groupValue: _metodeKirim,
                                  onChanged: (MetodeKirim? value) {
                                    setState(() {
                                      _metodeKirim = value;
                                    });
                                  },
                                ),
                                RadioListTile(
                                  title: Text("Diambil Sendiri"),
                                  value: MetodeKirim.TidakDiantar,
                                  groupValue: _metodeKirim,
                                  onChanged: (MetodeKirim? value) {
                                    setState(() {
                                      _metodeKirim = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ),
                          _alamatPengiriman(_metodeKirim),
                          Container(
                            padding: EdgeInsets.all(20),
                            child: Column(
                              children: [
                                Text(
                                  "Metode Pembayaran",
                                  style: TextStyle(fontSize: 18),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                //mandiri
                                Container(
                                  child: Column(
                                    children: [
                                      Text('Bank Mandiri'),
                                      Text(
                                          '${widget.dataProduk['bank_mandiri']} atas nama ${widget.dataProduk['bank_mandiri_penerima']}'),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                //bri
                                Container(
                                  child: Column(
                                    children: [
                                      Text('Bank BRI'),
                                      Text(
                                          '${widget.dataProduk['bank_bri']} atas nama ${widget.dataProduk['bank_bri_penerima']}'),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  child: Column(
                                    children: [
                                      Text('DANA'),
                                      Text(
                                          '${widget.dataProduk['dana']} atas nama ${widget.dataProduk['dana_penerima']}'),
                                    ],
                                  ),
                                ),

                                SizedBox(
                                  height: 20,
                                ),

                                Container(
                                  child: Column(
                                    children: [
                                      Text(widget
                                          .dataProduk['bank_lainnya_namabank']),
                                      Text(
                                          '${widget.dataProduk['bank_lainnya']} atas nama ${widget.dataProduk['bank_lainnya_penerima']}'),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                          Container(
                            child: Column(
                              children: [
                                ElevatedButton(
                                    onPressed: () async {
                                      await getImage();
                                    },
                                    child: Text("Masukkan bukti pembayaran")),
                                buktiFoto != null
                                    ? Container(
                                        height: 500,
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Image.file(
                                          buktiFoto!,
                                          fit: BoxFit.cover,
                                        ))
                                    : Container(),
                              ],
                            ),
                          ),
                          ElevatedButton(
                              onPressed: () async {
                                CircularProgressIndicator();
                                await uploadBuktiFoto();
                                await widget._referencePesanan.update({
                                  'id_kondisi': 4,
                                  'url_bukti_pembayaran': fotoBuktiUrl,
                                  'waktu_transaksi': DateTime.now(),
                                  'total': widget.dataPesanan['total'],
                                  'alamat_kirim': alamat_kirimController.text,
                                  'id_pengiriman': id_pengiriman
                                });
                                Navigator.pushReplacement(context,
                                    MaterialPageRoute(builder: (context) {
                                  return ProdusenTransaksi();
                                }));
                              },
                              child: Text("Bayar"))
                        ],
                      );
                    }
                    return CircularProgressIndicator();
                  },
                );
              }
              return CircularProgressIndicator();
            }),
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