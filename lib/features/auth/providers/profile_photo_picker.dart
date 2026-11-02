/*
 * lib/features/auth/providers/profile_photo_picker.dart
 *
 * Seleção da foto de perfil pela câmera ou galeria.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 25/09/2026
 */

import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

class ProfilePhotoPicker with ChangeNotifier {
  File? _image;
  File? get image => _image;

  Future<void> handlePicker() async {
    final ImagePicker picker = ImagePicker();

    final XFile? pickerImage = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 100,
      maxHeight: 140,
    );

    if (pickerImage != null) {
      _image = File(pickerImage.path);
      notifyListeners();
    }
  }
}
