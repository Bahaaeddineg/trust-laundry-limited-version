import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/order.dart';

part 'order_state.dart';

class OrderCubit extends Cubit<OrderState> {
  OrderCubit() : super(OrderInitial());

  Future<void> getMyOrders() async {
    emit(OrderLoading());
    List<UserOrder> orders = [];
    final userOrders = FirebaseFirestore.instance
        .collection("orders")
          .orderBy(
          "timeStamp",
          descending: true,
        )
        .where("userId", isEqualTo: FirebaseAuth.instance.currentUser!.uid);
      

    final data = await userOrders.get();
    for (var x in data.docs) {
      orders.add(UserOrder.fromJson(x.data()));
    }
    emit(OrderSuccess(orders: orders));
  }
}
