import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import '../../ui/product_orders/product_orders.dart';

part 'prod_orders_state.dart';

class ProdOrdersCubit extends Cubit<ProdOrderState> {
  ProdOrdersCubit() : super(ProdOrderInitial());
  Future<void> getMyOrders() async {
    emit(ProdOrderLoading());
    List<MyProdOrder> orders = [];
    final userOrders = FirebaseFirestore.instance
        .collection("prodOrders")
        .where("uid", isEqualTo: FirebaseAuth.instance.currentUser!.uid);

    final data = await userOrders.get();
    for (var x in data.docs) {
      orders.add(MyProdOrder.fromJson(x.data()));
    }
    emit(ProdOrderSuccess(orders: orders));
  }
}
