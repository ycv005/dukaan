import 'dart:convert';

import 'package:dukaan/models/http_exception.dart';
import 'package:dukaan/providers/product.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  List<Product> _items = [];
  String _authToken;
  String _userId;

  Products();

  void setValues(String token, String userId) {
    _authToken = token;
    _userId = userId;
  }

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favouriteItems {
    return _items.where((prod) => prod.isFavourite).toList();
  }

  bool _noProduct = false;

  bool get noProduct => _noProduct;

  Future<void> fetchAndSetProduct({bool filterByUser = false}) async {
    final filterString =
        filterByUser ? '&orderBy="createdBy"&equalTo="$_userId"' : '';
    final String url =
        'https://dukaan-5902a.firebaseio.com/products.json?auth=$_authToken' +
            filterString;
    try {
      final response = await http.get(url);
      final Map<String, dynamic> jsonDecoded =
          json.decode(response.body) as Map;
      if (jsonDecoded == null) {
        _noProduct = true;
      } else {
        final List<Product> loadedProducts = [];
        jsonDecoded.forEach((productId, productData) {
          loadedProducts.add(Product.fromJson(productId, productData));
        });
        _items = loadedProducts;
      }
      notifyListeners();
    } catch (e) {
      throw (e);
    }
  }

  Future<void> addProduct(Product product) {
    final url =
        "https://dukaan-5902a.firebaseio.com/products.json?auth=$_authToken";
    return http
        .post(url,
            body: json.encode({
              "title": product.title,
              "description": product.description,
              "imgUrl": product.imgUrl,
              "id": DateTime.now().toString(),
              "price": product.price,
              "isFavourite": product.isFavourite,
              "createdBy": _userId,
            }))
        .then((response) {
      final jsonResponse = json.decode(response.body);
      final newProduct = Product(
        title: product.title,
        description: product.description,
        imgUrl: product.imgUrl,
        id: jsonResponse['name'],
        price: product.price,
        isFavourite: product.isFavourite,
      );
      _items.add(newProduct);
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> updateProduct(String id, Product product) async {
    final index = _items.indexWhere((element) => element.id == id);
    if (index >= 0) {
      final url =
          "https://dukaan-5902a.firebaseio.com/products/$id.json?auth=$_authToken";
      try {
        await http.patch(url,
            body: json.encode(Product.toJson(product).remove('isFavourite')));
        _items[index] = product;
        notifyListeners();
      } catch (e) {
        throw e;
      }
    }
  }

  Future<void> deleteProduct(String id) async {
    try {
      final url =
          "https://dukaan-5902a.firebaseio.com/products/$id.json?auth=$_authToken";
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw HttpException("Could not delete Product.");
      }
      _items.removeWhere((element) => element.id == id);
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => id == prod.id);
  }

  int getProductIndex(String id) {
    return _items.indexWhere((prod) => prod.id == id);
  }

  Future<void> toggleFavourite(String id) async {
    final int productIndex = getProductIndex(id);
    final Product product = _items[productIndex];
    product.isFavourite = !product.isFavourite;
    notifyListeners();
    try {
      final url = "https://dukaan-5902a.firebaseio.com/products/$id.json";
      final response =
          await http.patch(url, body: json.encode(Product.toJson(product)));
      if (response.statusCode >= 400) {
        throw HttpException('Unable to toggle Favourite');
      }
    } catch (e) {
      product.isFavourite = !product.isFavourite;
      notifyListeners();
      throw e;
    }
  }
}
