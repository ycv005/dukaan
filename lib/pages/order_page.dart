import 'package:dukaan/providers/orders.dart' show Orders;
import 'package:dukaan/widgets/order_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatelessWidget {
  static const routeName = '/order';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      body: Consumer<Orders>(
        builder: (context, orders, _) => ListView.builder(
          itemBuilder: (ctx, index) {
            return OrderItem(orders.orders[index]);
          },
          itemCount: orders.orders.length,
        ),
      ),
    );
  }
}
