import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:quackmo/peternak/peternak_transaksi/peternak_transaksi_detail_done.dart';

class PeternakTransaksiDetail extends StatelessWidget {
  const PeternakTransaksiDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: (){
            Navigator.pop(context);
          },
        ),
        title: Text('Detail Transaksi'),
      ),
      body: Column(
        children: [
          Container(
            child: Column(
              children: [
                Text('Transfer Rupiah'),
                Text('Transfer Berhasil!'),
                Text('30 April 2023 - 23:16:04 - No. Ref 193243453857')
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Text('Penerima'),
                Text('Farlin Nurjananti'),
                Text('Bank Mandiri - 2433539556669')
              ],
            ),
          ),
          Container(
            child: Column(
              children: [
                Text('Detail Transaksi'),
                Row(
                  children: [
                    Column(
                      children: [
                        Text("Metode Transfer"),
                        Text("Total Transaksi")
                      ],
                    ),
                    Column(
                      children: [
                        Text('Sesama Bank Mandiri'),
                        Text('Rp. 20.000')
                      ],
                    )
                  ],
                )
              ],
            ),
          ),

          Container(
            child: Column(
              children: [
                Text('Bukti Transaksi'),
                Image(image: AssetImage('images/bukti_transaksi.png')),
                ElevatedButton(onPressed: (){
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
                    return PeternakTransaksiDetailDone();
                  }));
                }, child: Text('Setujui Pembayaran'))
              ],
            ),
          )
        ],
      ),
    );
  }
}