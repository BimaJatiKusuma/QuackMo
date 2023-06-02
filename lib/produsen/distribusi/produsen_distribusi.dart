import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:quackmo/peternak/peternak_login.dart';
import 'package:quackmo/produsen/produsen_login.dart';

class ProdusenDistribusi extends StatefulWidget {
  const ProdusenDistribusi({super.key});

  @override
  State<ProdusenDistribusi> createState() => _ProdusenDistribusiState();
}

class _ProdusenDistribusiState extends State<ProdusenDistribusi> {
  CollectionReference _pesananList = FirebaseFirestore.instance.collection('pemesanan');

  late Stream<QuerySnapshot> _streamPemesananList;
  // List kondisi_pengiriman = [100, 200];

  @override
  void initState() {
    _streamPemesananList = _pesananList.where('id_produsen', isEqualTo: userProdusenID).where('id_kondisi', isEqualTo: 500).snapshots();
    super.initState();
  }
  
  _icon(id_pengiriman){
    if (id_pengiriman==100){
      return Icon(Icons.check_circle_outline_rounded, color: Color.fromRGBO(225, 202, 167, 1),);
    }
    if (id_pengiriman==200){
      return Icon(Icons.check_circle, color: Color.fromRGBO(225, 202, 167, 1),);
    }
  }
  
  _textKondisiPengiriman(id_pengiriman){
    if (id_pengiriman==100){
      return Text("Dalam Perjalanan");
    }
    if (id_pengiriman==200){
      return Text("Tiba");
    }
  }

  @override
  Widget build(BuildContext context) {
    _pesananList.snapshots();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(225, 202, 167, 1),
        title: Text("Distribusi Masuk"),
        centerTitle: true,
        leading: PreferredSize(
          preferredSize: Size(10, 10),
          child: ElevatedButton(onPressed: (){
            Navigator.pop(context);
          },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(225, 202, 167, 1),
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
                side: BorderSide(color: Colors.white),
              ),
            ),
            child: Icon(Icons.arrow_back_ios_new,)),
        ),
      ),
      body: StreamBuilder(
        stream: _streamPemesananList,
        builder: (context, AsyncSnapshot snapshot) {
          if(snapshot.hasError){
            return Text("Error");
          }
          if(snapshot.connectionState == ConnectionState.active){
            QuerySnapshot querySnapshot = snapshot.data;
            List<QueryDocumentSnapshot> listQueryDocumentSnapshot = querySnapshot.docs;

            return ListView.builder(
              itemCount: listQueryDocumentSnapshot.length,
              itemBuilder: (context, index) {
                QueryDocumentSnapshot pemesanan = listQueryDocumentSnapshot[index];
                
                late Future<DocumentSnapshot<Map<String, dynamic>>>  _futureDataProduk = FirebaseFirestore.instance.collection('produk').doc(pemesanan['id_produk']).get();
                late Future<DocumentSnapshot<Map<String, dynamic>>>  _futureDataUsers = FirebaseFirestore.instance.collection('users').doc(pemesanan['id_peternak']).get();
                late Map dataProduk;
                late Map dataUsers;
                return FutureBuilder(
                  future: _futureDataProduk,
                  builder: (context, snapshot) {
                    if(snapshot.hasData){
                      dataProduk = snapshot.data!.data() as Map;
                      return FutureBuilder(
                        future: _futureDataUsers,
                        builder: (context, snapshot) {
                          if (snapshot.hasData){
                            dataUsers = snapshot.data!.data() as Map;

                            return 
                              Container(
                                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Text("${pemesanan["waktu_pembayaran"] ?? ""}"),
                                  Text(DateFormat('dd MMMM yyyy, HH:mm').format((pemesanan["waktu_pembayaran"] as Timestamp).toDate())),
                                  InkWell(
                                    onTap: () {
                                      // _alertKonfirmasi(pemesanan["id_pengiriman"], pemesanan.id);
                                    },
                                    splashColor: Color.fromRGBO(225, 202, 167, 1),
                                    child: Ink(
                                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                                      decoration: BoxDecoration(
                                        color: Color.fromRGBO(241, 241, 241, 1),
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey,
                                            blurRadius: 5
                                          )
                                        ]
                                      ),
                                      child: Table(
                                        columnWidths: {1:FractionColumnWidth(.8)},
                                        children: [
                                          TableRow(
                                            children: [
                                              Container(
                                                // color: Colors.blue,
                                                child: Image(image: AssetImage("images/distribution.png"))),
                                              Container(
                                                // color: Colors.amber,
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text("Peternak Bebek ${dataUsers["nama"]}", style: TextStyle(fontWeight: FontWeight.w600),),
                                                    // Text("Pengantar: ${pemesanan["id_produsen"]}"),
                                                    Text("Produk: ${dataProduk["nama_produk"]}"),
                                                    Text("Jumlah: ${pemesanan["quantity"]}")
                                                  ],
                                                ),
                                              ),
                                              _icon(pemesanan["id_pengiriman"])
                                              // Icon(Icons.check_circle_outline_rounded, color: Color.fromRGBO(225, 202, 167, 1),)
                                            ]
                                          ),
                                          
                                          TableRow(
                                            children: [
                                              Icon(Icons.location_on),
                                              TableCell(
                                                verticalAlignment: TableCellVerticalAlignment.middle,
                                                child: Text("${pemesanan["alamat_kirim"]}",)),
                                              Container(), 
                                            ]
                                          ),
                                          TableRow(
                                            children: [
                                              Icon(Icons.access_time_filled_rounded),
                                              TableCell(
                                                verticalAlignment: TableCellVerticalAlignment.middle,
                                                child: _textKondisiPengiriman(pemesanan["id_pengiriman"])),
                                              Container(),
                                            ]
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }
                          return CircularProgressIndicator();
                        },
                      );
                    }
                    return CircularProgressIndicator();
                  },
                );
                
              },
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}