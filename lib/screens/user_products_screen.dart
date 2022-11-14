import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';
import '../providers/products_prov.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = "/user-products";
  Future<void> _refreshProducts(BuildContext context) async {
    await Provider.of<Products_Prov>(context, listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products_Prov>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text("Your products"),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(EditProductScreen.routeName);
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: RefreshIndicator(
          onRefresh: () => _refreshProducts(context),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemCount: productsData.items.length,
              itemBuilder: ((_, i) => Column(children: [
                    UserProductItem(
                      id: productsData.items[i].id,
                      imageUrl: productsData.items[i].imageUrl,
                      title: productsData.items[i].title,
                    ),
                    Divider()
                  ])),
            ),
          ),
        ));
  }
}
