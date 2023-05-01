import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:quackmo/login.dart';
import 'package:quackmo/produsen/daftarpeternak/produsen_daftar_peternak.dart';
import 'package:quackmo/produsen/produsen_login.dart';
import 'package:quackmo/produsen/pesanan/produsen_pesanan.dart';
import 'package:quackmo/produsen/transaksi/produsen_transaksi.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';





class ProdusenHomepage extends StatefulWidget {
  const ProdusenHomepage({super.key});

  @override
  State<ProdusenHomepage> createState() => _ProdusenHomepageState();
}

int _index = 0;

class _ProdusenHomepageState extends State<ProdusenHomepage> {
  @override
  Widget build(BuildContext context) {
    Widget child = Container();

    switch (_index) {
      case 0:
        child = ProdusenMainHomePage(userProdusenID);
        break;

      case 1:
        child = ProdusenProfilPage(userProdusenID);
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
    userProdusenID = '';
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



class ProdusenMainHomePage extends StatefulWidget {
  ProdusenMainHomePage(this.idProdusen){
  _referenceProfil = FirebaseFirestore.instance.collection('users').doc(userProdusenID);
  _futureDataProfil = _referenceProfil.get();
  }
  
  String idProdusen;
  late DocumentReference _referenceProfil;
  late Future _futureDataProfil;
  late Map dataProfil;
  @override
  State<ProdusenMainHomePage> createState() => _ProdusenMainHomePageState();
}

class _ProdusenMainHomePageState extends State<ProdusenMainHomePage> {
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
            return Column(
                children: [
                  Container(
                    decoration:
                        BoxDecoration(color: Color.fromRGBO(245, 233, 215, 1)),
                    child: Row(
                      children: [
                        Image(image: AssetImage('images/produsen_01.png')),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Hai, Produsen'),
                            Text(
                              widget.dataProfil['nama'],
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w600),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    height: 50,
                    decoration:
                        BoxDecoration(color: Color.fromRGBO(225, 202, 167, 1)),
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
                                      return ProdusenDaftarPeternak();
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
                                      Image(image: AssetImage('images/daftar_peternak.png')),
                                      Text(
                                        'List Peternak',
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
                                      return ProdusenPesanan();
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
                                        'Pesanan',
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
                                      return ProdusenTransaksi();
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
                                  onPressed: () {},
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


















class ProdusenProfilPage extends StatefulWidget {
  ProdusenProfilPage(this.idProdusen) {
    _referenceProfil = FirebaseFirestore.instance.collection('users').doc(idProdusen);
    _futureDataProfil = _referenceProfil.get();
  }

  String idProdusen;
  late DocumentReference _referenceProfil;
  late Future _futureDataProfil;
  late Map dataProfil;

  @override
  State<ProdusenProfilPage> createState() => _ProdusenProfilPageState();
}

class _ProdusenProfilPageState extends State<ProdusenProfilPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Profil"),
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
                                  image: AssetImage('images/produsen_01.png')),
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
                                            return ProdusenProfilPageEdit(
                                                userProdusenID);
                                          }));
                                        },
                                        icon: Icon(Icons.edit_rounded)),
                                  ))
                            ],
                          ),
                          Text('Produsen Telur Asin')
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
                                            backgroundColor: Colors.red),
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
                                                      await FirebaseFirestore.instance.collection('users').doc(userProdusenID).delete();
                                                      setState(() {
                                                        _index = 0;
                                                      });
                                                      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                                                        return Login();
                                                      }), (route) => false);
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

















class ProdusenProfilPageEdit extends StatefulWidget {
  ProdusenProfilPageEdit(this.idProdusen) {
    _referenceProfil =
        FirebaseFirestore.instance.collection('users').doc(idProdusen);
    _futureDataProfil = _referenceProfil.get();
  }

  String idProdusen;
  late DocumentReference _referenceProfil;
  late Future _futureDataProfil;
  late Map dataProfil;

  @override
  State<ProdusenProfilPageEdit> createState() => _ProdusenProfilPageEditState();
}

class _ProdusenProfilPageEditState extends State<ProdusenProfilPageEdit> {
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
                          Image(image: AssetImage('images/produsen_01.png')),
                          Text('Produsen Telur Bebek')
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
                                  Text('Gender'),
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
                                            backgroundColor: Colors.green),
                                        onPressed: () {
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
                                            return _ProdusenplashScreenUpdateProfil();
                                          }));
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




class _ProdusenplashScreenUpdateProfil extends StatefulWidget {
  const _ProdusenplashScreenUpdateProfil({super.key});

  @override
  State<_ProdusenplashScreenUpdateProfil> createState() => __ProdusenplashScreenUpdateProfilState();
}

class __ProdusenplashScreenUpdateProfilState extends State<_ProdusenplashScreenUpdateProfil> {
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
              Text("PROFIL BERHASIL DIUPDATE", style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),),
              ElevatedButton(
                style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
                onPressed: (){
                setState(() {
                  _index = 0;
                });
                Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
                  return ProdusenHomepage();
                }), (route) => false);
              }, child: Text("Kembali ke Homepage"))
            ],
          ),
        ),
      ),
    );
  }
}