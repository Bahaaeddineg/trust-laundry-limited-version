part of 'phone_auth_cubit.dart';

abstract class PhoneAuthState {}

class PhoneAuthInitial extends PhoneAuthState {}

class PhoneAuthLoading extends PhoneAuthState {}

class PhoneAuthError extends PhoneAuthState {
  final String errorMsg;

  PhoneAuthError({required this.errorMsg});
}

class PhoneAuthPhoneNumberSubmited extends PhoneAuthState{}

class PhoneAuthPhoneOTPVerified extends PhoneAuthState{}
