import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id, title, description, imgUrl;
  double price;
  bool isFavourite;
  bool isInCart;
  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imgUrl,
    @required this.price,
    this.isFavourite = false,
    this.isInCart = false,
  });

  factory Product.fromJson(String id, Map<String, dynamic> json) {
    return Product(
      id: id,
      title: json['title'],
      description: json['description'],
      imgUrl: json['imgUrl'],
      price: json['price'],
      isFavourite: json['isFavourite'],
    );
  }

  static Map<String, dynamic> toJson(Product product) {
    return {
      "id": product.id,
      "title": product.title,
      "description": product.description,
      "imgUrl": product.imgUrl,
      "price": product.price,
      "isFavourite": product.isFavourite,
    };
  }
}
