import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quackmo/peternak/peternak_login.dart';

class PeternakPremium extends StatefulWidget {
  final idPeternak;
  const PeternakPremium({
    required this.idPeternak,
    super.key
    });

  @override
  State<PeternakPremium> createState() => _PeternakPremiumState();
}

class _PeternakPremiumState extends State<PeternakPremium> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Menuju Premium"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.fromLTRB(10, 20, 10, 10),
              color: Colors.red,
              child: ListView(
                children: [
                  Text("data fafafa"),
                ],
              ),
            ),
          ),
          Container(
            height: 100,
            alignment: Alignment.topCenter,
            color: Colors.amber,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton(onPressed: (){
                  Navigator.pop(context);
                }, child: Text("Batal")),
                ElevatedButton(onPressed: (){
                  FirebaseFirestore.instance.collection('users').doc(widget.idPeternak).update({
                    'premium':"y"
                  }).then((value){
                    FirebaseFirestore.instance.collection('users').doc(widget.idPeternak).get().then((value){
                        premium = value.get('premium');
                        Navigator.pop(context);
                    });
                  });
                  // print(premium);
                }, child: Text("Bayar")),
              ],
            ),
          )
        ],
      ),
    );
  }
}

