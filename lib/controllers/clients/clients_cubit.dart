// ignore_for_file: prefer_interpolation_to_compose_strings

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:notes/constants.dart';
import 'package:notes/controllers/clients/clients_state.dart';
import 'package:notes/models/client.dart';
import 'package:notes/services/firestore/clients_firestore.dart';
import 'package:path/path.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClientsCubit extends Cubit<ClientsState>{
  List<Client> clients = [];
  List<Client> filteredClients = [];
  ClientsFirestore clientsFirestore = ClientsFirestore();

  ClientsCubit() : super(InitClientsState());

  void getClientsFromDB() async{
    Box box = Hive.box(clientsTable);
    clients = box.keys.toList().map((key){
        Map map = box.get(key);
        Client client = Client.fromMap(map);
        client.id = key;
        return client;
      }
    ).toList();
    filteredClients = clients;
    emit(GetClientsDataState());
  }

  void searchInClients(String value){
    filteredClients = clients.where((element) => element.name!.contains(value)).toList();
    emit(FilterClientsDataState());
  }

  void addClient(Client client) async{
    Box box = Hive.box(clientsTable);
    await box.add(client.toMap());
    clients.add(client);
    emit(AddClientState());
  }

  Future<void> showDeleteDialog(BuildContext context, int index) async {
    return showDialog<void>(
      context: context,
      //barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.deleteData),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context)!.sureDeletedataQuestion + clients[index].name.toString() + "?"),
                Text(AppLocalizations.of(context)!.makeSureThereIsNoOrders),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.confirm,
                style: TextStyle(
                  color: Colors.red[900]
                ),
              ),
              onPressed: () async{
                Box box = Hive.box(clientsTable);
                await box.delete(clients[index].id);
                clients.removeAt(index);
                emit(ClientDeletedState());
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> uploadAllData() async{
    try{
      emit(UploadingState());
      await clientsFirestore.removeAll();
      for(var client in clients){
        await clientsFirestore.add(client);
      }
      print('Done uploading (check)');
      emit(SuccessUploadState());
    }
    catch(e){
      emit(FailUploadState());
    }
  }

  Future<void> getAllDataFromFB() async{
    try{
      emit(DownloadingState());
      List<Client>? clientsFromFB = await clientsFirestore.getAll();
      print('clients from fb: $clientsFromFB');
      if(clientsFromFB != null){
        filteredClients = clients = clientsFromFB;
        Box box = Hive.box(clientsTable);
        for(int i=0; i<clients.length; i++){
          int id = await box.add(clients[i].toMap());
          clients[i].id = id;
        }
        emit(SuccessDownloadState());
      }
      else{
        emit(FailDownloadState());
      }
    }
    catch(e){
      emit(FailDownloadState());
    }
  }

  Future<void> showConfirmDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      //barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          //title: const Text("تم تحميل البيانات"),
          content: const Icon(Icons.check, color: Colors.green,),
          actions: <Widget>[
            TextButton(
              child: Text(
                AppLocalizations.of(context)!.gotIt,
                style: TextStyle(
                  color: Colors.red[900]
                ),
              ),
              onPressed: () async{
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}