import 'package:flutter/material.dart';

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
                  children: [],
                ),
                Row(
                  children: [],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}