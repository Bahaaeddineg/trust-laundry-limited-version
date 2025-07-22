import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/product.dart';

import '../../models/cart.dart';

part 'prod_cart_state.dart';

class ProdCartCubit extends Cubit<ProdCart> {
  ProdCartCubit() : super(ProdCart(priceToPay: 0, itemsToPayFor: []));

  List<MyProduct> itemsToPayFor = [];

  void addToCart({required MyProduct prod}) {
  
      final existingItemIndex =
          itemsToPayFor.indexWhere((i) => i.id == prod.id);
      if (existingItemIndex != -1) {
        itemsToPayFor[existingItemIndex].quantity += prod.quantity;
      } else {
        itemsToPayFor.add(prod);
      }
    
    final totalPriceToPay = calculatePriceToPay();
    emit(ProdCart(
      priceToPay: totalPriceToPay,
      itemsToPayFor: itemsToPayFor,
    ));
  }

  void emptyCart() {
    itemsToPayFor = [];
    emit(ProdCart(
      priceToPay: 0,
      itemsToPayFor: [],
    ));
  }

  void delete({required String id}) {
    int index = itemsToPayFor.indexWhere((e) => e.id == id);

    itemsToPayFor.removeAt(index);

    final totalPriceToPay = calculatePriceToPay();
    emit(ProdCart(
      priceToPay: totalPriceToPay,
      itemsToPayFor: itemsToPayFor,
    ));
  }

  void increase({required String id}) {
    int index = itemsToPayFor.indexWhere((e) => e.id == id);
    if (itemsToPayFor[index].quantity < 22) {
      itemsToPayFor[index].quantity++;
      final totalPriceToPay = calculatePriceToPay();

      emit(ProdCart(
      priceToPay: totalPriceToPay,
      itemsToPayFor: itemsToPayFor,
    ));
    }
  }

  void decrease({required String id}) {
    int index = itemsToPayFor.indexWhere((e) => e.id == id);

    if (itemsToPayFor[index].quantity > 1) {
      itemsToPayFor[index].quantity--;
      final totalPriceToPay = calculatePriceToPay();
      emit(ProdCart(
      priceToPay: totalPriceToPay,
      itemsToPayFor: itemsToPayFor,
    ));
    } else {
      delete(id: itemsToPayFor[index].id);
    }
  }

  double calculatePriceToPay() {
    // Calculate the total price to pay
    double totalPriceToPay = 0;

    for (var item in itemsToPayFor) {
      totalPriceToPay += item.priceAfterDiscount * item.quantity;
    }

    return totalPriceToPay;
  }
}
