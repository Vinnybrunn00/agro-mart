/*
 * lib/features/auth/form/fields/latitude_field.dart
 *
 * Campo de latitude da propriedade e sua validação.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 05/10/2026
 */

import 'package:flutter/widgets.dart';

class LatitudeField with ChangeNotifier {
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
