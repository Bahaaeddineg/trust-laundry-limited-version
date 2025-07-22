import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../generated/l10n.dart';
import '../../widgets/snack_bar.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  static AuthCubit get(context) => BlocProvider.of(context);

  Future<void> registerUser({
    required String email,
    required String password,
  }) async {
    try {
      emit(AuthLoading());

    await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthFailure(errorMessage: 'The password provided is too weak.'));
      } else if (e.code == 'email-already-in-use') {}
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
  }

  Future<void> loginUser(
      {required String email, required String password}) async {
    try {
      emit(AuthLoading());
      final userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
      // SharedPreferences prefs = await SharedPreferences.getInstance();
      // prefs.setString('uid', userCredential.user!.uid);
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      if (e.code == "invalid-credential") {
        emit(AuthFailure(
            errorMessage: "Email or password is incorrect ! Try again"));
      } else {
        emit(
          AuthFailure(errorMessage: e.code),
        );
      }
    }
  }

  // Future<void> signInWithGoogle() async {
  //   final FirebaseAuth auth = FirebaseAuth.instance;
  //   try {
  //     GoogleAuthProvider googleAuthProvider = GoogleAuthProvider();
  //     googleAuthProvider.addScope('profile');
  //     final userCredential = await auth.signInWithProvider(googleAuthProvider);
  //     bool hasAlreadySigned = await checkIfUserAlreadyExists();
  //     if (!hasAlreadySigned) {
  //       await userCredential.user!.reload();
  //       addUserData(
  //         email: userCredential.user!.email!,
  //         username: "user",
  //         phoneNumber: "",
  //         image: userCredential.user!.photoURL!,
  //       );
  //     }
  //     emit(AuthSuccess());
  //   } catch (error) {
  //     emit(AuthFailure(errorMessage: error.toString()));
  //   }
  // }

  // Future<bool> checkIfUserAlreadyExists() async {
  //   final snapshot = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(FirebaseAuth.instance.currentUser!.uid)
  //       .get();
  //   return snapshot.exists;
  // }

  Future<bool> validateUserPassword({required String password}) async {
    final auth = FirebaseAuth.instance;
    final currentUser = auth.currentUser;
    final authCredentials = EmailAuthProvider.credential(
        email: currentUser!.email!, password: password);
    try {
      final authResult =
          await currentUser.reauthenticateWithCredential(authCredentials);
      return authResult.user != null;
    } catch (e) {
      
    }
    return false;
  }

  Future<bool> updatePwd({required String newPwd}) async {
    final auth = FirebaseAuth.instance;
    final currentUser = auth.currentUser;
    try {
      currentUser!.updatePassword(newPwd);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<void> updateUserPassword(
      {required String currentPwd, required String newPwd}) async {
    emit(AuthLoading());
    bool isPasswordCorrect = await validateUserPassword(password: currentPwd);
    if (!isPasswordCorrect) {
      emit(AuthFailure(errorMessage: "Wrong Password!"));
      return;
    }
    bool isPwdUpdated = await updatePwd(newPwd: newPwd);
    if (!isPwdUpdated) {
      emit(AuthFailure(errorMessage: "There is an error try again!"));
    }
    emit(AuthSuccess());
  }

  Future<void> addUserData({
    required String email,
    required String phoneNum,
  }) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
      "email": email,
      "phoneNumber":phoneNum,
      "role":"user"
    });
  }

  // Future<void> setAlreadyLogged({required String uid}) async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   prefs.setString('uid', uid);
  // }

  Future<bool> logout() async {
    emit(AuthLoading());
    try {
      await FirebaseAuth.instance.signOut();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.remove('uid');
      emit(AuthSuccess());
      return true;
    } catch (e) {
      emit(AuthFailure(errorMessage: e.toString()));
    }
    return false;
  }

  Future<void> resetPwd({required String email}) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email.trim());
      emit(AuthSuccess());
    } on FirebaseAuthException catch (e) {
      emit(AuthFailure(errorMessage: e.message!));
    }
  }
}
