import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quackmo/peternak/daftarproduk/peternak_daftar_produk.dart';
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
  TextEditingController alamatController = TextEditingController();
  TextEditingController danaController = TextEditingController();
  TextEditingController danaNamaController = TextEditingController();
  TextEditingController mandiriController = TextEditingController();
  TextEditingController mandiriNamaController = TextEditingController();
  TextEditingController briController = TextEditingController();
  TextEditingController briNamaController = TextEditingController();
  TextEditingController bankLainNamaBankController = TextEditingController();
  TextEditingController bankLainController = TextEditingController();
  TextEditingController bankLainNamaController = TextEditingController();

  File? produkFoto;
  String fotoProduk1 = '';
  String imageUrl = '';

  Future getImage() async {
    final ImagePicker foto = ImagePicker();
    final XFile? fotoProduk = await foto.pickImage(source: ImageSource.gallery);
    if (fotoProduk == null) return;
    
    fotoProduk1 = fotoProduk.path;
    produkFoto = File(fotoProduk.path);


    setState(() {});
  }

    Future getImage2() async {
    final ImagePicker foto = ImagePicker();
    final XFile? fotoProduk = await foto.pickImage(source: ImageSource.camera);
    if (fotoProduk == null) return;

    fotoProduk1 = fotoProduk.path;
    produkFoto = File(fotoProduk.path);



    setState(() {});
  }

  Future uploadImage() async {
    String uniqeFileName = DateTime.now().millisecondsSinceEpoch.toString();
    //Reference ke storage root
    Reference referenceRoot = FirebaseStorage.instance.ref();
    Reference referenceDirFotoProduk = referenceRoot.child('foto_produk');

    //Membuat reference untuk foto yang akan diupload
    Reference referenceFotoProdukUpload =
        referenceDirFotoProduk.child(uniqeFileName);

    try {
      //menyimpan file
      await referenceFotoProdukUpload.putFile(File(fotoProduk1));
      //success
      imageUrl = await referenceFotoProdukUpload.getDownloadURL();
    } catch (error) {
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
        backgroundColor: Color.fromRGBO(225, 202, 167, 1),
        title: Text("Tambah Produk"),
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.fromLTRB(10, 0, 10, 20),
            child: Form(
                key: _formkey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    Container(
                      child: Column(
                        children: [
                          produkFoto != null
                              ? Container(
                                  height: 500,
                                  color: Color.fromRGBO(225, 202, 167, 1),
                                  width:
                                      (MediaQuery.of(context).size.width / 1.2),
                                  child: Image.file(
                                    produkFoto!,
                                    fit: BoxFit.fitWidth,
                                  ))
                              : Container(
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
                          Container(
                            decoration: BoxDecoration(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(onPressed: () async{await getImage2();}, icon: Icon(Icons.add_a_photo),),
                                IconButton(onPressed: () async{await getImage();}, icon: Icon(Icons.image_search))
                                
                              ],
                            ),
                          ),
                          
                        ],
                      ),
                    ),
                    // Text(imageUrl),
          
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: namaProdukController,
                      decoration: InputDecoration(
                        label: Text("Nama Produk"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
          
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.number,
                      controller: stokController,
                      decoration: InputDecoration(
                        label: Text("stok"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
          
                    SizedBox(
                      height: 10,
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
                              label: Text("Harga (Rp.)"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 5,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: satuanController,
                            decoration: InputDecoration(
                              label: Text("Satuan"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
          
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: alamatController,
                      decoration: InputDecoration(
                        label: Text("Alamat"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
          
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: keteranganController,
                      decoration: InputDecoration(
                        label: Text("Keterangan"),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
          
                    SizedBox(
                      height: 20,
                    ),
                    Text('isi minimal salah satu metode pembayaran'),
                    SizedBox(
                      height: 10,
                    ),
                    //Mandiri
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 5,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: mandiriController,
                            decoration: InputDecoration(
                              label: Text("No. Rekening Bank Mandiri"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 5,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: mandiriNamaController,
                            decoration: InputDecoration(
                              label: Text("Atas Nama"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //BRI
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 5,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: briController,
                            decoration: InputDecoration(
                              label: Text("No. Rekening Bank BRI"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 5,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: briNamaController,
                            decoration: InputDecoration(
                              label: Text("Atas Nama"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    //Dana
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 5,
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            controller: danaController,
                            decoration: InputDecoration(
                              label: Text("Nomor Aplikasi Dana"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 5,
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            controller: danaNamaController,
                            decoration: InputDecoration(
                              label: Text("Atas Nama"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                        ),
                      ],
                    ),
          
                    SizedBox(
                      height: 20,
                    ),
                    Text('Isi jika memiliki metode pembayaran lain'),
                    SizedBox(
                      height: 10,
                    ),
                    //Bank Lain
                    Container(
                      child: Column(
                        children: [
                          TextFormField(
                            controller: bankLainNamaBankController,
                            decoration: InputDecoration(
                              label: Text("Nama Bank Lain"),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10)),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 5,
                                child: TextFormField(
                                  keyboardType: TextInputType.number,
                                  controller: bankLainController,
                                  decoration: InputDecoration(
                                    label: Text("No. Rekening"),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 5,
                                child: TextFormField(
                                  keyboardType: TextInputType.text,
                                  controller: bankLainNamaController,
                                  decoration: InputDecoration(
                                    label: Text("Atas Nama"),
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
          
          
                    SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(225, 202, 167, 1), foregroundColor: Colors.black),
                          onPressed: () async {
                            await uploadImage();
                            peternak_produk.add({
                              'peternak_uid': userPeternakID,
                              'nama_produk': namaProdukController.text,
                              'stok': int.tryParse(stokController.text) ?? 0,
                              'harga': int.tryParse(hargaController.text) ?? 0,
                              'satuan': int.tryParse(satuanController.text) ?? 0,
                              'alamat': alamatController.text,
                              'keterangan': keteranganController.text,
                              'dana': danaController.text,
                              'dana_penerima': danaNamaController.text,
                              'bank_mandiri': mandiriController.text,
                              'bank_mandiri_penerima': mandiriNamaController.text,
                              'bank_bri': briController.text,
                              'bank_bri_penerima': briNamaController.text,
                              'bank_lainnya': bankLainController.text,
                              'bank_lainnya_namabank':bankLainNamaBankController.text,
                              'bank_lainnya_penerima': bankLainNamaController.text,
                              'foto_url': imageUrl,
                            });
                            namaProdukController.text = '';
                            stokController.text = '';
                            hargaController.text = '';
                            satuanController.text = '';
                            alamatController.text = '';
                            keteranganController.text = '';
                            danaController.text = '';
                            danaNamaController.text = '';
                            mandiriController.text = '';
                            mandiriNamaController.text = '';
                            briController.text = '';
                            briNamaController.text = '';
                            bankLainController.text = '';
                            bankLainNamaController.text = '';
                            bankLainNamaBankController.text = '';
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                              return _PeternakSplashScreenDaftarProdukBuat();
                            }));
                          },
                          child: Text("Tambahkan", style: TextStyle(fontWeight: FontWeight.w600),)),
                    ),
          
                    SizedBox(
                      height: 20,
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}


class _PeternakSplashScreenDaftarProdukBuat extends StatefulWidget {
  const _PeternakSplashScreenDaftarProdukBuat({super.key});

  @override
  State<_PeternakSplashScreenDaftarProdukBuat> createState() => __PeternakSplashScreenDaftarProdukBuatState();
}

class __PeternakSplashScreenDaftarProdukBuatState extends State<_PeternakSplashScreenDaftarProdukBuat> {
   @override
  void initState(){
    super.initState();

    Timer(Duration(seconds: 1), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
        return PeternakDaftarProduk();
      }));
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
              Text("PRODUK BERHASIL DI TAMBAHKAN", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
            ],
          ),
        ),
      ),
    );
  }
}