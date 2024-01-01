import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:notes/constants.dart';
import 'package:notes/controllers/clients/clients_cubit.dart';
import 'package:notes/controllers/clients/clients_state.dart';
import 'package:notes/controllers/language/app_language_cubit.dart';
import 'package:notes/controllers/orders/orders_cubit.dart';
import 'package:notes/controllers/orders/orders_state.dart';
import 'package:notes/local/database.dart';
import 'package:notes/screens/add_note_screen.dart';
import 'package:notes/screens/clients_screen.dart';
import 'package:notes/screens/history_screen.dart';
import 'package:notes/screens/order_details_screen.dart';
import 'package:notes/services/local_notification.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<OrderCubit>(context).getOrders();
  }

  Future<void> uploadDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      //barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirm),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context)!.uploadDataQuestion),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.confirm,
                style: TextStyle(
                  color: Colors.green[900]
                ),
              ),
              onPressed: () async{
                Navigator.pop(context);
                BlocProvider.of<ClientsCubit>(context).getClientsFromDB();
                BlocProvider.of<ClientsCubit>(context).uploadAllData();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> downloadDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      //barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirm),
          content:  SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context)!.getClientsDataQuestion),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.confirm,
                style: TextStyle(
                  color: Colors.green[900]
                ),
              ),
              onPressed: () async{
                Navigator.pop(context);
                BlocProvider.of<ClientsCubit>(context).getAllDataFromFB();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 100,
              color: Colors.green,
              child: Align(
                alignment: BlocProvider.of<AppLanguageCubit>(context).lang == 'en' ? Alignment.bottomLeft : Alignment.bottomRight ,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    DateTime.now().hour < 2 ? AppLocalizations.of(context)!.goodMorning : AppLocalizations.of(context)!.goodEvening,
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                ),
              ),
            ),
            ListTile(
              onTap: () {
                uploadDialog(context);
              },
              leading: const Icon(Icons.cloud_upload),
              title: BlocBuilder<ClientsCubit, ClientsState>(
                builder: (context, state) {
                  if(state is UploadingState){
                    return Text(AppLocalizations.of(context)!.uploading);
                  }
                  else if(state is SuccessUploadState){
                    return Text(AppLocalizations.of(context)!.uploadDone);
                  }
                  else if(state is FailUploadState){
                    return Text(AppLocalizations.of(context)!.internetConnectionProblem);
                  }
                  else{
                    return Text(AppLocalizations.of(context)!.uploadData);
                  }
                },
              ),
            ),
            ListTile(
              onTap: () {
                downloadDialog(context);
              },
              leading: const Icon(Icons.file_download_outlined),
              title: BlocBuilder<ClientsCubit, ClientsState>(
                builder: (context, state) {
                  if(state is DownloadingState){
                    return Text(AppLocalizations.of(context)!.downloading);
                  }
                  else if(state is SuccessDownloadState){
                    return Text(AppLocalizations.of(context)!.downloadDone);
                  }
                  else if(state is FailDownloadState){
                    return Text(AppLocalizations.of(context)!.internetConnectionProblem);
                  }
                  else{
                    return Text(AppLocalizations.of(context)!.downloadData);
                  }
                },
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.orders),
        elevation: 0.5,
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const ClientsScreen()));
            },
            icon: Icon(Icons.person_3_rounded),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: ((context) => const HistoryScreen())));
            },
            icon: Icon(Icons.timer_sharp),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            print('state now: $state');
            var cubit = BlocProvider.of<OrderCubit>(context);
            if (state is LoadingOrderState) {
              return const Center(
                child: CircularProgressIndicator(
                  color: Colors.black,
                ),
              );
            } else if (state is FailOrderState) {
               return Center(
                child: Text(
                  AppLocalizations.of(context)!.problemExist,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              );
            } else {
              return Visibility(
                visible: cubit.orders.isNotEmpty,
                replacement: Center(
                  child: Image.asset(
                    'images/empty.png',
                    width: 200,
                  ),
                ),
                child: ListView.separated(
                  itemCount: cubit.orders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Material(
                      elevation: 1,
                      borderRadius: BorderRadius.circular(10),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => OrderDetailsScreen(
                                        index: index,
                                        order: cubit.orders[index],
                                      )));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 15, vertical: 12),
                          decoration: BoxDecoration(
                            color: cubit.getOrderColor(index),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    cubit.orders[index].client!.name.toString(),
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                  Text(
                                    "${cubit.orders[index].deadline!.day} / ${cubit.orders[index].deadline!.month} / ${cubit.orders[index].deadline!.year}",
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                              Material(
                                elevation: 3,
                                borderRadius: BorderRadius.circular(100),
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Text(
                                    '${cubit.orders[index].deadline!.difference(DateTime.now()).inDays + 1}',
                                    style: TextStyle(
                                        color: Colors.grey[800], fontSize: 15),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, i) {
                    return const SizedBox(
                      height: 10,
                    );
                  },
                ),
              );
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const ClientsScreen())));
        },
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
    );
  }
}
