import 'package:dukaan/providers/cart.dart';
import 'package:dukaan/providers/product.dart';
import 'package:dukaan/providers/products.dart';
import 'package:provider/provider.dart';

import '../pages/product_detail.dart';
import 'package:flutter/material.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  const ProductItem(this.product);
  @override
  Widget build(BuildContext context) {
    final products = Provider.of<Products>(context);
    final cart = Provider.of<Cart>(context, listen: false);
    return GridTile(
      child: GestureDetector(
        onTap: () => Navigator.of(context)
            .pushNamed(ProductDetail.routeName, arguments: {"id": product.id}),
        child: Image.network(
          product.imgUrl ??
              "https://upload.wikimedia.org/wikipedia/commons/thumb/a/ac/No_image_available.svg/600px-No_image_available.svg.png",
          fit: BoxFit.cover,
        ),
      ),
      footer: GridTileBar(
        backgroundColor: Colors.black45,
        title: Text(product.title),
        leading: IconButton(
          icon: Icon(
              product.isFavourite ? Icons.favorite : Icons.favorite_border),
          onPressed: () async {
            try {
              await products.toggleFavourite(product.id);
            } catch (e) {
              Scaffold.of(context).showSnackBar(
                SnackBar(content: Text("Unable to make Favourite, Try Again")),
              );
            }
          },
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
