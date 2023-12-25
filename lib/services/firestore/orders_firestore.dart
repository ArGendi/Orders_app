import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/models/order.dart' as order;

class OrdersFirestore{
  String collectionName = 'orders';

  Future<bool> add(order.Order order) async{
    try{
      String id = FirebaseAuth.instance.currentUser!.uid;
      await FirebaseFirestore.instance.collection('users').doc(id).collection(collectionName).add(order.toMap());
      return true;
    }
    catch(e){
      return false;
    }
  }

  Future<List<order.Order>?> getAll() async{
    try{
      String id = FirebaseAuth.instance.currentUser!.uid;
      var snapshot = await FirebaseFirestore.instance.collection('users').doc(id).collection(collectionName).get();
      List<order.Order> orders = [];
      for(var doc in snapshot.docs){
        orders.add(
          order.Order.fromMap(doc.data())
        );
      }
      return orders;
    }
    catch(e){
      return null;
    }
  }

}