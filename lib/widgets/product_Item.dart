import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final String id;
  final String title;
  final String imageUrl;
  const ProductItem(
      {@required this.id, @required this.imageUrl, @required this.title});
  @override
  Widget build(BuildContext context) {
    return GridTile(
      child: Image.network(
        imageUrl,
        fit: BoxFit.cover,
      ),
      footer: GridTileBar(
        leading: IconButton(icon: Icon(Icons.favorite), onPressed: () {}),
        trailing: IconButton(icon: Icon(Icons.shopping_cart), onPressed: () {}),
        backgroundColor: Colors.black54,
        title: Text(title, textAlign: TextAlign.center),
      ),
    );
  }
}
