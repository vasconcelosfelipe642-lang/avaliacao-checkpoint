import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:usedev_uninassau/src/screens/initial_screen.dart';
import 'package:usedev_uninassau/src/screens/login_screen.dart';
import 'package:usedev_uninassau/src/services/auth_service.dart';
import 'package:usedev_uninassau/src/services/cart_service.dart';
import 'package:usedev_uninassau/src/widgets/cart_item_card_widget.dart';
import 'package:usedev_uninassau/src/widgets/custom_app_bar_widget.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const Color _purple = Color(0xFF780BF7);

  String _formatPrice(double value) {
    return 'R\$ ${value.toStringAsFixed(2).replaceAll('.', ',')}';
  }

  Future<void> _finalizePurchase(BuildContext context) async {
    final loggedIn = await AuthService.instance.isLoggedIn();
    if (!context.mounted) return;

    if (!loggedIn) {
      await Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
      );
      return;
    }

    await CartService.instance.clear();
    if (!context.mounted) return;

    final messenger = ScaffoldMessenger.of(context);
    messenger.showSnackBar(
      SnackBar(
        content: Text(
          'Compra finalizada com sucesso!',
          style: TextStyle(fontFamily: GoogleFonts.poppins().fontFamily),
        ),
        backgroundColor: _purple,
      ),
    );

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const InitialScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartService.instance;

    return Scaffold(
      appBar: const CustomAppBarWidget(showBackButton: true),
      body: ListenableBuilder(
        listenable: cart,
        builder: (context, _) {
          if (cart.items.isEmpty) {
            return Center(
              child: Text(
                'Seu carrinho está vazio.',
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: GoogleFonts.poppins().fontFamily,
                ),
              ),
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Text(
                  'Meu Carrinho',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    fontFamily: GoogleFonts.orbitron().fontFamily,
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.only(bottom: 16),
                  itemCount: cart.items.length,
                  itemBuilder: (context, index) {
                    final item = cart.items[index];
                    final productId = item.product.id;

                    return CartItemCardWidget(
                      item: item,
                      onDelete: () async {
                        await cart.removeProduct(productId);
                        if (!context.mounted) return;
                      },
                      onIncrement: () async {
                        await cart.incrementQuantity(productId);
                        if (!context.mounted) return;
                      },
                      onDecrement: () async {
                        await cart.decrementQuantity(productId);
                        if (!context.mounted) return;
                      },
                    );
                  },
                ),
              ),
              Container(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                          ),
                        ),
                        Text(
                          _formatPrice(cart.total),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            color: _purple,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _finalizePurchase(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _purple,
                          padding: const EdgeInsets.symmetric(vertical: 18),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'FINALIZAR COMPRA',
                          style: TextStyle(
                            fontFamily: GoogleFonts.poppins().fontFamily,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
