import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:money_manage_project/models/transaction.dart';
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:money_manage_project/logic/cubit/user_cubit.dart';
import 'package:money_manage_project/logic/repository/user_repository.dart';
import 'package:money_manage_project/ui/screens/wrapper.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  final appDocumentaryDirectory =
      await path_provider.getApplicationDocumentsDirectory();
  Hive.init(appDocumentaryDirectory.path);
  Hive.registerAdapter(TransactionAdapter());
  Hive.registerAdapter(CategoryAdapter());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final UserRepository userRepository = UserRepository();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserCubit(userRepository: userRepository),
      child: MaterialApp(
        theme: ThemeData.light(),
        home: Wrapper(
          userRepository: userRepository,
        ),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
