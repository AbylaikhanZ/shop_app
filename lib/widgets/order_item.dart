import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../providers/orders.dart' as ord_prov;

class OrderItem extends StatefulWidget {
  final ord_prov.OrderItem order;
  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
        curve: Curves.easeOut,
        duration: Duration(milliseconds: 300),
        height: _expanded
            ? min(widget.order.products.length * 24.0 + 10, 120) + 85
            : 85,
        margin: EdgeInsets.all(10),
        child: Card(
          elevation: 8.0,
          child: Column(
            children: [
              ListTile(
                title: Text("\$${widget.order.amount.toStringAsFixed(2)}"),
                subtitle: Text(DateFormat("dd/MM/yyyy hh:mm")
                    .format(widget.order.dateTime)),
                trailing: IconButton(
                    icon:
                        Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                    onPressed: (() {
                      setState(() {
                        _expanded = !_expanded;
                      });
                    })),
              ),
              AnimatedContainer(
                duration: Duration(milliseconds: 300),
                curve: Curves.easeOut,
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 7),
                height: _expanded
                    ? min(widget.order.products.length * 24.0 + 10, 120)
                    : 0,
                child: ListView(
                  children: [
                    ...widget.order.products
                        .map((prod) => Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  prod.title,
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  "${prod.quantity} x \$${prod.price}",
                                  style: TextStyle(
                                      fontSize: 18, color: Colors.grey),
                                ),
                              ],
                            ))
                        .toList(),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
