import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
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

  File? produkFoto;
  String fotoProduk1='';
  String imageUrl = '';

  Future getImage() async {
    final ImagePicker foto = ImagePicker();
    final XFile? fotoProduk = await foto.pickImage(source: ImageSource.gallery);
    fotoProduk1 = fotoProduk!.path;
    produkFoto = File(fotoProduk!.path);
    
    if(produkFoto==null) return;
    
    setState(() {});

  }

Future uploadImage() async{
    String uniqeFileName = DateTime.now().millisecondsSinceEpoch.toString();
    //Reference ke storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirFotoProduk = referenceRoot.child('foto_produk');

    //Membuat reference untuk foto yang akan diupload
    Reference referenceFotoProdukUpload = referenceDirFotoProduk.child(uniqeFileName);

    try{
    //menyimpan file
    await referenceFotoProdukUpload.putFile(File(fotoProduk1));
    //success
    imageUrl = await referenceFotoProdukUpload.getDownloadURL();
    }
    catch(error){
      print(error);
    }

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
              Text("$produkFoto"),
              Container(
                child: Column(
                  children: [
                    produkFoto != null
                        ? Container(
                            height: 500,
                            width: MediaQuery.of(context).size.width,
                            child: Image.file(
                              produkFoto!,
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
              Text(imageUrl),
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
                  uploadImage();
                  peternak_produk.add({
                    'peternak_uid': userPeternakID,
                    'nama_produk': namaProdukController.text,
                    'stok': int.tryParse(stokController.text)??0,
                    'harga': int.tryParse(hargaController.text) ?? 0,
                    'satuan': int.tryParse(satuanController.text)??0,
                    'keterangan': keteranganController.text,
                    'no_rekening': int.tryParse(rekeningController.text)??0,
                    'dana':int.tryParse(danaController.text)??0,
                    'foto_url':imageUrl,
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
