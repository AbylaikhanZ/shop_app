import 'package:flutter/foundation.dart';
import './cart.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem(
      {@required this.amount,
      @required this.dateTime,
      @required this.id,
      @required this.products});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = Uri.parse(
        "https://shop-app-d1490-default-rtdb.europe-west1.firebasedatabase.app/orders.json");
    final timeStamp = DateTime.now();
    try {
      //wrap the parts of the code that might throw errors/exceptions
      final response = await http.post(url,
          body: json.encode({
            "amount": total,
            "dateTime": timeStamp.toIso8601String(),
            "products": cartProducts
                .map((e) => {
                      "id": e.id,
                      "imageURL": e.imageURL,
                      "title": e.title,
                      "price": e.price,
                      "quantity": e.quantity
                    })
                .toList(),
          }));
      //posting the new product to DB. await is doing the action that
      //will be done after the synced code is done
      final newOrder = OrderItem(
          id: json.decode(response.body)["name"],
          amount: total,
          dateTime: timeStamp,
          products: cartProducts);

      _orders.insert(0, newOrder);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
