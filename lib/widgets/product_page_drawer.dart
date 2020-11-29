import 'package:dukaan/pages/cart_page.dart';
import 'package:dukaan/pages/order_page.dart';
import 'package:dukaan/pages/user_product_screen.dart';
import 'package:flutter/material.dart';

class DrawerProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Container(),
          ),
          ListTile(
            title: Text("Shop"),
            leading: Icon(Icons.shop),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          Divider(),
          ListTile(
            title: Text("Cart"),
            leading: Icon(Icons.shopping_cart),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(CartPage.routeName),
          ),
          Divider(),
          ListTile(
            title: Text("Orders"),
            leading: Icon(Icons.payment),
            onTap: () =>
                Navigator.of(context).pushReplacementNamed(OrderPage.routeName),
          ),
          Divider(),
          ListTile(
            title: Text("Manage Products"),
            leading: Icon(Icons.edit),
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(UserProductScreen.routeName),
          ),
          Divider(),
        ],
      ),
    );
  }
}
