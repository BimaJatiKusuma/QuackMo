import 'package:flutter/material.dart';

class PeternakPesanan extends StatelessWidget {
  const PeternakPesanan({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: BackButton(
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Title(color: Colors.indigo, child: Text("Transaksi")),
        ),
        body: ListView(
          children: [
            Text("Semua Pesanan"),
            Column(
              children: [
                Text("1 April 2023"),
                TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) => AlertDialog(
                      title: const Text('Pemberitahuan'),
                      content: const Text('Pemesanan disetujui'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Tidak'),
                          child: const Text('Tidak'),
                        ),
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Ya'),
                          child: const Text('Ya'),
                        ),
                      ],
                    ),
                  );
                },
                child: Card(
                      child: Row(children: [
                        Icon(Icons.square),
                        Column(
                          children: [
                            Text('Telur Hibrida'),
                            Text('Produsen Telur Asin Ady'),
                            Text('Pemesanan: 1 butir telur'),
                            Text('Menunggu konfirmasi pemesanan')
                          ],
                        ),
                        Icon(Icons.check_circle_outline),
                      ]),
                    ),
                ),
              ],
            ),



            InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    Text('1 April 2023'),
                    Card(
                      child: Row(children: [
                        Icon(Icons.square),
                        Column(
                          children: [
                            Text('Telur Hibrida'),
                            Text('PT. Jaya Abadi'),
                            Text('Pemesanan: 1 butir telur'),
                            Text('Pemesanan telah dibatalkan')
                          ],
                        ),
                        Icon(Icons.close_rounded),
                      ]),
                    ),
                  ],
                )),

            InkWell(
                onTap: () {},
                child: Column(
                  children: [
                    Text('1 April 2023'),
                    Card(
                      child: Row(children: [
                        Icon(Icons.square),
                        Column(
                          children: [
                            Text('Telur Hibrida'),
                            Text('PT. Jaya Abadi'),
                            Text('Pemesanan: 1 butir telur'),
                            Text('Telah disetujui')
                          ],
                        ),
                        Icon(Icons.check_circle),
                      ]),
                    ),
                  ],
                )),

          ],
        ));
  }
}

// class PeternakPesananKonfirmasi extends StatelessWidget {
//   const PeternakPesananKonfirmasi({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return TextButton(onPressed: () {}, child: Text("test"));
//   }
// }
