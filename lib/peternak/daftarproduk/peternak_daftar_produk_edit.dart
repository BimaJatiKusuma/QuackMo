import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class PeternakDaftarProdukEdit extends StatefulWidget {
  PeternakDaftarProdukEdit(this.produkID, {Key? key}) : super(key: key) {
    _reference = FirebaseFirestore.instance.collection('produk').doc(produkID);
    _futureData = _reference.get();
  }

  String produkID;
  late DocumentReference _reference;

  late Future<DocumentSnapshot> _futureData;
  late Map data;

  @override
  State<PeternakDaftarProdukEdit> createState() =>
      _PeternakDaftarProdukEditState();
}

class _PeternakDaftarProdukEditState extends State<PeternakDaftarProdukEdit> {
  final _formkey = GlobalKey<FormState>();
  late TextEditingController namaProdukController = TextEditingController(text: widget.data['nama_produk']);
  late TextEditingController stokController = TextEditingController(text: widget.data['stok'].toString());
  late TextEditingController hargaController = TextEditingController(text: widget.data['harga'].toString());
  late TextEditingController satuanController = TextEditingController(text: widget.data['satuan'].toString());
  late TextEditingController keteranganController = TextEditingController(text: widget.data['keterangan']);
  late TextEditingController rekeningController = TextEditingController(text: widget.data['no_rekening'].toString());
  late TextEditingController danaController = TextEditingController(text: widget.data['dana'].toString());

  File? produkFoto;
  String fotoProduk1 = '';
  late String imageUrl = widget.data['foto_url'];

  Future getImage() async {
    final ImagePicker foto = ImagePicker();
    final XFile? fotoProduk = await foto.pickImage(source: ImageSource.gallery);
    fotoProduk1 = fotoProduk!.path;
    produkFoto = File(fotoProduk.path);

    if (produkFoto == null) return;

    setState(() {});
  }

  Future updateImage() async {
    String uniqeFileName = DateTime.now().millisecondsSinceEpoch.toString();
    //Reference ke storage root
    // Reference referenceRoot = FirebaseStorage.instance.ref();
    // Reference referenceDirFotoProduk = referenceRoot.child('foto_produk');

    // //Membuat reference untuk foto yang akan diupload
    // Reference referenceFotoProdukUpload =
    //     referenceDirFotoProduk.child(uniqeFileName);

    Reference referenceFotoProdukUpdate = FirebaseStorage.instance.refFromURL(imageUrl);

    try {
      //menyimpan file
      await referenceFotoProdukUpdate.putFile(File(fotoProduk1));
      //success
      imageUrl = await referenceFotoProdukUpdate.getDownloadURL();
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ListView(
          children: [
            FutureBuilder<DocumentSnapshot>(
              future: widget._futureData,
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Terjadi Error ${snapshot.hasError}'));
                }
                if (snapshot.hasData) {
                  DocumentSnapshot? documentSnapshot = snapshot.data;
                  widget.data = documentSnapshot!.data() as Map;

                  return Column(
                    children: [
                      Text("${widget.data}"),
                      Text(widget.produkID),
                      Form(
                          key: _formkey,
                          child: Column(
                            children: [
                              Text("$produkFoto"),
                              Container(
                                child: Column(
                                  children: [
                                    produkFoto != null
                                        ? Container(
                                            height: 500,
                                            width:
                                                MediaQuery.of(context).size.width,
                                            child: Image.file(
                                              produkFoto!,
                                              fit: BoxFit.cover,
                                            ))
                                        : Container(
                                          height: 500,
                                            width:
                                                MediaQuery.of(context).size.width,
                                            child: Image.network(imageUrl,
                                              fit: BoxFit.cover,)
                                        ),
                                    Container(
                                      decoration: BoxDecoration(
                                          // image: NetworkImage(),
                                          ),
                                    ),
                                    ElevatedButton(
                                        onPressed: () async {
                                          await getImage();
                                        },
                                        child: Text("Masukkan Foto Produk")),
                                  ],
                                ),
                              ),
                              Text(imageUrl),
                              TextFormField(
                                controller: namaProdukController,
                                decoration:
                                    InputDecoration(label: Text("Nama Produk")),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: stokController,
                                decoration: InputDecoration(label: Text("stok")),
                              ),
                              Row(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Expanded(
                                    flex: 5,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: hargaController,
                                      decoration: InputDecoration(
                                          label: Text("Harga (Rp.)")),
                                    ),
                                  ),
                                  Expanded(
                                    flex: 5,
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      controller: satuanController,
                                      decoration:
                                          InputDecoration(label: Text("Satuan")),
                                    ),
                                  ),
                                ],
                              ),
                              TextFormField(
                                controller: keteranganController,
                                decoration:
                                    InputDecoration(label: Text("Keterangan")),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: rekeningController,
                                decoration:
                                    InputDecoration(label: Text("No. Rekening")),
                              ),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                controller: danaController,
                                decoration: InputDecoration(label: Text("Dana")),
                              ),
                              ElevatedButton(
                                  onPressed: () async {
                                    await updateImage();
                                    widget._reference.update({
                                      // 'peternak_uid': widget.userPeternakID,
                                      'nama_produk': namaProdukController.text,
                                      'stok':
                                          int.tryParse(stokController.text) ?? 0,
                                      'harga':
                                          int.tryParse(hargaController.text) ?? 0,
                                      'satuan':
                                          int.tryParse(satuanController.text) ?? 0,
                                      'keterangan': keteranganController.text,
                                      // 'no_rekening':
                                      //     int.tryParse(rekeningController.text) ??
                                      //         0,
                                      'dana':
                                          int.tryParse(danaController.text) ?? 0,
                                      'foto_url': imageUrl,
                                    });
                                    namaProdukController.text = '';
                                    stokController.text = '';
                                    hargaController.text = '';
                                    satuanController.text = '';
                                    keteranganController.text = '';
                                    rekeningController.text = '';
                                    danaController.text = '';

                                    Navigator.pop(context);
                                  },
                                  child: Text("Simpan Perubahan"))
                            ],
                          )),
                    ],
                  );
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          ],
        ),
        // floatingActionButton: ElevatedButton(
        //     onPressed: () async {
        //       await uploadImage();
        //       widget._reference.update({
        //         // 'peternak_uid': widget.userPeternakID,
        //         'nama_produk': namaProdukController.text,
        //         'stok': int.tryParse(stokController.text) ?? 0,
        //         'harga': int.tryParse(hargaController.text) ?? 0,
        //         'satuan': int.tryParse(satuanController.text) ?? 0,
        //         'keterangan': keteranganController.text,
        //         'no_rekening': int.tryParse(rekeningController.text) ?? 0,
        //         'dana': int.tryParse(danaController.text) ?? 0,
        //         'foto_url': imageUrl,
        //       });
        //       namaProdukController.text = '';
        //       stokController.text = '';
        //       hargaController.text = '';
        //       satuanController.text = '';
        //       keteranganController.text = '';
        //       rekeningController.text = '';
        //       danaController.text = '';

        //       Navigator.pop(context);
        //     },
        //     child: Text("Simpan Perubahan"))
      );
  }
}
