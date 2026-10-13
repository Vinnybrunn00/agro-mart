
import 'dart:io';

import 'package:flutter/widgets.dart';

class ImagesEquipamento with ChangeNotifier {
  String? _error;
  List<String> _images = [];

  List<String> get images => _images;

  String? get msgError => _error;

  void validate(List<String> images) async {
    if (images.isEmpty) {
      _error = 'Precisa conter pelo menos uma imagem no anuncio.';
      notifyListeners();
      throw Exception(_error);
    }

    double totalSize = 0;

    for (final String image in images) {
      final File file = File(image);
      final int bytes = await file.length();
      totalSize += bytes;
    }

    final double sizeMB = totalSize / (1024 * 1024);

    if (sizeMB >= 100) {
      _error = 'Você excedeu a capacidade de dados da imagem.';
      notifyListeners();
      throw Exception(_error);
    }

    _images = images;
    notifyListeners();
  }
}
