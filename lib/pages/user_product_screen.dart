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
    await Provider.of<Products>(context).fetchAndSetProduct(filterByUser: true);
  }

  @override
  Widget build(BuildContext context) {
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
      body: FutureBuilder(
        future: _refereshProducts(context),
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refereshProducts(context),
                    child: Consumer<Products>(
                      builder: (context, products, _) => ListView.builder(
                        itemBuilder: (context, index) {
                          return Column(children: [
                            UserProductItem(
                                products.items[index], products.deleteProduct),
                            Divider(),
                          ]);
                        },
                        itemCount: products.items.length,
                      ),
                    ),
                  ),
      ),
    );
  }
}
