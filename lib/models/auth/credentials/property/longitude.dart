//  longitude.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 05/10/2026
//

import 'package:flutter/widgets.dart';

class LongitudeProperty with ChangeNotifier {
  String? _msgError;
  double? _longitude;

  String? get msgError => _msgError;
  double? get longitude => _longitude;

  void validate(double? longitude) {
    if (longitude == null) {
      _msgError = 'A Longitude não pode estar vazia';
      notifyListeners();
      throw Exception(_msgError);
    }

    _longitude = longitude;
    _msgError = null;
    notifyListeners();
  }
}
