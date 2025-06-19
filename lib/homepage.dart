import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:project_uas_fadila/berita.dart';
import 'package:project_uas_fadila/homescreen.dart';
import 'package:project_uas_fadila/keranjang.dart';
import 'package:project_uas_fadila/profile.dart';
import 'package:project_uas_fadila/riwayat.dart'; // Make sure to import the Riwayat page

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int currentPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> pages = [
      const HomeScreen(),
      const PageBerita(),
      const RiwayatPage(), // Add Riwayat page here
      const ProfilePage(),
      
    ];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 23, 55, 184),
        title: const Text("Fadila Medical Center",
            style: TextStyle(
                fontSize: 22,
                color: Colors.white,
                fontWeight: FontWeight.bold)),
        centerTitle: true,
        
      ),
      body: pages[currentPageIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentPageIndex,
        backgroundColor: const Color.fromARGB(255, 23, 55, 184),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.white,
        onTap: (index) {
          if (index < pages.length) {  // Ensure the index is within the bounds of the pages list
            setState(() {
              currentPageIndex = index;
            });
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.house, size: 20),
            label: "Home",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.news, size: 20),
            label: "Berita",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.time, size: 20),  // Use an appropriate icon for "Riwayat"
            label: "Riwayat",
          ),
          BottomNavigationBarItem(
            icon: Icon(CupertinoIcons.person_circle_fill, size: 20),
            label: "Profil",
          ),
          
        ],
      ),
    );
  }
}
