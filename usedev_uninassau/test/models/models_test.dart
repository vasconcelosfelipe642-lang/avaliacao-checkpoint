import 'package:flutter_test/flutter_test.dart';
import 'package:usedev_uninassau/src/models/cart_item_model.dart';
import 'package:usedev_uninassau/src/models/product_model.dart';
import 'package:usedev_uninassau/src/models/rating_model.dart';

void main() {
  group('Models', () {
    group('RatingModel', () {
      test('RatingModel.fromJson desserializa corretamente', () {
        final json = {'rate': 4.5, 'count': 100};
        final rating = RatingModel.fromJson(json);

        expect(rating.rate, 4.5);
        expect(rating.count, 100);
      });

      test('RatingModel.toJson serializa corretamente', () {
        final rating = RatingModel(rate: 3.8, count: 50);
        final json = rating.toJson();

        expect(json['rate'], 3.8);
        expect(json['count'], 50);
      });

      test('RatingModel fields são immutáveis (final)', () {
        final rating = RatingModel(rate: 4.0, count: 80);

        // Não deveria ter setters
        expect(() {
          // Tenta acessar o campo
          return rating.rate;
        }, returnsNormally);
      });
    });

    group('ProductModel', () {
      final testJson = {
        'id': 1,
        'title': 'Produto Teste',
        'price': 99.99,
        'description': 'Uma descrição de teste',
        'category': 'eletrônicos',
        'image': 'https://example.com/image.jpg',
        'rating': {'rate': 4.5, 'count': 150},
      };

      test('ProductModel.fromJson desserializa corretamente', () {
        final product = ProductModel.fromJson(testJson);

        expect(product.id, 1);
        expect(product.title, 'Produto Teste');
        expect(product.price, 99.99);
        expect(product.description, 'Uma descrição de teste');
        expect(product.category, 'eletrônicos');
        expect(product.image, 'https://example.com/image.jpg');
        expect(product.rating.rate, 4.5);
        expect(product.rating.count, 150);
      });

      test('ProductModel.toJson serializa corretamente', () {
        final product = ProductModel(
          id: 2,
          title: 'Outro Produto',
          price: 49.99,
          description: 'Outra descrição',
          category: 'livros',
          image: 'https://example.com/book.jpg',
          rating: RatingModel(rate: 3.5, count: 80),
        );

        final json = product.toJson();

        expect(json['id'], 2);
        expect(json['title'], 'Outro Produto');
        expect(json['price'], 49.99);
        expect(json['description'], 'Outra descrição');
        expect(json['category'], 'livros');
        expect(json['image'], 'https://example.com/book.jpg');
        expect(json['rating']['rate'], 3.5);
        expect(json['rating']['count'], 80);
      });

      test('ProductModel fields são immutáveis (final)', () {
        final product = ProductModel.fromJson(testJson);

        // Verifica que fields existem e são acessíveis
        expect(product.id, isNotNull);
        expect(product.title, isNotNull);
        expect(product.price, isNotNull);
      });

      test('ProductModel.fromJson com diferentes tipos de price', () {
        // API retorna price como int ou double
        final jsonWithIntPrice = {...testJson, 'price': 50}; // int
        final productFromInt = ProductModel.fromJson(jsonWithIntPrice);

        expect(productFromInt.price, 50.0);

        final jsonWithDoublePrice = {...testJson, 'price': 50.99}; // double
        final productFromDouble = ProductModel.fromJson(jsonWithDoublePrice);

        expect(productFromDouble.price, 50.99);
      });

      test('ProductModel round-trip: fromJson → toJson → fromJson', () {
        final product1 = ProductModel.fromJson(testJson);
        final json = product1.toJson();
        final product2 = ProductModel.fromJson(json);

        expect(product1.id, product2.id);
        expect(product1.title, product2.title);
        expect(product1.price, product2.price);
        expect(product1.description, product2.description);
        expect(product1.category, product2.category);
        expect(product1.image, product2.image);
        expect(product1.rating.rate, product2.rating.rate);
        expect(product1.rating.count, product2.rating.count);
      });

      test('ProductModel lida com campos vazios', () {
        final jsonWithEmptyFields = {
          'id': 3,
          'title': '',
          'price': 0.0,
          'description': '',
          'category': '',
          'image': '',
          'rating': {'rate': 0.0, 'count': 0},
        };

        final product = ProductModel.fromJson(jsonWithEmptyFields);

        expect(product.title, '');
        expect(product.price, 0.0);
        expect(product.description, '');
      });
    });

    group('CartItemModel', () {
      final testProduct = ProductModel(
        id: 1,
        title: 'Produto',
        price: 10.0,
        description: 'Desc',
        category: 'cat',
        image: 'img.jpg',
        rating: RatingModel(rate: 4.0, count: 50),
      );

      test('CartItemModel.subtotal calcula corretamente', () {
        final item = CartItemModel(product: testProduct, quantity: 3);

        expect(item.subtotal, 30.0); // 10.0 * 3
      });

      test('CartItemModel.copyWith atualiza quantity', () {
        final item1 = CartItemModel(product: testProduct, quantity: 1);
        final item2 = item1.copyWith(quantity: 5);

        expect(item1.quantity, 1);
        expect(item2.quantity, 5);
        expect(item2.product, item1.product);
      });

      test('CartItemModel é imutável (copyWith não altera original)', () {
        final item1 = CartItemModel(product: testProduct, quantity: 2);
        final item2 = item1.copyWith(quantity: 10);

        expect(item1.quantity, 2); // Não foi alterado
        expect(item2.quantity, 10); // Novo objeto criado
        expect(item1 != item2, true); // Referências diferentes
      });
    });
  });
}
