import 'package:flutter_test/flutter_test.dart';
import 'package:usedev_uninassau/src/models/cart_item_model.dart';
import 'package:usedev_uninassau/src/models/product_model.dart';
import 'package:usedev_uninassau/src/models/rating_model.dart';
import 'package:usedev_uninassau/src/services/cart_service.dart';

void main() {
  group('CartService', () {
    late CartService cartService;
    late ProductModel testProduct;
    late ProductModel testProduct2;

    setUp(() {
      cartService = CartService.instance;
      // Remover todos os listeners para evitar interferência entre testes
      cartService.removeListener(() {});
      // Limpar estado anterior
      cartService.clear();

      // Criar produtos de teste
      testProduct = ProductModel(
        id: 1,
        title: 'Teste Produto 1',
        price: 10.0,
        description: 'Descrição teste',
        category: 'test',
        image: 'http://example.com/img.jpg',
        rating: RatingModel(rate: 4.5, count: 100),
      );

      testProduct2 = ProductModel(
        id: 2,
        title: 'Teste Produto 2',
        price: 20.0,
        description: 'Descrição teste 2',
        category: 'test',
        image: 'http://example.com/img2.jpg',
        rating: RatingModel(rate: 3.5, count: 50),
      );
    });

    test('CartService.instance é um Singleton', () {
      final instance1 = CartService.instance;
      final instance2 = CartService.instance;
      expect(identical(instance1, instance2), true);
    });

    test('Inicialmente carrinho está vazio', () {
      expect(cartService.items.isEmpty, true);
      expect(cartService.itemCount, 0);
      expect(cartService.total, 0.0);
    });

    test('addProduct adiciona um novo produto', () async {
      await cartService.addProduct(testProduct);

      expect(cartService.items.length, 1);
      expect(cartService.items.first.product.id, 1);
      expect(cartService.items.first.quantity, 1);
    });

    test('addProduct incrementa quantidade se produto já existe', () async {
      await cartService.addProduct(testProduct);
      await cartService.addProduct(testProduct);

      expect(cartService.items.length, 1);
      expect(cartService.items.first.quantity, 2);
    });

    test('itemCount retorna soma de quantidades', () async {
      await cartService.addProduct(testProduct);
      await cartService.addProduct(testProduct);
      await cartService.addProduct(testProduct2);

      // testProduct (qtd 2) + testProduct2 (qtd 1) = 3
      expect(cartService.itemCount, 3);
    });

    test('total calcula subtotal correto', () async {
      await cartService.addProduct(testProduct); // 10.0 * 1
      await cartService.addProduct(testProduct); // 10.0 * 2 = 20.0
      await cartService.addProduct(testProduct2); // 20.0 * 1 = 20.0
      // Total: 10.0 + 10.0 + 20.0 = 40.0

      expect(cartService.total, 40.0);
    });

    test('incrementQuantity aumenta quantidade do produto', () async {
      await cartService.addProduct(testProduct);
      await cartService.incrementQuantity(1);

      expect(cartService.items.first.quantity, 2);
    });

    test('decrementQuantity diminui quantidade do produto', () async {
      await cartService.addProduct(testProduct);
      await cartService.addProduct(testProduct);
      await cartService.decrementQuantity(1);

      expect(cartService.items.first.quantity, 1);
    });

    test('decrementQuantity remove produto se quantidade chegar a 0', () async {
      await cartService.addProduct(testProduct);
      await cartService.decrementQuantity(1);

      expect(cartService.items.isEmpty, true);
    });

    test('removeProduct deleta produto do carrinho', () async {
      await cartService.addProduct(testProduct);
      await cartService.addProduct(testProduct2);

      await cartService.removeProduct(1);

      expect(cartService.items.length, 1);
      expect(cartService.items.first.product.id, 2);
    });

    test('clear limpa todos os produtos', () async {
      await cartService.addProduct(testProduct);
      await cartService.addProduct(testProduct2);
      await cartService.clear();

      expect(cartService.items.isEmpty, true);
      expect(cartService.itemCount, 0);
      expect(cartService.total, 0.0);
    });

    test('items retorna lista imutável', () async {
      await cartService.addProduct(testProduct);

      final itemList = cartService.items;
      expect(
        () => itemList.add(CartItemModel(product: testProduct2, quantity: 1)),
        throwsUnsupportedError,
      );
    });
  });
}
