import 'package:firebase_auth/firebase_auth.dart';

class UserRepository {
  late FirebaseAuth firebaseAuth;

  UserRepository() {
    this.firebaseAuth = FirebaseAuth.instance;
  }

  Future<User?> registerUserWithEmailPassword(
      String email, String password) async {
    try {
      var result = await firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<User?> loginUserWithEmailPassword(
      String email, String password) async {
    try {
      var result = await firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      return result.user;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> signOut() async {
    await firebaseAuth.signOut();
  }

  bool isLoggedIn() {
    var currentUser = firebaseAuth.currentUser;
    return currentUser != null;
  }

  User? getCurrentUser() {
    return firebaseAuth.currentUser;
  }

}
