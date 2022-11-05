import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/cart_screen_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Your Cart")),
      body: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: 5,
          vertical: 20,
        ),
        child: Column(
          children: [
            Expanded(
                child: ListView.builder(
              itemBuilder: ((context, i) => CartScreenItem(
                    id: cart.items.values.toList()[i].id,
                    price: cart.items.values.toList()[i].price,
                    quantity: cart.items.values.toList()[i].quantity,
                    title: cart.items.values.toList()[i].title,
                    imageURL: cart.items.values.toList()[i].imageURL,
                  )),
              itemCount: cart.items.length,
            )),
            //wrapped the listview to expanded, because listview
            //uses all the space it can get, and column is infinite.

            Card(
              margin: EdgeInsets.all(15),
              elevation: 10,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Total: ", style: TextStyle(fontSize: 20)),
                      Chip(
                          label: Text(
                            "\$${cart.totalAmount.toStringAsFixed(2)}",
                            style: TextStyle(
                                color: Theme.of(context)
                                    .primaryTextTheme
                                    .titleMedium
                                    .color,
                                fontSize: 20),
                          ),
                          backgroundColor:
                              Theme.of(context).colorScheme.primary),
                    ],
                  )),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: SizedBox.fromSize(
                size: Size(double.infinity, 60),
                child: ElevatedButton(
                  onPressed: () {},
                  child: Text("ORDER NOW",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  style: ButtonStyle(
                    elevation: MaterialStateProperty.all(5.0),
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                        RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15))),
                  ),
                ),
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ),
    );
  }
}
