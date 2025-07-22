part of 'items_cubit.dart';

sealed class ItemsState {}

final class ItemsInitial extends ItemsState {}

final class ItemsSuccess extends ItemsState {
  final List<MyCategory> categories;
  ItemsSuccess({
    required this.categories,
  });
}

final class ItemsLoading extends ItemsState {}
