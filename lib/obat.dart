import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_uas_fadila/homepage.dart';
import 'package:project_uas_fadila/keranjang.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ObatPage extends StatefulWidget {
  const ObatPage({super.key});

  @override
  State<ObatPage> createState() => _ObatPageState();
}

class _ObatPageState extends State<ObatPage> {
  List<dynamic> dataObat = [];
  String userId = '';
  Future<void> getUserId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = prefs.getString('user_id') ?? '';
    });
  }

  Future<void> getDataObat() async {
    String urlObat = "http://10.0.3.2/backend_project/obat.php";
    try {
      var response = await http.get(Uri.parse(urlObat));
      setState(() {
        dataObat = jsonDecode(response.body);
      });
    } catch (exc) {
      if (kDebugMode) {
        print(exc);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getUserId();
    getDataObat();
  }

  void itemDataTap(index) {
    final item = dataObat[index];
    if (kDebugMode) {
      print("Nama Obat : $item['nama_obat]");
    }
    Navigator.of(context).push(MaterialPageRoute(
      builder: (BuildContext context) => DetailScreen(item: item),
    ));
    // if (userId.isNotEmpty) {
    //   Navigator.of(context).push(MaterialPageRoute(
    //     builder: (BuildContext context) =>
    //         DetailScreen(item: item),
    //   ));
    // }
    // else {
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     const SnackBar(content: Text('User ID belum tersedia')),
    //   );
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 55, 184),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 18,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => const HomePage(),
              ),
            );
          },
        ),
        title: const Text(
          "Toko Obat",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.cart,
              size: 22,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.search,
              size: 22,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: Center(
          child: GridView.builder(
              reverse: false,
              scrollDirection: Axis.vertical,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0),
              itemCount: dataObat.length,
              itemBuilder: (context, index) {
                final itemData = dataObat[index];
                return GestureDetector(
                  onTap: () {
                    itemDataTap(index);
                  },
                  child: Card(
                    child: Column(
                      children: [
                        Image.network(
                          itemData['image'],
                          height: 125,
                          width: 150,
                          fit: BoxFit.fill,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes !=
                                        null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                        (loadingProgress.expectedTotalBytes ??
                                            1)
                                    : null,
                              );
                            }
                          },
                          errorBuilder: (context, error, stackTrace) {
                            return const Text(
                              "Error Loading Obat Image",
                              textAlign: TextAlign.justify,
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
                          child: Text(
                            itemData['nama_obat'],
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(30, 5, 5, 5),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Harga produk
                              Text(
                                'Rp.${itemData['harga'].toString()}',
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              })),
    );
  }
}

class DetailScreen extends StatelessWidget {
  final dynamic item;
  // final String userId;
  // const DetailScreen({Key? key, required this.item}) : super(key: key);

  const DetailScreen({Key? key, required this.item}) : super(key: key);
  Future<void> addToCart(BuildContext context) async {
    var response = await http.post(
      Uri.parse('http://10.0.3.2/backend_project/add_keranjang.php'),
      body: {
        // 'user_id': userId, // Menggunakan userId yang di-passing
        'obat_id': item['id_obat'].toString(),
      },
    );

    var data = jsonDecode(response.body);
    if (data['value'] == '1') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Produk berhasil ditambahkan ke keranjang!')),
      );
    } else if (data['value'] == '2') {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Produk sudah ada di keranjang.')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menambahkan ke keranjang!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 55, 184),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            size: 18,
            color: Colors.white,
          ),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => ObatPage(),
              ),
            );
          },
        ),
        title: const Text(
          "Obat",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const Keranjang(
                      userId: 'userId'), // Pass the userId if needed
                ),
              );
            },
            icon: const Icon(
              CupertinoIcons.cart,
              size: 22,
              color: Colors.white,
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(
              CupertinoIcons.search,
              size: 22,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        // Make the body scrollable
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
              10, 10, 10, 0), // Reduced top padding for the whole body
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(
                    40, 10, 10, 0), // Reduced padding for the image
                child: Image.network(
                  item['image'],
                  width: 250,
                  height: 300,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 5, 30,
                    10), // Reduced padding between image and nama_obat
                child: Text(
                  item['nama_obat'],
                  style: const TextStyle(
                    fontSize: 20,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(250, 5, 30, 10),
                child: Text(
                  'Rp.${item['harga'].toString()}',
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Text(
                  "Obat Description",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 30, 10),
                child: Text(
                  item['deskripsi'],
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Text(
                  "Indikasi Umum",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 30, 10),
                child: Text(
                  item['indikasi_umum'],
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Text(
                  "Dosis",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 30, 10),
                child: Text(
                  item['dosis'],
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.fromLTRB(10, 5, 10, 0),
                child: Text(
                  "Komposisi",
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(10, 0, 30, 10),
                child: Text(
                  item['komposisi'],
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.black,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Center(
                  child: Container(
                    height: 55,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      gradient: const LinearGradient(
                        colors: [
                          Color.fromARGB(255, 23, 55, 184),
                          Color(0xff281537),
                        ],
                      ),
                    ),
                    child: ElevatedButton(
                      onPressed: () {
                        //addToCart(context);  // Panggil fungsi tambah ke keranjang
                      },
                      style: ElevatedButton.styleFrom(
                        shadowColor: Colors.transparent,
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 30),
                      ),
                      child: const Text(
                        'ADD TO CART',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
