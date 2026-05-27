import 'package:flutter_test/flutter_test.dart';
import 'package:usedev_uninassau/src/models/product_model.dart';
import 'package:usedev_uninassau/src/services/product_service.dart';

void main() {
  group('ProductService', () {
    late ProductService productService;

    setUp(() {
      productService = ProductService();
    });

    // Resposta de exemplo da API (não será usada sem mock)
    // const mockResponseBody = '''
    // [
    //   {
    //     "id": 1,
    //     "title": "Produto 1",
    //     "price": 10.5,
    //     "description": "Descrição 1",
    //     "category": "categoria1",
    //     "image": "https://example.com/img1.jpg",
    //     "rating": {"rate": 4.5, "count": 100}
    //   },
    //   {
    //     "id": 2,
    //     "title": "Produto 2",
    //     "price": 20.0,
    //     "description": "Descrição 2",
    //     "category": "categoria2",
    //     "image": "https://example.com/img2.jpg",
    //     "rating": {"rate": 3.8, "count": 50}
    //   }
    // ]
    // ''';

    test(
      'ProductService.getAllProducts é uma Future<List<ProductModel>>',
      () async {
        // Como o ProductService não permite injetar o client,
        // este é um teste demonstrativo
        // Em produção, refatore ProductService para aceitar http.Client injetável

        final result = productService.getAllProducts();
        expect(result, isA<Future<List<ProductModel>>>());
      },
    );

    test('ProductModel desserializa corretamente a partir da API', () {
      final jsonItem = {
        "id": 1,
        "title": "Produto Teste",
        "price": 99.99,
        "description": "Descrição do teste",
        "category": "eletrônicos",
        "image": "https://example.com/produto.jpg",
        "rating": {"rate": 4.5, "count": 200},
      };

      final product = ProductModel.fromJson(jsonItem);

      expect(product.id, 1);
      expect(product.title, "Produto Teste");
      expect(product.price, 99.99);
      expect(product.rating.rate, 4.5);
    });
  });
}
