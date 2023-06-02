import 'package:cloud_firestore/cloud_firestore.dart';

getDataAkun(){
  return FirebaseFirestore.instance.collection('users');
}