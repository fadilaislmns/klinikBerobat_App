import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_uas_fadila/homepage.dart';

class UpdateProfile extends StatefulWidget {
  final Map<String, dynamic> users;
  const UpdateProfile({super.key, required this.users});

  @override
  State<UpdateProfile> createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  final _id = TextEditingController();
  final _email = TextEditingController();
  final _password = TextEditingController();
  final _nama = TextEditingController();

  @override
  void initState() {
    super.initState();
    _id.text = widget.users['id'].toString();
    _email.text = widget.users['email'].toString();
    _password.text = widget.users['password'].toString();
    _nama.text = widget.users['nama'].toString();
  }

  Future<void> editUser() async {
    String urlEditUser = "http://10.0.3.2/backend_project/update_users.php";
    try {
      var resEditUser = await http.post(Uri.parse(urlEditUser), body: {
        "id": _id.text,
        "email": _email.text,
        "password": _password.text,
        "nama": _nama.text,
      });

      var bodyEditUser = json.decode(resEditUser.body);
      if (bodyEditUser['Success'] == true) {
        if (kDebugMode) print("User updated successfully");
        Navigator.pop(context, true);
      } else {
        if (kDebugMode) print("Failed to update user");
      }
    } catch (exc) {
      if (kDebugMode) print(exc);
    }
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required IconData icon,
    bool obscureText = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.grey[100],
          hintText: hintText,
          hintStyle: const TextStyle(color: Colors.grey, fontSize: 15),
          prefixIcon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        leading: IconButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const HomePage()),
            );
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          "Edit User",
          style: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              buildTextField(
                controller: _id,
                hintText: "ID",
                icon: Icons.badge,
              ),
              buildTextField(
                controller: _nama,
                hintText: "Nama",
                icon: Icons.person,
              ),
              buildTextField(
                controller: _email,
                hintText: "Email",
                icon: Icons.email,
              ),
              buildTextField(
                controller: _password,
                hintText: "Password",
                icon: Icons.lock,
                obscureText: true,
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                width: 200,
                child: ElevatedButton(
                  onPressed: editUser,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: const Text(
                    "Update Profile",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
