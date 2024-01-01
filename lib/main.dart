import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/constants.dart';
import 'package:notes/controllers/auth/auth_cubit.dart';
import 'package:notes/controllers/clients/clients_cubit.dart';
import 'package:notes/controllers/history/history_cubit.dart';
import 'package:notes/controllers/language/app_language_cubit.dart';
import 'package:notes/controllers/language/language_cubit.dart';
import 'package:notes/controllers/orders/orders_cubit.dart';
import 'package:notes/controllers/phone/phone_cubit.dart';
import 'package:notes/firebase_options.dart';
import 'package:notes/local/shared_prference.dart';
import 'package:notes/screens/add_note_screen.dart';
import 'package:notes/screens/home_screen.dart';
import 'package:notes/screens/language_screen.dart';
import 'package:notes/screens/login_screen.dart';
import 'package:notes/services/local_notification.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(ordersTable);
  await Hive.openBox(clientsTable);
  await Hive.openBox(historyTable);
  await Cache.init();
  tz.initializeTimeZones();
  await LocalNotificationServices.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OrderCubit()),
        BlocProvider(create: (context) => ClientsCubit()),
        BlocProvider(create: (context) => HistoryCubit()),
        BlocProvider(create: (context) => PhoneCubit()),
        BlocProvider(create: (context) => AuthCubit()),
        BlocProvider(create: (context) => LanguageCubit()),
        BlocProvider(create: (context) => AppLanguageCubit()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<AppLanguageCubit>(context).getSavedLanguage();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppLanguageCubit, LanguageState>(
      builder: (context, state) {
        return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              useMaterial3: true,
            ),
            home: Cache.getLanguage() != null  && Cache.getEmail() != null?
               const HomeScreen() : const LanguageScreen(),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: Locale(BlocProvider.of<AppLanguageCubit>(context).lang));
      },
    );
  }
}
