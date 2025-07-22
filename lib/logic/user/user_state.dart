part of 'user_cubit.dart';

sealed class UserState {}

final class UserInitial extends UserState {}
final class UserLoading extends UserState {}
final class UserSuccess extends UserState {
  final AppUser user ; 
  UserSuccess({
    required this.user
  });
}
