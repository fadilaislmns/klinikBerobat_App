import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_uas_fadila/homepage.dart';

class KlinikPage extends StatelessWidget {
  const KlinikPage({Key? key}) : super(key: key);

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
          "Info Klinik",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          // Clinic Image Section
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Image.network(
              'https://i0.wp.com/asiaarsitek.com/wp-content/uploads/2020/03/Jasa-Arsitek-Desain-Rumah-Sakit-Klinik-Apotek-Cinambo-Bandung-Asia-Arsitek-3.jpg?ssl=1',  // Replace with actual image URL
              height: 200,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 16),
          
          // Clinic Name Section
          Container(
            padding: const EdgeInsets.all(8.0),
            decoration: BoxDecoration(
              color: Colors.blue.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Text(
              'Klinik Fadila Medical Center',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Clinic Details Section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3), // Changes position of shadow
                ),
              ],
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Jl. Sehat No. 123, Padang, Indonesia',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.phone, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      '+62 812-3456-7890',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(CupertinoIcons.time_solid, color: Colors.blue),
                    SizedBox(width: 8),
                    Text(
                      'Open Daily: 08:00 AM - 05:00 PM',
                      style: TextStyle(fontSize: 16, color: Colors.black),
                    ),
                  ],
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.medical_services, color: Colors.blue),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Services: General Checkup, Pediatric Care, Vaccinations, etc.',
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
