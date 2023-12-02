import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:notes/constants.dart';
import 'package:notes/controllers/orders/orders_cubit.dart';
import 'package:notes/controllers/orders/orders_state.dart';
import 'package:notes/local/database.dart';
import 'package:notes/screens/add_note_screen.dart';
import 'package:notes/screens/clients_screen.dart';
import 'package:notes/screens/history_screen.dart';
import 'package:notes/screens/order_details_screen.dart';
import 'package:notes/services/local_notification.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late DataBase database;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BlocProvider.of<OrderCubit>(context).getOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاوردرات'),
        
        elevation: 0.5,
        backgroundColor: Colors.grey[900],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => const ClientsScreen()));
            }, 
            icon: Icon(Icons.person_3_rounded),
          ),
          IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: ((context) => const HistoryScreen())));
            }, 
            icon: Icon(Icons.timer_sharp),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: BlocBuilder<OrderCubit, OrderState>(
          builder: (context, state) {
            var cubit = BlocProvider.of<OrderCubit>(context);
            if(state is LoadingOrderState){
              return const Center(child: CircularProgressIndicator(color: Colors.black,),);
            }
            else{
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
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> OrderDetailsScreen(
                            index: index, 
                            order: cubit.orders[index]
                          ,)));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
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
                                    '${cubit.orders[index].deadline!.difference(DateTime.now()).inDays+1}',
                                    style: TextStyle(
                                      color: Colors.grey[800],
                                      fontSize: 15
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                  separatorBuilder: (context, i){
                    return const SizedBox(height: 10,);
                  },
                ),
              );
              
            }
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: ((context) => AddNoteScreen())));
        },
        child: Icon(Icons.add),
        backgroundColor: mainColor,
        foregroundColor: Colors.white,
      ),
    );
  }
}
