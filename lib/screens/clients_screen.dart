import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes/constants.dart';
import 'package:notes/controllers/clients/clients_cubit.dart';
import 'package:notes/controllers/clients/clients_state.dart';
import 'package:notes/screens/add_note_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ClientsScreen extends StatefulWidget {
  const ClientsScreen({super.key});

  @override
  State<ClientsScreen> createState() => _ClientsScreenState();
}

class _ClientsScreenState extends State<ClientsScreen> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<ClientsCubit>(context).getClientsFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Row(
          children: [
            Text(AppLocalizations.of(context)!.clients),
            const SizedBox(width: 15,),
            Expanded(
              child: Container(
                height: 35,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(5)
                ),
                child: TextField(
                  onChanged: (value){
                    BlocProvider.of<ClientsCubit>(context).searchInClients(value);
                  },
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(vertical: 9.5, horizontal: 5),
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    prefixIcon: Icon(Icons.search),
                    hintText: AppLocalizations.of(context)!.search,
                  ),
                ),
              ),
            ),
          ],
        ),
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: BlocBuilder<ClientsCubit, ClientsState>(
          builder: (context, state) {
            var cubit = BlocProvider.of<ClientsCubit>(context);
            return Visibility(
              visible: cubit.clients.isNotEmpty,
              replacement: Center(
                  child: Image.asset(
                    'images/empty.png',
                    width: 200,
                  ),
                ),
              child: ListView.separated(
                itemBuilder: (context, i){
                  return Material(
                    //elevation: 3,
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[900],
                    child: InkWell(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context) => AddNoteScreen(client: cubit.filteredClients[i],)));
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
                        child: Row(
                          //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Icon(Icons.person_3_rounded, color: Colors.white,),
                            const SizedBox(width: 10,),
                            Text(
                              cubit.filteredClients[i].name.toString(),
                              style: const TextStyle(
                                fontSize: 17,
                                color: Colors.white
                                //fontWeight: FontWeight.bold
                              ),
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: (){
                                cubit.showDeleteDialog(context, i);
                              }, 
                              icon:  Icon(Icons.cancel_rounded, color: Colors.red[800],),
                            ),
            
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) {
                  return const SizedBox(
                    height: 8,
                  );
                },
                itemCount: cubit.filteredClients.length,
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const AddNoteScreen())));
        },
        label: Text(AppLocalizations.of(context)!.newOrder),
        icon: const Icon(Icons.add),
        //child: ,
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
