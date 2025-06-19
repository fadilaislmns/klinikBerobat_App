import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_uas_fadila/dokter.dart';
import 'package:project_uas_fadila/klinik.dart';
import 'package:project_uas_fadila/obat.dart';
import 'package:project_uas_fadila/pendaftaran.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  PageController bannerController = PageController();
  int indexBanner = 0;
  Timer? timer;
  final TextEditingController searchController = TextEditingController();
  List listAllDokter = [];

  @override
  void initState() {
    super.initState();
    bannerController.addListener(() {
      setState(() {
        indexBanner = bannerController.page?.round() ?? 0;
      });
    });
    bannerOnBoarding();
    getAllDokter();
  }

  Future<void> getAllDokter() async {
    String urlAllDokter = "http://10.0.2.2/backend_project/dokter.php";
    try {
      var response = await http.get(Uri.parse(urlAllDokter));
      if (response.statusCode == 200) {
        setState(() {
          listAllDokter = jsonDecode(response.body);
        });
      } else {
        if (kDebugMode) {
          print("Failed to load dokter: ${response.statusCode}");
        }
      }
    } catch (exc) {
      if (kDebugMode) {
        print("Error fetching dokter: $exc");
      }
    }
  }

  void bannerOnBoarding() {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (indexBanner < 3) {
        indexBanner++;
      } else {
        indexBanner = 0;
      }
      bannerController.animateToPage(
        indexBanner,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    });
  }

  @override
  void dispose() {
    bannerController.dispose();
    timer?.cancel();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> bannerList = [
      './lib/assets/banner1.png',
      './lib/assets/banner2.png',
      './lib/assets/banner4.png',
      './lib/assets/banner5.png',
    ];

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            SizedBox(
              height: 150,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  PageView.builder(
                    controller: bannerController,
                    itemCount: bannerList.length,
                    onPageChanged: (index) {
                      setState(() {
                        indexBanner = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.asset(
                          bannerList[index],
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                  Positioned(
                    bottom: 10,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        bannerList.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: index == indexBanner ? 12 : 8,
                          height: index == indexBanner ? 12 : 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index == indexBanner
                                ? Colors.white
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                height: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _buildMenuCard(
                      context,
                      './lib/assets/dokter.png',
                      'Info Dokter',
                      const allDoctors(),
                    ),
                    _buildMenuCard(
                      context,
                      './lib/assets/pendaftaran.png',
                      'Pendaftaran Pelayanan',
                      const PendaftaranPasien(),
                    ),
                    _buildMenuCard(
                      context,
                      './lib/assets/obat.png',
                      'Obat',
                      const ObatPage(),
                    ),
                    _buildMenuCard(
                      context,
                      './lib/assets/clinic.png',
                      'Info Klinik',
                      const KlinikPage(),
                    ),
                  ],
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16),
              child: Text(
                "Profile Dokter",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemCount: listAllDokter.length,
                itemBuilder: (BuildContext context, int index) {
                  final itemData = listAllDokter[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (BuildContext context) =>
                              DetilScreen(item: itemData),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(5),
                            child: Image.network(
                              itemData['image'] ?? '',
                              height: 90,
                              width: 90,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              itemData['nama_dokter'] ??
                                  'Dokter tidak tersedia',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Text(
                            itemData['poli'] ?? 'Poli tidak tersedia',
                            style: const TextStyle(fontSize: 12),
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuCard(
    BuildContext context,
    String imagePath,
    String title,
    Widget? nextPage,
  ) {
    return Card(
      elevation: 5,
      child: InkWell(
        onTap: nextPage != null
            ? () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => nextPage),
                );
              }
            : null,
        child: SizedBox(
          width: 80,
          height: 110,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                imagePath,
                width: 45,
                height: 45,
                fit: BoxFit.cover,
              ),
              const SizedBox(height: 5),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
