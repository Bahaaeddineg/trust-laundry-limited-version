part of 'manage_items_cubit.dart';

sealed class ManageItemsState {}

final class ManageItemsInitial extends ManageItemsState {}
final class ManageItemsSuccess extends ManageItemsState {
  final List<MainCategory> mainCategories;
  ManageItemsSuccess({
    required this.mainCategories,
  });
}
final class ManageItemsFailure extends ManageItemsState {}
final class ManageItemsLoading extends ManageItemsState {}
