import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quackmo/peternak/peternak_login.dart';

class PeternakDaftarProdukBuat extends StatefulWidget {
  const PeternakDaftarProdukBuat({super.key});

  @override
  State<PeternakDaftarProdukBuat> createState() =>
      _PeternakDaftarProdukBuatState();
}

class _PeternakDaftarProdukBuatState extends State<PeternakDaftarProdukBuat> {
  final _formkey = GlobalKey<FormState>();
  TextEditingController namaProdukController = TextEditingController();
  TextEditingController stokController = TextEditingController();
  TextEditingController hargaController = TextEditingController();
  TextEditingController satuanController = TextEditingController();
  TextEditingController keteranganController = TextEditingController();
  TextEditingController rekeningController = TextEditingController();
  TextEditingController danaController = TextEditingController();

  File? buktiFoto;

  Future getImage() async {
    final ImagePicker foto = ImagePicker();
    final XFile? fotoBukti = await foto.pickImage(source: ImageSource.gallery);
    buktiFoto = File(fotoBukti!.path);
    setState(() {});
  }



  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference peternak_produk = firestore.collection('produk');

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        title: Text("Tambah Produk"),
      ),
      body: ListView(
        children: [
          Form(
            key: _formkey,
            child: Column(
            children: [
              Text("$buktiFoto"),
              Container(
                child: Column(
                  children: [
                    buktiFoto != null
                        ? Container(
                            height: 500,
                            width: MediaQuery.of(context).size.width,
                            child: Image.file(
                              buktiFoto!,
                              fit: BoxFit.cover,
                            ))
                        : Container(),
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
              TextFormField(
                controller: namaProdukController,
                decoration: InputDecoration(label: Text("Nama Produk")),
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
                        label: Text("Harga (Rp.)")
                        ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: satuanController,
                      decoration: InputDecoration(label: Text("Satuan")),
                    ),
                  ),
                ],
              ),

              TextFormField(
                controller: keteranganController,
                decoration: InputDecoration(label: Text("Keterangan")),
              ),
              
              TextFormField(
                keyboardType: TextInputType.number,
                controller: rekeningController,
                decoration: InputDecoration(label: Text("No. Rekening")),
              ),

              TextFormField(
                keyboardType: TextInputType.number,
                controller: danaController,
                decoration: InputDecoration(label: Text("Dana")),
              ),

              ElevatedButton(onPressed: () async{
                await
                  peternak_produk.add({
                    'peternak_uid': userPeternakID,
                    'nama_produk': namaProdukController.text,
                    'stok': int.tryParse(stokController.text)??0,
                    'harga': int.tryParse(hargaController.text) ?? 0,
                    'satuan': int.tryParse(satuanController.text)??0,
                    'keterangan': keteranganController.text,
                    'no_rekening': int.tryParse(rekeningController.text)??0,
                    'dana':int.tryParse(danaController.text)??0
                });
                namaProdukController.text = '';
                stokController.text = '';
                hargaController.text= '';
                satuanController.text= '';
                keteranganController.text = '';
                rekeningController.text = '';
                danaController.text = '';

                Navigator.pop(context);

              }, child: Text("Tambahkan"))
            ],
            )
          
          ),
        ],
      ),
    );
  }
}
