part of 'users_cubit.dart';

sealed class UsersState {}

final class UsersInitial extends UsersState {}
final class UsersSuccess extends UsersState {
  final List<AppUser> appUsers;
  UsersSuccess({
    required this.appUsers,
  });
}
final class UsersLoading extends UsersState {}
final class UsersFailure extends UsersState {}

