import 'package:flutter/material.dart';
import '../providers/cart.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';
import '../providers/product.dart';
import '../providers/auth.dart';

class ProductItem extends StatelessWidget {
  // final String id;
  // final String title;
  // final String imageUrl;
  // const ProductItem(
  //     {@required this.id, @required this.imageUrl, @required this.title});
  @override
  Widget build(BuildContext context) {
    final scaffold = ScaffoldMessenger.of(context);
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    final authData = Provider.of<Auth>(context, listen: false);
    // in this page, we do not need to rebuild the whole widget, so we set the listen option to false
    // the only thing that updates is the favorite button
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: GestureDetector(
          onTap: () {
            Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                arguments: product.id);
          },
          child: Image.network(
            product.imageUrl,
            fit: BoxFit.cover,
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, product, child) => IconButton(
                icon: Icon(product.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                onPressed: () async {
                  try {
                    await product.toggleFavorite(authData.token);
                  } catch (error) {
                    scaffold.showSnackBar(SnackBar(
                        content: Text(
                      "Failed to change the favorite status :(",
                      textAlign: TextAlign.center,
                    )));
                  }
                },
                color: Theme.of(context).colorScheme.secondary),
          ),
          // we wrap the widget of the leading argument, which is IconButton with a Consumer<Product>
          // in order to avoid rebuilding of the whole widget, but instead to rebuild only the IconButton
          trailing: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                cart.addItem(
                    product.id, product.price, product.title, product.imageUrl);
                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                    "Item added to the cart!",
                  ),
                  duration: Duration(seconds: 3),
                  action: SnackBarAction(
                    label: "UNDO",
                    onPressed: () => cart.removeSingleItem(product.id),
                  ),
                ));
              },
              color: Theme.of(context).colorScheme.secondary),
          backgroundColor: Colors.black54,
          title: Text(
            product.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
