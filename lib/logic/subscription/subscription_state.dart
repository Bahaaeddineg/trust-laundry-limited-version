part of 'subscription_cubit.dart';

sealed class SubscriptionState {}

final class SubscriptionInitial extends SubscriptionState {}
final class SubscriptionSuccess extends SubscriptionState {
  final List<Sub> subscriptions;
  SubscriptionSuccess({required this.subscriptions});
}
final class SubscriptionLoading extends SubscriptionState {}
