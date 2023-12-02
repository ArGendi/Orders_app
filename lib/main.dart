import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:notes/constants.dart';
import 'package:notes/controllers/clients/clients_cubit.dart';
import 'package:notes/controllers/history/history_cubit.dart';
import 'package:notes/controllers/orders/orders_cubit.dart';
import 'package:notes/screens/add_note_screen.dart';
import 'package:notes/screens/home_screen.dart';
import 'package:notes/services/local_notification.dart';
import 'package:timezone/data/latest_all.dart' as tz;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(ordersTable);
  await Hive.openBox(clientsTable);
  await Hive.openBox(historyTable);
  tz.initializeTimeZones();
  await LocalNotificationServices.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => OrderCubit()),
        BlocProvider(create: (context) => ClientsCubit()),
        BlocProvider(create: (context) => HistoryCubit()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Notes',
        theme: ThemeData(
          useMaterial3: true,
        ),
        home: const HomeScreen(),
        localizationsDelegates: const [
          GlobalCupertinoLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale("ar", "EG"),
        ],
        locale: const Locale("ar", "EG")
      ),
    );
  }
}