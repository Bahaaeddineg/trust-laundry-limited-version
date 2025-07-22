part of 'address_cubit.dart';

sealed class AddressState {}

final class AddressInitial extends AddressState {}

final class AddressSuccess extends AddressState {
  final List<MyAddress> myAddresses;
  AddressSuccess({
    required this.myAddresses,
  });
}
