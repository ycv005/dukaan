import 'package:dukaan/pages/edit_user_product.dart';
import 'package:dukaan/providers/product.dart';
import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final Product product;
  final Function delProduct;
  const UserProductItem(this.product, this.delProduct);
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(
        product.title,
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imgUrl),
      ),
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(Icons.edit),
              onPressed: () => Navigator.of(context)
                  .pushNamed(EditUserProduct.routeName, arguments: product.id),
              color: Theme.of(context).primaryColor,
            ),
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: () => delProduct(product.id),
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
