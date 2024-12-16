class UserModel {
  final String uid;
  final String name;
  final String email;
  final String? profilePictureUrl;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.profilePictureUrl,
  });

  factory UserModel.fromMap(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      name: data['name'],
      email: data['email'],
      profilePictureUrl: data['profilePictureUrl'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}
