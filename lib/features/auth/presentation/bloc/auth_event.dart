part of 'auth_bloc.dart';

abstract class AuthEvent {}

class GetCurrentUserRequested extends AuthEvent {}

class SignInRequested extends AuthEvent {
  final String email;
  final String password;

  SignInRequested(this.email, this.password);
}

class SignUpRequested extends AuthEvent {
  final String name;
  final String email;
  final String password;
  final String profilePic;

  SignUpRequested(this.email, this.password, this.name, this.profilePic);
}

class ResetPasswordRequested extends AuthEvent {
  final String email;

  ResetPasswordRequested(this.email);
}

class SignOutRequested extends AuthEvent {}
