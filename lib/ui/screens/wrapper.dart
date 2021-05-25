import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:money_manage_project/logic/bloc/authentication/authentication_bloc.dart';
import 'package:money_manage_project/logic/bloc/transaction/transaction_bloc.dart';
import 'package:money_manage_project/logic/cubit/user_cubit.dart';
import 'package:money_manage_project/logic/repository/transaction_repository.dart';
import 'package:money_manage_project/logic/repository/user_repository.dart';
import 'package:money_manage_project/ui/screens/authentication/auth_builder.dart';
import 'package:money_manage_project/ui/screens/home/home_screen.dart';

class Wrapper extends StatelessWidget {
  final UserRepository userRepository;
  Wrapper({required this.userRepository});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, state) {
      print('state of user changed');
      if (state.uid != null) {
        TransactionRepository transactionRepository = TransactionRepository();
        transactionRepository.getBox(state.uid!);
        return BlocProvider(
          create: (context) => TransactionBloc(
              transactionList: [],
              categoryList: [],
              transactionRepository: transactionRepository),
          child: HomeScreen(
            userRepository: userRepository,
            transactionRepository: transactionRepository,
          ),
        );
      } else {
        return BlocProvider(
          create: (context) => AuthBloc(userRepository: userRepository),
          child: AuthBuilder(),
        );
      }
    });
  }
}
