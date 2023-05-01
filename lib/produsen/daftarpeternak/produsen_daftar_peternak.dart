import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:quackmo/produsen/daftarpeternak/produsen_daftar_produk.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class ProdusenDaftarPeternak extends StatefulWidget {
  const ProdusenDaftarPeternak({super.key});

  @override
  State<ProdusenDaftarPeternak> createState() => _ProdusenDaftarPeternakState();
}

class _ProdusenDaftarPeternakState extends State<ProdusenDaftarPeternak> {
  Query<Map<String, dynamic>> _peternakList = FirebaseFirestore.instance.collection('users').where('role', isEqualTo: 'peternak');
  late Stream _streamPeternakList;

  void initState(){
    super.initState();
    _streamPeternakList = _peternakList.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    _peternakList.snapshots();

    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () {
          Navigator.pop(context);
        },),
        title: Text("Daftar Peternak Bebek"),
      ),
      body:
      StreamBuilder(
            stream: _streamPeternakList,
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
                    QueryDocumentSnapshot peternak=listQueryDocumentSnapshot[index];
                    var id_peternak = peternak.id;
                    print(peternak);
                    print(peternak['email']);
                    print(peternak['alamat']);
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      color: Colors.blue,
                      margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                      child: InkWell(
                        child: Row(
                          children: [
                            Container(
                              child: Icon(Icons.square_rounded),
                            ),
                            Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('Peternak Bebek ${peternak['nama']}'),
                                Text('Alamat: ${peternak['alamat']}')
                              ],
                            )
                          ],
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return ProdusenDaftarProduk(id_peternak);
                          }));
                        },
                      ),
                      // child: ListTile(
                      //   tileColor: Colors.amber,
                      //   minVerticalPadding: 10,
                      //   visualDensity: VisualDensity.adaptivePlatformDensity,

                      //   title: Text(peternak['nama']),
                        
                      //   onTap: () {
                      //     Navigator.push(context, MaterialPageRoute(builder: (context){
                      //       return ProdusenDaftarProduk(id_peternak);
                      //     }));
                      //   },
                      // ),
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



      // ListView(
      //   children: [
      //     Text("Jember"),
      //     Container(
      //     child: Column(children: [
      //       InkWell(
      //         onTap: () {
      //           Navigator.push(context, MaterialPageRoute(builder: (context) {
      //             return ProdusenDaftarProduk();
      //           }));
      //         },
      //         child: Ink(
      //           color: Colors.blue,
      //           child: Row(
      //             children: [
      //               Icon(Icons.square),
      //               Column(children: [
      //                 Text('Peternak Bebek Farhaz'),
      //                 Text('PT. Jaya Abadi'),
      //                 Text('Alamat: Jl. Mawar Merah no. 11')
      //               ])
      //             ],
      //           ),
      //         ),
      //       ),
      //     ]),
      //   ),
      //   ],
      // ),