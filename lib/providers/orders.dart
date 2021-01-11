import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItemModel> products;
  final DateTime dateTime;
  const OrderItem({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });

  static Map<String, dynamic> toJson(OrderItem orderItem) {
    return {
      'id': orderItem.id,
      'amount': orderItem.amount,
      'dateTime': orderItem.dateTime is DateTime
          ? orderItem.dateTime.toIso8601String()
          : orderItem.dateTime,
      'products':
          orderItem.products.map((cp) => CartItemModel.toJson(cp)).toList(),
    };
  }

  factory OrderItem.fromJson(String id, Map<String, dynamic> json) {
    return OrderItem(
      id: id,
      amount: json['amount'],
      products: (json['products'] as List)
          .map((cartItem) => CartItemModel.fromJson(cartItem))
          .toList(),
      dateTime: DateTime.parse(json['dateTime']),
    );
  }
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItemModel> cartProducts, double total) async {
    const url = "https://dukaan-5902a.firebaseio.com/orders.json";
    final timeStamp = DateTime.now();
    final OrderItem orderItem = OrderItem(
      id: timeStamp.toString(),
      amount: total,
      products: cartProducts,
      dateTime: timeStamp,
    );
    try {
      final response = await http.post(
        url,
        body: json.encode(OrderItem.toJson(orderItem)),
      );
      _orders.insert(
          0,
          OrderItem(
            id: json.decode(response.body)['name'],
            amount: total,
            products: cartProducts,
            dateTime: timeStamp,
          ));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> fetchAndSetOrders() async {
    const url = "https://dukaan-5902a.firebaseio.com/orders.json";
    try {
      final response = await http.get(url);
      final jsonDecoded = json.decode(response.body) as Map<String, dynamic>;
      print("here is the json $jsonDecoded");
      List<OrderItem> loadedOrders = [];
      jsonDecoded.forEach((key, value) {
        print("here into jsonDecoded");
        loadedOrders.add(OrderItem.fromJson(key, value));
      });
      _orders = loadedOrders;
      print("here is the loadorder- $loadedOrders");
      notifyListeners();
    } catch (e) {}
  }
}
