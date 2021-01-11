import 'package:dukaan/pages/edit_user_product.dart';
import 'package:dukaan/providers/product.dart';
import 'package:flutter/material.dart';

class UserProductItem extends StatelessWidget {
  final Product product;
  final Function delProduct;
  const UserProductItem(this.product, this.delProduct);
  @override
  Widget build(BuildContext context) {
    final scaffold = Scaffold.of(context);
    return ListTile(
      title: Text(
        product.title,
      ),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imgUrl ??
            "https://www.google.com/url?sa=i&url=https%3A%2F%2Fen.wikipedia.org%2Fwiki%2FFile%3ANo_image_available.svg&psig=AOvVaw3pu2nE0hVKokAZc7ErbzhF&ust=1608537906949000&source=images&cd=vfe&ved=0CAIQjRxqFwoTCPDembiN3O0CFQAAAAAdAAAAABAD"),
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
              onPressed: () async {
                try {
                  await delProduct(product.id);
                } catch (e) {
                  scaffold.showSnackBar(
                      SnackBar(content: Text("Unable to delete")));
                }
              },
              color: Theme.of(context).errorColor,
            )
          ],
        ),
      ),
    );
  }
}
