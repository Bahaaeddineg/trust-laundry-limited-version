import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'balance_state.dart';

class BalanceCubit extends Cubit<double> {
  BalanceCubit() : super(0);

  double balance = 0;

  Future<bool> getBalance() async {
    final userDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    try {
      final snapshot = await userDoc.get();
      if (snapshot.exists && snapshot.data()!.containsKey("balance")) {
        balance = snapshot.data()!["balance"];
      }
      
      emit(balance);
      return true;
    } catch (e) {
      
      return false;
    }
  }

  Future<void> increaseBalance(double price) async {
    final userDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    balance += price;
    emit(balance);
    userDoc.update({
      "balance": balance,
    });
  }

  Future<void> decreaseBalance(double price) async {
    final userDoc = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid);
    balance -= price;
    emit(balance);
    userDoc.update({
      "balance": balance,
    });
  }
}
