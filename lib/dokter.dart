import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_uas_fadila/homepage.dart';

class allDoctors extends StatefulWidget {
  const allDoctors({super.key});

  @override
  State<allDoctors> createState() => _allDoctorsState();
}

class _allDoctorsState extends State<allDoctors> {
  List<dynamic> dataDokter = [];
  final searchController = TextEditingController();
  List listAllDokter = [];


  Future<void> getDataDokter() async {
    String urlAllDoctors = "http://10.0.3.2/backend_project/dokter.php";
    try {
      var response = await http.get(Uri.parse(urlAllDoctors));
      setState(() {
        dataDokter = jsonDecode(response.body);
      });
    } catch (exc) {
      print(exc);
    }
  }

  void searchDokter() async {
    final searchD = searchController.text;
    if (searchD.isEmpty) return;
    try {
      String urlSearchDokter =
          "http://10.0.3.2/backend_project/search_dokter.php?search=$searchD";
      var responseSearch = await http.get(Uri.parse(urlSearchDokter));
      final List listSearch = json.decode(responseSearch.body);
      setState(() {
        listAllDokter = listSearch;
      });
    } catch (exc) {
      if (kDebugMode) {
        print("Failed to load products");
      }
      ;
    }
  }

  @override
  void initState() {
    super.initState();
    getDataDokter();
  }

  void itemDataTap(index) {
    final item = dataDokter[index];
    if (kDebugMode) {
      print("Nama Dokter : ${item['nama_dokter']}");
    }
    Navigator.of(context).push(MaterialPageRoute(
        builder: (BuildContext context) => DetilScreen(item: item)));
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
          "List Dokter",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      // bottomNavigationBar: BottomNavigationBar(
      //   currentIndex: 0,
      //   onTap: (index) {},
      //   backgroundColor: const Color.fromARGB(255, 23, 55, 184),
      //   selectedItemColor: const Color.fromARGB(
      //       255, 120, 181, 232), // Warna untuk item yang dipilih
      //   unselectedItemColor: const Color.fromARGB(
      //       179, 253, 252, 252), // Warna untuk item yang tidak dipilih
      //   type: BottomNavigationBarType.fixed, // Menjaga warna tetap konsisten
      //   items: const <BottomNavigationBarItem>[
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.home, size: 18, color: Colors.white),
      //         label: 'Home'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.newspaper, size: 18, color: Colors.white),
      //         label: 'Berita'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.history, size: 18, color: Colors.white),
      //         label: 'Riwayat'),
      //     BottomNavigationBarItem(
      //         icon: Icon(Icons.person, size: 18, color: Colors.white),
      //         label: 'Profil'),
      //   ],
      // ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              controller: searchController,
              autocorrect: true,
              decoration: const InputDecoration(
                labelText: "Cari Dokter Yang Kamu Inginkan",
                hintText: "Search",
                labelStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
                prefixIcon: Align(
                  widthFactor: 1.0,
                  heightFactor: 1.0,
                  child: Icon(
                    CupertinoIcons.search,
                    color: Colors.blue,
                  ),
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(
                      width: 3.0, color: Colors.grey, style: BorderStyle.solid),
                  borderRadius: BorderRadius.all(Radius.circular(1)),
                ),
              ),
              onChanged: (search) => searchDokter(),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              itemCount: listAllDokter.isNotEmpty
                  ? listAllDokter.length
                  : dataDokter.length,
              itemBuilder: (context, index) {
                final itemData = listAllDokter.isNotEmpty
                    ? listAllDokter[index]
                    : dataDokter[index];
                return GestureDetector(
                  onTap: () {
                    itemDataTap(index);
                  },
                  child: Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Gambar Dokter
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.network(
                              itemData['image'],
                              height: 80,
                              width: 80,
                              fit: BoxFit.cover,
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) {
                                  return child;
                                } else {
                                  return SizedBox(
                                    height: 80,
                                    width: 80,
                                    child: Center(
                                      child: CircularProgressIndicator(
                                        value: loadingProgress
                                                    .expectedTotalBytes !=
                                                null
                                            ? loadingProgress
                                                    .cumulativeBytesLoaded /
                                                (loadingProgress
                                                        .expectedTotalBytes ??
                                                    1)
                                            : null,
                                      ),
                                    ),
                                  );
                                }
                              },
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  height: 80,
                                  width: 80,
                                  color: Colors.grey,
                                  child: const Icon(Icons.broken_image,
                                      color: Colors.white),
                                );
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Informasi Dokter
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  itemData['nama_dokter'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  itemData['poli'],
                                  style: const TextStyle(
                                      fontSize: 14, color: Colors.black54),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class DetilScreen extends StatelessWidget {
  final dynamic item;
  const DetilScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          item['nama_dokter'],
          style: const TextStyle(
              color: Colors.black, fontSize: 16, fontWeight: FontWeight.bold),
        ),
      ),
     
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(60, 10, 10, 0),
            child: Image.network(
              item['image'],
              width: 250,
              height: 300,
            ),
          ),
          
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 30, 10),
            child: Text(
              item['poli'],
              style: const TextStyle(
                backgroundColor: Colors.blueAccent,
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(30, 5, 10, 0),
            child: Text(
              "Detail Dokter",
              style: TextStyle(
                fontSize: 15,
                color: Colors.blueGrey,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(30, 0, 30, 10),
            child: Text(
              item['deskripsi'],
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
