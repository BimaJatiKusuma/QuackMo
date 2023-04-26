
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quackmo/peternak/daftarproduk/peternak_daftar_produk_buat.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quackmo/peternak/daftarproduk/peternak_daftar_produk_detail.dart';
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
    _streamProdukList = _produkList.where('peternak_uid', isEqualTo: userPeternakID).snapshots();
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
        backgroundColor: Color.fromRGBO(225,202,167,1),
      ),
      body: 
          Container(
            padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
            child: StreamBuilder(
              stream: _streamProdukList,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasError){
                  return Text(snapshot.error.toString());
                }
                if(snapshot.connectionState==ConnectionState.active){
                  QuerySnapshot querySnapshot = snapshot.data;
                  List<QueryDocumentSnapshot> listQueryDocumentSnapshot = querySnapshot.docs;
          
                  return ListView.builder(
                    itemCount: listQueryDocumentSnapshot.length,
                    itemBuilder:(context, index) {
                      QueryDocumentSnapshot produk=listQueryDocumentSnapshot[index];
                      var id_produk = produk.id;
                      return Container(
                        height: 100,
                        margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                        child: ListTile(
                          tileColor: Color.fromRGBO(225,202,167,1),
                          minVerticalPadding: 10,
                          visualDensity: VisualDensity.adaptivePlatformDensity,
                          leading: Image(image: NetworkImage(produk['foto_url'])),
                          title: Text(produk['nama_produk']),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(id_produk),
                              // Text("${produk['peternak_uid']}"),
                              Text("Stock: ${produk['stok']}"),
                              Text("Harga: ${produk['harga']} / ${produk['satuan']}  telur")
                            ],
                          ),
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context){
                              return PeternakDaftarProdukDetail(id_produk);
                            }));
                          },
                        ),
                      );
                      // Text(produk['nama_produk']);
                    },
                  );
                }
                return Center(child: CircularProgressIndicator(),);
              },
            ),
          ),
       
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context){
            return PeternakDaftarProdukBuat();
          }));
        },
        child: Icon(Icons.add),
        backgroundColor: Color.fromRGBO(225,202,167,1),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}