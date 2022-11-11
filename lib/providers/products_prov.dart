import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'product.dart';
import 'dart:convert';

class Products_Prov with ChangeNotifier {
  //Mixin is similar to inheritance, Products mixes in the change notifier
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];
  // _ used to prevent access from outside to
  //the items(not final since it will change)
  List<Product> get items {
    return [..._items];
    //returning a copy of items. if _items is returned directly,
    //we would return a pointer to _items directly, and everyone
    //will get direct access to the products class
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  Future<void> addProduct(Product product) {
    final url = Uri.parse(
        "https://shop-app-d1490-default-rtdb.europe-west1.firebasedatabase.app/products.json");
    return http
        .post(url,
            body: json.encode({
              "description": product.description,
              "imageUrl": product.imageUrl,
              "price": product.price,
              "title": product.title,
              "isFavorite": product.isFavorite,
            }))
        .then((response) {
      final newProduct = Product(
          id: json.decode(response.body)["name"],
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
          title: product.title);
      _items.add(newProduct);
      notifyListeners();
    });

    // 'with ChangeNotifier' gives access to this functions, that lets everyone know about the changes
    //the changes of the _items have to be done inside this class, so that everyone will be notified
  }

  void updateProduct(String id, Product newProduct) {
    final prodIndex =
        _items.indexWhere((element) => element.id == newProduct.id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("...");
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
