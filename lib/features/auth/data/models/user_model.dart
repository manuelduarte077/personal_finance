class UserModel {
  final String uid; // ID único del usuario (de Firebase Auth)
  final String name; // Nombre del usuario
  final String email; // Correo electrónico del usuario
  final String?
      profilePictureUrl; // URL de la foto de perfil del usuario (puede ser nula)

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profilePictureUrl,
  });

  /// Crear una instancia de `UserModel` desde un mapa (Firestore)
  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      profilePictureUrl: data['profilePictureUrl'],
    );
  }

  /// Convertir una instancia de `UserModel` a un mapa (para Firestore)
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}
