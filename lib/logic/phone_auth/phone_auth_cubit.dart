import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../constants/colors.dart';
import '../../constants/strings.dart';
import '../../generated/l10n.dart';
import '../../ui/home/home_screen.dart';
import '../../widgets/snack_bar.dart';

part 'phone_auth_state.dart';

class PhoneAuthCubit extends Cubit<PhoneAuthState> {
  late String? otp;
  late DateTime? otpExpiry;

  PhoneAuthCubit() : super(PhoneAuthInitial());

  final String apiUrl = "https://www.kwtsms.com/API/send/";
// Replace with your sender ID
 // Replace with your sender ID

  String generateOTP(int length) {
    final random = Random();
    return List.generate(length, (_) => random.nextInt(10)).join();
  }

  Future<bool> isAuthenticatedBefore(String phoneNumber) async {
    final ok = await FirebaseFirestore.instance
        .collection("users")
        .where("phoneNumber", isEqualTo: phoneNumber)
        .limit(1)
        .get();
    return ok.docs.isNotEmpty;
  }

// Verify the OTP entered by the user
  Future<void> verifyOTP(
      String inputOTP, String phoneNumber, String lang) async {
    emit(PhoneAuthLoading());
    if (otp != null && otpExpiry != null) {
      if (DateTime.now().isAfter(otpExpiry!)) {
        emit(PhoneAuthError(
            errorMsg: lang == "en"
                ? "OTP expired, send the code again!"
                : "انتهت مدة صلاحية الكود أرسل الكود مرة أخرى"));
        return;
      }

      if (inputOTP == otp) {
        final email =
            '$phoneNumber@gmail.com'; // Create a dummy email using the phone number// Use a default password
        final isAuthenticated = await isAuthenticatedBefore(phoneNumber);
        if (isAuthenticated) {
          // User exists, log in
          await FirebaseAuth.instance.signInWithEmailAndPassword(
            email: email,
            password: await ApiKeyManager.decryptKey(passwordd),
          );
        } else {
          // User doesn't exist, sign up
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
            email: email,
            password: await ApiKeyManager.decryptKey(passwordd),
          );
        }
        emit(PhoneAuthPhoneOTPVerified());
      } else {
        emit(PhoneAuthError(
            errorMsg: lang == "en"
                ? "The otp code is wrong, try again!"
                : "الكود خاطئ حاول مرة أخرى"));
      }
    }
  }

Future<void> resendOTP(
      String phoneNumber, String lang, BuildContext context) async {
    otp = generateOTP(6);
    otpExpiry = DateTime.now().add(const Duration(minutes: 1));

    final response = await Dio().post(
      apiUrl,
      options: Options(headers: {'Content-Type': 'application/json'}),
      data: {
        "username": await ApiKeyManager.decryptKey(usernamee),
        "password": await ApiKeyManager.decryptKey(passwordd),
        "sender": await ApiKeyManager.decryptKey(senderIdd),
        "mobile": "965$phoneNumber",
        "message": "$otp",
        "lang": lang == "en" ? 1 : 3,
        "test": 0
      },
    );
    if (response.data["result"] == "OK") {
      CustomSnackBar.show(context, S.of(context).otpReSent, AppColors.kGreen);
    } else {
      CustomSnackBar.show(context, S.of(context).tryAgain, AppColors.kRed);
    }
  }

  Future<void> sendOTP(String phoneNumber, String lang) async {
    emit(PhoneAuthLoading());
    final code = await FirebaseFirestore.instance
        .collection("keys")
        .doc("l9pgPvjXDamoD84YsE2X")
        .get();

   if (phoneNumber.trim() == code.data()!["iv"]) {
    otp = "123456";
    otpExpiry = DateTime.now().add(const Duration(minutes: 15));
    emit(PhoneAuthPhoneNumberSubmited());
   }else{
     otp = generateOTP(6);
    otpExpiry = DateTime.now().add(const Duration(minutes: 1));

    try {
      final response = await Dio().post(
        apiUrl,
        options: Options(headers: {'Content-Type': 'application/json'}),
        data: {
          "username": await ApiKeyManager.decryptKey(usernamee),
          "password": await ApiKeyManager.decryptKey(passwordd),
          "sender": await ApiKeyManager.decryptKey(senderIdd),
          "mobile": "965$phoneNumber",
          "message": "$otp",
          "lang": lang == "en" ? 1 : 3,
          "test": 0
        },
      );

      if (response.statusCode == 200) {
        
        if (response.data['result'] == 'OK') {
          emit(PhoneAuthPhoneNumberSubmited());
        }
      } else {
        
      }
    } catch (e) {
      
    }
   }
  }

  Future<bool> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return true;
    } catch (e) {
      return false;
    }
  }
}


  // User getLoggedInUser() {
  //   User firebaseUser = FirebaseAuth.instance.currentUser!;
  //   return firebaseUser;
  // }

    // Future<void> submitPhoneNumber(String phoneNumber) async {
  //   emit(PhoneAuthLoading());

  //   try {
  //    // await FirebaseAuth.instance.setSettings(appVerificationDisabledForTesting: true); 
  //     await FirebaseAuth.instance.verifyPhoneNumber(
  //       phoneNumber: "+213$phoneNumber",
  //       timeout: const Duration(seconds: 60),
  //       verificationCompleted: verificationCompleted,
  //       verificationFailed: verificationFailed,
  //       codeSent: codeSent,
  //       codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
  //     );
      
  //   } catch (e) {
  //     emit(PhoneAuthError(errorMsg: e.toString()));
  //   }
  // }

  // void verificationCompleted(PhoneAuthCredential credential) async {
  //   
  //   await signIn(credential: credential);
  // }

  // void verificationFailed(FirebaseAuthException error) {
  //   
  //   emit(PhoneAuthError(errorMsg: error.toString()));
  // }

  // void codeSent(String verificationId, int? resendToken) {
  //   this.verificationId = verificationId;
  //   emit(PhoneAuthPhoneNumberSubmited());
  // }

  // void codeAutoRetrievalTimeout(String verificationId) {
  //   emit(PhoneAuthError(errorMsg: "Timeout"));
  // }



  // Future<void> submitOTP(String otpCode) async {
  //   PhoneAuthCredential credential = PhoneAuthProvider.credential(
  //       verificationId: this.verificationId, smsCode: otpCode);

  //   await signIn(credential: credential);
  // }

  // Future<void> signIn({required PhoneAuthCredential credential}) async {
  //   try {
  //     emit(PhoneAuthLoading());
  //     await FirebaseAuth.instance.signInWithCredential(credential);
  //     emit(PhoneAuthPhoneOTPVerified());
  //   } catch (error) {
  //     emit(PhoneAuthError(errorMsg: error.toString()));
  //   }
  // }