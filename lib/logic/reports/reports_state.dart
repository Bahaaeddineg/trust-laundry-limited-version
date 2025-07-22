part of 'reports_cubit.dart';


sealed class ReportsState {}

final class ReportsInitial extends ReportsState {}
final class ReportsLoading extends ReportsState {}
final class ReportsFailure extends ReportsState {}
final class ReportsSuccess extends ReportsState {
  final List<Report> reports;
  ReportsSuccess({
    required this.reports,
  });
}
