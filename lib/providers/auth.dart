import 'dart:convert';

import 'package:dukaan/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:dukaan/settings/firebase.dart';

class Auth with ChangeNotifier {
  String _token, _userId;
  DateTime _expiryDateOfToken;
  FirebaseSetting firebaseSetting = FirebaseSetting();

  bool get isAuthenticated {
    return getUserAuthToken != null;
  }

  String get getUserAuthToken {
    if (_expiryDateOfToken != null &&
        _expiryDateOfToken.isAfter(DateTime.now()) &&
        _token != null) {
      return _token;
    }
    return null;
  }

  Future<void> _authenticate(String email, String password, String url) async {
    try {
      final response = await http.post(
        url,
        body: jsonEncode(getUserSignUpBody(email, password)),
      );
      final responseData = jsonDecode(response.body) as Map;
      print("here is the auth response- $responseData");
      if (responseData.containsKey('error')) {
        throw HttpException(responseData['error']['message']);
      }

      _token = responseData['idToken'];
      _userId = responseData['localId'];
      _expiryDateOfToken = DateTime.now()
          .add(Duration(seconds: int.parse(responseData['expiresIn'])));
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> login(String email, String password) async {
    String apiKey = firebaseSetting.webApiKey;
    String signInEndpoint =
        "https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=[$apiKey]";
    return _authenticate(email, password, signInEndpoint);
  }

  Future<void> signUp(String email, String password) async {
    String apiKey = firebaseSetting.webApiKey;
    String signUpEndpoint =
        "https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=[$apiKey]";
    return _authenticate(email, password, signUpEndpoint);
  }

  Map<String, dynamic> getUserSignUpBody(String email, String password) {
    return {
      "email": email,
      "password": password,
      "returnSecureToken": true,
    };
  }
}
