import 'dart:async';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quackmo/peternak/aduan/peternak_aduan.dart';
import 'package:quackmo/peternak/daftarproduk/peternak_daftar_produk_buat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quackmo/peternak/daftarproduk/peternak_daftar_produk_edit.dart';
import 'package:quackmo/peternak/peternak_login.dart';

class PeternakDaftarProduk extends StatefulWidget {
  const PeternakDaftarProduk({super.key});

  @override
  State<PeternakDaftarProduk> createState() => _PeternakDaftarProdukState();
}

class _PeternakDaftarProdukState extends State<PeternakDaftarProduk> {
  CollectionReference _produkList = FirebaseFirestore.instance.collection('produk');
  late Stream<QuerySnapshot> _streamProdukList;

  void initState() {
    // TODO: implement initState
    super.initState();
    _streamProdukList = _produkList
        .where('peternak_uid', isEqualTo: userPeternakID).where('deleted_at', isEqualTo: '')
        .snapshots();
  }

  _deleteProduk(id_produk, foto_url) async {
    Reference referenceFotoProdukUpdate =
        FirebaseStorage.instance.refFromURL(foto_url);
    try {
      // await referenceFotoProdukUpdate.delete();
      _produkList.doc(id_produk).update({'deleted_at':DateTime.now().toString()});
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    _produkList.snapshots();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        centerTitle: true,
        title: Text("DAFTAR PRODUK"),
        leading: BackButton(),
        backgroundColor: Color.fromRGBO(225, 202, 167, 1),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(0, 20, 0, 50),
        child: StreamBuilder(
          stream: _streamProdukList,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasError) {
              return Text(snapshot.error.toString());
            }
            if (snapshot.connectionState == ConnectionState.active) {
              QuerySnapshot querySnapshot = snapshot.data;
              List<QueryDocumentSnapshot> listQueryDocumentSnapshot =
                  querySnapshot.docs;
              return ListView.builder(
                itemCount: listQueryDocumentSnapshot.length,
                itemBuilder: (context, index) {
                  QueryDocumentSnapshot produk =
                      listQueryDocumentSnapshot[index];
                  var id_produk = produk.id;
                  return InkWell(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return PeternakAduan(idProduk: id_produk);
                      }));
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(225, 202, 167, 1),
                      ),
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                      child: Row(
                        children: [
                          Container(
                            width: 100,
                            height: 100,
                            child: Image(
                                image: NetworkImage(produk['foto_url']),
                                fit: BoxFit.contain),
                          ),
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(produk['nama_produk'], textAlign: TextAlign.justify, style: TextStyle(fontWeight: FontWeight.w600),),
                                  Text("Stock: ${produk['stok']}"),
                                  Text("Harga: ${produk['harga']} / ${produk['satuan']}  telur"),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                          onPressed: () {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Container(color: Color.fromRGBO(225, 202, 167, 1), child: Text('Pemberitahuan', textAlign: TextAlign.center,)),
                                                  content: Text('Hapus Produk ?', textAlign: TextAlign.center,),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      style: TextButton.styleFrom(
                                                        foregroundColor: Colors.black
                                                      ),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                      child: const Text('Tidak'),
                                                    ),
                                                    TextButton(
                                                      style: ElevatedButton.styleFrom(
                                                        backgroundColor: Color.fromRGBO(225, 202, 167, 1),
                                                        foregroundColor: Colors.black
                                                      ),
                                                      onPressed: () async {
                                                        await _deleteProduk(id_produk, produk['foto_url']);
                                                        Navigator.push(context, MaterialPageRoute(builder: (context){
                                                          return _PeternakSplashScreenDaftarProdukHapus();
                                                        }));
                                                      },
                                                      child: Text('Ya'),
                                                    ),
                                                  ],
                                                );
                                              }
                                              );
                                      
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black
                                          ),
                                          child: Text('Hapus')),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(context,
                                                MaterialPageRoute(
                                                    builder: (context) {
                                              return PeternakDaftarProdukEdit(
                                                  id_produk);
                                            }));
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black
                                          ),
                                          child: Text("Edit"))
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) {
            return PeternakDaftarProdukBuat();
          }));
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(225, 202, 167, 1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}


class _PeternakSplashScreenDaftarProdukHapus extends StatefulWidget {
  const _PeternakSplashScreenDaftarProdukHapus({super.key});

  @override
  State<_PeternakSplashScreenDaftarProdukHapus> createState() => __PeternakSplashScreenDaftarProdukHapusState();
}

class __PeternakSplashScreenDaftarProdukHapusState extends State<_PeternakSplashScreenDaftarProdukHapus> {
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
              Text("PRODUK BERHASIL DI HAPUS", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
            ],
          ),
        ),
      ),
    );
  }
}