import 'package:flutter/material.dart';

class OnBoardingPage extends StatefulWidget {
  const OnBoardingPage({super.key});

  @override
  State<OnBoardingPage> createState() => _OnBoardingPageState();
}

class _OnBoardingPageState extends State<OnBoardingPage> {
  final PageController onboardController = PageController();
  int indexPage = 0;
  List<Map<String, String>> pageList = [
    {
      "title": "Fadila Medical Center",
      "image":
          "https://png.pngtree.com/png-clipart/20220509/original/pngtree-webpage-presents-high-quality-healthcare-at-clinic-banner-png-image_7672946.png",
      "subtitle": "Welcome to Our Clinic"
    },
    {
      "title": "Discover Products",
      "image":
          "https://i0.wp.com/scmohospital.net/wp-content/uploads/2023/01/PatientVisitor.jpg?ssl=1",
      "subtitle": "Explore the best quality product in our store"
    },
    {
      "title": "Search the Product You Like",
      "image":
          "https://www.vinmec.com/static/uploads/20191211_141350_205886_hieu_ve_rung_nhi_ro_max_1800x1800_jpg_99e31bead4.jpg",
      "subtitle": "Explore the best quality product in our store"
    },
    {
      "title": "Surf Our Online Store",
      "image":
          "https://thumbs.dreamstime.com/z/healthcare-smart-card-doctor-digital-health-medical-consultation-information-organization-concept-violet-palette-header-126558021.jpg",
      "subtitle": "Explore the best quality product in our store"
    },
    {
      "title": "Get Started",
      "image":
          "https://png.pngtree.com/png-clipart/20220531/original/pngtree-medical-check-up-cover-template-health-care-flat-design-illustration-editable-png-image_7778602.png",
      "subtitle": "Let's get started shopping with us. Happy Shopping!"
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Expanded(
            child: PageView.builder(
              controller: onboardController,
              onPageChanged: (page) {
                setState(() {
                  indexPage = page;
                });
              },
              itemCount: pageList.length,
              itemBuilder: (context, index) {
                return OnBoardingData(
                  title: pageList[index]['title']!,
                  image: pageList[index]['image']!,
                  subtitle: pageList[index]['subtitle']!,
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                if (indexPage == pageList.length - 1)
                  TextButton(
                    onPressed: () {
                      // Navigator.of(context).pushReplacement(
                      //   MaterialPageRoute(
                      //     builder: (context) => const (),
                      //   ),
                      // );
                    },
                    child: const Text(
                      "Get Started",
                      style: TextStyle(
                        color: Colors.blue,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  const SizedBox(width: 80), // Placeholder agar posisi tetap
                // Lingkaran indikator di tengah
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    pageList.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: indexPage == index
                            ? Colors.blue
                            : Colors.grey.shade400,
                      ),
                    ),
                  ),
                ),
           
                IconButton(
                  onPressed: () {
                    // if (indexPage == pageList.length - 1) {
                    //   Navigator.of(context).pushReplacement(
                    //     MaterialPageRoute(
                    //       builder: (context) => const HomePages(),
                    //     ),
                    //   );
                    // } else {
                    //   onboardController.nextPage(
                    //     duration: const Duration(milliseconds: 300),
                    //     curve: Curves.easeInOut,
                    //   );
                    // }
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    size: 24,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnBoardingData extends StatelessWidget {
  final String title;
  final String image;
  final String subtitle;

  const OnBoardingData({
    super.key,
    required this.title,
    required this.image,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.network(
          image,
          height: 350,
          width: 300,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            } else {
              return CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                    ? loadingProgress.cumulativeBytesLoaded /
                        (loadingProgress.expectedTotalBytes ?? 1)
                    : null,
              );
            }
          },
          errorBuilder: (context, error, stackTrace) {
            return const Text(
              "Error Loading Image",
              textAlign: TextAlign.center,
            );
          },
        ),
        const SizedBox(height: 20),
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black54,
          ),
        ),
        const SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Text(
            subtitle,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        ),
      ],
    );
  }
}
