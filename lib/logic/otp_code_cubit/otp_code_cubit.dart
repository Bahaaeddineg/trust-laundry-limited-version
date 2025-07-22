import 'package:flutter_bloc/flutter_bloc.dart';

class OtpCodeCubit extends Cubit<bool> {
  OtpCodeCubit() : super(false);

  void onCodeChange({required int codeLength}) {
    emit(codeLength==6);
  }
}
