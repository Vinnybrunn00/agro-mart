/*
 * lib/features/auth/form/fields/credential_field.dart
 *
 * Interface comum aos campos de credencial do cadastro.
 *
 * Copyright (C) 2026 Vinícius Bruno <vinibruno.dev@gmail.com>
 *
 * Created on 25/09/2026
 */

abstract class CredentialField {
  String? get msgError;
  String? get getValue;

  void validate(String? value);
}
