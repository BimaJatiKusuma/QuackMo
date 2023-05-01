import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quackmo/produsen/daftarpeternak/produsen_daftar_produk_detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProdusenDaftarProduk extends StatefulWidget {
  ProdusenDaftarProduk(this.peternakID, {Key? key}) : super(key:key) {
    _reference = FirebaseFirestore.instance.collection('produk').doc(peternakID);
    _futureData = _reference.get();
  }

  late DocumentReference _reference;
  late Future _futureData;
  String peternakID;


  @override
  State<ProdusenDaftarProduk> createState() => _ProdusenDaftarProdukState();
}

class _ProdusenDaftarProdukState extends State<ProdusenDaftarProduk> {
  
  CollectionReference _produkList = FirebaseFirestore.instance.collection('produk');
  late Stream _streamProdukList;

  void initState(){
    super.initState();
    _streamProdukList = _produkList.where('peternak_uid', isEqualTo: widget.peternakID).snapshots();
  }
  
  @override
  Widget build(BuildContext context) {
     _produkList.snapshots();
    
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Daftar Produk"),
        leading: BackButton(),
      ),
      body: 
          StreamBuilder(
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
                      margin: EdgeInsets.fromLTRB(5, 0, 5, 10),
                      child: ListTile(
                        tileColor: Colors.amber,
                        minVerticalPadding: 10,
                        visualDensity: VisualDensity.adaptivePlatformDensity,
                        leading: Image(image: NetworkImage(produk['foto_url'])),
                        title: Text(produk['nama_produk']),
                        subtitle: Column(
                          children: [
                            Text("Stock: ${produk['stok']}"),
                            Text("Harga: ${produk['harga']} / ${produk['satuan']}  telur")
                          ],
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return ProdusenDaftarProdukDetail(id_produk);
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
       

    );
  }
}
















































// Scaffold(
//       appBar: AppBar(
//         leading: BackButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: Text("Daftar Produk Peternak"),
//       ),
//       body: Column(
//         children: [
//           Row(
//             children: [
//               Text(widget.peternakID),
//               Container(
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) {
//                       return ProdusenDaftarProdukDetail();
//                     }));
//                   },
//                   child: Ink(
//                     color: Colors.blue,
//                     child: Column(
//                       children: [
//                         Image(image: AssetImage('images/daftar_produk01.png')),
//                         Column(children: [
//                           Text('TELUR BEBEK HIBRIDA'),
//                           Text('Stok: 100 telur'),
//                           Text('Harga: Rp. 2.000 / telur')
//                         ])
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//               Container(
//                 child: InkWell(
//                   onTap: () {
//                     Navigator.push(context,
//                         MaterialPageRoute(builder: (context) {
//                       return ProdusenDaftarProdukDetail();
//                     }));
//                   },
//                   child: Ink(
//                     color: Colors.blue,
//                     child: Column(
//                       children: [
//                         Image(image: AssetImage('images/daftar_produk01.png')),
//                         Column(children: [
//                           Text('TELUR BEBEK HIBRIDA'),
//                           Text('Stok: 100 telur'),
//                           Text('Harga: Rp. 2.000 / telur')
//                         ])
//                       ],
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           )
//         ],
//       ),
//     );