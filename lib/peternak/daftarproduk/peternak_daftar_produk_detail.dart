import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quackmo/peternak/daftarproduk/peternak_daftar_produk_edit.dart';

class PeternakDaftarProdukDetail extends StatefulWidget {
  PeternakDaftarProdukDetail(this.produkID, {Key? key}) : super(key: key) {
    _reference = FirebaseFirestore.instance.collection('produk').doc(produkID);
    _futureData = _reference.get();
  }

  String produkID;
  late DocumentReference _reference;

  late Future<DocumentSnapshot> _futureData;
  late Map data;

  @override
  State<PeternakDaftarProdukDetail> createState() =>
      _PeternakDaftarProdukDetailState();
}

class _PeternakDaftarProdukDetailState
    extends State<PeternakDaftarProdukDetail> {
  late String imageUrl = widget.data['foto_url'];

  _deleteProduk() async {
    Reference referenceFotoProdukUpdate =
        FirebaseStorage.instance.refFromURL(imageUrl);
    try {
      //menyimpan file
      await referenceFotoProdukUpdate.delete();
      widget._reference.delete();
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(),
      ),
      body: FutureBuilder<DocumentSnapshot>(
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
              ],
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: Row(
        children: [
          ElevatedButton(
              onPressed: () {
                _deleteProduk();
                Navigator.pop(context);
              },
              child: Text('Hapus')),
          ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return PeternakDaftarProdukEdit(widget.produkID);
                }));
              },
              child: Text("Edit"))
        ],
      ),
    );
  }
}
