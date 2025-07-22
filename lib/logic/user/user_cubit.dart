import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/app_user.dart';

part 'user_state.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitial());

  Future<void> getUserInfo() async {
    try {
      emit(UserLoading());
      final userDoc = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid);

      final data = await userDoc.get();

      if (data.exists) {
        emit(UserSuccess(user: AppUser.fromJson(data.data()!)));
      }
    } catch (e) {
      
    }
  }

  Future<String?> getToken() async {
    try {
      FirebaseMessaging messaging = FirebaseMessaging.instance;

      // Request permission for iOS devices
      await messaging.requestPermission();

      // Get the FCM token
      return await messaging.getToken();
    } catch (e) {
      return null;
    }
  }

  Future<void> addUserData({
    required String username,
    required String phoneNumber,
  //  required String email,
  }) async {
    final users = FirebaseFirestore.instance.collection("users");
    final data = await users.where('phoneNumber', isEqualTo: phoneNumber).get();

    if (data.docs.isNotEmpty) {
      await users.doc(data.docs.first.id).update(
        {
          "username": username,
        //  "email": email,
          "fcmToken":await getToken()??"null",
        },
      );
    } else {
      await users.doc(FirebaseAuth.instance.currentUser!.uid).set(
        {
          "username": username,
          "phoneNumber": phoneNumber,
          "role": "user",
          "fcmToken":await getToken()??"null",
          "balance": 0.0,
          "joined_at": FieldValue.serverTimestamp(),
        },
      );
    }

    getUserInfo();
  }
}
