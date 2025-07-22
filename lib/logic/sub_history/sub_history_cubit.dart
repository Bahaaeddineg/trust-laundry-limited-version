import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/sub.dart';

part 'sub_history_state.dart';

class SubHistoryCubit extends Cubit<SubHistoryState> {
  SubHistoryCubit() : super(SubHistoryInitial());

  Future<void> getMySubs() async {
    emit(SubHistoryLoading());
    List<MySub> subsHistory = [];
    final subsHistoryDocs = await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("subscriptionsHistory")
        .get();
    for (var x in subsHistoryDocs.docs) {
      subsHistory.add(MySub.fromJson(x.data()));
    }
    subsHistory.sort(
      (a, b) => b.timeStamp.compareTo(a.timeStamp),
    );
    emit(SubHistorySuccess(sub: subsHistory));
  }
}
