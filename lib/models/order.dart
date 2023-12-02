import 'dart:io';

import 'package:notes/models/client.dart';

class Order{
  int? id;
  Client? client;
  File? image;
  String? comment;
  DateTime? deadline;
  DateTime? createdAt;

  Order({this.id, this.client, this.deadline, this.createdAt, this.comment, this.image}){
    client ??= Client();
  }
  Order.fromMap(Map map){
    client = Client(id: map['clientId']);
    comment = map['comment'];
    deadline = DateTime.fromMillisecondsSinceEpoch(map['deadline']);
    createdAt = DateTime.fromMillisecondsSinceEpoch(map['createdAt']);
    image = map['image'] != null ? File(map['image']) : null;
  }

  Map<String, dynamic> toMap(){
    return {
      'clientId': client?.id,
      'comment': comment,
      'deadline': deadline?.millisecondsSinceEpoch,
      'createdAt': createdAt?.millisecondsSinceEpoch,
      'image': image?.path,
    };
  }

  Order copyObject(){
    return Order(
      id: id,
      client: client,
      comment: comment,
      deadline: deadline,
      createdAt: createdAt,
      image: image,
    );
  }
}