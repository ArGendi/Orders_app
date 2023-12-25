import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:notes/constants.dart';
import 'package:notes/controllers/clients/clients_state.dart';
import 'package:notes/models/client.dart';
import 'package:notes/services/firestore/clients_firestore.dart';

class ClientsCubit extends Cubit<ClientsState>{
  List<Client> clients = [];
  List<Client> filteredClients = [];
  ClientsFirestore clientsFirestore = ClientsFirestore();

  ClientsCubit() : super(InitClientsState());

  void getClientsFromDB() async{
    if(clients.isEmpty){
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
  }

  void searchInClients(String value){
    filteredClients = clients.where((element) => element.name!.contains(value)).toList();
    emit(FilterClientsDataState());
  }

  Future<void> showDeleteDialog(BuildContext context, int index) async {
    return showDialog<void>(
      context: context,
      //barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("مسح البيانات"),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('متأكدة من مسح بيانات ${clients[index].name} ؟'),
                Text("أتاكدي ان مفيش اوردرات حاليا للشخص دا الاول"),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'تأكيد',
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

  Future<void> replaceAllData() async{
    emit(UploadingState());
    await clientsFirestore.removeAll();
    for(var client in clients){
      await clientsFirestore.add(client);
    }
    print('Done uploading (check)');
    emit(SuccessUploadState());
  }

  Future<void> getAllDataFromFB() async{
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
  }
}