import 'dart:async';
import 'dart:convert';

import 'package:dukaan/models/http_exception.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:dukaan/settings/firebase.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Auth with ChangeNotifier {
  String _token, _userId;
  DateTime _expiryDateOfToken;
  FirebaseSetting firebaseSetting = FirebaseSetting();
  Timer _authTimer;

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

  String get getUserId {
    if (getUserAuthToken != null) {
      return _userId;
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
      _autoLogout();
      notifyListeners();
      final data = json.encode({
        "token": _token,
        "userId": _userId,
        "expiryDate": _expiryDateOfToken.toIso8601String(),
      });
      final prefs = await SharedPreferences.getInstance();
      prefs.setString('userAuthInfo', data);
    } catch (e) {
      throw e;
    }
  }

  Future<bool> tryAutoLogin() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userAuthInfo')) {
      return false;
    }
    final userData =
        json.decode(prefs.get('userAuthInfo')) as Map<String, dynamic>;

    final DateTime expiryData = DateTime.parse(userData['expiryDate']);
    if (expiryData.isBefore(DateTime.now())) {
      return false;
    }
    _token = userData['token'];
    _userId = userData['userId'];
    _expiryDateOfToken = userData['expiryDate'];
    notifyListeners();
    _autoLogout();
    return true;
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

  void logout() async {
    _token = null;
    _userId = null;
    _expiryDateOfToken = null;
    if (_authTimer != null) {
      _authTimer.cancel();
      _authTimer = null;
    }
    final prefs = await SharedPreferences.getInstance();
    // prefs.remove('userAuthInfo');
    prefs.clear();
    notifyListeners();
  }

  void _autoLogout() {
    if (_authTimer != null) {
      _authTimer.cancel();
    }
    final timeToExpiry =
        _expiryDateOfToken.difference(DateTime.now()).inSeconds;
    _authTimer = Timer(Duration(seconds: timeToExpiry), () {
      logout();
    });
  }
}
