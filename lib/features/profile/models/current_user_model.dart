/*
 * lib/features/profile/models/current_user_model.dart
 *
 * Modelo do usuário autenticado.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 17/10/2026
 */

class CurrentUserModel {
  final String id;
  final String name;
  final String email;
  final String cpf;
  final String photoUrl;

  CurrentUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.cpf,
    required this.photoUrl,
  });

  factory CurrentUserModel.fromMap({required Map<String, dynamic> data}) {
    return CurrentUserModel(
      id: data['id'],
      name: data['name'],
      email: data['email'],
      cpf: data['cpf'],
      photoUrl: data['photo'],
    );
  }
}
