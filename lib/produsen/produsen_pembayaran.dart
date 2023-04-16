import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:quackmo/produsen/produsen_transaksi.dart';

enum SingingCharacter { lafayette, jefferson }

class ProdusenPembayaran extends StatefulWidget {
  const ProdusenPembayaran({super.key});

  @override
  State<ProdusenPembayaran> createState() => _ProdusenPembayaranState();
}

enum MetodeKirim { Diantar, TidakDiantar }
enum MetodeBayar { Dana, BankMandiri, PembayaranDitempat }

class _ProdusenPembayaranState extends State<ProdusenPembayaran> {
  final formKey = GlobalKey<FormState>();
  String alamat = "";
  MetodeKirim? _metodeKirim = MetodeKirim.Diantar;
  MetodeBayar? _metodeBayar = MetodeBayar.Dana;

  File? buktiFoto;

  Future getImage() async{
    final ImagePicker foto = ImagePicker();
    final XFile? fotoBukti = await foto.pickImage(source: ImageSource.gallery);
    buktiFoto = File(fotoBukti!.path);
    setState(() {
      
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Pembayaran"),
        // backgroundColor: Colors.deepOrangeAccent,
      ),
      body: ListView(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "Metode Pengiriman",
                  style: TextStyle(fontSize: 18),
                ),
                // Divider(),
                RadioListTile(
                  title: Text("Diantar"),
                  value: MetodeKirim.Diantar,
                  groupValue: _metodeKirim,
                  onChanged: (MetodeKirim? value) {
                    setState(() {
                      _metodeKirim = value;
                    });
                  },
                ),
                RadioListTile(
                  title: Text("Diambil Sendiri"),
                  value: MetodeKirim.TidakDiantar,
                  groupValue: _metodeKirim,
                  onChanged: (MetodeKirim? value) {
                    setState(() {
                      _metodeKirim = value;
                    });
                  },
                ),
              ],
            ),
          ),

          Container(
            child: Form(
              key: formKey,
              child:
                TextFormField(
                  
                  decoration: InputDecoration(
                    prefixIcon: Padding(padding: EdgeInsets.all(2), child: Icon(Icons.location_on),),
                    hintText: 'masukkan alamat anda'
                  ),
                )
            ),
          ),

          Container(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "Metode Pembayaran",
                  style: TextStyle(fontSize: 18),
                ),
                // Divider(),
                RadioListTile(
                  title: Text("Dana"),
                  value: MetodeBayar.Dana,
                  groupValue: _metodeBayar,
                  onChanged: (MetodeBayar? value) {
                    setState(() {
                      _metodeBayar = value;
                    });
                  },
                ),
                RadioListTile(
                  title: Text("Bank Mandiri"),
                  value: MetodeBayar.BankMandiri,
                  groupValue: _metodeBayar,
                  onChanged: (MetodeBayar? value) {
                    setState(() {
                      _metodeBayar = value;
                    });
                  },
                ),

                RadioListTile(
                  title: Text("Dibayar Ditempat"),
                  value: MetodeBayar.PembayaranDitempat,
                  groupValue: _metodeBayar,
                  onChanged: (MetodeBayar? value) {
                    setState(() {
                      _metodeBayar = value;
                    });
                  },
                ),
              ],
            ),
          ),

          Container(
            child: Column(
              children: [
                Text("Harga: 30.000"),
                Text("Ongkos Kirim"),
                Text("Total Pembayaran: Rp. 35.000")
              ],
            ),
          ),

          Container(
            child: Column(
              children: [
                ElevatedButton(onPressed: () async{
                  await getImage();
                }, child: Text("Masukkan bukti pembayaran")),
                buktiFoto != null ? Container(
                    height: 500,
                    width: MediaQuery.of(context).size.width,
                    child: Image.file(buktiFoto!, fit: BoxFit.cover,))
                    :Container(),
              ],
            ),
          ),


          ElevatedButton(onPressed: (){
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context){
              return ProdusenTransaksi();
            }));
          }, child: Text("Bayar"))
        ],
      ),
    );
  }
}
