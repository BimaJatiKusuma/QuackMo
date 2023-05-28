import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:quackmo/peternak/cuaca/cuaca.dart';
import 'package:quackmo/peternak/daftarproduk/peternak_daftar_produk.dart';
import 'package:quackmo/peternak/distribusi/peternak_distribusi.dart';
import 'package:quackmo/peternak/peternak_login.dart';
import 'package:quackmo/peternak/peternak_pemesanan/peternak_pesanan.dart';
import 'package:quackmo/peternak/peternak_transaksi/peternak_transaksi.dart';

import 'package:quackmo/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class PeternakHomepage extends StatefulWidget {
  const PeternakHomepage({super.key});

  @override
  State<PeternakHomepage> createState() => _PeternakHomepageState();
}

int _index = 0;

class _PeternakHomepageState extends State<PeternakHomepage> {
  @override
  Widget build(BuildContext context) {
    Widget child = Container();

    switch (_index) {
      case 0:
        child = PeternakMainHomePage(userPeternakID);
        break;

      case 1:
        child = PeternakProfilPage(userPeternakID);
        break;

      case 2:
        child= AlertDialog(
              title: Container(color: Color.fromRGBO(225, 202, 167, 1), child: Text('Pemberitahuan', textAlign: TextAlign.center,)),
              content: Text('Yakin ingin keluar ?', textAlign: TextAlign.center,),
              actions: <Widget>[
                TextButton(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.black
                  ),
                  onPressed: () {
                    setState(() {
                      _index = 0;
                    });
                  },
                  child: const Text('Tidak'),
                ),
                TextButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(225, 202, 167, 1),
                    foregroundColor: Colors.black
                  ),
                  onPressed: () async {
                    _logout(context);
                  },
                  child: Text('Ya'),
                ),
              ],
            );

        break;
    }

    return Scaffold(
        body: child,
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.black,
          backgroundColor: Color.fromRGBO(225, 202, 167, 1),
          onTap: (int index) => setState(() => _index = index),
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Beranda'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
            BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Keluar'),
          ],
          currentIndex: _index,
        ));
  }
}

_logout(context) {
  _index = 0;
  SchedulerBinding.instance.addPostFrameCallback((_) {
    userPeternakID = '';
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) {
      return Login();
    }), (route) => false);
  });
}






class Logout extends StatefulWidget {
  const Logout({super.key});

  @override
  State<Logout> createState() => _LogoutState();
}

class _LogoutState extends State<Logout> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}




class PeternakMainHomePage extends StatefulWidget {
  PeternakMainHomePage(this.idPeternak){
  _referenceProfil = FirebaseFirestore.instance.collection('users').doc(userPeternakID);
  _futureDataProfil = _referenceProfil.get();
  }
  
  String idPeternak;
  late DocumentReference _referenceProfil;
  late Future _futureDataProfil;
  late Map dataProfil;
  @override
  State<PeternakMainHomePage> createState() => _PeternakMainHomePageState();
}

class _PeternakMainHomePageState extends State<PeternakMainHomePage> {
  // Future getTotalDataPemesananByDate()async {
  //   QuerySnapshot snapshotPemesanan = await FirebaseFirestore.instance.collection('pemesanan').where('waktu', isLessThanOrEqualTo: DateTime.now()).where('id_kondisi', isEqualTo: 100).get();
  //   int groupCount = snapshotPemesanan.docs.length;
  //   print(groupCount);
  //   return groupCount;
  // }
  CollectionReference _pemesananCollection = FirebaseFirestore.instance.collection('pemesanan');
  late Stream<QuerySnapshot> _streamPemesanan;

  @override
  void initState() {
    _streamPemesanan = _pemesananCollection.where('id_kondisi', isEqualTo: 100).snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Container(
      child: FutureBuilder(
        future: widget._futureDataProfil,
        builder: (context, snapshot) {
          if (snapshot.hasError){
            return Center(child: Text("Terjadi Error ${snapshot.hasError}"),);
          }
          if (snapshot.hasData){
            DocumentSnapshot? documentSnapshot = snapshot.data;
            widget.dataProfil = documentSnapshot!.data() as Map;
            _pemesananCollection.snapshots();
            return Column(
                children: [
                  Container(
                    height: 150,
                    alignment: Alignment.center,
                    width: double.infinity,
                    decoration:
                        BoxDecoration(color: Color.fromRGBO(245, 233, 215, 1)),
                    child: Row(
                      children: [
                        Container(
                          width: 100,
                          child: Image(image: AssetImage('images/peternak_01.png'))),
                        Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Text(userPeternakID),
                              Text('Hai, Peternak'),
                              Text(
                                widget.dataProfil['nama'],
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),

                  Container(
                    width: double.infinity,
                    decoration:
                        BoxDecoration(color: Color.fromRGBO(225, 202, 167, 1)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Image(image: AssetImage('images/peternak_02.png')),
                        StreamBuilder(
                          stream: _streamPemesanan,
                          builder: (context, AsyncSnapshot snapshot) {
                            if(snapshot.connectionState == ConnectionState.active && snapshot.hasData){
                              QuerySnapshot _queryPemesanan = snapshot.data;
                              List<QueryDocumentSnapshot> listQueryPemesanan = _queryPemesanan.docs;
                              var totalPendingPesanan = 0;
                              totalPendingPesanan = listQueryPemesanan.length;
                              return Column(
                                children: [Text("Pesanan belum dikonfirmasi: "), Text("${totalPendingPesanan} pesanan")],
                                );
                            }
                            else{
                              return CircularProgressIndicator();
                            }
                          },
                        ),
                        
                        ElevatedButton(
                            onPressed: () {
                              Navigator.push(context, MaterialPageRoute(builder: (context){
                                return PeternakPesanan();
                              }));
                            },
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromRGBO(208, 155, 76, 1),
                                foregroundColor: Colors.white),
                            child: Text("Detail"))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Column(
                      children: [
                        SizedBox(
                          width: double.infinity,
                          child: Text(
                            "Kategori",
                            textAlign: TextAlign.left,
                            style:
                                TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return PeternakDaftarProduk();
                                    }));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromRGBO(250, 250, 250, 1),
                                      foregroundColor: Colors.black,
                                      shadowColor: Colors.black,
                                      elevation: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(image: AssetImage('images/produk.png')),
                                      Text(
                                        'Produk',
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )),
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return Cuaca();
                                    }));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromRGBO(250, 250, 250, 1),
                                      foregroundColor: Colors.black,
                                      shadowColor: Colors.black,
                                      elevation: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(image: AssetImage('images/cuaca.png')),
                                      Text(
                                        'Monitoring Cuaca',
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )),
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return PeternakTransaksi();
                                    }));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromRGBO(250, 250, 250, 1),
                                      foregroundColor: Colors.black,
                                      shadowColor: Colors.black,
                                      elevation: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                    children: [
                                      Image(
                                          image: AssetImage('images/transaksi.png')),
                                      Text(
                                        'Transaksi',
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )),
                            )
                          ],
                        ),
                        SizedBox(height: 20),
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (context) {
                                      return PeternakPesanan();
                                    }));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromRGBO(250, 250, 250, 1),
                                      foregroundColor: Colors.black,
                                      shadowColor: Colors.black,
                                      elevation: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(image: AssetImage('images/pesanan.png')),
                                      Text(
                                        'Pesanan Masuk',
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )),
                            ),
                            Container(
                              width: 100,
                              height: 100,
                              child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return PeternakDistribusi();
                                    }));
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Color.fromRGBO(250, 250, 250, 1),
                                      foregroundColor: Colors.black,
                                      shadowColor: Colors.black,
                                      elevation: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image(
                                          image: AssetImage('images/distribusi.png')),
                                      Text(
                                        'Distribusi',
                                        textAlign: TextAlign.center,
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              );
          }

          return Center(child: CircularProgressIndicator());  
        },
      ),
    ));
  }
}


















class PeternakProfilPage extends StatefulWidget {
  PeternakProfilPage(this.idPeternak) {
    _referenceProfil = FirebaseFirestore.instance.collection('users').doc(idPeternak);
    _futureDataProfil = _referenceProfil.get();
  }

  String idPeternak;
  late DocumentReference _referenceProfil;
  late Future _futureDataProfil;
  late Map dataProfil;

  @override
  State<PeternakProfilPage> createState() => _PeternakProfilPageState();
}

class _PeternakProfilPageState extends State<PeternakProfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0),
        foregroundColor: Colors.black,
        elevation: 0,
        title: Text("Profil"),
        centerTitle: true,
      ),
      body: Container(
        child: FutureBuilder(
          future: widget._futureDataProfil,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Terjadi Error ${snapshot.hasError}"),
              );
            }
            if (snapshot.hasData) {
              DocumentSnapshot? documentSnapshot = snapshot.data;
              widget.dataProfil = documentSnapshot!.data() as Map;
              return Container(
                child: ListView(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Stack(
                            children: [
                              Image(
                                  image: AssetImage('images/peternak_01.png')),
                              Positioned(
                                  right: 0,
                                  bottom: 0,
                                  child: CircleAvatar(
                                    radius: 20,
                                    backgroundColor: Colors.blue,
                                    child: IconButton(
                                        onPressed: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(
                                                  builder: (context) {
                                            return PeternakProfilPageEdit(
                                                userPeternakID);
                                          }));
                                        },
                                        icon: Icon(Icons.edit_rounded)),
                                  ))
                            ],
                          ),
                          Text(widget.dataProfil['nama'], style: TextStyle(fontWeight: FontWeight.w900, fontSize: 20),),
                          Text('Peternak Bebek')
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('Nama'),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  width: double.infinity,
                                  height: 35,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color.fromRGBO(225, 202, 167, 1)),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(widget.dataProfil['nama']),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('Email'),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  width: double.infinity,
                                  height: 35,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color.fromRGBO(225, 202, 167, 1)),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: Text(widget.dataProfil['email']),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('No. HP'),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  width: double.infinity,
                                  height: 35,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color.fromRGBO(225, 202, 167, 1)),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: widget.dataProfil['no_hp'] != null ? Text(widget.dataProfil['no_hp']) : Text('Belum diatur'),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('Alamat'),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  width: double.infinity,
                                  height: 35,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color.fromRGBO(225, 202, 167, 1)),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: widget.dataProfil['alamat'] != null ? Text(widget.dataProfil['alamat']) : Text('Belum diatur'),
                                )
                              ],
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('Kota'),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  width: double.infinity,
                                  height: 35,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color.fromRGBO(225, 202, 167, 1)),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: widget.dataProfil['kota'] != null ? Text(widget.dataProfil['kota']) : Text('Belum diatur'),
                                )
                              ],
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('Kode Pos'),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  width: double.infinity,
                                  height: 35,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color.fromRGBO(225, 202, 167, 1)),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: widget.dataProfil['kode_pos'] != null ? Text(widget.dataProfil['kode_pos']) : Text('Belum diatur'),
                                )
                              ],
                            ),
                          ),

                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('Usia'),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  width: double.infinity,
                                  height: 35,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(color: Color.fromRGBO(225, 202, 167, 1))
                                  ),
                                  child: widget.dataProfil['usia'] != null ? Text(widget.dataProfil['usia']) : Text('Belum diatur'),
                                )
                              ],
                            ),
                          ),


                          Container(
                            margin: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width * 0.9,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text('Gender'),
                                Container(
                                  padding: EdgeInsets.all(5),
                                  width: double.infinity,
                                  height: 35,
                                  alignment: Alignment.centerLeft,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Color.fromRGBO(225, 202, 167, 1)),
                                    borderRadius: BorderRadius.circular(5),
                                  ),
                                  child: widget.dataProfil['gender'] != null ? Text(widget.dataProfil['gender']) : Text('Belum diatur'),
                                )
                              ],
                            ),
                          ),


                          SizedBox(height: 30,),

                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Container(
                                    margin: EdgeInsets.only(left: 20),
                                    width: 150,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromRGBO(225, 202, 167, 1),
                                            foregroundColor: Colors.black),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context){
                                              return AlertDialog(
                                                title: Container(color: Color.fromRGBO(225, 202, 167, 1), child: Text('Pemberitahuan', textAlign: TextAlign.center,)),
                                                content: Text('Hapus Data Akun ?', textAlign: TextAlign.center,),
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
                                                      await FirebaseAuth.instance.currentUser!.delete();
                                                      await FirebaseFirestore.instance.collection('users').doc(userPeternakID).delete();
                                                      setState(() {
                                                        _index = 0;
                                                      });
                                                      Navigator.push(context, MaterialPageRoute(builder: (context){
                                                        return _PeternakSplashScreenHapusProfil();
                                                      }));
                                                    },
                                                    child: Text('Ya'),
                                                  ),
                                                ],
                                              );
                                            });
                                        },
                                        child: Text("Hapus Akun"))),
                            ],
                          )


                        ],
                      ),
                    )
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}



class _PeternakSplashScreenHapusProfil extends StatefulWidget {
  const _PeternakSplashScreenHapusProfil({super.key});

  @override
  State<_PeternakSplashScreenHapusProfil> createState() => __PeternakSplashScreenHapusProfilState();
}

class __PeternakSplashScreenHapusProfilState extends State<_PeternakSplashScreenHapusProfil> {
  @override
  void initState(){
    super.initState();

    Timer(Duration(seconds: 1), () {
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
        return Login();
      }), (route) => false);
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
              Text("AKUN BERHASIL DI HAPUS", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
            ],
          ),
        ),
      ),
    );
  }
}













class PeternakProfilPageEdit extends StatefulWidget {
  PeternakProfilPageEdit(this.idPeternak) {
    _referenceProfil =
        FirebaseFirestore.instance.collection('users').doc(idPeternak);
    _futureDataProfil = _referenceProfil.get();
  }

  String idPeternak;
  late DocumentReference _referenceProfil;
  late Future _futureDataProfil;
  late Map dataProfil;

  @override
  State<PeternakProfilPageEdit> createState() => _PeternakProfilPageEditState();
}

class _PeternakProfilPageEditState extends State<PeternakProfilPageEdit> {
  final _formkey = GlobalKey<FormState>();

  late TextEditingController namaController = TextEditingController(text: widget.dataProfil['nama']);
  late TextEditingController emailController = TextEditingController(text: widget.dataProfil['email']);
  late TextEditingController noHpController = TextEditingController(text: widget.dataProfil['no_hp']);
  late TextEditingController alamatController= TextEditingController(text: widget.dataProfil['alamat']);
  late TextEditingController kotaController = TextEditingController(text: widget.dataProfil['kota']);
  late TextEditingController kodePosController = TextEditingController(text: widget.dataProfil['kode_pos']);
  late TextEditingController usiaController = TextEditingController(text: widget.dataProfil['usia']);
  late TextEditingController genderController = TextEditingController(text: widget.dataProfil['gender']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(255, 255, 255, 0),
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Text("Edit Profil"),
      ),
      body: Container(
        child: FutureBuilder(
          future: widget._futureDataProfil,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text("Terjadi Error ${snapshot.hasError}"),
              );
            }
            if (snapshot.hasData) {
              DocumentSnapshot? documentSnapshot = snapshot.data;
              widget.dataProfil = documentSnapshot!.data() as Map;
              return Container(
                child: ListView(
                  children: [
                    Container(
                      child: Column(
                        children: [
                          Image(image: AssetImage('images/peternak_01.png')),
                          Text('Peternak Bebek')
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
                      child: Form(
                        child: Column(
                          children: [
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text('Nama'),
                                  Container(
                                    width: double.infinity,
                                    height: 35,
                                    alignment: Alignment.centerLeft,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      controller: namaController,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text('Email'),
                                  Container(
                                    width: double.infinity,
                                    height: 35,
                                    alignment: Alignment.centerLeft,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                        filled: true,
                                        fillColor: Colors.grey
                                      ),
                                      readOnly: true,
                                      enabled: false,
                                      controller: emailController,
                                    )
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text('No HP'),
                                  Container(
                                    width: double.infinity,
                                    height: 35,
                                    alignment: Alignment.centerLeft,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      controller: noHpController,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text('Alamat'),
                                  Container(
                                    width: double.infinity,
                                    height: 35,
                                    alignment: Alignment.centerLeft,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      controller: alamatController,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text('Kota'),
                                  Container(
                                    width: double.infinity,
                                    height: 35,
                                    alignment: Alignment.centerLeft,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      controller: kotaController,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text('Kode Pos'),
                                  Container(
                                    width: double.infinity,
                                    height: 35,
                                    alignment: Alignment.centerLeft,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      controller: kodePosController,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text('Usia'),
                                  Container(
                                    width: double.infinity,
                                    height: 35,
                                    alignment: Alignment.centerLeft,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      controller: usiaController,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Container(
                              margin: EdgeInsets.only(top: 10),
                              width: MediaQuery.of(context).size.width * 0.9,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Text('Jenis Kelamin'),
                                  Container(
                                    width: double.infinity,
                                    height: 35,
                                    alignment: Alignment.centerLeft,
                                    child: TextFormField(
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                      ),
                                      controller: genderController,
                                    ),
                                  )
                                ],
                              ),
                            ),

                            SizedBox(height: 30,),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Container(
                                    margin: EdgeInsets.only(right: 20),
                                    width: 150,
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            backgroundColor: Color.fromRGBO(225, 202, 167, 1),
                                            foregroundColor: Colors.black),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context){
                                              return AlertDialog(
                                                title: Container(color: Color.fromRGBO(225, 202, 167, 1), child: Text('Pemberitahuan', textAlign: TextAlign.center,)),
                                                content: Text('Simpan Perubahan ?', textAlign: TextAlign.center,),
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
                                                      widget._referenceProfil.update({
                                                        'nama':namaController.text,
                                                        'no_hp':noHpController.text,
                                                        'alamat':alamatController.text,
                                                        'kota':kotaController.text,
                                                        'kode_pos':kodePosController.text,
                                                        'usia':usiaController.text,
                                                        'gender':genderController.text,
                                                      });
                                                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                                                        return _PeternaksplashScreenUpdateProfil();
                                                      }));
                                                    },
                                                    child: Text('Ya'),
                                                  ),
                                                ],
                                              );
                                            });
                                        },
                                        child: Text("Simpan")))
                              ],
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }
}

class _PeternaksplashScreenUpdateProfil extends StatefulWidget {
  const _PeternaksplashScreenUpdateProfil({super.key});

  @override
  State<_PeternaksplashScreenUpdateProfil> createState() => __PeternaksplashScreenUpdateProfilState();
}

class __PeternaksplashScreenUpdateProfilState extends State<_PeternaksplashScreenUpdateProfil> {
   @override
  void initState(){
    super.initState();

    Timer(Duration(seconds: 1), () {
      setState(() {
        _index = 0;
      });
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
        return PeternakHomepage();
      }), (route) => false);
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
              Text("PROFIL BERHASIL DI UBAH", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
            ],
          ),
        ),
      ),
    );
  }
}