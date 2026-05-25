import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usedev_uninassau/src/models/product_model.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({required this.produto, super.key});

  final ProductModel produto;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, size: 40),
          onPressed: () => Navigator.pop(context),
        ),
        title: Image.asset('assets/logo_usedev.png', height: 40),
        centerTitle: true,
        actions: const [
          Icon(Icons.person_outline, size: 40),
          SizedBox(width: 10),
          Icon(Icons.shopping_cart_outlined, size: 40),
          SizedBox(width: 25),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              produto.image,
              height: 300,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text(
                produto.title,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.orbitron().fontFamily,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Text(
                produto.description,
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Text(
                'R\$ ${produto.price.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 31,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_shopping_cart, color: Colors.white),
                label: Text(
                  'Adicionar ao carrinho',
                  style: TextStyle(
                    fontFamily: GoogleFonts.poppins().fontFamily,
                    fontSize: 18,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF780BF7),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
