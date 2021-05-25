import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manage_project/logic/bloc/authentication/authentication_event.dart';
import 'package:money_manage_project/logic/bloc/authentication/authentication_state.dart';
import 'package:money_manage_project/logic/repository/user_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  UserRepository userRepository;
  String? email = "";
  String? password = "";
  bool isLogin = false; // if true : login else : register
  bool isValidEmail = false;
  bool isValidPassword = false;
  bool isLoading = false;

  AuthBloc({required this.userRepository}) : super(AppStarted());

  @override
  Stream<AuthState> mapEventToState(AuthEvent event) async* {
    if (event is EmailModified) {
      email = event.email;
      isValidEmail = event.email == null
          ? false
          : RegExp(
              r"[a-z0-9!#$%&'+/=?^_`{|}~-]+(?:.[a-z0-9!#$%&'+/=?^_`{|}~-]+)@(?:[a-z0-9](?:[a-z0-9-][a-z0-9])?.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?",
              caseSensitive: false,
              multiLine: false,
            ).hasMatch(event.email);
      yield AuthState();
    } else if (event is PasswordModified) {
      password = event.password;
      isValidPassword =
          event.password == null ? false : event.password.length > 6;
      yield AuthState();
    } else if (event is LoginSubmit) {
      isLoading = true;
      yield LoadingState();
      try {
        var user =
            await userRepository.loginUserWithEmailPassword(email!, password!);
        if (user != null) {
          isLoading = false;
          yield AuthSuccess(user: user);
        } else {
          isLoading = false;
          yield AuthFail(error: 'Authentication Failed');
        }
      } catch (e) {
        isLoading = false;
        yield AuthFail(
          error: e.toString(),
        );
      }
    } else if (event is RegisterSubmit) {
      isLoading = true;
      yield LoadingState();
      try {
        var user = await userRepository.registerUserWithEmailPassword(
            email!, password!);
        if (user != null) {
          print('user not null');
          isLoading = false;
          yield AuthSuccess(user: user);
        } else {
          print('uauth failed');
          isLoading = false;
          yield AuthFail(error: 'Authentication Failed');
        }
      } catch (e) {
        print('printing error');
        isLoading = false;
        yield AuthFail(error: e.toString());
      }
    } else if (event is ToggleIsLogin) {
      isLogin = !isLogin;
      yield AuthState();
    }
  }
}
