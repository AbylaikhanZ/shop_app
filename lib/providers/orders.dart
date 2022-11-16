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

  Future<void> fetchOrders() async {
    final url = Uri.parse(
        "https://shop-app-d1490-default-rtdb.europe-west1.firebasedatabase.app/orders.json");
    final response = await http.get(url);
    final List<OrderItem> loadedOrders = [];
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    if (extractedData == null) {
      return;
    }
    extractedData.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          amount: orderData["amount"],
          dateTime: DateTime.parse(orderData["dateTime"]),
          id: orderId,
          products: (orderData["products"] as List<dynamic>)
              .map((item) => CartItem(
                  id: item["id"],
                  title: item["title"],
                  quantity: item["quantity"],
                  price: item["price"],
                  imageUrl: item["imageUrl"]))
              .toList()));
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
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
                      "imageUrl": e.imageUrl,
                      "title": e.title,
                      "price": e.price,
                      "quantity": e.quantity
                    })
                .toList(),
          }));
      //posting the new order to DB. await is doing the action that
      //will be done after the synced code is done
      // here we have a nested map, since the cart products are a list of products
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
