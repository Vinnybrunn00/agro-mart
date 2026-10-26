//
//
// profile_photo_uploader.dart
// AgroShare
//
// Create by Vinícius Bruno on 01/10/2026
//

import 'dart:developer';
import 'dart:io';

import 'package:agroshare/features/auth/form/auth_form.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ProfilePhotoUploader {
  final FirebaseStorage _storage = FirebaseStorage.instance;

  /// Esta função faz upload de imagens do usuário para o [FirebaseStorage].
  /// Ela retorna o path da imagem vindo do [FirebaseStorage].
  ///
  /// - O método por enquanto não está tratanto erro.
  ///
  /// Os erros deverão ser tratatos futuramnete em [FirebaseException].
  Future<String?> uploadImagePicker(String id, AuthForm userModel) async {
    final File? image = userModel.image;

    if (image != null) {
      try {
        final File file = File(image.path);
        final TaskSnapshot uploadTask = await _storage
            .ref('photos/$id/img$id.jpg')
            .putFile(file);

        return await uploadTask.ref.getDownloadURL();
      } on FirebaseException catch (err) {
        log(err.message.toString());
        return null;
      }
    }
    return null;
  }
}
