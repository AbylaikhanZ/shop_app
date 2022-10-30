import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/providers/products_prov.dart';

import 'product_Item.dart';
import '../providers/product.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavs;
  ProductGrid(this.showFavs);
  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products_Prov>(context);
    //provider of context makes this builld method and all its children become listeners
    //this widget will re-run when the data of the provider is changed
    final products = showFavs ? productsData.favoriteItems : productsData.items;
    //productsData is getting access to the provider's class
    //.items is using the getter of the provider
    //.favoriteItems is using the getter that gets only the favorite items

    return GridView.builder(
      padding: const EdgeInsets.all(10.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15),
      itemCount: products.length,
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        // we are making a provider in the grid, so that product item will listen to the changes of favorites.
        // it is better to use provider.value when we are using an existing object type (list, string etc.)
        // but if we are using a newly created class, it is better to use "create"
        value: products[i],
        // provider creates an object for each product individually
        child: ProductItem(
            // id: products[i].id,
            // imageUrl: products[i].imageUrl,
            // title: products[i].title,
            ),
      ),
    );
  }
}
