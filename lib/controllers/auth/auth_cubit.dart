// ignore_for_file: use_build_context_synchronously

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants.dart';
import 'package:notes/local/shared_prference.dart';
import 'package:notes/screens/home_screen.dart';
import 'package:notes/services/auth_services.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  String? email;
  String? pass;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  AuthCubit() : super(AuthInitial());

  void onEnter(BuildContext context) async{
    bool valid = formKey.currentState!.validate();
    if(valid){
      formKey.currentState!.save();
      emit(LoadingState());
      AuthServices authServices = AuthServices();
      LoginStatus loginStatus = await authServices.login(email!, pass!);
      if(loginStatus == LoginStatus.success){
        await Cache.setEmail('$email@orga.com');
        emit(SuccessState());
        Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (p) => false);
      }
      else if(loginStatus == LoginStatus.wrongPassword){
        emit(FailState());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.wrongPassword),
            backgroundColor: Colors.red,
          ),
        );
      }
      else if(loginStatus == LoginStatus.invalidEmail){
        emit(FailState());
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context)!.wrongPhoneNumber),
            backgroundColor: Colors.red,
          ),
        );
      }
      else{
        SignupStatus signupStatus = await authServices.signUp(email!, pass!);
        if(signupStatus == SignupStatus.success){
          await Cache.setEmail('$email@orga.com');
          emit(SuccessState());
          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const HomeScreen()), (p) => false);
        }
        else if(signupStatus == SignupStatus.emailAlreadyInUse){
          emit(FailState());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.wrongPassword),
              backgroundColor: Colors.red,
            ),
          );
        }
        else{
          emit(FailState());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(AppLocalizations.of(context)!.problemExist),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    }
  }
}
