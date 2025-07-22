import 'package:flutter_bloc/flutter_bloc.dart';


class PageIndicatorCubit extends Cubit<int> {
  PageIndicatorCubit() : super(0);

  void onPageChanged({required int currentIndex}){
    emit(currentIndex);
  }
}
