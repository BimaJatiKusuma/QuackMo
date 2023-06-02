import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:quackmo/produsen/pembayaran/produsen_pembayaran_detail.dart';
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

  late DocumentReference _referenceProduk;
  late Future<DocumentSnapshot> _futureData2;
  late Map dataProduk;

  @override
  State<ProdusenPembayaran> createState() => _ProdusenPembayaranState();
}

enum MetodeKirim { Diantar, TidakDiantar }

// enum MetodeBayar { Dana, BankMandiri, PembayaranDitempat }

class _ProdusenPembayaranState extends State<ProdusenPembayaran> {
  final _formKey = GlobalKey<FormState>();
  MetodeKirim? _metodeKirim = MetodeKirim.Diantar;

  // File? buktiFoto;
  // String fotoPath = '';
  // String fotoBuktiUrl = '';
  // String _alertFoto = '';
  int id_pengiriman = 0;
  String _alertAlamat = '';

  // Future getImage() async {
  //   final ImagePicker foto = ImagePicker();
  //   final XFile? fotoBukti = await foto.pickImage(source: ImageSource.gallery);
  //   if (fotoBukti == null) return;
  //   fotoPath = fotoBukti.path;
  //   buktiFoto = File(fotoBukti.path);
  //   setState(() {});
  // }

  // Future uploadBuktiFoto() async {
  //   String uniqeFileName = DateTime.now().millisecondsSinceEpoch.toString();
  //   Reference referenceRoot = FirebaseStorage.instance.ref();
  //   Reference referenceDirFotoBukti = referenceRoot.child('foto_bukti');

  //   Reference referenceFotoBuktiUpload =
  //       referenceDirFotoBukti.child(uniqeFileName);

  //   try {
  //     await referenceFotoBuktiUpload.putFile(File(fotoPath));
  //     fotoBuktiUrl = await referenceFotoBuktiUpload.getDownloadURL();
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  TextEditingController alamat_kirimController = TextEditingController();

  _alamatPengiriman(x) {
    if (x == MetodeKirim.Diantar) {
      id_pengiriman = 200;
      return Container(
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: TextFormField(
                  controller: alamat_kirimController,
                  validator: (value) {
                    if (value!.isEmpty || value.length == 0){
                      return "Alamat kirim harus diisi";
                    }
                    return null;
                  },
                  onSaved:(newValue) {
                    alamat_kirimController.text = newValue!;
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color:  Colors.grey)
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(Icons.location_on),
                    ),
                    hintText: 'masukkan alamat anda'),
                )),
            Text(_alertAlamat)
          ],
        ),
      );
    } else if (x == MetodeKirim.TidakDiantar) {
      alamat_kirimController.text = '${widget.dataProduk['alamat']}';
      id_pengiriman = 100;
      return
      Container(
        child: Column(
          children: [
            Form(
                key: _formKey,
                child: TextFormField(
                  readOnly: true,
                  controller: alamat_kirimController,
                  validator: (value) {
                    if (value!.isEmpty || value.length == 0){
                      return "Alamat kirim harus diisi";
                    }
                    return null;
                  },
                  onSaved:(newValue) {
                    alamat_kirimController.text = newValue!;
                  },
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey)
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color:  Colors.grey)
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.all(2),
                      child: Icon(Icons.location_on),
                    ),
                    hintText: 'masukkan alamat anda'),
                )),
            Text(_alertAlamat)
          ],
        ),
      );
      // Container(
      //   padding: EdgeInsets.fromLTRB(0,5,5,5),
      //   decoration: BoxDecoration(
      //     border: Border.all(),
      //     borderRadius: BorderRadius.circular(5)
      //   ),
      //   child: Table(
      //     columnWidths: {
      //       0: FlexColumnWidth(1),
      //       1: FlexColumnWidth(5)
      //     },
      //     children: [
      //       TableRow(
      //         children: [
      //           TableCell(
      //             verticalAlignment: TableCellVerticalAlignment.middle,
      //             child: Icon(Icons.location_on),
      //           ),
      //           Container(
      //             child: Column(
      //               crossAxisAlignment: CrossAxisAlignment.start,
      //               children: [
      //               Text("Dapat diambil di"),
      //               Text(widget.dataProduk['alamat'])
      //               ],
      //             ),
      //           )
      //         ]
      //       )
      //     ],
      //   )
      // );
    }
  }

  NumberFormat formatter = NumberFormat.currency(locale: 'id', symbol: 'Rp. ', decimalDigits: 2);

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
        title: Text("Pembayaran"),
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
                      return Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height,
                        margin: EdgeInsets.all(20),
                        child: ListView(
                          children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                child: Container(
                                  padding: EdgeInsets.all(20),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey,
                                      blurRadius: 5
                                    )
                                  ]
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${widget.dataProduk["nama_produk"]}"),
                                    Text("Jumlah: ${widget.dataPesanan["quantity"]}"),
                                    Text('harga produk total adalah ${formatter.format(widget.dataPesanan['total'])}'),
                                  ],
                                ),
                                                          ),
                              ),
                            Container(
                                    padding: EdgeInsets.all(20),
                                    child: Column(
                                      children: [
                                        Text(
                                          "Metode Pengiriman",
                                          style: TextStyle(fontSize: 18),
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(10),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 5
                                              )
                                            ]
                                          ),                                  
                                          child: Column(
                                            children: [
                                              RadioListTile(
                                                title: Text("Diantar"),
                                                value: MetodeKirim.Diantar,
                                                groupValue: _metodeKirim,
                                                onChanged: (MetodeKirim? value) {
                                                  alamat_kirimController.text ='';
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
                                                  alamat_kirimController.text ='';
                                                  setState(() {
                                                    _metodeKirim = value;
                                                  });
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 20,),
                                        _alamatPengiriman(_metodeKirim),
                                      ],
                                    ),
                                  ),
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
                                  
                                  ListMetodePembayaran(namaMetode: "Bank Mandiri", nomorTujuan: "${widget.dataProduk['bank_mandiri']}", namaPenerima: "${widget.dataProduk['bank_mandiri_penerima']}"),
                                  ListMetodePembayaran(namaMetode: "Bank BRI", nomorTujuan: "${widget.dataProduk['bank_bri']}", namaPenerima: "${widget.dataProduk['bank_bri_penerima']}"),
                                  ListMetodePembayaran(namaMetode: "DANA", nomorTujuan: "${widget.dataProduk['dana']}", namaPenerima: "${widget.dataProduk['dana_penerima']}"),
                                  ListMetodePembayaran(namaMetode: "${widget.dataProduk['bank_lainnya_namabank']}", nomorTujuan: "${widget.dataProduk['bank_lainnya']}", namaPenerima: "${widget.dataProduk['bank_lainnya_penerima']}"),
                                ],
                              ),
                            ),
                            // Container(
                            //   child: Column(
                            //     children: [
                            //       ElevatedButton(
                            //           style: ElevatedButton.styleFrom(
                            //             backgroundColor: Color.fromRGBO(225, 202, 167, 1),
                            //             foregroundColor: Colors.black
                            //           ),
                            //           onPressed: () async {
                            //             await getImage();
                            //           },
                            //           child: Text("Masukkan bukti pembayaran")),
                            //       buktiFoto != null
                            //     ? Container(
                            //         height: 500,
                            //         color: Color.fromRGBO(225, 202, 167, 1),
                            //         width:
                            //             (MediaQuery.of(context).size.width / 1.2),
                            //         child: Image.file(
                            //           buktiFoto!,
                            //           fit: BoxFit.fitWidth,
                            //         ))
                            //     : Container(
                            //       child: Icon(Icons.image, size: 50,),
                            //       height: 200,
                            //       width: 200,
                                  
                            //       decoration: BoxDecoration(
                            //         color: Colors.white,
                            //         borderRadius: BorderRadius.circular(10),
                            //         boxShadow: [
                            //           BoxShadow(
                            //             color: Colors.grey,
                            //             spreadRadius: 1,
                            //             blurRadius: 10,
                            //           )
                            //         ]
                            //       ),
                            //     ),
                            //     SizedBox(height: 5,),
                            //     Text(_alertFoto, style: TextStyle(color: Colors.red),),
                            //     ],
                            //   ),
                            // ),
                            SizedBox(height: 40,),
                            ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color.fromRGBO(225, 202, 167, 1),
                                  foregroundColor: Colors.black
                                ),
                                onPressed: () async {
                                  print(_formKey.currentState!.validate());
                                  if(_formKey.currentState!.validate()){
                                  print(_formKey.currentState!.validate());
                                    // if(buktiFoto != null){
                                    //   await uploadBuktiFoto();
                                    //   await widget._referencePesanan.update({
                                    //     'id_kondisi': 400,
                                    //     'url_bukti_pembayaran': fotoBuktiUrl,
                                    //     'waktu_transaksi': DateTime.now(),
                                    //     'total': widget.dataPesanan['total'],
                                    //     'alamat_kirim': alamat_kirimController.text,
                                    //     'id_pengiriman': id_pengiriman
                                    //   });
                                    //   Navigator.pushReplacement(context,
                                    //       MaterialPageRoute(builder: (context) {
                                    //     return ProdusenTransaksi();
                                    //   }));
                                    // }
                                    // else {
                                    //   setState(() {
                                    //     _alertFoto = "Bukti foto harus diisi!";
                                    //   });
                                    // }
                                     Navigator.push(context, MaterialPageRoute(builder: (context){
                                        return ProdusenPembayaranDetail(pesananID: widget.pesananID, total: widget.dataPesanan['total'], alamat_kirim: alamat_kirimController.text, id_pengiriman: id_pengiriman);
                                      }));
                                  }
                                },
                                child: Text("Detail Pembayaran"))
                          ],
                        ),
                      );
                    }
                    return Center(child: CircularProgressIndicator());
                  },
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }
}





class ListMetodePembayaran extends StatelessWidget {
  const ListMetodePembayaran({
    super.key,
    required this.namaMetode,
    required this.nomorTujuan,
    required this.namaPenerima,
  });

  final String namaMetode;
  final String nomorTujuan;
  final String namaPenerima;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 5
          )
        ]
      ),
      width: double.infinity,
      margin: EdgeInsets.fromLTRB(0, 10, 0, 10),
      padding: EdgeInsets.fromLTRB(10, 10, 10, 10),
      child: Table(
        columnWidths: {
          0: FlexColumnWidth(2),
          1: FlexColumnWidth(3)
        },
        children: [
          TableRow(
            children: [
              Text("Metode"),
              Text(": ${namaMetode}")
            ]
          ),
          TableRow(
            children: [
              Text("Nomor Tujuan"),
              Text(": ${nomorTujuan}")
            ]
          ),
          TableRow(
            children: [
              Text("Penerima"),
              Text(": ${namaPenerima}")
            ]
          )
        ],
      )

    );
  }
}