import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:notes/controllers/language/language_cubit.dart';
import 'package:notes/local/shared_prference.dart';

class AppLanguageCubit extends Cubit<LanguageState> {
  String lang = 'en';

  AppLanguageCubit() : super(LanguageInitial());

  Future<void> changeLanguage(String code) async{
    lang = code;
    await Cache.setLanguage(lang);
    emit(LanguageChangedState());
  }

  void getSavedLanguage(){
    String? cachelanguage = Cache.getLanguage();
    if(cachelanguage != null){
      lang = cachelanguage;
    }
  }
}
