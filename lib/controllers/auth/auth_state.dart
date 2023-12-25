part of 'auth_cubit.dart';

@immutable
abstract class AuthState {}

class AuthInitial extends AuthState {}
class LoadingState extends AuthState {}
class SuccessState extends AuthState {}
class FailState extends AuthState {}
