import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
part 'language_state.dart';

class LanguageCubit extends Cubit<LanguageState> {
  String lang = 'undefined';

  LanguageCubit() : super(LanguageInitial());

  void changeLanguage(String code){
    lang = code;
    emit(LanguageChangedState());
  }
}
