import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;

class RiwayatPage extends StatefulWidget {
  const RiwayatPage({super.key});

  @override
  State<RiwayatPage> createState() => _RiwayatPageState();
}

class _RiwayatPageState extends State<RiwayatPage> {
  List<dynamic> dataRiwayat = [];
  bool isLoading = true;

  // Fungsi untuk mendapatkan data riwayat konsultasi berdasarkan user_id
  Future<void> getDataRiwayat() async {
    dynamic userId = await SessionManager().get("id");

    if (userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Anda belum login')),
      );
      return;
    }

    final String urlRiwayat = 'http://10.0.2.2/backend_project/riwayat.php?user_id=$userId';

    try {
      final response = await http.get(Uri.parse(urlRiwayat));

      if (response.statusCode == 200) {
        setState(() {
          dataRiwayat = jsonDecode(response.body)['riwayat'];
          isLoading = false;
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (exc) {
      if (kDebugMode) {
        print(exc);
      }
      setState(() {
        isLoading = false;
      });
    }
  }

  // Fungsi untuk menghapus produk
  Future<void> deleteRiwayat(String id) async {
    String urlDelete = "http://10.0.2.2/backend_project/delete_riwayat.php";

    try {
      var responseDelete = await http.post(
        Uri.parse(urlDelete),
         headers: {"Content-Type": "application/json"}, // Menambahkan header untuk JSON
      body: jsonEncode({
        "id": id,  // Pastikan id_konsultasi dikirim sebagai JSON
      }),
      );

      if (responseDelete.statusCode == 200) {
        var bodyDelete = jsonDecode(responseDelete.body);
        if (bodyDelete['success'] == true) {
          // Penghapusan berhasil, beri tahu pengguna
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Riwayat berhasil dihapus')),
          );
          // Refresh data setelah penghapusan
          getDataRiwayat();
        } else {
          // Handle failure
          print("Failed to delete product: ${bodyDelete['message']}");
        }
      } else {
        print("Error: ${responseDelete.statusCode}");
      }
    } catch (exc) {
      if (kDebugMode) {
        print(exc);
      }
    }
  }

  // Menampilkan konfirmasi sebelum penghapusan
  Future<void> showDeleteConfirmationDialog(String id) async {
    bool confirmDelete = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Hapus'),
          content: const Text('Apakah Anda yakin ingin menghapus riwayat ini?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // Cancel deletion
              },
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(true);  // Confirm deletion
              },
              child: const Text(
                'Hapus',
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );

    if (confirmDelete == true) {
      deleteRiwayat(id);  // Perform deletion if confirmed
    }
  }

  @override
  void initState() {
    super.initState();
    getDataRiwayat();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : dataRiwayat.isEmpty
              ? const Center(child: Text('Tidak ada riwayat Konsultasi.'))
              : ListView.builder(
                  itemCount: dataRiwayat.length,
                  itemBuilder: (context, index) {
                    var item = dataRiwayat[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: Colors.blueAccent,
                          child: Text(item['nama_penyakit'][0]),
                        ),
                        title: Text(item['nama_penyakit']),
                        subtitle: Text('Tanggal Prediksi: ${item['tanggal']}'),
                        trailing: IconButton(
                          icon: const Icon(
                            CupertinoIcons.delete,
                            color: Colors.red,
                          ),
                          onPressed: () {
                            showDeleteConfirmationDialog(item['id'].toString());
                          },
                        ),
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(item['nama_penyakit']),
                              content: Text('Solusi: ${item['solusi']}'),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Tutup'),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}
