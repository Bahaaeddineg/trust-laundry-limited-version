
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LanguageCubit extends Cubit<String> {
  LanguageCubit() : super("ar");

  List languages = [
    {"code": "en", "title": "English"},
    {"code": "ar", "title": "Arabic"},
  ];

  Future<void> setLocale(String languageCode) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("LanguageCode", languageCode);
  }
  Future<void> getLocale() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String languageCode = prefs.getString("LanguageCode") ?? "ar";
    emit(languageCode);
  
  }

  void chooseLanguage(String languageCode) async {
    
    await setLocale(languageCode);
    emit(languageCode);
    await FirebaseFirestore.instance.collection("users").doc(FirebaseAuth.instance.currentUser!.uid).update({
      "lang":languageCode,
    });
  }
}