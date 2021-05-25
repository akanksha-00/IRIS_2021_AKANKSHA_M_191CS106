import 'package:bloc/bloc.dart';
import 'package:money_manage_project/logic/repository/user_repository.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  final UserRepository userRepository;
  UserCubit({required this.userRepository})
      : super(UserState(uid: userRepository.getCurrentUser()?.uid));

  void changeUID(String? uid) => emit(UserState(uid: uid));
}
