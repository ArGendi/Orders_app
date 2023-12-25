import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:notes/services/auth_services.dart';
part 'phone_state.dart';

class PhoneCubit extends Cubit<PhoneState> {
  String? phone;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  PhoneCubit() : super(PhoneInitial());

  Future<void> onPhone() async{
    bool valid = formKey.currentState!.validate();
    if(valid){
      formKey.currentState!.save();
      AuthServices authServices = AuthServices();
      await authServices.loginWithPhone(phone!);
      //bool x = await authServices.verifyOTP('123456');
      //print("x: $x");
    }
  }
}
