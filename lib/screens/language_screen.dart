import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:notes/controllers/language/app_language_cubit.dart';
import 'package:notes/controllers/language/language_cubit.dart';
import 'package:notes/screens/login_screen.dart';

class LanguageScreen extends StatefulWidget {
  const LanguageScreen({super.key});

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> with TickerProviderStateMixin {
  late Animation<Offset> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<Offset>(
      begin: Offset(-10,0),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _controller, curve: Curves.bounceOut)
    );
  }

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('Orga'),
      //   backgroundColor: Colors.grey[900],
      //   foregroundColor: Colors.white,
      // ),
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'images/lang.png',
                    width: 300,
                  ),
                  // const SizedBox(
                  //   height: 10,
                  // ),
                  const Text(
                    'أختار لغتك',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  const Text(
                    'Select your language',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(height: 15,),
                  BlocBuilder<LanguageCubit, LanguageState>(
                    builder: (context, state) {
                      var cubit = BlocProvider.of<LanguageCubit>(context);
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () {
                              cubit.changeLanguage('ar');
                              if(!_controller.isCompleted){
                                _controller.forward();
                              }
                            },
                            child: AnimatedContainer(
                              width: double.infinity,
                              height: 45,
                              duration: const Duration(milliseconds: 500),
                              decoration: BoxDecoration(
                                color: cubit.lang == 'ar' ? Colors.green[700] : Colors.grey[900],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'عربي',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 17,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          GestureDetector(
                            onTap: () {
                              cubit.changeLanguage('en');
                              if(!_controller.isCompleted){
                                _controller.forward();
                              }
                            },
                            child: AnimatedContainer(
                              width: double.infinity,
                              height: 45,
                              duration: const Duration(milliseconds: 500),
                              decoration: BoxDecoration(
                                color: cubit.lang == 'en' ? Colors.green[700] : Colors.grey[900],
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Center(
                                child: Text(
                                  'English',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: SlideTransition(
        position: _animation,
        child: FloatingActionButton(
          onPressed: () async{
            Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
          },
          backgroundColor: Colors.green[700],
          foregroundColor: Colors.white,
          child: const Icon(Icons.arrow_forward),
        ),
      ),
    );
  }
}
