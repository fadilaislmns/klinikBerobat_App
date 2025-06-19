import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class PageBerita extends StatefulWidget {
  const PageBerita({super.key});

  @override
  State<PageBerita> createState() => _PageBeritaState();
}

class _PageBeritaState extends State<PageBerita> {
  List<dynamic> dataBerita = [];

  Future<void> getDataBerita() async {
    const String urlBerita = "http://10.0.2.2/backend_project/berita.php";
    try {
      final response = await http.get(Uri.parse(urlBerita));
      setState(() {
        dataBerita = jsonDecode(response.body);
      });
      if (kDebugMode) {
        print('Data Berita: $dataBerita');
      }
    } catch (exc) {
      if (kDebugMode) {
        print(exc);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    getDataBerita();
  }

  void itemDataTap(int index) {
    final item = dataBerita[index];
    if (kDebugMode) {
      print('Tapped item: $item');
    }
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context) => DetailScreen(item: item),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ListView.builder(
          itemCount: dataBerita.length,
          itemBuilder: (context, index) {
            final itemData = dataBerita[index];
            return GestureDetector(
              onTap: () => itemDataTap(index),
              child: Card(
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Gambar Berita
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.0),
                        child: Image.network(
                          itemData['image'],
                          height: 80,
                          width: 120,
                          fit: BoxFit.cover,
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) {
                              return child;
                            } else {
                              return SizedBox(
                                height: 80,
                                width: 80,
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
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
                      // Informasi Berita
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              itemData['judul'],
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Text(
                              itemData['tgl_upload'],
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
    );
  }
}

class DetailScreen extends StatelessWidget {
  final dynamic item;
  const DetailScreen({Key? key, required this.item}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (kDebugMode) {
      print('Detail Screen Item: $item');
    }

    // Null checks for item fields
    final String imageUrl =
        item['image'] ?? ''; // Default to empty string if null
    // ignore: non_constant_identifier_names
    final String JudulBerita = item['judul'] ?? 'No Title Available';
    // ignore: non_constant_identifier_names
    final String DetailBerita = item['detail'] ?? 'No Description Available';
    final String tanggalUpload = 'Tanggal Upload: ${item['tgl_upload'].toString()}' ?? 'No Date Available';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 55, 184),
        
        title: const Text(
          'Detail Berita',
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
              color: const Color.fromARGB(255, 247, 143, 135), // Set the background color here
              child: Text(
                tanggalUpload,
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              JudulBerita,
              style: const TextStyle(
                fontSize: 20,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            Center(
              child: imageUrl.isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 400,
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : const Icon(Icons.broken_image, size: 100),
            ),
            const SizedBox(height: 10),
            Text(
              DetailBerita,
              style: const TextStyle(
                fontSize: 15,
                color: Colors.black,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
