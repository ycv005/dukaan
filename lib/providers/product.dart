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

  void toggleFavourite() {
    isFavourite = !isFavourite;
    notifyListeners();
  }
}
