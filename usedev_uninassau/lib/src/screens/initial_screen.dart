import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usedev_uninassau/src/models/product_model.dart';
import 'package:usedev_uninassau/src/screens/product_detail_screen.dart';
import 'package:usedev_uninassau/src/services/product_service.dart';
import 'package:usedev_uninassau/src/widgets/custom_app_bar_widget.dart';
import 'package:usedev_uninassau/src/widgets/hero_section_widget.dart';
import 'package:usedev_uninassau/src/widgets/product_card_widget.dart';
import 'package:usedev_uninassau/src/widgets/subscription_section_widget.dart';

class InitialScreen extends StatefulWidget {
  const InitialScreen({super.key});

  @override
  State<InitialScreen> createState() => InitialScreenState();
}

class InitialScreenState extends State<InitialScreen> {
  final _productService = ProductService();
  late final Future<List<ProductModel>> _produtosFuture;

  @override
  void initState() {
    super.initState();
    _produtosFuture = _productService.getAllProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBarWidget(),
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
              future: _produtosFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      'Erro ao carregar promos: ${snapshot.error}',
                    ),
                  );
                }

                final produtos = snapshot.data;
                if (produtos == null || produtos.isEmpty) {
                  return const Center(
                    child: Text('Nenhuma promo disponível.'),
                  );
                }

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
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProductDetailScreen(produto: produto),
                          ),
                        );
                      },
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
