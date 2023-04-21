import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PeternakDaftarProdukDetail extends StatefulWidget {
  PeternakDaftarProdukDetail(this.produkID, {Key? key}) : super(key:key) {
    _reference = FirebaseFirestore.instance.collection('produk').doc(produkID);
    _futureData = _reference.get();
  }

  String produkID;
  late DocumentReference _reference;

  late Future<DocumentSnapshot> _futureData;
  late Map data;

  @override
  State<PeternakDaftarProdukDetail> createState() => _PeternakDaftarProdukDetailState();
}

class _PeternakDaftarProdukDetailState extends State<PeternakDaftarProdukDetail> {
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<DocumentSnapshot>(
        future: widget._futureData,
        builder: (context, snapshot) {
          
          if (snapshot.hasError){
            return Center(child: Text('Terjadi Error ${snapshot.hasError}'));
          }
          if (snapshot.hasData){
            DocumentSnapshot? documentSnapshot = snapshot.data;
            widget.data = documentSnapshot!.data() as Map;
            
            return Column(
              children: [
                Text("${widget.data}")
              ],
            );
          }

          return Center(child: CircularProgressIndicator(),);
        },

      )
    );
  }
}