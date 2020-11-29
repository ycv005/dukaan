import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './pages/cart_page.dart';
import './pages/edit_user_product.dart';
import './pages/order_page.dart';
import './pages/product_detail.dart';
import './pages/product_overview_screen.dart';
import './pages/user_product_screen.dart';
import './providers/orders.dart';
import './providers/cart.dart';
import './providers/products.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (BuildContext context) => Products()),
      ChangeNotifierProvider(create: (BuildContext context) => Cart()),
      ChangeNotifierProvider(create: (BuildContext context) => Orders()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  static const appName = "Dukaan";
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: appName,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        accentColor: Colors.yellowAccent,
      ),
      home: ProductOverviewScreen(),
      routes: {
        ProductDetail.routeName: (ctx) => ProductDetail(),
        CartPage.routeName: (ctx) => CartPage(),
        OrderPage.routeName: (ctx) => OrderPage(),
        UserProductScreen.routeName: (ctx) => UserProductScreen(),
        EditUserProduct.routeName: (ctx) => EditUserProduct(),
      },
    );
  }
}
