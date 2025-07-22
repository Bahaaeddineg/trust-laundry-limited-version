import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/app_user.dart';
import '../../models/order.dart';

part 'users_state.dart';

class UsersCubit extends Cubit<UsersState> {
  UsersCubit() : super(UsersInitial());

Future<void> getAllUsers() async {
    emit(UsersLoading());
    List<AppUser> users = [];
    final orderDocs =await FirebaseFirestore.instance.collection("users").get();
    for (var x in orderDocs.docs){
      users.add(AppUser.fromJson(x.data()));
    } 
    emit(UsersSuccess(appUsers: users));
  }
}
