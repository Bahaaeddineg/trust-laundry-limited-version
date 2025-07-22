part of 'prod_orders_cubit.dart';

@immutable
sealed class ProdOrderState {}

final class ProdOrderInitial extends ProdOrderState {}
final class ProdOrderLoading extends ProdOrderState {}
final class ProdOrderSuccess extends ProdOrderState {
  final List<MyProdOrder> orders;
  ProdOrderSuccess({
    required this.orders,
  });
}
final class ProdOrderFailure extends ProdOrderState {}

