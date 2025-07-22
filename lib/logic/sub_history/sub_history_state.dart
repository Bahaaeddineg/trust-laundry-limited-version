part of 'sub_history_cubit.dart';

sealed class SubHistoryState {}

final class SubHistoryInitial extends SubHistoryState {}

final class SubHistorySuccess extends SubHistoryState {
  final List<MySub> sub;
  SubHistorySuccess({
    required this.sub,
  });
}

final class SubHistoryFailure extends SubHistoryState {}

final class SubHistoryLoading extends SubHistoryState {}
