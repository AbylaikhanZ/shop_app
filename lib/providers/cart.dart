import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  // we will have 2 different IDs, one of the product item, and the other
  //for the item in the cart, so we need a map to keep track of both of them
  Map<String, CartItem> get items {
    return {..._items};
  }

  int get countItems {
    return _items.length;
  }
  // this instance of items is public

  void addItem(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + 1,
              price: existingCartItem.price));
      //update the exxisting cart item if what we are
      // trying to add the the cart is already there
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItem(
                id: DateTime.now().toString(),
                title: title,
                quantity: 1,
                price: price,
              ));
    }
    notifyListeners(); // create a new cartitem
  }
}
