import 'dart:async';
import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quackmo/componen/form.dart';
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

  String alertImage = "";

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    CollectionReference peternak_produk = firestore.collection('produk');

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
        backgroundColor: Color.fromRGBO(225, 202, 167, 1),
        title: Text("Tambah Produk"),
        centerTitle: true,
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
                                child: Icon(Icons.image, size: 23, color: Color.fromRGBO(186, 186, 186, 1),),
                                height: 70,
                                width: 70,
                                
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
                          Text(alertImage, style: TextStyle(color: Colors.red),),
                          Container(
                            decoration: BoxDecoration(),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(onPressed: () async{await getImage2();}, icon: Icon(Icons.add_a_photo,  color: Color.fromRGBO(186, 186, 186, 1),),),
                                IconButton(onPressed: () async{await getImage();}, icon: Icon(Icons.image_search,  color: Color.fromRGBO(186, 186, 186, 1),))
                                
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
                    FormGroup(stringNamaLabel: "Nama Produk", controllerNama: namaProdukController, keyboardType: TextInputType.text),
                    SizedBox(height: 10,),
                    FormGroup(stringNamaLabel: "Stok", controllerNama: stokController, keyboardType: TextInputType.number),
                    SizedBox(height: 10,),
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 5,
                          child: FormGroup(stringNamaLabel: "Harga (Rp.)", controllerNama: hargaController, keyboardType: TextInputType.number)
                        ),
                        SizedBox(width: 10),
                        Expanded(
                          flex: 5,
                          child: FormGroup(stringNamaLabel: "Satuan", controllerNama: satuanController, keyboardType: TextInputType.number)
                        ),
                      ],
                    ),
                    SizedBox(height: 10,),
                    FormGroup(stringNamaLabel: "Alamat", controllerNama: alamatController, keyboardType: TextInputType.text),
                    SizedBox(height: 10,),
                    FormGroup(stringNamaLabel: "Keterangan", controllerNama: keteranganController, keyboardType: TextInputType.text),
                              
                    SizedBox(
                      height: 20,
                    ),
                    Text('isi minimal salah satu metode pembayaran', style: TextStyle(color: Color.fromRGBO(164, 119, 50, 1))),
                    SizedBox(
                      height: 10,
                    ),
                    
                    Row(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Expanded(
                          flex: 5,
                          child: FormGroup(stringNamaLabel: "No. Rekening Bank Mandiri", controllerNama: mandiriController, keyboardType: TextInputType.number, optionalAnswer: true,)
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 5,
                          child: FormGroup(stringNamaLabel: "Atas Nama", controllerNama: mandiriNamaController, keyboardType: TextInputType.name, optionalAnswer: true)
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
                          child: FormGroup(stringNamaLabel: "No. Rekening Bank BRI", controllerNama: briController, keyboardType: TextInputType.number, optionalAnswer: true)
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 5,
                          child: FormGroup(stringNamaLabel: "Atas Nama", controllerNama: briNamaController, keyboardType: TextInputType.name, optionalAnswer: true)
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
                          child: FormGroup(stringNamaLabel: "Nomor Aplikasi Dana", controllerNama: danaController, keyboardType: TextInputType.number, optionalAnswer: true)
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          flex: 5,
                          child: FormGroup(stringNamaLabel: "Atas Nama", controllerNama: danaNamaController, keyboardType: TextInputType.number, optionalAnswer: true)
                        ),
                      ],
                    ),
          
                    SizedBox(
                      height: 20,
                    ),
                    Text('Isi jika memiliki metode pembayaran lain', style: TextStyle(color: Color.fromRGBO(164, 119, 50, 1)),),
                    SizedBox(
                      height: 10,
                    ),
                    //Bank Lain
                    Container(
                      child: Column(
                        children: [
                          FormGroup(stringNamaLabel: "Nama Bank Lain", controllerNama: bankLainNamaBankController, keyboardType: TextInputType.text, optionalAnswer: true),
                          SizedBox(
                            height: 10,
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            children: [
                              Expanded(
                                flex: 5,
                                child: FormGroup(stringNamaLabel: "No. Rekening", controllerNama: bankLainController, keyboardType: TextInputType.number, optionalAnswer: true)                                
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(
                                flex: 5,
                                child: FormGroup(stringNamaLabel: "Atas Nama", controllerNama: bankLainNamaController, keyboardType: TextInputType.name, optionalAnswer: true)
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
                            if(_formkey.currentState!.validate()){
                              if(produkFoto != null){
                                await uploadImage();
                                peternak_produk.add({
                                  'peternak_uid': userPeternakID,
                                  'nama_produk': namaProdukController.text,
                                  'stok': int.tryParse(stokController.text),
                                  'harga': int.tryParse(hargaController.text),
                                  'satuan': int.tryParse(satuanController.text),
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
                              }
                              else {
                                setState(() {
                                  alertImage = "foto produk harus diisi";
                                });
                              }
                            }
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