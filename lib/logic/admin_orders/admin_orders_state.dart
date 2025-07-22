part of 'admin_orders_cubit.dart';


sealed class AdminOrdersState {}

final class AdminOrdersInitial extends AdminOrdersState {}
final class AdminOrdersFailure extends AdminOrdersState {}
final class AdminOrdersLoading extends AdminOrdersState {}
final class AdminOrdersSuccess extends AdminOrdersState {
  final List<UserOrder> orders;
   AdminOrdersSuccess({
    required this.orders,
  });
}
