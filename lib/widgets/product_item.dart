import 'package:dukaan/providers/cart.dart';
import 'package:dukaan/providers/product.dart';
import 'package:provider/provider.dart';

import '../pages/product_detail.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final cart = Provider.of<Cart>(context, listen: false);
    return GridTile(
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(ProductDetail.routeName, arguments: {"id": product.id}),
        child: Image.network(
          product.imgUrl,
          fit: BoxFit.cover,
        ),
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black45,
        title: Text(product.title),
        leading: IconButton(
          icon: Icon(
              product.isFavourite ? Icons.favorite : Icons.favorite_border),
          onPressed: product.toggleFavourite,
        ),
        trailing: IconButton(
          icon: Icon(Icons.shopping_cart),
          onPressed: () {
            cart.addItems(
              product.id,
              product.price,
              product.title,
            );
            Scaffold.of(context).hideCurrentSnackBar();
            Scaffold.of(context).showSnackBar(SnackBar(
              content: Text("Item added to the card"),
              duration: Duration(seconds: 2),
              action: SnackBarAction(
                label: "UNDO",
                onPressed: () {
                  cart.removeSingleItem(product.id);
                },
              ),
            ));
          },
        ),
      ),
    );
  }
}
