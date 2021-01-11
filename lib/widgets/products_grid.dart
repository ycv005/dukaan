import 'package:dukaan/providers/products.dart';
import 'package:provider/provider.dart';
import 'product_item.dart';
import 'package:flutter/material.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavourite;
  const ProductsGrid(this.showFavourite);
  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    final products =
        showFavourite ? productData.favouriteItems : productData.items;
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 5, mainAxisSpacing: 5),
      itemBuilder: (ctx, i) {
        return ChangeNotifierProvider.value(
            // create: (BuildContext context) => products[i],
            value: products[i],
            child: ProductItem(products[i]));
      },
      itemCount: products.length,
    );
  }
}
