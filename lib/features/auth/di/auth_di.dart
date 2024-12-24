import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../data/repositories/auth_repository_impl.dart';
import '../domain/repositories/auth_repository.dart';
import '../domain/use_cases/current_user_use_case.dart';
import '../domain/use_cases/reset_password_use_case.dart';
import '../domain/use_cases/sign_in_use_case.dart';
import '../domain/use_cases/sign_out_use_case.dart';
import '../domain/use_cases/sign_up_use_case.dart';
import '../presentation/bloc/auth_bloc.dart';

final getIt = GetIt.instance;

Future<void> authSetup() async {
  // Register repository
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(
        FirebaseAuth.instance,
        FirebaseFirestore.instance,
        FirebaseStorage.instance,
      ));

  // Register use cases
  getIt.registerLazySingleton(() => CurrentUserUseCase(getIt()));
  getIt.registerLazySingleton(() => ResetPasswordUseCase(getIt()));
  getIt.registerLazySingleton(() => SignInUseCase(getIt()));
  getIt.registerLazySingleton(() => SignOutUseCase(getIt()));
  getIt.registerLazySingleton(() => SignUpUseCase(getIt()));

  // Register auth bloc
  getIt.registerLazySingleton(
    () => AuthBloc(
      signOutUseCase: getIt(),
      signUpUseCase: getIt(),
      resetPasswordUseCase: getIt(),
      getCurrentUserUseCase: getIt(),
      signInUseCase: getIt(),
    ),
  );
}
