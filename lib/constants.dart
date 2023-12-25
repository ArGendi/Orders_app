import 'package:flutter/material.dart';

Color? mainColor = Colors.grey.shade900;

// database tables
String ordersTable = "orders";
String clientsTable = "clients";
String historyTable = "history";

// enum
enum OrderStatus{
  success,
  fail,
  internetProblem,
}

enum LoginStatus{
  success,
  wrongPassword,
  invalidEmail,
  failed,
}

enum SignupStatus{
  success,
  emailAlreadyInUse,
  failed,
}