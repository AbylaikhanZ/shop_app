import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/cart_screen_item.dart';
import '../providers/orders.dart';

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
                    imageURL: cart.items.values.toList()[i].imageUrl,
                    productId: cart.items.keys.toList()[i],
                  )),
              //we use this weird way of sending the data because
              //cart.items is a map, and we need to get to its values
              //and keys separately
              itemCount: cart.items.length,
            )),
            //wrapped the listview to expanded, because listview
            //uses all the space it can get, and column is infinite.

            Card(
              margin: EdgeInsets.all(15),
              elevation: 5,
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
                child: OrderButton(cart: cart),
              ),
            )
          ],
          mainAxisAlignment: MainAxisAlignment.end,
        ),
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: (widget.cart.totalAmount <= 0 || _isLoading == true)
          ? null
          : () async {
              setState(() {
                _isLoading = true;
              });
              try {
                await Provider.of<Orders>(context, listen: false).addOrder(
                  widget.cart.items.values.toList(),
                  widget.cart.totalAmount,
                );
                setState(() {
                  _isLoading = false;
                });
                widget.cart.clear();
              } catch (error) {
                await showDialog(
                    context: context,
                    builder: (ctx) => AlertDialog(
                          title: Text("An error occured!"),
                          content: Text(
                              "Something went wrong, when trying to make an order!"),
                          actions: [
                            TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text("Okay"))
                          ],
                        ));
              }
            },
      child: _isLoading
          ? CircularProgressIndicator()
          : Text("ORDER NOW",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
      style: ButtonStyle(
        elevation: MaterialStateProperty.all(5.0),
        shape: MaterialStateProperty.all<OutlinedBorder>(
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))),
      ),
    );
  }
}
