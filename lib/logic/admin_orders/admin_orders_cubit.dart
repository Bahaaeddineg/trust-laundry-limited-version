import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../models/order.dart';


part 'admin_orders_state.dart';

class AdminOrdersCubit extends Cubit<AdminOrdersState> {
  AdminOrdersCubit() : super(AdminOrdersInitial());


  Future<void> getUsersOrders() async {
    emit(AdminOrdersLoading());
    List<UserOrder> orders = [];
    final orderDocs =await FirebaseFirestore.instance.collection("orders").get();
    for (var x in orderDocs.docs){
      orders.add(UserOrder.fromJson(x.data()));
    } 
    emit(AdminOrdersSuccess(orders: orders));
  }
  Future<void> getUpdatedOrders() async {
    emit(AdminOrdersLoading());
    List<UserOrder> orders = [];
    final orderDocs = await FirebaseFirestore.instance.collection("orders").get();
    for (var x in orderDocs.docs) {
      orders.add(UserOrder.fromJson(x.data()));
    }
    emit(AdminOrdersSuccess(orders: orders));
  }

}
