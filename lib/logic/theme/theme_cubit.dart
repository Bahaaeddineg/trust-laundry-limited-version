import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeCubit extends Cubit<bool> {
  ThemeCubit() : super(false);


  Future<void> setTheme(bool isDark) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool("isDark", isDark);
  }
  Future<void> getTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isDark = prefs.getBool("isDark") ?? false;
    emit(isDark);
  
  }

  void chooseTheme(bool isDark) async {
    await setTheme(isDark);
    emit(isDark);
  }
}