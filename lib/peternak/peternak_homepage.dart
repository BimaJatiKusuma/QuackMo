import 'package:flutter/material.dart';
import 'package:quackmo/peternak/peternak_pesanan.dart';
import 'package:quackmo/peternak/peternak_transaksi.dart';

class PeternakHomepage extends StatelessWidget {
  const PeternakHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Row(
              children: [
                Image(image: AssetImage('images/peternak_01.png')),
                Column(
                  children: [
                    Text('Hi,Peternak'),
                    Text('Farlin Nurjananti')
                  ],
                )
              ],
            ),
          ),

          Container(
            child: Row(
              children: [
                Image(image: AssetImage('images/peternak_02.png')),
                Column(
                  children: [
                    Text("Pesanan hari ini"),
                    Text("371 produk")
                  ],
                ),
                ElevatedButton(onPressed: (){}, child: Text("Detail"))
              ],
            ),
          ),
          
          Container(
            child: Column(
              children: [
                Text("Kategori"),
                Row(
                  children: [
                    ElevatedButton(onPressed: (){}, child: Column(
                      children: [
                        Image(image: AssetImage('images/produk.png')),
                        Text('Produk')
                      ],
                    )),
                    ElevatedButton(onPressed: (){}, child: Column(
                      children: [
                        Image(image: AssetImage('images/cuaca.png')),
                        Text('Monitoring Cuaca')
                      ],
                    )),
                    ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return PeternakTransaksi();
                      }));
                    }, child: Column(
                      children: [
                        Image(image: AssetImage('images/transaksi.png')),
                        Text('Transaksi')
                      ],
                    ))
                  ],
                ),
                Row(
                  children: [
                    ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return PeternakPesanan();
                      }));
                    }, child: Column(
                      children: [
                        Image(image: AssetImage('images/pesanan.png')),
                        Text('Pesanan Masuk')
                      ],
                    )),
                    ElevatedButton(onPressed: (){}, child: Column(
                      children: [
                        Image(image: AssetImage('images/distribusi.png')),
                        Text('Distribusi')
                      ],
                    )),
                    ElevatedButton(onPressed: (){}, child: Column(
                      children: [
                        Image(image: AssetImage('images/pesan_masuk.png')),
                        Text('Pesan Masuk')
                      ],
                    ))
                  ],
                )
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Keluar'),
      ])
    );
  }
}