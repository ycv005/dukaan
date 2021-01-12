import 'package:dukaan/providers/orders.dart' show Orders;
import 'package:dukaan/widgets/order_item.dart';
import 'package:dukaan/widgets/product_page_drawer.dart';
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
        drawer: DrawerProductPage(),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("Error occured"),
              );
            }
            return Consumer<Orders>(
              builder: (context, orders, _) => ListView.builder(
                itemBuilder: (ctx, index) {
                  if (orders.noOrdersYet) {
                    return Center(
                      child: Text("No Orders made Yet"),
                    );
                  }
                  return OrderItem(orders.orders[index]);
                },
                itemCount: orders.orders.length,
              ),
            );
          },
        ));
  }
}
