import 'package:dukaan/pages/edit_user_product.dart';
import 'package:dukaan/widgets/product_page_drawer.dart';
import 'package:dukaan/widgets/user_product_item.dart';
import 'package:flutter/material.dart';
import 'package:dukaan/providers/products.dart';
import 'package:provider/provider.dart';

class UserProductScreen extends StatefulWidget {
  static const routeName = "/user-products";
  @override
  _UserProductScreenState createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  Future<void> _refereshProducts(BuildContext context) async {
    await Provider.of<Products>(context).fetchAndSetProduct();
  }

  @override
  Widget build(BuildContext context) {
    final productData = Provider.of<Products>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Products"),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.add,
              color: Color.fromRGBO(255, 255, 255, 1),
            ),
            onPressed: () =>
                Navigator.of(context).pushNamed(EditUserProduct.routeName),
          ),
        ],
      ),
      drawer: DrawerProductPage(),
      body: RefreshIndicator(
        onRefresh: () => _refereshProducts(context),
        child: ListView.builder(
          itemBuilder: (context, index) {
            return Column(children: [
              UserProductItem(
                  productData.items[index], productData.deleteProduct),
              Divider(),
            ]);
          },
          itemCount: productData.items.length,
        ),
      ),
    );
  }
}
