import 'package:dukaan/pages/cart_page.dart';
import 'package:dukaan/providers/cart.dart';
import 'package:dukaan/providers/products.dart';
import 'package:dukaan/widgets/badge.dart';
import 'package:dukaan/widgets/product_page_drawer.dart';
import 'package:dukaan/widgets/products_grid.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';

enum FilterProductOptions {
  Favorites,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool _showFavourite = false;
  bool _firstInit = true;
  bool _isLoading = true;

  @override
  void didChangeDependencies() {
    if (_firstInit) {
      Provider.of<Products>(context).fetchAndSetProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      _firstInit = false;
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(MyApp.appName),
        actions: [
          PopupMenuButton(
            onSelected: (FilterProductOptions val) {
              setState(() {
                if (val == FilterProductOptions.All) {
                  _showFavourite = false;
                } else if (val == FilterProductOptions.Favorites) {
                  _showFavourite = true;
                }
              });
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem(
                child: Text("Show only Favourite"),
                value: FilterProductOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text("Show All"),
                value: FilterProductOptions.All,
              ),
            ],
            icon: Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            builder: (_, cart, childNotReBuild) => Badge(
                child: childNotReBuild, value: cart.countCartItem.toString()),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartPage.routeName),
            ),
          ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(
              backgroundColor: Theme.of(context).primaryColor,
            ))
          : RefreshIndicator(
              onRefresh: () async {
                Provider.of<Products>(context, listen: false)
                    .fetchAndSetProduct();
              },
              child: ProductsGrid(_showFavourite)),
      drawer: DrawerProductPage(),
    );
  }
}
