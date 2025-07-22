import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/sub.dart';

part 'subscription_state.dart';

class SubscriptionCubit extends Cubit<SubscriptionState> {
  SubscriptionCubit() : super(SubscriptionInitial());

  final subs = FirebaseFirestore.instance.collection("subscriptions");

  Future<void> getSubs() async {
    List<Sub> subscriptions = [];
    try {
      emit(SubscriptionLoading());
      final snapshots = await subs.get();
      final docs = snapshots.docs;
      for (var x in docs) {
        final subsciption = x.data();
      
        subscriptions.add(Sub.fromJson(subsciption));
      }
      subscriptions.sort((a, b) => a.get < b.get ? -1 : 1);
      emit(SubscriptionSuccess(subscriptions: subscriptions));
    } catch (e) {
      
    }
  }


}
