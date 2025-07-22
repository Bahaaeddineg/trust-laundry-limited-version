import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/cart.dart';
import '../../models/items.dart';
part 'cart_state.dart';

class CartCubit extends Cubit<Cart> {
  CartCubit()
      : super(Cart(priceToPay: 0, itemsToPayFor: [], totalFastPriceToPay: 0));

  List<SubItem> itemsToPayFor = [];

  void addToCart({required List<SubItem> subItems}) {
    for (var tempItem in subItems) {
      final existingItemIndex =
          itemsToPayFor.indexWhere((i) => i.id == tempItem.id);
      if (existingItemIndex != -1) {
        itemsToPayFor[existingItemIndex].quantity += tempItem.quantity;
      } else {
        itemsToPayFor.add(tempItem);
      }
    }

    final totalPriceToPay = calculatePriceToPay();
    final totalFastPriceToPay = calcFastPrice();
    emit(Cart(
        priceToPay: totalPriceToPay,
        itemsToPayFor: itemsToPayFor,
        totalFastPriceToPay: totalFastPriceToPay));
  }

  void emptyCart() {
    itemsToPayFor = [];
    emit(Cart(
        priceToPay: 0, itemsToPayFor: itemsToPayFor, totalFastPriceToPay: 0));
  }

  void delete({required String id}) {
    int index = itemsToPayFor.indexWhere((e) => e.id == id);

    itemsToPayFor.removeAt(index);

    final totalPriceToPay = calculatePriceToPay();
    final totalFastPriceToPay = calcFastPrice();
    emit(Cart(
        priceToPay: totalPriceToPay,
        itemsToPayFor: itemsToPayFor,
        totalFastPriceToPay: totalFastPriceToPay));
  }

  void increase({required String id}) {
    int index = itemsToPayFor.indexWhere((e) => e.id == id);
    if (itemsToPayFor[index].quantity < 22) {
      itemsToPayFor[index].quantity++;
      final totalPriceToPay = calculatePriceToPay();
      final totalFastPriceToPay = calcFastPrice();
      emit(Cart(
          priceToPay: totalPriceToPay,
          itemsToPayFor: itemsToPayFor,
          totalFastPriceToPay: totalFastPriceToPay));
    }
  }

  void decrease({required String id}) {
    int index = itemsToPayFor.indexWhere((e) => e.id == id);

    if (itemsToPayFor[index].quantity > 1) {
      itemsToPayFor[index].quantity--;
      final totalPriceToPay = calculatePriceToPay();
      final totalFastPriceToPay = calcFastPrice();
      emit(Cart(
          priceToPay: totalPriceToPay,
          itemsToPayFor: itemsToPayFor,
          totalFastPriceToPay: totalFastPriceToPay));
    } else {
      delete(id: itemsToPayFor[index].id);
    }
  }

  double calculatePriceToPay() {
    // Calculate the total price to pay
    double totalPriceToPay = 0;

    for (var item in itemsToPayFor) {
      totalPriceToPay += item.price * item.quantity;
    }

    return totalPriceToPay;
  }

  double calcFastPrice() {
    // Calculate the total price to pay
    double totalPriceToPay = 0;

    for (var item in itemsToPayFor) {
      totalPriceToPay += item.priceFast * item.quantity;
    }

    return totalPriceToPay;
  }
}
