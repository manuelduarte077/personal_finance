import 'package:get_it/get_it.dart';
import 'package:personal_finance/features/auth/presentation/bloc/auth_bloc.dart';

import '../domain/repositories/auth_repository.dart';
import '../domain/use_cases/current_user_use_case.dart';
import '../domain/use_cases/reset_password_use_case.dart';
import '../domain/use_cases/sign_in_use_case.dart';
import '../domain/use_cases/sign_out_use_case.dart';
import '../domain/use_cases/sign_up_use_case.dart';

final getIt = GetIt.instance;

void authSetup() {
  getIt
      .registerLazySingleton(() => CurrentUserUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(
      () => ResetPasswordUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignInUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignOutUseCase(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => SignUpUseCase(getIt<AuthRepository>()));

  getIt.registerLazySingleton(
    () => AuthBloc(
      signOutUseCase: getIt<SignOutUseCase>(),
      signUpUseCase: getIt<SignUpUseCase>(),
      resetPasswordUseCase: getIt<ResetPasswordUseCase>(),
      getCurrentUserUseCase: getIt<CurrentUserUseCase>(),
      signInUseCase: getIt<SignInUseCase>(),
    ),
  );
}
