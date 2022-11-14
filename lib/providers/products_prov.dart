import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shop_app/models/http_exception.dart';
import 'product.dart';
import 'dart:convert';

class Products_Prov with ChangeNotifier {
  //Mixin is similar to inheritance, Products mixes in the change notifier
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
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

  Future<void> fetchProducts() async {
    final url = Uri.parse(
        "https://shop-app-d1490-default-rtdb.europe-west1.firebasedatabase.app/products.json");
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      extractedData.forEach((prodId, prodData) {
        loadedProducts.add(Product(
            id: prodId,
            description: prodData["description"],
            imageUrl: prodData["imageUrl"],
            price: prodData["price"],
            title: prodData["title"],
            isFavorite: prodData["isFavorite"]));
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> addProduct(Product product) async {
    // async wraps all the code into Future
    final url = Uri.parse(
        "https://shop-app-d1490-default-rtdb.europe-west1.firebasedatabase.app/products.json");
    //url of our database
    try {
      //wrap the parts of the code that might throw errors/exceptions
      final response = await http.post(url,
          body: json.encode({
            "description": product.description,
            "imageUrl": product.imageUrl,
            "price": product.price,
            "title": product.title,
            "isFavorite": product.isFavorite,
          }));
      //posting the new product to DB. await is doing the action that
      //will be done after the synced code is done
      final newProduct = Product(
          id: json.decode(response.body)["name"],
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
          title: product.title);

      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
    // 'with ChangeNotifier' gives access to this functions, that lets everyone know about the changes
    //the changes of the _items have to be done inside this class, so that everyone will be notified
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final prodIndex =
        _items.indexWhere((element) => element.id == newProduct.id);
    if (prodIndex >= 0) {
      final url = Uri.parse(
          "https://shop-app-d1490-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json");
      // we are using string interpolation to access not the whole folder of our products,
      //but only to access the updated product
      await http.patch(url,
          body: json.encode({
            "title": newProduct.title,
            "description": newProduct.description,
            "imageUrl": newProduct.imageUrl,
            "price": newProduct.price,
          }));
      //patch request updates the existing item in the firebase
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print("...");
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        "https://shop-app-d1490-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json");
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException("Could not delete the product");
    }
    // throw stops the execution.
    existingProduct = null;
  }
}
// here we are using optimistic updating. If the deleting fails,
// we will return the deleted product, because removeat removes the
// item from the list, but not from the memory!
