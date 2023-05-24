import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class ProdusenDistribusi extends StatefulWidget {
  const ProdusenDistribusi({super.key});

  @override
  State<ProdusenDistribusi> createState() => _ProdusenDistribusiState();
}

class _ProdusenDistribusiState extends State<ProdusenDistribusi> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(225, 202, 167, 1),
        title: Text("Distribusi Masuk"),
        centerTitle: true,
        leading: PreferredSize(
          preferredSize: Size(10, 10),
          child: ElevatedButton(onPressed: (){
            Navigator.pop(context);
          },
            style: ElevatedButton.styleFrom(
              backgroundColor: Color.fromRGBO(225, 202, 167, 1),
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(60),
                side: BorderSide(color: Colors.white),
              ),
            ),
            child: Icon(Icons.arrow_back_ios_new,)),
        ),
      ),
      body: Container(
        padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Distribusi Produk"),
            SizedBox(height: 20,),
            Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Sekarang"),
                  InkWell(
                    // onTap: () {
                    //   showDialog(
                    //     context: context,
                    //     builder: (_){
                    //       return AlertDialog(
                    //         shape: RoundedRectangleBorder(
                    //           borderRadius: BorderRadius.circular(10)
                    //         ),
                    //         titlePadding: EdgeInsets.zero,
                    //         // insetPadding: EdgeInsets.zero,
                    //         // contentPadding: EdgeInsets.zero,
                    //         // clipBehavior: Clip.antiAliasWithSaveLayer,
                    //         backgroundColor: Color.fromRGBO(250, 250, 250, 1),
                    //         title: Container(
                    //           decoration: BoxDecoration(
                    //             borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)),
                    //             color: Color.fromRGBO(225, 202, 167, 1),
                    //           ),
                    //           alignment: Alignment.center,
                    //           height: 30,
                    //           child: Text("Pemberitahuan", textAlign: TextAlign.center,),
                    //         ),
                    //         content: Text("Distribusi selesai ?", textAlign: TextAlign.center,),
                    //         actions: [
                    //           ElevatedButton(onPressed: (){}, child: Text("Tidak"), style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),),
                    //           ElevatedButton(onPressed: (){}, child: Text("Ya"), style: ElevatedButton.styleFrom(backgroundColor: Color.fromRGBO(225, 207, 167, 1), foregroundColor: Colors.black),)
                    //         ],
                    //         actionsAlignment: MainAxisAlignment.spaceAround,
                    //       );
                    //     }
                    //   );

                    // },
                    splashColor: Color.fromRGBO(225, 202, 167, 1),
                    child: Ink(
                      padding: EdgeInsets.fromLTRB(5, 5, 5, 5),
                      decoration: BoxDecoration(
                        color: Color.fromRGBO(241, 241, 241, 1),
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey,
                            blurRadius: 5
                          )
                        ]
                      ),
                      child: Table(
                        columnWidths: {1:FractionColumnWidth(.8)},
                        children: [
                          TableRow(
                            children: [
                              Container(
                                // color: Colors.blue,
                                child: Image(image: AssetImage("images/distribution.png"))),
                              Container(
                                // color: Colors.amber,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Produsen Telur Asin Ady", style: TextStyle(fontWeight: FontWeight.w600),),
                                    Text("Pengantar: Farhaz"),
                                    Text("Produk: Telur Bebek Hibrida"),
                                    Text("Jumlah: 3 Butir")
                                  ],
                                ),
                              ),
                              Icon(Icons.check_circle_outline_rounded, color: Color.fromRGBO(225, 202, 167, 1),)
                            ]
                          ),
                          
                          TableRow(
                            children: [
                              Icon(Icons.location_on),
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Text("Jl. Mawar no. 11, kab. Kaliwates",)),
                              Container(), 
                            ]
                          ),
                          TableRow(
                            children: [
                              Icon(Icons.access_time_filled_rounded),
                              TableCell(
                                verticalAlignment: TableCellVerticalAlignment.middle,
                                child: Text("Dalam perjalanan")),
                              Container(),
                            ]
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}