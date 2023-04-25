import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:quackmo/peternak/daftarproduk/peternak_daftar_produk.dart';
import 'package:quackmo/peternak/peternak_login.dart';
import 'package:quackmo/peternak/peternak_pemesanan/peternak_pesanan.dart';
import 'package:quackmo/peternak/peternak_transaksi/peternak_transaksi.dart';

import 'package:quackmo/login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';



class PeternakHomepage extends StatefulWidget {
  const PeternakHomepage({super.key});

  @override
  State<PeternakHomepage> createState() => _PeternakHomepageState();
}

int _index = 0;

class _PeternakHomepageState extends State<PeternakHomepage> {
  @override
  Widget build(BuildContext context) {
  Widget child = Container();

  switch(_index) {
    case 0:
      child = PeternakMainHomePage();
      break; 

    case 1:
      
      break;
    
    case 2:
      _index=0;
      _logout(context);
  }

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (int index) => setState(() => _index = index),
        items: [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
        BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Keluar'),
      ],
        currentIndex: _index,
      )
    );
  }
}





_logout(context){
  SchedulerBinding.instance.addPostFrameCallback((_) {
    userPeternakID='';
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context){
        return Login();
        }), (route) => false);
  });
}













class PeternakMainHomePage extends StatefulWidget {
  const PeternakMainHomePage({super.key});

  @override
  State<PeternakMainHomePage> createState() => _PeternakMainHomePageState();
}

class _PeternakMainHomePageState extends State<PeternakMainHomePage> {
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
                    Text(userPeternakID),
                    Text('Hai, Peternak'),
                    Text(userNamaPeternak),
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
                    ElevatedButton(onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                        return PeternakDaftarProduk();
                      }));
                    }, child: Column(
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
    );
  }
}
























// class PeternakHomepage extends StatelessWidget {
//   const PeternakHomepage({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         children: [
//           Container(
//             child: Row(
//               children: [
//                 Image(image: AssetImage('images/peternak_01.png')),
//                 Column(
//                   children: [
//                     Text('Hi,Peternak'),
//                     Text('Farlin Nurjananti')
//                   ],
//                 )
//               ],
//             ),
//           ),

//           Container(
//             child: Row(
//               children: [
//                 Image(image: AssetImage('images/peternak_02.png')),
//                 Column(
//                   children: [
//                     Text("Pesanan hari ini"),
//                     Text("371 produk")
//                   ],
//                 ),
//                 ElevatedButton(onPressed: (){}, child: Text("Detail"))
//               ],
//             ),
//           ),
          
//           Container(
//             child: Column(
//               children: [
//                 Text("Kategori"),
//                 Row(
//                   children: [
//                     ElevatedButton(onPressed: (){}, child: Column(
//                       children: [
//                         Image(image: AssetImage('images/produk.png')),
//                         Text('Produk')
//                       ],
//                     )),
//                     ElevatedButton(onPressed: (){}, child: Column(
//                       children: [
//                         Image(image: AssetImage('images/cuaca.png')),
//                         Text('Monitoring Cuaca')
//                       ],
//                     )),
//                     ElevatedButton(onPressed: (){
//                       Navigator.push(context, MaterialPageRoute(builder: (context){
//                         return PeternakTransaksi();
//                       }));
//                     }, child: Column(
//                       children: [
//                         Image(image: AssetImage('images/transaksi.png')),
//                         Text('Transaksi')
//                       ],
//                     ))
//                   ],
//                 ),
//                 Row(
//                   children: [
//                     ElevatedButton(onPressed: (){
//                       Navigator.push(context, MaterialPageRoute(builder: (context){
//                         return PeternakPesanan();
//                       }));
//                     }, child: Column(
//                       children: [
//                         Image(image: AssetImage('images/pesanan.png')),
//                         Text('Pesanan Masuk')
//                       ],
//                     )),
//                     ElevatedButton(onPressed: (){}, child: Column(
//                       children: [
//                         Image(image: AssetImage('images/distribusi.png')),
//                         Text('Distribusi')
//                       ],
//                     )),
//                     ElevatedButton(onPressed: (){}, child: Column(
//                       children: [
//                         Image(image: AssetImage('images/pesan_masuk.png')),
//                         Text('Pesan Masuk')
//                       ],
//                     ))
//                   ],
//                 )
//               ],
//             ),
//           ),
//         ],
//       ),
//       bottomNavigationBar: BottomNavigationBar(items: [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
//         BottomNavigationBarItem(icon: Icon(Icons.logout), label: 'Keluar'),
//       ])
//     );
//   }
// }