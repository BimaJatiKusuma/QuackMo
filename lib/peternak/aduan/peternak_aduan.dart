import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class PeternakAduan extends StatefulWidget {
  const PeternakAduan({super.key});

  @override
  State<PeternakAduan> createState() => _PeternakAduanState();
}

class _PeternakAduanState extends State<PeternakAduan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Aduan Produk")),
    );
  }
}