import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/report.dart';


part 'reports_state.dart';

class ReportsCubit extends Cubit<ReportsState> {
  ReportsCubit() : super(ReportsInitial());


 Future<void> getReports() async {
  emit(ReportsLoading());
  try {
    final snapshot = await FirebaseFirestore.instance
        .collection("reports")
        .orderBy("time", descending: true)
        .get();

    if (snapshot.docs.isEmpty) {
      emit(ReportsSuccess(reports: [])); // No reports yet
      return;
    }

    List<Report> reports = snapshot.docs
        .map((doc) => Report.fromJson(doc.data()))
        .toList();

    emit(ReportsSuccess(reports: reports));
  } catch (e) {
    emit(ReportsFailure());
  }
}

}
