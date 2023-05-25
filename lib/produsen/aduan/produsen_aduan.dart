import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quackmo/peternak/peternak_login.dart';
import 'package:quackmo/produsen/produsen_login.dart';

class ProdusenAduan extends StatefulWidget {
  String idProduk;
  ProdusenAduan({
    required this.idProduk,
    super.key});

  @override
  State<ProdusenAduan> createState() => _ProdusenAduanState();
}

class _ProdusenAduanState extends State<ProdusenAduan> {
  TextEditingController chatController = TextEditingController();
  CollectionReference _chatList = FirebaseFirestore.instance.collection('chat');
  late Stream<QuerySnapshot> _streamChatList;
  @override
  void initState() {
    _streamChatList = _chatList.where('id_produk', isEqualTo: widget.idProduk).snapshots();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Aduan"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(225, 202, 167, 1),
        ),
      body: Column(
        children: [
          Text(widget.idProduk),
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
                        return Container(
                          width: double.infinity,
                          margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                          decoration: BoxDecoration(
                            color: _divider(chat["id_peternak"], chat["id_produsen"], userProdusenID),
                          ),
                          child: Column(
                            children: [
                              Text(chat.id),
                              Text(chat["id_peternak"]),
                              Text("${chat["datetime"]}"),
                              Text("isi pesan: ${chat["pesan"]}")
                            ],
                          ),
                        );
                      },
                      
                    );
                }
                return Center(child: CircularProgressIndicator(),);
              },
            )


          ),
          Container(
            // color: Colors.red,
            height: 35,
            width: double.infinity,
            margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
            child: TextFormField(
              controller: chatController,
              decoration: InputDecoration(
                suffixIcon: IconButton(
                  onPressed: (){
                    _sendChat(chatController.text, userProdusenID, widget.idProduk);
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
}

_sendChat(text, idProdusen, idProduk){
  FirebaseFirestore collection = FirebaseFirestore.instance;
  CollectionReference chatCollection = collection.collection('chat');

  chatCollection.add({
    "pesan": text,
    "id_peternak": "",
    "id_produsen": idProdusen,
    "id_produk": idProduk,
    "datetime": DateTime.now(),
    });
}

_divider(id_peternak, id_produsen, current_id_produsen){
  if (id_produsen == current_id_produsen){
    return Colors.green;
  }
  if (id_produsen != ""){
    return Colors.amber;
  }
  else {
    return Colors.red;
  }
}