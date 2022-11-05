import 'package:flutter/material.dart';

class CartScreenItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  final String imageURL;
  CartScreenItem(
      {this.id, this.imageURL, this.price, this.quantity, this.title});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Card(
          elevation: 20,
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: Container(
              padding: EdgeInsets.all(5),
              margin: EdgeInsets.all(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: Image.network(
                      imageURL,
                      fit: BoxFit.contain,
                      height: 90,
                      width: 140,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: TextStyle(fontSize: 20),
                      ),
                      Chip(
                        label: Text(
                          "\$$price x $quantity = \$${(price * quantity).toStringAsFixed(2)}",
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ],
                //subtitle: Text("Total: \$${price * quantity}"),
              )),
        ));
  }
}
