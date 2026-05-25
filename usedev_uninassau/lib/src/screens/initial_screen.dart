import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usedev_uninassau/src/widgets/hero_section_widget.dart';
import 'package:usedev_uninassau/src/widgets/product_card_widget.dart';
import 'package:usedev_uninassau/src/widgets/subscription_section_widget.dart';
import 'package:usedev_uninassau/src/services/product_service.dart';
import 'package:usedev_uninassau/src/models/product_model.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  _InitialScreenState createState() => _InitialScreenState();
}

class _InitialScreenState extends State<InitialScreen> {

  final _productService = ProductService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const Icon(Icons.menu, size: 40),
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
          spacing: 20,
          crossAxisAlignment: CrossAxisAlignment.stretch, 
          children: [
            const HeroSectionWidget(),
            Text(
              'Promos Especiais',
              textAlign: TextAlign.center, 
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: GoogleFonts.orbitron().fontFamily,
              ),
            ),

            FutureBuilder<List<ProductModel>>(
              future: _productService.getAllProducts(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } 
                else if (snapshot.hasError) {
                  return Center(child: Text('Erro ao carregar promos: ${snapshot.error}'));
                } 

                else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return const Center(child: Text('Nenhuma promo disponível.'));
                }

             
                final produtos = snapshot.data!;

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(), 
                  itemCount: produtos.length,
                  itemBuilder: (context, index) {
                    final produto = produtos[index];
                    return ProductCardWidget(
                      nome: produto.title,
                      url: produto.image,
                      preco: produto.price.toStringAsFixed(2), 
                    );
                  },
                );
              },
            ),
            
            const SubscriptionSectionWidget(),
          ],
        ),
      ),
    );
  }
}