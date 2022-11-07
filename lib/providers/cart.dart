import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double price;
  final String imageURL;

  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price,
      @required this.imageURL});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  // we will have 2 different IDs, one of the product item, and the other
  //for the item in the cart, so we need a map to keep track of both of them
  Map<String, CartItem> get items {
    return {..._items};
  }
  // this instance of items is public

  int get countItems {
    int itemsNumber = 0;
    _items.forEach((key, cartItem) {
      itemsNumber += cartItem.quantity;
    });
    return itemsNumber;
  }
  //returns an amount of ordered items.

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quantity;
    });
    return total;
  }

  void addItem(String productId, double price, String title, String imageURL) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (existingCartItem) => CartItem(
              id: existingCartItem.id,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity + 1,
              price: existingCartItem.price,
              imageURL: existingCartItem.imageURL));
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
              imageURL: imageURL));
    }
    notifyListeners(); // create a new cartitem
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    } else if (_items[productId].quantity == 1) {
      _items.remove(productId);
    } else if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (oldCartItem) => CartItem(
                id: oldCartItem.id,
                imageURL: oldCartItem.imageURL,
                price: oldCartItem.price,
                quantity: oldCartItem.quantity - 1,
                title: oldCartItem.title,
              ));
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
