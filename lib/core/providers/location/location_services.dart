//
// location_services.dart
// AgroShare
//
// Create by Vinícius Bruno on 28/09/2026
//

import 'package:flutter/material.dart';

import 'package:geolocator/geolocator.dart';

class LocationServices with ChangeNotifier {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  double? _latitude;
  double? _longitude;

  double? get latitude => _latitude;
  double? get longitude => _longitude;

  bool get latLongIsNotEmpty => _latitude != null && _longitude != null;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  Future<void> determinePosition() async {
    _setLoading(true);

    try {
      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        // O usuário precisa ligar o GPS e tocar no mapa novamente.
        await Geolocator.openLocationSettings();
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) return;

      if (permission == LocationPermission.deniedForever) {
        // Só é possível conceder pelas configurações do app.
        await Geolocator.openAppSettings();
        return;
      }

      final Position currentPosition = await Geolocator.getCurrentPosition();

      _latitude = currentPosition.latitude;
      _longitude = currentPosition.longitude;
    } catch (e) {
      debugPrint('Erro ao obter localização: $e');
    } finally {
      _setLoading(false);
    }
  }

}
