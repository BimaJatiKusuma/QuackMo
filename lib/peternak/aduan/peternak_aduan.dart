import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:quackmo/peternak/go_premium/premium.dart';
import 'package:quackmo/peternak/peternak_login.dart';

class PeternakAduan extends StatefulWidget {
  String idProduk;
  PeternakAduan({
    required this.idProduk,
    super.key});

  @override
  State<PeternakAduan> createState() => _PeternakAduanState();
}

class _PeternakAduanState extends State<PeternakAduan> {
  TextEditingController chatController = TextEditingController();
  CollectionReference _chatList = FirebaseFirestore.instance.collection('chat');
  late Stream<QuerySnapshot> _streamChatList;

  CollectionReference _usersCollection = FirebaseFirestore.instance.collection('users');
  late Stream<DocumentSnapshot> _streamUsersCollection;

  @override
  void initState() {
    _streamUsersCollection = _usersCollection.doc(userPeternakID).snapshots();
    _streamChatList = _chatList.where('id_produk', isEqualTo: widget.idProduk).snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _streamUsersCollection,
      builder:(context, AsyncSnapshot snapshot) {
        if(snapshot.connectionState == ConnectionState.active){
          DocumentSnapshot usersSnapshot = snapshot.data;
          premium = usersSnapshot.get('premium');
          if(premium == 'y')
          {return Scaffold(
            backgroundColor: Color.fromRGBO(249, 239, 224, 1),
            appBar: AppBar(
              title: Text("Aduan"),
              centerTitle: true,
              backgroundColor: Color.fromRGBO(225, 202, 167, 1),
              ),
            body: Column(
              children: [
                Expanded(
                  child: StreamBuilder(
                    stream: _streamChatList,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (snapshot.hasError){
                        return Text(snapshot.error.toString());
                      }
                      if (snapshot.connectionState == ConnectionState.active){
                        QuerySnapshot chatQuerySnaphsot = snapshot.data;
                        List<QueryDocumentSnapshot> listChatQuerySnapshot = chatQuerySnaphsot.docs;
                        if (listChatQuerySnapshot.length >= 2) {
                          listChatQuerySnapshot
                              .sort((a, b) => a['datetime'].compareTo(b['datetime']));
                        }
                        
                        return ListView.builder(
                            itemCount: listChatQuerySnapshot.length,
                            itemBuilder:(context, index) {
                              QueryDocumentSnapshot chat = listChatQuerySnapshot[index];

                              late DocumentReference _referenceUser;
                              late Future<DocumentSnapshot> _futureDataUser;
                              late Map dataUser;


                              _referenceUser = FirebaseFirestore.instance.collection('users').doc(_getDocById(chat['id_peternak'], chat['id_produsen'], userPeternakID));
                              _futureDataUser = _referenceUser.get();

                              return FutureBuilder(
                                future: _futureDataUser,
                                builder: (context, snapshot) {
                                  if (snapshot.hasError){
                                    return Center(child: Text('${snapshot.hasError}'),);
                                  }
                                  if (snapshot.hasData){
                                    DocumentSnapshot? documentSnapshotUser = snapshot.data;
                                    dataUser = documentSnapshotUser!.data() as Map;
                                    
                                    return 
                                      Container(
                                        // width: double.infinity,
                                        constraints: BoxConstraints(
                                          maxWidth: 150,
                                          minWidth: 50
                                        ),
                                        margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                                        padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                                        decoration: BoxDecoration(
                                          color: _divider_color(chat["id_produsen"], chat["id_peternak"], userPeternakID),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Column(
                                          crossAxisAlignment: _divider_CrossAlignment(chat["id_produsen"], chat["id_peternak"], userPeternakID),
                                          children: [
                                            Text(DateFormat('dd MMMM yyyy, HH:mm').format((chat['datetime']as Timestamp).toDate())),
                                            Text(dataUser["nama"], style: TextStyle(fontWeight: FontWeight.w600),),
                                            Text(chat["pesan"])
                                          ],
                                        ),
                                      );
                                  }
                                  return CircularProgressIndicator();
                                },
                              );


                            },
                            
                          );
                      }
                      return Center(child: CircularProgressIndicator(),);
                    },
                  )
                ),
                Container(
                  height: 60,
                  width: double.infinity,
                  margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
                  child: TextFormField(
                    controller: chatController,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      hintText: "tulis pesan ...",
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromRGBO(164, 119, 50, 1))
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Color.fromRGBO(164, 119, 50, 1))
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color:  Color.fromRGBO(164, 119, 50, 1))
                      ),
                      suffixIconColor: Color.fromRGBO(164, 119, 50, 1),
                      suffixIcon: IconButton(
                        onPressed: (){
                          _sendChat(chatController.text, userPeternakID, widget.idProduk);
                          chatController.text = '';
                        },
                        icon: Icon(Icons.send),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromRGBO(225, 202, 167, 1)
                        ),
                      )
                    ),
                  ),
                )
              ],
            ),
          );
          }
          else {
            return Scaffold(
            appBar: AppBar(
              title: Text("Aduan"),
              centerTitle: true,
              backgroundColor: Color.fromRGBO(225, 202, 167, 1),
              ),
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Fitur ini hanya untuk akun premium"),
                  ElevatedButton(onPressed: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context){
                      return PeternakPremium(idPeternak: userPeternakID);
                    }));
                  }, child: Text("Gabung Premium"))
                ],
              ),
            )
            );
          }
        }
        return CircularProgressIndicator();
      },
    );
  }
}

_sendChat(text, idPeternak, idProduk){
  FirebaseFirestore collection = FirebaseFirestore.instance;
  CollectionReference chatCollection = collection.collection('chat');

  chatCollection.add({
    "pesan": text,
    "id_peternak": idPeternak,
    "id_produsen": "",
    "id_produk": idProduk,
    "datetime": DateTime.now(),
    });
}



_divider_color(id_produsen, id_peternak, current_id_peternak){
  if (id_peternak == current_id_peternak){
    return Color.fromARGB(255, 196, 251, 198);
  }

  else {
    return Color.fromARGB(255, 255, 255, 255);
  }
}

_divider_CrossAlignment(id_produsen, id_peternak, current_id_peternak){
  if (id_peternak == current_id_peternak){
    return CrossAxisAlignment.end;
  }

  else {
    return CrossAxisAlignment.start;
  }
}

_getDocById(id_produsen, id_peternak, current_id_peternak){
  if (id_produsen != ""){
    return id_produsen;
  }
  else if (id_peternak != ""){
    return id_peternak;
  }
  else (current_id_peternak){
    return current_id_peternak;
  };
}