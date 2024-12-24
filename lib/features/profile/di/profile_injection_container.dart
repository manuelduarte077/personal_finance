import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';

import '../data/profile_repository_impl.dart';
import '../domain/delete_account_usecase.dart';
import '../domain/profile_repository.dart';
import '../presentation/bloc/profile_bloc.dart';

final sl = GetIt.instance;

Future<void> initProfile() async {
  // Repository
  sl.registerLazySingleton<ProfileRepository>(
    () => ProfileRepositoryImpl(
      FirebaseAuth.instance,
      FirebaseStorage.instance,
      FirebaseFirestore.instance,
    ),
  );

  // Use cases
  sl.registerLazySingleton(() => DeleteAccountUseCase(sl()));

  // Register Profile bloc
  sl.registerLazySingleton(
    () => ProfileBloc(sl()),
  );
}
