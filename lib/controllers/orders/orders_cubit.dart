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
import 'package:notes/services/local_notification.dart';

class OrderCubit extends Cubit<OrderState>{
  List<Order> orders = [];
  Order order = Order();
  final formKey = GlobalKey<FormState>();

  OrderCubit() : super(InitOrderState());

  Future<bool> onConfirmOrder(Client? existClient) async{
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
        orders.add(order.copyObject());
        //order = Order(); // reset object
        //formKey.currentState!.reset();
        _arrangeOrders();
        try{
          DateTime dayBefore = order.deadline!.subtract(const Duration(days: 1));
          LocalNotificationServices.scheduleNotification(
            id: 1,
            title: 'التسليم بكرا',
            body: 'متنسيش ${order.client!.name} هتستلم بكرا',
            time: DateTime(dayBefore.year, dayBefore.month, dayBefore.day, 12)
          );
        }catch(e){
          // if error happens
        }
        
        emit(SuccessOrderState());
        return true;
      }
    }
    return false;
  }

  Future<bool> onUpdateOrder(int index) async{
    bool valid = formKey.currentState!.validate();
    if(valid){
      formKey.currentState!.save();
      order.createdAt = DateTime.now();
      orders[index] = order.copyObject();
      Box ordersBox = Hive.box(ordersTable);
      Box clientsBox = Hive.box(clientsTable);
      ordersBox.put(order.id, order.toMap());
      clientsBox.put(order.client!.id, order.client!.toMap());
      //order = Order(); // reset
      try{
        DateTime dayBefore = order.deadline!.subtract(const Duration(days: 1));
        LocalNotificationServices.scheduleNotification(
          id: 1,
          title: 'التسليم بكرا',
          body: 'متنسيش ${order.client!.name} هتستلم بكرا',
          time: DateTime(dayBefore.year, dayBefore.month, dayBefore.day, 12)
        );
      }catch(e){
        // if error happens
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

  String getFilteredDeadline(){
    if(order.deadline != null){
      return '${order.deadline!.day} - ${order.deadline!.month} - ${order.deadline!.year}';
    }
    else {
      return 'تاريخ التسليم';
    }
  }

  String getFilteredDeadlineByIndex(int i){
    if(order.deadline != null){
      return '${orders[i].deadline!.day} - ${orders[i].deadline!.month} - ${orders[i].deadline!.year}';
    }
    else {
      return 'تاريخ التسليم';
    }
  }

  void getOrders() async{
    emit(LoadingOrderState());
    Box ordersBox = Hive.box(ordersTable);
    Box clientsBox = Hive.box(clientsTable);
    orders = ordersBox.keys.toList().map((key) {
      Map map = ordersBox.get(key);
      Order newOrder = Order.fromMap(map);
      Map orderClientMap = clientsBox.get(newOrder.client!.id);
      int id = newOrder.client!.id!;
      newOrder.client = Client.fromMap(orderClientMap);
      newOrder.client!.id = id;
      newOrder.id = key;
      return newOrder;
    } ).toList();
    _arrangeOrders();
    emit(SuccessOrderState());
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
      return Color.fromARGB(255, 163, 161, 23);
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
          title: const Text("تأكيد التسليم"),
          content: const SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('متأكدة من تسليم الاوردر ؟'),
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
    emit(OrderDoneState());
  }

  void imageBottomSheet(BuildContext context){
    showModalBottomSheet(
      context: context, 
      builder: (ctx){
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(height: 10,),
            ListTile(
              onTap: () async{
                await _getImageFile(ImageSource.camera);
                Navigator.pop(context);
              },
              leading: const Icon(Icons.camera_alt),
              title: const Text('كاميرا'),
            ),
            ListTile(
              onTap: () async{
                await _getImageFile(ImageSource.gallery);
                Navigator.pop(context);
              },
              leading: const Icon(Icons.photo),
              title: const Text('الصور'),
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