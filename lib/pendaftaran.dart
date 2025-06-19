import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_session_manager/flutter_session_manager.dart';
import 'package:http/http.dart' as http;
import 'package:project_uas_fadila/homepage.dart';
import 'package:project_uas_fadila/riwayat.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PendaftaranPasien extends StatefulWidget {
  const PendaftaranPasien({super.key});

  @override
  State<PendaftaranPasien> createState() => _PendaftaranPasienState();
}

class _PendaftaranPasienState extends State<PendaftaranPasien> {
  // final _user_id = TextEditingController();
  final _tgl_konsul = TextEditingController();
  final _keluhan_pasien = TextEditingController();
  List<Map<String, dynamic>> poliData =
      []; // List untuk menyimpan poli dan id_dokter
  String? selectedPoli;
  int? selectedDoctorId;

  @override
  void initState() {
    super.initState();
    _getUserId(); // Fetch stored user_id
    _fetchPoliData(); // Fetch poli data
  }

  // Function to get user_id from SharedPreferences
  _getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    // setState(() {
    //   _user_id.text = prefs.getString('user_id') ?? ''; // Retrieve user_id
    // });
  }

  // Function to fetch poli data from the server
  _fetchPoliData() async {
    String url = 'http://10.0.2.2/backend_project/get_poli.php';
    try {
      var response = await http.get(Uri.parse(url));
      var data = json.decode(response.body);
      print('Data from API: $data'); // Debugging to ensure data is received

      if (data != null && data['data'] != null) {
        setState(() {
          poliData = List<Map<String, dynamic>>.from(data['data']);
          print('Poli Data: $poliData');

          if (poliData.isNotEmpty && selectedPoli == null) {
            selectedPoli = poliData[0]['poli'];
            selectedDoctorId = poliData[0]['id_dokter'];
          }
        });
      }
    } catch (e) {
      print("Failed to load poli data: $e");
    }
  }

  // Function to register a new consultation
  Future<void> addNewPendaftaran() async {
    String urlNewPendaftaran =
        'http://10.0.2.2/backend_project/add_konsultasi.php';
    dynamic user_id = await SessionManager().get("id");
    print("user id = $user_id");

    try {
      var resAddPendaftaran = await http.post(
        Uri.parse(urlNewPendaftaran),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "user_id": user_id,
          "dokter_id": selectedDoctorId.toString(),
          "tgl_konsul": _tgl_konsul.text.toString(),
          "keluhan_pasien": _keluhan_pasien.text.toString()
        }),
      );

      print('Response body: ${resAddPendaftaran.body}');
      var bodyAddProduct = json.decode(resAddPendaftaran.body);

      // Ubah pengecekan ke JSON object
      if (bodyAddProduct['success'] != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Pendaftaran berhasil dilakukan')),
        );
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const HomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to Add New Konsultasi')),
        );
      }
    } catch (exc) {
      print(exc);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Terjadi kesalahan, coba lagi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 55, 184),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 18, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (BuildContext context) => const HomePage()),
            );
          },
        ),
        title: const Text(
          "Pendaftaran Pasien",
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // const SizedBox(height: 20),
              // TextFormField(
              //   controller: _user_id,
              //   decoration: InputDecoration(
              //     labelText: 'User ID',
              //     prefixIcon: const Icon(Icons.person),
              //     border: OutlineInputBorder(
              //       borderRadius: BorderRadius.circular(10.0),
              //     ),
              //   ),
              //   keyboardType: TextInputType.number,
              // ),
              const SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: selectedPoli, // Set the default value
                decoration: InputDecoration(
                  labelText: 'Pilih Poli',
                  prefixIcon: Icon(Icons.local_hospital),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                items: poliData.map((Map<String, dynamic> poli) {
                  return DropdownMenuItem<String>(
                    value: poli['poli'],
                    child: Text(poli['poli']),
                  );
                }).toList(),
                onChanged: (String? newPoli) {
                  setState(() {
                    selectedPoli = newPoli;
                    selectedDoctorId = poliData.firstWhere(
                        (poli) => poli['poli'] == newPoli)['id_dokter'];
                  });
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _tgl_konsul,
                decoration: InputDecoration(
                  labelText: 'Tanggal Konsultasi',
                  prefixIcon: const Icon(Icons.calendar_today),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.datetime,
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _keluhan_pasien,
                decoration: InputDecoration(
                  labelText: 'Keluhan Pasien',
                  prefixIcon: const Icon(Icons.healing),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    if (selectedPoli != null) {
                      addNewPendaftaran(); // Call the function to add data
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Silakan pilih poli')),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 23, 55, 184),
                    padding: const EdgeInsets.symmetric(
                        vertical: 14.0, horizontal: 40.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  child: const Text(
                    'DAFTAR',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: Colors.white,
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
