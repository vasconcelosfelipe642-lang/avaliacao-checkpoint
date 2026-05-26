import 'package:flutter/foundation.dart';
import 'package:usedev_uninassau/src/models/cart_item_model.dart';
import 'package:usedev_uninassau/src/models/product_model.dart';

class CartService extends ChangeNotifier {
  CartService._();

  static final CartService instance = CartService._();

  final List<CartItemModel> _items = [];

  List<CartItemModel> get items => List.unmodifiable(_items);

  int get itemCount =>
      _items.fold<int>(0, (sum, item) => sum + item.quantity);

  double get total =>
      _items.fold<double>(0, (sum, item) => sum + item.subtotal);

  Future<void> addProduct(ProductModel product) async {
    await Future<void>.delayed(Duration.zero);

    final index =
        _items.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      final current = _items[index];
      _items[index] = current.copyWith(quantity: current.quantity + 1);
    } else {
      _items.add(CartItemModel(product: product, quantity: 1));
    }

    notifyListeners();
  }

  Future<void> incrementQuantity(int productId) async {
    await Future<void>.delayed(Duration.zero);
    _changeQuantity(productId, 1);
  }

  Future<void> decrementQuantity(int productId) async {
    await Future<void>.delayed(Duration.zero);
    _changeQuantity(productId, -1);
  }

  Future<void> removeProduct(int productId) async {
    await Future<void>.delayed(Duration.zero);
    _items.removeWhere((item) => item.product.id == productId);
    notifyListeners();
  }

  Future<void> clear() async {
    await Future<void>.delayed(Duration.zero);
    _items.clear();
    notifyListeners();
  }

  void _changeQuantity(int productId, int delta) {
    final index = _items.indexWhere((item) => item.product.id == productId);
    if (index < 0) return;

    final newQuantity = _items[index].quantity + delta;
    if (newQuantity <= 0) {
      _items.removeAt(index);
    } else {
      _items[index] = _items[index].copyWith(quantity: newQuantity);
    }
    notifyListeners();
  }
}
