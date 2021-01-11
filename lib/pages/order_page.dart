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
  bool _isLoading = true;
  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      Provider.of<Orders>(context, listen: false)
          .fetchAndSetOrders()
          .then((value) => setState(() {
                _isLoading = false;
              }));
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
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Consumer<Orders>(
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
            ),
    );
  }
}
