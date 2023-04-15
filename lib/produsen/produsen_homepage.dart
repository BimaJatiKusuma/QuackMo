import 'package:flutter/material.dart';
import 'package:quackmo/produsen/produsen_daftar_peternak.dart';
import 'package:quackmo/produsen/produsen_pesanan.dart';
import 'package:quackmo/produsen/produsen_transaksi.dart';

class ProdusenHomepage extends StatelessWidget {
  const ProdusenHomepage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            child: Row(
              children: [
                Image(image: AssetImage('images/produsen_01.png')),
                Column(
                  children: [
                    Text('Hi,Produsen!'),
                    Text('Farhaz Nurjananto')
                  ],
                )
              ],
            ),
          ),

          //Search
          
          Container(
            child: Column(
              children: [
                Text("Kategori"),
                Row(
                  children: [
                    ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ProdusenDaftarPeternak();
                      }));
                    }, child: Column(
                      children: [
                        Image(image: AssetImage('images/daftar_peternak.png')),
                        Text('List Peternak')
                      ],
                    )),

                    ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ProdusenPesanan();
                      }));
                    }, child: Column(
                      children: [
                        Image(image: AssetImage('images/pesanan.png')),
                        Text('Pemesanan')
                      ],
                    )),


                    ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return ProdusenTransaksi();
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
                    
                    ElevatedButton(onPressed: (){}, child: Column(
                      children: [
                        Image(image: AssetImage('images/distribusi.png')),
                        Text('Distribusi')
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
        //beri action onPress https://stackoverflow.com/questions/57496185/how-to-give-onpress-function-for-bottomnavigationbar-menu-in-flutter
        //bisa dari referensi file praktikum pbm
      ])
    );
  }
}