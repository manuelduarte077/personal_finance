import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user_model.dart';
import 'auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth firebaseAuth;
  final FirebaseFirestore firebaseFirestore;
  final FirebaseStorage firebaseStorage;

  AuthRepositoryImpl(
    this.firebaseAuth,
    this.firebaseFirestore,
    this.firebaseStorage,
  );

  /// Iniciar sesión
  @override
  Future<UserModel> signIn(String email, String password) async {
    try {
      // Autenticar al usuario con Firebase Auth
      final userCredential = await firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Obtener los datos del usuario desde Firestore
      final userDoc = await firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .get();

      if (!userDoc.exists) {
        throw Exception('Usuario no encontrado en la base de datos.');
      }

      return UserModel.fromMap(userDoc.data()!);
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  /// Registrarse
  @override
  Future<UserModel> signUp(
    String name,
    String email,
    String password,
    String profilePicPath,
  ) async {
    try {
      // Crear el usuario en Firebase Auth
      final userCredential = await firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Subir la foto de perfil a Firebase Storage
      final profilePicRef = firebaseStorage
          .ref()
          .child('profilePictures/${userCredential.user!.uid}');
      final uploadTask = await profilePicRef.putFile(File(profilePicPath));
      final profilePicUrl = await uploadTask.ref.getDownloadURL();

      // Guardar los datos del usuario en Firestore
      final userData = UserModel(
        uid: userCredential.user!.uid,
        name: name,
        email: email,
        profilePictureUrl: profilePicUrl,
      );

      await firebaseFirestore
          .collection('users')
          .doc(userCredential.user!.uid)
          .set(userData.toMap());

      return userData;
    } on FirebaseAuthException catch (e) {
      throw _handleAuthError(e);
    }
  }

  @override
  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  /// Obtener el usuario actual
  @override
  Future<UserModel?> getCurrentUser() async {
    final user = firebaseAuth.currentUser;
    if (user == null) return null;

    final userDoc =
        await firebaseFirestore.collection('users').doc(user.uid).get();
    if (!userDoc.exists) return null;

    return UserModel.fromMap(userDoc.data()!);
  }

  /// Manejar errores de Firebase Auth
  String _handleAuthError(FirebaseAuthException e) {
    switch (e.code) {
      case 'user-not-found':
        return 'No se encontró una cuenta con ese correo electrónico.';
      case 'wrong-password':
        return 'La contraseña ingresada es incorrecta.';
      case 'email-already-in-use':
        return 'El correo electrónico ya está en uso.';
      case 'weak-password':
        return 'La contraseña es demasiado débil.';
      case 'invalid-email':
        return 'El formato del correo electrónico no es válido.';
      default:
        return 'Ha ocurrido un error inesperado. Por favor, inténtelo de nuevo.';
    }
  }
}
