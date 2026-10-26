abstract class CredentialField {
  String? get msgError;
  String? get getValue;

  void validate(String? value);
}
