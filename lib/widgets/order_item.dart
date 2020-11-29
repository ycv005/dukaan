import 'dart:math';

import 'package:flutter/material.dart';
import 'package:dukaan/providers/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;
  const OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _isExpanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Column(
        children: [
          ListTile(
            title: Text("Total Amount- ${widget.order.amount}"),
            subtitle: Text(
                DateFormat("dd/MM/yyyy hh:mm").format(widget.order.dateTime)),
            trailing: IconButton(
              icon: Icon(_isExpanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () => setState(() {
                _isExpanded = !_isExpanded;
              }),
            ),
          ),
          if (_isExpanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 8),
              height: min(widget.order.products.length * 20.0 + 50, 120),
              child: ListView(
                children: widget.order.products
                    .map((prod) => Row(
                          children: [
                            Text(prod.name),
                            Spacer(),
                            Text(prod.quantity.toString() + 'x'),
                            SizedBox(
                              width: 5,
                            ),
                            Text(prod.price.toString()),
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
