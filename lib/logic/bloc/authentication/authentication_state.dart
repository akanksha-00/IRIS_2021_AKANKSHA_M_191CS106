import 'package:firebase_auth/firebase_auth.dart';

class AuthState {}

class AppStarted extends AuthState {}

class LoadingState extends AuthState {
}

class AuthSuccess extends AuthState {
  final User user;
  AuthSuccess({required this.user});
}

class AuthFail extends AuthState {
  final String error;
  AuthFail({required this.error});
}
