import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
   List<dynamic> dataRiwayat = [];

 Future<void> getDataRiwayat() async {
  const String urlRiwayat = "http://10.0.3.2/backend_project/riwayat.php";
  try {
    final response = await http.get(Uri.parse(urlRiwayat));
    setState(() {
      dataRiwayat = jsonDecode(response.body);
    });
    if (kDebugMode) {
      print('Data Berita: $dataRiwayat');
    }
  } catch (exc) {
    if (kDebugMode) {
      print(exc);
    }
  }
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: dataRiwayat.length,
          itemBuilder: (context, index) {
            final itemData = dataRiwayat[index];
            return GestureDetector(
              onTap: () => itemData(index),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar Berita
                      // Informasi Berita
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itemData['nama_obat'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              'Rp.${itemData['harga'].toString()}',
                              style: const TextStyle(fontSize: 14, color: Colors.black54),
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
    );
  }
}