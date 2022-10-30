import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/products_prov.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products_Prov>(context, listen: false).findById(productId);
    // it is better to create the functions in the other widgets, to do the heavy lifting.
    // listen false is needed in order to not update the page, when, for example, a new item is added to the list
    // in this case we only need to get the data once, no need to update it every time
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
    );
  }
}
