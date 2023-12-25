import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:notes/models/client.dart';

class ClientsFirestore{
  String collectionName = 'clients';

  Future<String?> add(Client client) async{
    try{
      String id = FirebaseAuth.instance.currentUser!.uid;
      var doc = await FirebaseFirestore.instance.collection('users').doc(id).collection(collectionName).add(client.toMap());
      return doc.id;
    }
    catch(e){
      print('error: $e');
      return null;
    }
  }

  // Future<bool> update(Client client) async{
  //   try{
  //     await FirebaseFirestore.instance.collection(collectionName).doc(client.docId).set(client.toMap());
  //     return true;
  //   }
  //   catch(e){
  //     return false;
  //   }
  // }

  Future<List<Client>?> getAll() async{
    try{
      String id = FirebaseAuth.instance.currentUser!.uid;
      var snapshot = await FirebaseFirestore.instance.collection('users').doc(id).collection(collectionName).get();
      List<Client> clients = [];
      for(var doc in snapshot.docs){
        clients.add(
          Client.fromMap(doc.data())
        );
      }
      return clients;
    }
    catch(e){
      return null;
    }
  }

   Future<bool> removeAll() async{
    try{
      String id = FirebaseAuth.instance.currentUser!.uid;
      var snapshot = await FirebaseFirestore.instance.collection('users').doc(id).collection(collectionName).get();
      for (var element in snapshot.docs) {
        element.reference.delete();
      }
      return true;
    }
    catch(e){
      return false;
    }
  }
}