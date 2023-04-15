import 'package:flutter/material.dart';

enum SingingCharacter { lafayette, jefferson }

class ProdusenPembayaran extends StatefulWidget {
  const ProdusenPembayaran({super.key});

  @override
  State<ProdusenPembayaran> createState() => _ProdusenPembayaranState();
}

class _ProdusenPembayaranState extends State<ProdusenPembayaran> {
  SingingCharacter? _character = SingingCharacter.lafayette;

  @override
  Widget build(BuildContext context) {
    return Column(
      // children: [
      //   ListTile(
      //     title: const Text('Lafayette'),
      //     leading: Radio<SingingCharacter>(
      //       value: SingingCharacter.lafayette,
      //       groupValue: _character,
      //       onChanged: (SingingCharacter? value) {
      //         setState(() {
      //           _character = value;
      //         });
      //       },
      //     ),
      //   ),
      //   ListTile(
      //     title: const Text('Thomas Jefferson'),
      //     leading: Radio<SingingCharacter>(
      //       value: SingingCharacter.jefferson,
      //       groupValue: _character,
      //       onChanged: (SingingCharacter? value) {
      //         setState(() {
      //           _character = value;
      //         });
      //       },
      //     ),
      //   ),
      // ],
    );
  }
}
