import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';
import '../models/product.dart';

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

  void addProduct() {
    //_items.add(value);
    notifyListeners();
    // 'with ChangeNotifier' gives access to this functions, that lets everyone know about the changes
    //the changes of the _items have to be done inside this class, so that everyone will be notified
  }
}
