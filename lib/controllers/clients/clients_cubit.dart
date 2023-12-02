import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:notes/constants.dart';
import 'package:notes/controllers/clients/clients_state.dart';
import 'package:notes/models/client.dart';

class ClientsCubit extends Cubit<ClientsState>{
  List<Client> clients = [];
  List<Client> filteredClients = [];

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
}