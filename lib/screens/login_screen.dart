import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes/controllers/auth/auth_cubit.dart';
import 'package:notes/controllers/language/app_language_cubit.dart';
import 'package:notes/controllers/language/language_cubit.dart';
import 'package:notes/controllers/phone/phone_cubit.dart';
import 'package:notes/services/auth_services.dart';
import 'package:notes/widgets/custom_button.dart';
import 'package:notes/widgets/custom_texfield.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    String selectedLanguage = BlocProvider.of<LanguageCubit>(context).lang;
    BlocProvider.of<AppLanguageCubit>(context).changeLanguage(selectedLanguage);
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            width: screenSize.width,
            height: screenSize.height * 0.40,
            decoration: BoxDecoration(
              color: Colors.blueGrey[100],
              borderRadius: BorderRadius.only(bottomRight: Radius.circular(260))
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  "Orga",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[50],
                    fontSize: 24,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(15.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: BlocProvider.of<AuthCubit>(context).formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset(
                        'images/login.png',
                        width: 340,
                      ),
                      // const SizedBox(
                      //   height: 25,
                      // ),
                      Text(
                        AppLocalizations.of(context)!.enterUserName,
                        //'ادخل الاسم المميز الخاص بيك لو جديد هيتسجل جديد لو موجود هيدخل علطول',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      CustomTextFormField(
                        text: AppLocalizations.of(context)!.phone,
                        keyboardType: TextInputType.phone,
                        prefix: const Icon(Icons.phone),
                        onSaved: (value) {
                          BlocProvider.of<AuthCubit>(context).email = value;
                        },
                        onValidate: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.enterYourPhoneNumber;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CustomTextFormField(
                        text: AppLocalizations.of(context)!.password,
                        prefix: const Icon(Icons.lock_outline),
                        obscureText: true,
                        onSaved: (value) {
                          BlocProvider.of<AuthCubit>(context).pass = value;
                        },
                        onValidate: (value) {
                          if (value!.isEmpty) {
                            return AppLocalizations.of(context)!.enterPassword;
                          } else if (value.length < 8) {
                            return AppLocalizations.of(context)!.shortPassword;
                          } else {
                            return null;
                          }
                        },
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      BlocBuilder<AuthCubit, AuthState>(
                        builder: (context, state) {
                          if(state is LoadingState){
                            return const CircularProgressIndicator(color: Colors.black,);
                          }
                          else {
                            return CustomButton(
                              text: AppLocalizations.of(context)!.login,
                              onClick: () {
                                BlocProvider.of<AuthCubit>(context).onEnter(context);
                              },
                              bgColor: Colors.grey[900],
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 60,),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
