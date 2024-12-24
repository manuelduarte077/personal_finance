import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../domain/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProfileRepositoryImpl(this._firebaseAuth, this._storage, this._firestore);

  @override
  Future<void> deleteAccount() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) throw Exception('No user logged in');

    if (user.photoURL != null) {
      final photoRef = _storage.refFromURL(user.photoURL!);
      await photoRef.delete();
    }

    await _firestore.collection('users').doc(user.uid).delete();

    await user.delete();
  }
}
