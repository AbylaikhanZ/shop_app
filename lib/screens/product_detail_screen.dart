import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';
import '../providers/products_prov.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = "/product-detail";

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final cart = Provider.of<Cart>(context, listen: false);
    final loadedProduct =
        Provider.of<Products_Prov>(context, listen: false).findById(productId);
    // it is better to create the functions in the other widgets, to do the heavy lifting.
    // listen false is needed in order to not update the page, when, for example, a new item is added to the list
    // in this case we only need to get the data once, no need to update it every time
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedProduct.title),
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          Image.network(
            loadedProduct.imageUrl,
          ),
          SizedBox(
            height: 10,
          ),
          Chip(
            backgroundColor: Theme.of(context).colorScheme.primary,
            elevation: 8,
            label: Text(
              "\$${loadedProduct.price.toString()}",
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              loadedProduct.description,
              style: TextStyle(fontSize: 18),
              softWrap: true,
            ),
            width: double.infinity,
            alignment: Alignment.center,
          )
        ],
      )),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Theme.of(context).colorScheme.primary,
        foregroundColor: Theme.of(context).colorScheme.background,
        onPressed: () {
          cart.addItem(loadedProduct.id, loadedProduct.price,
              loadedProduct.title, loadedProduct.imageUrl);
        },
      ),
    );
  }
}
