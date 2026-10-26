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
