//  select_images.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 03/10/2026
//

import 'dart:developer';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SelectImages with ChangeNotifier {
  final List<String> _listImages = [];
  List<String> get listImages => _listImages.reversed.toList();

  String? _messageError;
  String? get messageError => _messageError;

  int get length => _listImages.length;

  bool get isNotEmpty => _listImages.isNotEmpty;

  void onRemoveImages(int index) {
    _listImages.removeAt(_listImages.length - 1 - index);
    notifyListeners();
  }

  Future<void> onSelectImages([String? path]) async {
    if (_listImages.length >= 6) return;

    try {
      final List<PlatformFile> pickFiles = await FilePicker.pickFiles(
        type: FileType.image,
      );

      for (final PlatformFile item in pickFiles) {
        final String? itemPath = item.path;
        if (itemPath == null) continue;

        if (pickFiles.length > 6) {
          // exibir mensagem para o usuário informando que
          // pode submeter somente 6 imagens.
          return;
        }

        _listImages.add(itemPath);
        notifyListeners();
      }
    } on PlatformException catch (err) {
      _messageError = 'Erro ao selecionar imagens: ${err.code}';
      notifyListeners();
    } catch (err) {
      _messageError = 'Erro ao selecionar ou copiar imagens';
      notifyListeners();
    }
  }
}
