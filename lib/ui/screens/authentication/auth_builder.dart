import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:money_manage_project/consts/formField.dart';
import 'package:money_manage_project/logic/bloc/authentication/authentication_bloc.dart';
import 'package:money_manage_project/logic/bloc/authentication/authentication_event.dart';
import 'package:money_manage_project/logic/bloc/authentication/authentication_state.dart';
import 'package:money_manage_project/logic/cubit/user_cubit.dart';

// ignore: must_be_immutable
class AuthBuilder extends StatelessWidget {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = BlocProvider.of<AuthBloc>(context);
    UserCubit userCubit = BlocProvider.of<UserCubit>(context);

    return BlocConsumer<AuthBloc, AuthState>(listener: (context, state) {
      if (state is AuthFail) {
        print('Listening AuthFail');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          state.error,
          softWrap: true,
        )));
      } else if (state is AuthSuccess) {
        userCubit.changeUID(state.user.uid);
      }
    }, builder: (context, state) {
      print('Rebuiding');
      //print(state.isValidEmail);
      //print(state.isValidPassword);
      return KeyboardDismisser(
        child: Scaffold(
          body: SingleChildScrollView(
            child: Container(
              color: Colors.blue[100],
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 25.0),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      context.read<AuthBloc>().isLogin
                          ? 'Login to Money Mangement App!'
                          : 'Register to Money Mangement App!',
                      style: TextStyle(
                          fontSize: 35.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.blue[900]),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    TextFormField(
                        controller: email,
                        decoration: textFormFieldDecoration.copyWith(
                            hintText: 'Email',
                            labelText: 'Email',
                            prefixIcon: Icon(Icons.email)),
                        validator: (val) {},
                        onChanged: (val) {
                          authBloc.add(EmailModified(email: val.trim()));
                        }),
                    SizedBox(
                      height: 5.0,
                    ),
                    state is AppStarted
                        ? Container()
                        : Text(
                            context.read<AuthBloc>().isValidEmail
                                ? ""
                                : "Invalid Email",
                            style: TextStyle(color: Colors.red),
                          ),
                    SizedBox(
                      height: 30.0,
                    ),
                    TextFormField(
                        obscureText: true,
                        controller: password,
                        decoration: textFormFieldDecoration.copyWith(
                            hintText: 'Password',
                            labelText: 'Password',
                            prefixIcon: Icon(Icons.lock)),
                        validator: (val) {},
                        onChanged: (val) {
                          authBloc.add(PasswordModified(password: val.trim()));
                        }),
                    SizedBox(
                      height: 10.0,
                    ),
                    state is AppStarted
                        ? Container()
                        : Text(
                            context.read<AuthBloc>().isValidPassword
                                ? ""
                                : "Invalid Password",
                            style: TextStyle(color: Colors.red)),
                    SizedBox(
                      height: 20.0,
                    ),
                    MaterialButton(
                      color: Colors.blueAccent,
                      child: button(context.read<AuthBloc>().isLogin
                          ? 'Login'
                          : 'Register'),
                      onPressed: () {
                        if (context.read<AuthBloc>().isLogin == true) {
                          authBloc.add(LoginSubmit());
                        } else {
                          authBloc.add(RegisterSubmit());
                        }
                      },
                    ),
                    SizedBox(
                      height: 30.0,
                    ),
                    context.read<AuthBloc>().isLoading
                        ? CircularProgressIndicator()
                        : MaterialButton(
                            child: Text(
                              context.read<AuthBloc>().isLogin
                                  ? "New User? Register Here."
                                  : "Existing user? Login Here.",
                              style: TextStyle(fontSize: 20.0),
                            ),
                            onPressed: () {
                              authBloc.add(ToggleIsLogin());
                            },
                          )
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}
