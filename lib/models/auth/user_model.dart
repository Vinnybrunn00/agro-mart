//  user_model.dart
//  AgroMart
//
//  Create by Vinicius Bruno on 05/09/2026
//

import 'dart:io';

import 'package:flutter/material.dart';

class UserModel with ChangeNotifier {
  String? name;
  String? email;
  String? cpf;
  String? password;
  File? image;
  bool? isCheck = false;
  String? nameProperty;
  String? locationProperty;
  double? latitude;
  double? longitude;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  set setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void onChange(bool? value) {
    isCheck = value;
    notifyListeners();
  }

  Map<String, dynamic> get _map {
    return {
      'name': name,
      'cpf': cpf,
      'email': email,
      'password': password,
      'isCheck': isCheck,
      'photo': image?.path,
      'namePropriety': nameProperty,
      'locationProperty': locationProperty,
      'latitude': latitude,
      'longitude': longitude,
    };
  }

  @override
  String toString() {
    return _map.toString();
  }
}
