import 'package:flutter/material.dart';
import 'package:quackmo/produsen/produsen_pesanan.dart';

class ProdusenDaftarProdukDetail extends StatefulWidget {
  const ProdusenDaftarProdukDetail({super.key});

  @override
  State<ProdusenDaftarProdukDetail> createState() =>
      _ProdusenDaftarProdukDetailState();
}

class _ProdusenDaftarProdukDetailState
    extends State<ProdusenDaftarProdukDetail> {
  int total = 1;
  _add() {
    total = total + 1;
    return total;
  }

  _decrease() {
    if (total == 1) {
      total = 1;
    } else {
      total--;
    }
    return total;
  }

  _total(total) {
    return Text("$total");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text("Telur Bebek Hibrida"),
      ),
      body: Column(
        children: [
          Image(image: AssetImage('images/daftar_produk01.png')),
          Container(
            child: Column(
              children: [
                Text("Detail Produk"),
                Container(
                  child: Column(
                    children: [
                      Text("Kondisi: Baru"),
                      Text("Kategori: Telur Bebek"),
                      Text("Stock: 100 Telur"),
                      Text("Berat Satuan: 1 Butir"),
                      Text("Harga: Rp. 2.000 / telur"),
                    ],
                  ),
                ),
                ElevatedButton(
                    onPressed: () async {
                      await showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              content: StatefulBuilder(builder:
                                  (BuildContext context, StateSetter setState) {
                                return Container(
                                  //  height: 200,
                                  child: Column(children: [
                                    Row(
                                      children: [
                                        Container(
                                          child: Row(
                                            children: [
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _add();
                                                    });
                                                  },
                                                  icon: Icon(Icons.add)),
                                              Text("$total"),
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      _decrease();
                                                    });
                                                  },
                                                  icon: Icon(Icons.remove)),
                                            ],
                                          ),
                                        ),
                                        Text("Stock Total: 100")
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("SubTotal:"),
                                        Text("Rp. 30.000")
                                      ],
                                    )
                                  ]),
                                );
                              }),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pushAndRemoveUntil(context,
                                          MaterialPageRoute(builder: (context) {
                                    return ProdusenPesanan();
                                  }), (route) => false),
                                  child: const Text('Pesan Sekarang'),
                                ),
                              ],
                            );
                          });

                      setState(() {});
                    },
                    child: Text("Show Dailog"))
              ],
            ),
          )
        ],
      ),
    );
  }
}
