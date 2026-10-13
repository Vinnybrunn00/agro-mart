//  Latitude.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 05/10/2026
//

import 'package:flutter/widgets.dart';

class LatitudeProperty with ChangeNotifier {
  String? _msgError;
  double? _latitude;

  String? get msgError => _msgError;
  double? get latitude => _latitude;

  void validate(double? latitude) {
    if (latitude == null) {
      _msgError = 'A Latitude não pode estar vazia';
      notifyListeners();
      throw Exception(_msgError);
    }

    _latitude = latitude;
    _msgError = null;
    notifyListeners();
  }
}
