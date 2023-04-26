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
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.black,
        backgroundColor: Color.fromRGBO(225, 202, 167, 1),
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
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(color: Color.fromRGBO(245, 233, 215, 1)),
              child: Row(
                children: [
                  Image(image: AssetImage('images/peternak_01.png')),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Text(userPeternakID),
                      Text('Hai, Peternak'),
                      Text(userNamaPeternak, textAlign: TextAlign.left, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),),
                    ],
                  )
                ],
              ),
            ),
    
            Container(
              width: double.infinity,
              decoration: BoxDecoration(color: Color.fromRGBO(225,202,167,1)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Image(image: AssetImage('images/peternak_02.png')),
                  Column(
                    children: [
                      Text("Pesanan hari ini"),
                      Text("371 produk")
                    ],
                  ),
                  ElevatedButton(onPressed: (){},
                    style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(208, 155, 76, 1), foregroundColor: Colors.white),
                    child: Text("Detail"))
                ],
              ),
            ),
            
            Container(
              padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
              child: Column(
                children: [
                  SizedBox(
                    width: double.infinity,
                  child: Text("Kategori", textAlign: TextAlign.left, style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: ElevatedButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return PeternakDaftarProduk();
                          }));
                        },
                          style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(250, 250, 250, 1), foregroundColor: Colors.black, shadowColor: Colors.black, elevation: 10),
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(image: AssetImage('images/produk.png')),
                            Text('Produk', textAlign: TextAlign.center,)
                          ],
                        )),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        child: ElevatedButton(onPressed: (){},
                          style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(250, 250, 250, 1), foregroundColor: Colors.black, shadowColor: Colors.black, elevation: 10),
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(image: AssetImage('images/cuaca.png')),
                            Text('Monitoring Cuaca', textAlign: TextAlign.center,)
                          ],
                        )),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        child: ElevatedButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return PeternakTransaksi();
                          }));
                        },
                          style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(250, 250, 250, 1), foregroundColor: Colors.black, shadowColor: Colors.black, elevation: 10),
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Image(image: AssetImage('images/transaksi.png')),
                            Text('Transaksi', textAlign: TextAlign.center,)
                          ],
                        )),
                      )
                    ],
                  ),
                  
                  SizedBox(height:20),
    
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 100,
                        height: 100,
                        child: ElevatedButton(onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context){
                            return PeternakPesanan();
                          }));
                        },
                          style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(250, 250, 250, 1), foregroundColor: Colors.black, shadowColor: Colors.black, elevation: 10),
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(image: AssetImage('images/pesanan.png')),
                            Text('Pesanan Masuk', textAlign: TextAlign.center,)
                          ],
                        )),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        child: ElevatedButton(onPressed: (){},
                          style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(250, 250, 250, 1), foregroundColor: Colors.black, shadowColor: Colors.black, elevation: 10),
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image(image: AssetImage('images/distribusi.png')),
                            Text('Distribusi', textAlign: TextAlign.center,)
                          ],
                        )),
                      ),
                      Container(
                        width: 100,
                        height: 100,
                        child: ElevatedButton(onPressed: (){},
                          style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(250, 250, 250, 1), foregroundColor: Colors.black, shadowColor: Colors.black, elevation: 10),
                          child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Image(image: AssetImage('images/pesan_masuk.png')),
                            Text('Pesan Masuk', textAlign: TextAlign.center,)
                          ],
                        )),
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
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