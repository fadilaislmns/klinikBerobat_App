import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_uas_fadila/loginscreen.dart';

class RegScreen extends StatefulWidget {
  const RegScreen({Key? key}) : super(key: key);

  @override
  State<RegScreen> createState() => _RegScreenState();
}

class _RegScreenState extends State<RegScreen> {
  String _jenis_kelamin = "Laki-laki"; // Default value
  final _nama = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _alamat = TextEditingController();
  final _tgl_lahir = TextEditingController();

  // Fungsi untuk register pengguna
  Future<void> registerUser() async {
    // Validasi jika ada field yang kosong

    String urlAddPasien = "http://10.0.3.2/backend_project/add_users.php";
    try {
      var resAddPasien = await http.post(Uri.parse(urlAddPasien), body: {
        "nama": _nama.text.toString(),
        "email": _email.text.toString(),
        "password": _password.text.toString(),
        "alamat": _alamat.text.toString(),
        "jenis_kelamin": _jenis_kelamin, // Ambil nilai dari radio button
        "tgl_lahir": _tgl_lahir.text.toString()
      });

      var response = json.decode(resAddPasien.body);

      if (response['message'] == 'New user successfully added') {
        // Show success message
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("New Pasien Successfully Added")),
        );

        // Navigate to the login screen after successful registration
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) =>
                   LoginScreen()), // Replace with your LoginScreen widget
        );
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text("Failed to Add Pasien: ${response['message']}")),
        );
      }
    } catch (exc) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $exc")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: LinearGradient(colors: [
                Color.fromARGB(255, 23, 55, 184),
                Color(0xff281537),
              ]),
            ),
            child: const Padding(
              padding: EdgeInsets.only(top: 40.0, left: 22),
              child: Text(
                'Create Your\nAccount!',
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          // Form Container
          Padding(
            padding: const EdgeInsets.only(top: 170.0),
            child: Container(
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40)),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 18.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextField(
                      controller: _nama,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.check, color: Colors.grey),
                        label: Text(
                          'Nama',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 23, 55, 184),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _email,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.email, color: Colors.grey),
                        label: Text(
                          'Email',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 23, 55, 184),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _password,
                      decoration: const InputDecoration(
                        suffixIcon:
                            Icon(Icons.visibility_off, color: Colors.grey),
                        label: Text(
                          'Password',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 23, 55, 184),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _tgl_lahir,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.date_range, color: Colors.grey),
                        label: Text(
                          'Tanggal Lahir',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 23, 55, 184),
                          ),
                        ),
                      ),
                    ),
                    TextField(
                      controller: _alamat,
                      decoration: const InputDecoration(
                        suffixIcon: Icon(Icons.home, color: Colors.grey),
                        label: Text(
                          'Alamat',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 23, 55, 184),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    // Gender Selection
                    const Row(
                      children: [
                        Text(
                          'Jenis Kelamin',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Color.fromARGB(255, 23, 55, 184),
                          ),
                        ),
                        Spacer(),
                        Icon(Icons.person, color: Colors.grey),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Radio(
                          value: "Laki-laki",
                          groupValue: _jenis_kelamin,
                          onChanged: (value) {
                            setState(() {
                              _jenis_kelamin = value.toString();
                            });
                          },
                        ),
                        const Text("Laki-laki"),
                        const SizedBox(width: 20),
                        Radio(
                          value: "Perempuan",
                          groupValue: _jenis_kelamin,
                          onChanged: (value) {
                            setState(() {
                              _jenis_kelamin = value.toString();
                            });
                          },
                        ),
                        const Text("Perempuan"),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Register Button
                    GestureDetector(
                      onTap: registerUser,
                      child: Container(
                        height: 45,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: const LinearGradient(colors: [
                            Color.fromARGB(255, 23, 55, 184),
                            Color(0xff281537),
                          ]),
                        ),
                        child: const Center(
                          child: Text(
                            'REGISTER',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 50),
                    Align(
                    alignment: Alignment.bottomRight,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.grey),
                        ),
                        GestureDetector(
                          onTap: () {
                            // Navigasi ke halaman RegisterScreen ketika ditekan
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>  LoginScreen()),
                            );
                          },
                          child: const Text(
                            "Log In",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
