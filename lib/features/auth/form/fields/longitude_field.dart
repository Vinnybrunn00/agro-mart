/*
 * lib/features/auth/form/fields/longitude_field.dart
 *
 * Campo de longitude da propriedade e sua validação.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 05/10/2026
 */

import 'package:flutter/widgets.dart';

class LongitudeField with ChangeNotifier {
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
