abstract class AuthEvent {}

class EmailModified extends AuthEvent {
  final String email;
  EmailModified({required this.email});
}

class PasswordModified extends AuthEvent {
  final String password;
  PasswordModified({required this.password});
}

class LoginSubmit extends AuthEvent {}

class RegisterSubmit extends AuthEvent {}

class ToggleIsLogin extends AuthEvent {}
