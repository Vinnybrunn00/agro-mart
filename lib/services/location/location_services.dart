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

    final bool serviceEnabled;
    late LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
    }

    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    final Position currentPosition = await Geolocator.getCurrentPosition();

    _latitude = currentPosition.latitude;
    _longitude = currentPosition.longitude;
    notifyListeners();

    _setLoading(false);
  }

  Stream<bool> get locationServiceStatusStream async* {
    yield await Geolocator.isLocationServiceEnabled();
    yield* Geolocator.getServiceStatusStream().map(
      (ServiceStatus status) => status == ServiceStatus.enabled,
    );
  }
}
