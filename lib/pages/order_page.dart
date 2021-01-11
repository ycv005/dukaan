import 'package:dukaan/providers/orders.dart' show Orders;
import 'package:dukaan/widgets/order_item.dart';
import 'package:dukaan/widgets/product_page_drawer.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class OrderPage extends StatefulWidget {
  static const routeName = '/order';

  @override
  _OrderPageState createState() => _OrderPageState();
}

class _OrderPageState extends State<OrderPage> {
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<Orders>(context, listen: false).fetchAndSetOrders();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
      ),
      drawer: DrawerProductPage(),
      body: Consumer<Orders>(
        builder: (context, orders, _) => ListView.builder(
          itemBuilder: (ctx, index) {
            if (orders.orders.length > 0) {
              return OrderItem(orders.orders[index]);
            }
            return Center(
              child: CircularProgressIndicator(),
            );
          },
          itemCount: orders.orders.length,
        ),
      ),
    );
  }
}
