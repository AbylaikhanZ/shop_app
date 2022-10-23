import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_prov.dart';

import 'product_Item.dart';
import '../models/product.dart';

class ProductGrid extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products_Prov>(context);
    //provider of context makes this builld method and all its children become listeners
    //this widget will re-run when the data of the provider is changed
    final products = productsData.items;
    //productsData is getting access to the provider's class
    //.items is using the getter of the provider

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ProductItem(
        id: products[i].id,
        imageUrl: products[i].imageUrl,
        title: products[i].title,
      ),
    );
  }
}
