import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:notes/constants.dart';
import 'package:notes/controllers/orders/orders_state.dart';
import 'package:notes/models/client.dart';
import 'package:notes/local/database.dart';
import 'package:notes/models/history.dart';
import 'package:notes/models/order.dart';
import 'package:notes/screens/home_screen.dart';
import 'package:notes/screens/order_details_screen.dart';
import 'package:notes/services/firestore/clients_firestore.dart';
import 'package:notes/services/firestore/orders_firestore.dart';
import 'package:notes/services/local_notification.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class OrderCubit extends Cubit<OrderState>{
  List<Order> orders = [];
  Order order = Order();
  final ClientsFirestore _clientsFirestore = ClientsFirestore();
  final OrdersFirestore _ordersFirestore = OrdersFirestore();

  final formKey = GlobalKey<FormState>();

  OrderCubit() : super(InitOrderState());

  Future<OrderStatus> onConfirmOrder(BuildContext context, Client? existClient) async{
    bool valid = formKey.currentState!.validate();
    if(valid){
      formKey.currentState!.save();
      order.createdAt = DateTime.now();
      if(order.deadline != null){
        Box ordersBox = Hive.box(ordersTable);
        Box clientsBox = Hive.box(clientsTable);
        if(existClient == null){
          int clientId = await clientsBox.add(order.client!.toMap());
          order.client!.id = clientId;
        }
        else{
          order.client!.id = existClient.id;
          await clientsBox.put(existClient.id, order.client!.toMap());
        }
        int orderId = await ordersBox.add(order.toMap());
        order.id = orderId;
        emit(DoneUploadOrderState());
        orders.add(order.copyObject());
        order = Order(); // reset object
        //formKey.currentState!.reset();
        _arrangeOrders();
        try{
          DateTime dayBefore = orders.last.deadline!.subtract(const Duration(days: 1));
          LocalNotificationServices.scheduleNotification(
            id: 1,
            title:AppLocalizations.of(context)!.deliveryTomorrow,
            body: AppLocalizations.of(context)!.dontForget + order.client!.name! + AppLocalizations.of(context)!.deliveryTomorrow,
            time: DateTime(dayBefore.year, dayBefore.month, dayBefore.day, 12)
          );
        }catch(e){
          print('notification failed: $e');
        }
        emit(SuccessOrderState());
        return OrderStatus.success;
        
      }
    }
    return OrderStatus.fail;
  }

  Future<bool> onUpdateOrder(BuildContext context, int index) async{
    bool valid = formKey.currentState!.validate();
    if(valid){
      formKey.currentState!.save();
      order.createdAt = DateTime.now();
      orders[index] = order.copyObject();
      Box ordersBox = Hive.box(ordersTable);
      ordersBox.put(order.id, order.toMap());
      order = Order(); // reset
      try{
        DateTime dayBefore = orders[index].deadline!.subtract(const Duration(days: 1));
        LocalNotificationServices.scheduleNotification(
          id: 1,
          title: AppLocalizations.of(context)!.deliveryTomorrow,
          body: AppLocalizations.of(context)!.dontForget + order.client!.name! + AppLocalizations.of(context)!.deliveryTomorrow,
          time: DateTime(dayBefore.year, dayBefore.month, dayBefore.day, 12)
        );
      }catch(e){
        print('notification failed: $e');
      }
      emit(SuccessOrderState());
      return true;
    }
    return false;
  }

  void selectDeadlineDate(BuildContext context) async{
    DateTime now = DateTime.now();
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2), 
    );
    if (selected != null) {
      order.deadline = selected;
      emit(AddDeadlineOrderState());
    }
  }

  void selectDeadlineDateByIndex(BuildContext context, int i) async{
    DateTime now = DateTime.now();
    DateTime? selected = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 2),  
    );
    if (selected != null) {
      orders[i].deadline = selected;
      emit(AddDeadlineOrderState());
    }
  }

  String? validation(String? value, String returnMsg){
    if(value == null) return null;
    if(value.isEmpty) return returnMsg;
    return null;
  }

  String getFilteredDeadline(BuildContext context){
    if(order.deadline != null){
      return '${order.deadline!.day} - ${order.deadline!.month} - ${order.deadline!.year}';
    }
    else {
      return AppLocalizations.of(context)!.deadline;
    }
  }

  void getOrders() async{
    try{
      emit(LoadingOrderState());
      Box ordersBox = Hive.box(ordersTable);
      orders = ordersBox.keys.toList().map((key) {
        Map map = ordersBox.get(key);
        Order newOrder = Order.fromMap(map);
        newOrder.id = key;
        return newOrder;
      } ).toList();
      _arrangeOrders();
      emit(SuccessOrderState());
    }
    catch(e){
      emit(FailOrderState());
    }
  }

  void _arrangeOrders(){
    orders.sort((a,b){
      return a.deadline!.compareTo(b.deadline!);
    });
  }

  Color getOrderColor(int i){
    DateTime now = DateTime.now();
    int restDays = orders[i].deadline!.difference(now).inDays + 1;
    if(restDays <= 2){
      return Colors.red.shade400;
    }
    else if(restDays <= 4){
      return Colors.orange.shade400;
      
    }
    else if(restDays <= 5){
      return Colors.yellow.shade600;
    }
    else{
      return Colors.green.shade400;
    }
  }

  Future<void> showDoneDialog(BuildContext context, int index) async {
    return showDialog<void>(
      context: context,
      //barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(AppLocalizations.of(context)!.confirmDeadline),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(AppLocalizations.of(context)!.sureDeliveringOrderQuestion),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'تأكيد',
                style: TextStyle(
                  color: Colors.green[900]
                ),
              ),
              onPressed: () async{
                orderDone(context, index);
                Navigator.of(context).popUntil((route) => route.isFirst);
              },
            ),
          ],
        );
      },
    );
  }

  void orderDone(BuildContext context, int index) async{
    orders[index].deadline = DateTime.now();
    Box historyBox = Hive.box(historyTable);
    Box ordersBox = Hive.box(ordersTable);
    History newOrderInHistory = History(
      name: orders[index].client!.name,
      createdAt: orders[index].createdAt,
      deadline: orders[index].deadline,
    );
    await historyBox.add(newOrderInHistory.toMap());
    await ordersBox.delete(orders[index].id);
    orders.removeAt(index);
    emit(SuccessOrderState());
  }

  void imageBottomSheet(BuildContext context){
    showModalBottomSheet(
      context: context, 
      builder: (ctx){
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10,),
            ListTile(
              onTap: () async{
                await _getImageFile(ImageSource.camera);
                Navigator.pop(context);
              },
              leading: const Icon(Icons.camera_alt),
              title: Text(AppLocalizations.of(context)!.camera),
            ),
            ListTile(
              onTap: () async{
                await _getImageFile(ImageSource.gallery);
                Navigator.pop(context);
              },
              leading: const Icon(Icons.photo),
              title: Text(AppLocalizations.of(context)!.photos),
            ),
          ],
        );
      },
    );
  }

  Future<void> _getImageFile(ImageSource source) async{
    ImagePicker picker = ImagePicker();
    XFile? xFile = await picker.pickImage(source: source);
    if(xFile != null){
      order.image = File(xFile.path);
      emit(ImageUplaodedState());
    }
  }
  
}