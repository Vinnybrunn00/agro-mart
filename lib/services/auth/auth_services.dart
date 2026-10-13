//  auth_services.dart
//  AgroShare
//
//  Create by Vinicius Bruno on 05/09/2026
//

import 'package:agroshare/models/auth/user_model.dart';
import 'package:agroshare/services/picker/manager_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthServices extends ManagerPicker with ChangeNotifier {
  // instancia do firebaseFirestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // instancia do firebaseAuth
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  String? _firebaseMsgError;

  /// Esse getter recebe um erro do FirebaseException
  /// e exibe a mensagem ao usuário caso aconteça algum erro.
  ///
  /// - Caso não existe erro, ela será nula.
  ///
  /// O tratamento de erro é feito pela class abstrata e privada [_ExceptionMessage].
  String? get firebaseMsgError => _firebaseMsgError;

  Future<void> signIn({
    required String email,
    required String password,
    required UserModel userModel,
  }) async {
    try {
      userModel.setLoading = true;

      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      _firebaseMsgError = _ExceptionMessage.messages(error);
      notifyListeners();
      throw Exception(_firebaseMsgError);
    } finally {
      userModel.setLoading = false;
    }
  }

  Future<void> signUp({required UserModel userModel}) async {
    try {
      userModel.setLoading = true;

      final UserCredential userCredential = await _firebaseAuth
          .createUserWithEmailAndPassword(
            email: userModel.email!,
            password: userModel.password!,
          );

      final User? user = userCredential.user;

      if (user != null) {
        /// OVERRIDE DE [ManagerPicker]
        ///
        /// Esse método [uploadImagePicker] extendido de [ManagerPicker]
        final String? imageUrl = await uploadImagePicker(user.uid, userModel);

        // Lança um erro caso o usuário não selecione a imagem.
        //
        // O motivo dessa condição não está sendo tratada em [FirebaseException],
        // é que o FirebaseExcpetion não extende a class Exception do [ManagerPicker]
        if (imageUrl == null) {
          throw 'Erro ao fazer upload da imagem, tente novamente';
        }

        await user.updateDisplayName(userModel.name);

        await _firestore.collection('users').doc(user.uid).set({
          'id': user.uid,
          'name': userModel.name,
          'cpf': userModel.cpf,
          'email': userModel.email,
          'create_in': DateTime.now().millisecondsSinceEpoch,
          'photo': imageUrl,
          'nameProperty': userModel.nameProperty,
          'locationProperty': userModel.locationProperty,
          'lat': userModel.latitude,
          'long': userModel.longitude,
        });
      }
    } on FirebaseAuthException catch (error) {
      _firebaseMsgError = _ExceptionMessage.messages(error);
      notifyListeners();
      throw Exception(_firebaseMsgError);
    } finally {
      userModel.setLoading = false;
    }
  }
}

abstract class _ExceptionMessage {
  static String messages(FirebaseAuthException error) {
    switch (error.code) {
      case 'email-already-in-use':
        return 'Este e-mail já está sendo utilizado por outra conta.';
      case 'invalid-email':
        return 'O e-mail informado é inválido.';
      case 'user-not-found':
        return 'Nenhum usuário encontrado com este e-mail.';
      case 'wrong-password':
        return 'Senha incorreta. Tente novamente.';
      case 'invalid-credential':
        return 'Credenciais inválidas.';
      case 'too-many-requests':
        return 'Muitas tentativas. Tente novamente mais tarde.';
      default:
        return 'Erro Desconhecido';
    }
  }
}
