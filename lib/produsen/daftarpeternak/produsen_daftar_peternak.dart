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
        backgroundColor: Color.fromRGBO(225,202,167,1),
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
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: Offset(0, 3)
                          )
                        ]
                      ),
                      margin: EdgeInsets.fromLTRB(10, 30, 10, 0),
                      child: InkWell(
                        child: Row(
                          children: [
                            Container(
                              margin: EdgeInsets.only(left: 5),
                              child: Icon(Icons.square_rounded, color: Color.fromRGBO(225,202,167,1),),
                            ),
                            Expanded(
                              child: Container(
                                margin: EdgeInsets.fromLTRB(10, 5, 10, 5),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Peternak Bebek ${peternak['nama']}', style: TextStyle(fontWeight: FontWeight.w500),),
                                    Text('Alamat: ${peternak['alamat']}')
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return ProdusenDaftarProduk(id_peternak);
                          }));
                        },
                      ),
                    );
                  },
                );
              }
              return Center(child: CircularProgressIndicator(),);
            },
          ),
    );
  }
}