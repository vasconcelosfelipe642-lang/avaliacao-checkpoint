import 'package:flutter/material.dart';
import 'package:usedev_uninassau/src/screens/cart_screen.dart';
import 'package:usedev_uninassau/src/services/cart_service.dart';

class CustomAppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBarWidget({
    this.showBackButton = false,
    super.key,
  });

  final bool showBackButton;

  static const Color _purple = Color(0xFF780BF7);

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final cart = CartService.instance;

    return AppBar(
      leading: showBackButton
          ? IconButton(
              icon: const Icon(Icons.arrow_back, size: 40),
              onPressed: () => Navigator.pop(context),
            )
          : const Icon(Icons.menu, size: 40),
      title: Image.asset('assets/logo_usedev.png', height: 40),
      centerTitle: true,
      actions: [
        const Icon(Icons.person_outline, size: 40),
        const SizedBox(width: 10),
        ListenableBuilder(
          listenable: cart,
          builder: (context, _) {
            final count = cart.itemCount;

            return IconButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CartScreen()),
                );
              },
              icon: Badge(
                isLabelVisible: count > 0,
                backgroundColor: _purple,
                label: Text(
                  '$count',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
                child: const Icon(Icons.shopping_cart_outlined, size: 40),
              ),
            );
          },
        ),
        const SizedBox(width: 25),
      ],
    );
  }
}
