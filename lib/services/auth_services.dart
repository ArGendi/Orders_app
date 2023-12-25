import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_auth_platform_interface/firebase_auth_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:notes/constants.dart';

class AuthServices {
  String? verificationId;

  Future<LoginStatus> login(String email, String password) async{
    try{
      await FirebaseAuth.instance.signInWithEmailAndPassword(email: '$email@orga.com', password: password);
      return LoginStatus.success;
    }
    on FirebaseAuthException catch(e){
      if(e.code == "invalid-email"){
        return LoginStatus.invalidEmail;
      }
      else if(e.code == "wrong-password"){
        return LoginStatus.wrongPassword;
      }
      else{
        return LoginStatus.failed;
      }
    }
    catch(e){
      return LoginStatus.failed;
    }
  }

  Future<SignupStatus> signUp(String email, String password) async{
    try{
      await FirebaseAuth.instance.createUserWithEmailAndPassword(email: '$email@orga.com', password: password);
      return SignupStatus.success;
    }
     on FirebaseAuthException catch(e){
      if(e.code == "email-already-in-use"){
        return SignupStatus.emailAlreadyInUse;
      }
      else{
        return SignupStatus.failed;
      }
    }
    catch(e){
      return SignupStatus.failed;
    }
  }

  Future<void> loginWithPhone(String mobile) async{
    print(mobile);
    await FirebaseAuth.instance.verifyPhoneNumber(
      timeout: const Duration(seconds: 60),
      phoneNumber: "+2$mobile",
      verificationCompleted: (cred) async{
        print('phone auth completed');
        await FirebaseAuth.instance.signInWithCredential(cred);
      },
      verificationFailed: (exception){
        print('Faileeeeeed: ${exception.message}');
      },
      codeSent: (verifiedId, otp){
        verificationId = verifiedId;
        print("verifiedId: $verifiedId");
        print("otp: $otp");
      },
      codeAutoRetrievalTimeout: (verifiedId){
        verificationId = verifiedId;
        print('codeAutoRetrievalTimeout :(');
      }
    );
  } 

  Future<bool> verifyOTP(String otp) async{
    try{
      await FirebaseAuth.instance.signInWithCredential(
        PhoneAuthProvider.credential(verificationId: verificationId!, smsCode: otp)
      );
      return true;
    }
    catch(e){
      return false;
    }
  }
}