import 'package:dukaan/pages/auth_screen.dart';
import 'package:dukaan/pages/loading_screen.dart';
import 'package:dukaan/providers/auth.dart';
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
      ChangeNotifierProvider(create: (BuildContext context) => Auth()),
      ChangeNotifierProxyProvider<Auth, Products>(
        update: (BuildContext context, auth, Products previousProducts) =>
            previousProducts..setValues(auth.getUserAuthToken, auth.getUserId),
        create: (BuildContext context) => Products(),
      ),
      ChangeNotifierProvider(create: (BuildContext context) => Cart()),
      ChangeNotifierProxyProvider<Auth, Orders>(
        create: (BuildContext context) => Orders(),
        update: (context, auth, previousOrders) =>
            previousOrders..setValues(auth.getUserAuthToken, auth.getUserId),
      ),
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
      home: Consumer<Auth>(
        builder: (context, auth, _) => auth.isAuthenticated
            ? ProductOverviewScreen()
            : FutureBuilder(
                future: auth.tryAutoLogin(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return LoadingScreen();
                  }
                  return AuthScreen();
                },
              ),
      ),
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
