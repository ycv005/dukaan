import 'package:dukaan/providers/product.dart';
import 'package:flutter/material.dart';

class CartItemModel {
  final String id, name;
  final double price;
  final int quantity;
  const CartItemModel({
    @required this.id,
    @required this.name,
    @required this.price,
    @required this.quantity,
  });
  static Map<String, dynamic> toJson(CartItemModel cartItemModel) {
    return {
      'id': cartItemModel.id,
      'name': cartItemModel.name,
      'price': cartItemModel.price,
      'quantity': cartItemModel.quantity,
    };
  }

  factory CartItemModel.fromJson(Map<String, dynamic> json, {String id}) {
    String _id = id ?? json['id'];
    return CartItemModel(
      id: _id,
      name: json['name'],
      price: json['price'],
      quantity: json['quantity'],
    );
  }
}

class Cart with ChangeNotifier {
  Map<String, CartItemModel> _items = {};
  Map<String, CartItemModel> get items {
    return {..._items};
  }

  int get countCartItem {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, value) => total += (value.price) * value.quantity);
    return total;
  }

  void addItems(String productId, double price, String name) {
    if (_items.containsKey(productId)) {
      _items.update(
          productId,
          (cartItem) => CartItemModel(
                id: cartItem.id,
                price: cartItem.price,
                name: cartItem.name,
                quantity: cartItem.quantity + 1,
              ));
    } else {
      _items.putIfAbsent(
          productId,
          () => CartItemModel(
                id: DateTime.now().toString(),
                price: price,
                name: name,
                quantity: 1,
              ));
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (_items.containsKey(productId)) {
      return;
    }
    if (_items[productId].quantity > 1) {
      _items.update(
          productId,
          (item) => CartItemModel(
                id: item.id,
                name: item.name,
                price: item.price,
                quantity: item.quantity - 1,
              ));
    } else {
      _items.remove(productId);
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
