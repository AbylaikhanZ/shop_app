import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart.dart';

class CartScreenItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String title;
  final String imageURL;
  final String productId;
  CartScreenItem(
      {@required this.id,
      @required this.imageURL,
      @required this.price,
      @required this.quantity,
      @required this.title,
      @required this.productId});

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(true);
                          },
                          child: Text("Yes")),
                      TextButton(
                          onPressed: () {
                            Navigator.of(ctx).pop(false);
                          },
                          child: Text("No")),
                    ],
                    content:
                        Text("Do you want to remove the item from your cart?"),
                    title: Text("Are you sure?")));
      },
      background: ClipRRect(
        borderRadius: BorderRadius.circular(35),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          padding: EdgeInsets.all(5),
          color: Theme.of(context).colorScheme.error,
          alignment: Alignment.centerRight,
          child: IconButton(
            color: Colors.white,
            icon: Icon(Icons.delete),
            onPressed: () {},
          ),
        ),
      ),
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      child: ClipRRect(
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
          )),
    );
  }
}
