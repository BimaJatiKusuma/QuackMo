import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quackmo/peternak/peternak_transaksi/peternak_transaksi.dart';

class PeternakTransaksiDetailDone extends StatelessWidget {
  const PeternakTransaksiDetailDone ({super.key});

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: Center(
      child: Column(
        children: [
          Icon(Icons.check_circle),
          Text('TRANSAKSI BERHASIL DISETUJUI'),
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          }, child: Text('Kembali'))
        ],
      ),
    ),
    );
    
  }
}