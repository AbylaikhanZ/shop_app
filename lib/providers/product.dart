import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.description,
      @required this.imageUrl,
      this.isFavorite = false,
      @required this.price,
      @required this.title});

  Future<void> toggleFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        "https://shop-app-d1490-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json");
    try {
      final response = await http.patch(url,
          body: json.encode({
            "isFavorite": isFavorite,
            "title": title,
            "description": description,
            "imageUrl": imageUrl,
            "price": price,
          }));
      if (response.statusCode >= 400) {
        isFavorite = !isFavorite;
        notifyListeners();
        throw HttpException("Could not change the favorite status");
      }
    } catch (error) {
      //isFavorite = !isFavorite;
      //notifyListeners();
      throw error;
    }
  }
}
