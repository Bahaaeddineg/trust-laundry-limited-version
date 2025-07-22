part of 'order_cubit.dart';


sealed class OrderState {}

final class OrderInitial extends OrderState {}
final class OrderLoading extends OrderState {}
final class OrderSuccess extends OrderState {
  final List<UserOrder> orders;
  OrderSuccess({
    required this.orders,
  });
}
final class OrderFailure extends OrderState {}
