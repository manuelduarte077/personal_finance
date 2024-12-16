import 'package:bloc/bloc.dart';
import 'package:personal_finance/features/auth/domain/use_cases/current_user_use_case.dart';

import '../../domain/use_cases/reset_password_use_case.dart';
import '../../domain/use_cases/sign_in_use_case.dart';
import '../../domain/use_cases/sign_out_use_case.dart';
import '../../domain/use_cases/sign_up_use_case.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignOutUseCase signOutUseCase;
  final SignInUseCase signInUseCase;
  final SignUpUseCase signUpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;
  final CurrentUserUseCase getCurrentUserUseCase;

  AuthBloc({
    required this.signOutUseCase,
    required this.signInUseCase,
    required this.signUpUseCase,
    required this.resetPasswordUseCase,
    required this.getCurrentUserUseCase,
  }) : super(AuthInitial()) {
    /// Get Current User
    on<GetCurrentUserRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        final user = await getCurrentUserUseCase();

        if (user != null) {
          emit(AuthAuthenticated());
        } else {
          emit(AuthUnauthenticated());
        }
      } catch (e) {
        emit(AuthUnauthenticated());
      }
    });

    /// Sign In
    on<SignInRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await signInUseCase(event.email, event.password);

        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    /// Sign Up
    on<SignUpRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await signUpUseCase(
            event.email, event.password, event.name, event.profilePic);
        emit(AuthAuthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    /// Sign Out
    on<SignOutRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        await signOutUseCase();
        emit(AuthUnauthenticated());
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });

    /// Reset Password
    on<ResetPasswordRequested>((event, emit) async {
      emit(AuthLoading());
      try {
        resetPasswordUseCase(event.email);

        emit(AuthSuccess(
            'Se ha enviado un enlace para restablecer tu contraseña a tu correo.'));
      } catch (e) {
        emit(AuthError(e.toString()));
      }
    });
  }
}
