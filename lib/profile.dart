import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:project_uas_fadila/loginscreen.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  late Future<Map<String, dynamic>> userData;
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController = TextEditingController();
  bool _isUpdating = false;
  int? _userId;

  @override
  void initState() {
    super.initState();
    loadUserId();
  }

  Future<void> loadUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final storedUserId = prefs.getInt('user_id');
    if (storedUserId != null) {
      setState(() {
        _userId = storedUserId;
        userData = fetchUserData(storedUserId);
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('User belum login')),
      );
    }
  }

  Future<Map<String, dynamic>> fetchUserData(int userId) async {
    final response = await http.get(
      Uri.parse('http://10.0.2.2/backend_project/profile.php?id=$userId'),
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load user data');
    }
  }

  Future<void> _changePassword() async {
    if (_oldPasswordController.text.isEmpty || 
        _newPasswordController.text.isEmpty || 
        _confirmNewPasswordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Semua kolom harus diisi')),
      );
      return;
    }

    if (_newPasswordController.text != _confirmNewPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi baru tidak cocok')),
      );
      return;
    }

    setState(() {
      _isUpdating = true;
    });

    final response = await http.post(
      Uri.parse('http://10.0.2.2/backend_project/change_password.php'),
      body: {
        'user_id': _userId.toString(),
        'old_password': _oldPasswordController.text,
        'new_password': _newPasswordController.text,
      },
    );

    setState(() {
      _isUpdating = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Kata sandi berhasil diubah')),
      );
      Navigator.pop(context); // Menutup form ubah kata sandi
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal mengubah kata sandi')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _userId == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<Map<String, dynamic>>(
              future: userData,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final user = snapshot.data;

                return SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: Colors.teal.shade100,
                        child: const Icon(
                          Icons.person,
                          size: 60,
                          color: Color.fromARGB(255, 23, 55, 184),
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        user!['data']['nama'] ?? 'Nama Pengguna',
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 23, 55, 184),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        user['data']['email'] ?? 'nama.email@example.com',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Card untuk pengaturan akun
                      Card(
                        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(15),
                        ),
                        elevation: 5,
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Pengaturan Akun',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromARGB(255, 23, 55, 184),
                                ),
                              ),
                              const Divider(color: Color.fromARGB(255, 23, 55, 184), thickness: 1),
                              const SizedBox(height: 10),
                              ListTile(
                                leading: const Icon(Icons.lock, color: Colors.teal),
                                title: const Text('Ubah Kata Sandi'),
                                onTap: () {
                                  _showChangePasswordDialog(context);
                                },
                              ),
                              const Divider(),
                              ListTile(
                                leading: const Icon(Icons.logout, color: Colors.red),
                                title: const Text('Keluar'),
                                onTap: () async {
                                  final prefs = await SharedPreferences.getInstance();
                                  await prefs.remove('user_id');
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) => const LoginScreen()),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  // Dialog ubah password
  void _showChangePasswordDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Ubah Kata Sandi'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _oldPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Kata Sandi Lama',
                ),
              ),
              TextField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Kata Sandi Baru',
                ),
              ),
              TextField(
                controller: _confirmNewPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Konfirmasi Kata Sandi Baru',
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: _changePassword,
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }
}
