import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';


class Cuaca extends StatefulWidget {
  const Cuaca({super.key});

  @override
  State<Cuaca> createState() => _CuacaState();
}

class _CuacaState extends State<Cuaca> {
  String dataCuaca = "";
  String namaKota = "jember";
  TextEditingController kotaController = TextEditingController();

  late Future _data;

  Future getDataCuaca() async {
    Uri url = Uri.parse("https://api.openweathermap.org/data/2.5/forecast?q=$namaKota&appid=69bb7ab71dec32d98ebab160cf39cb85");
    
    final res = await http.get(url);
    print(res.statusCode);
    if (res.statusCode == 404 || res.statusCode == 400){
      return Error();
    }
    if (res.statusCode == 200){
      return res.body;
    }
  }


  @override
  void initState() {
    // getDataCuaca();
    _data = getDataCuaca();
    super.initState();
  }
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          height: 50 ,
          child: TextFormField(
                controller: kotaController,
                decoration: InputDecoration(
                  suffix: IconButton(onPressed: (){
                    setState(() {
                      namaKota = kotaController.text.toLowerCase();
                    });
                    _data = getDataCuaca();
                  },icon: Icon(Icons.search, color: Colors.black,)),
        
                  filled: true,
                  fillColor: Colors.white,
                  // contentPadding: EdgeInsets.fromLTRB(20, 20, 20,20),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none),
                  hintText: "cari daerah",
                  ),
              ),
        ),
        backgroundColor: Color.fromRGBO(225, 202, 167,1),
        centerTitle: true,
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: _data,
            builder: (context, snapshot){
              if (snapshot.hasError){
                return Text("terjadi kesalahan ${snapshot.hasError}");
              }
              if (snapshot.hasData){
                if (snapshot.data.runtimeType == Error){
                  return Center(child: Text("Data Tidak ditemukan"),);
                }
                final newData = jsonDecode(snapshot.data);
                final newData_new = jsonDecode(snapshot.data)["list"];
                final timezone = newData["city"]["timezone"];
                
                return Expanded(
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        height: 30,
                        child: Text("Prediksi Cuaca Terkini di ${newData["city"]["name"]}", style: TextStyle(fontWeight: FontWeight.w600),)
                        ),
                      Expanded(
                        child: ListView.builder(
                          itemCount: newData_new.length,
                          itemBuilder: (context, index) {
                            var current_data = newData_new[index];
                            var waktu = current_data["dt"];
                            var temp = (current_data["main"]["temp"] - 273);
                            var date = DateFormat('HH:mm d MMMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(waktu * 1000));
                            // var date = DateFormat('HH:mm d MMMM yyyy').format(DateTime.fromMillisecondsSinceEpoch(waktu * 1000).add(Duration(seconds: timezone)));

                            return Container(
                              margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                              padding: EdgeInsets.fromLTRB(10, 5, 10, 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.5),
                                    spreadRadius: 3,
                                    blurRadius: 3,
                                    offset: Offset(0, 3)
                                  )
                                ]
                              ),
                              child: Column(
                                children: [
                                  Text("${date}"),
                                  Image.network('http://openweathermap.org/img/w/${current_data["weather"][0]["icon"]}.png',),
                                  Text("${current_data["weather"][0]["main"]} : ${current_data["weather"][0]["description"]}"),
                                  Text("Suhu: ${double.parse((temp).toStringAsFixed(2))} Celcius")
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
                
              }
              else{
                return Center(child: CircularProgressIndicator());
              }
            }
            ),
        ],
      ),
    );
  }
}
