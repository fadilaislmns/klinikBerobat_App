import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:project_uas_fadila/homepage.dart';

class Keranjang extends StatefulWidget {
  final String userId; // Pass the userId to the constructor

  const Keranjang({Key? key, required this.userId}) : super(key: key);

  @override
  State<Keranjang> createState() => _KeranjangState();
}

class _KeranjangState extends State<Keranjang> {
  List<dynamic> cartItems = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCartItems();
  }

  // Fetch cart items from the backend
  Future<void> fetchCartItems() async {
    final response = await http.post(
      Uri.parse('http://10.0.3.2/backend_project/keranjang.php'),
      body: {'user_id': widget.userId},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      if (data is List) {
        setState(() {
          cartItems = data;
          isLoading = false;
        });
      } else {
        // Handle error response
        setState(() {
          isLoading = false;
        });
        showError(data['message']);
      }
    } else {
      setState(() {
        isLoading = false;
      });
      showError('Failed to load cart items.');
    }
  }

  // Show error message
  void showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  // Calculate the total price of items in the cart
 String calculateTotal() {
  int total = 0;
  for (var item in cartItems) {
    total += int.parse(item['harga'].replaceAll('Rp ', '').replaceAll(',', ''));
  }
  return 'Rp ${total.toString().replaceAllMapped(RegExp(r'(\d)(?=(\d{3})+(?!\d))'), (match) => '${match[1]},')}';
}


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
          "Keranjang Saya",
          style: TextStyle(
              fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : cartItems.isEmpty
              ? const Center(child: Text('Keranjang Anda Kosong'))
              : ListView.builder(
                  itemCount: cartItems.length,
                  itemBuilder: (context, index) {
                    final item = cartItems[index];
                    return CartItemWidget(
                      name: item['nama_obat'],
                      price: 'Rp ${item['harga']}',
                      image: item['image'],
                      quantity: item['jumlah'],
                    );
                  },
                ),
      bottomNavigationBar: cartItems.isEmpty
          ? null
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Total: Rp ${calculateTotal()}',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Implement checkout action
                    },
                    child: const Text('Checkout'),
                    style: ElevatedButton.styleFrom(primary: Colors.orange),
                  ),
                ],
              ),
            ),
    );
  }
}

class CartItemWidget extends StatelessWidget {
  final String name;
  final String price;
  final String image;
  final int quantity;

  const CartItemWidget({
    required this.name,
    required this.price,
    required this.image,
    required this.quantity,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Image.network(image, width: 80, height: 80, fit: BoxFit.cover),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(price, style: const TextStyle(color: Colors.grey)),
                Text('Qty: $quantity', style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {
              // Implement remove item from cart
            },
          ),
        ],
      ),
    );
  }
}
