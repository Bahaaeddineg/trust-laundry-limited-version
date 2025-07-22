import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/my_address.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit() : super(AddressInitial());

 

  Future<bool> getAddresses() async {
    List<MyAddress> myAddresses = [];
     final addresses = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("addresses");
    try {
      final querySnapshot = await addresses.get();

      for (QueryDocumentSnapshot doc in querySnapshot.docs) {
        final data = doc.data();
        myAddresses.add(MyAddress.fromJson(data));
      }

      emit(AddressSuccess(myAddresses: myAddresses));
      return true;
    } catch (e) {
      
      return false;
    }
  }

  Future<bool> deleteAddress({required String id}) async {
     final addresses = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("addresses");
    try {
      if (state is AddressSuccess) {
        final currentState = state as AddressSuccess;
        final updatedAddresses = List<MyAddress>.from(currentState.myAddresses);
        updatedAddresses.removeWhere((e) => e.id == id);

        emit(AddressSuccess(myAddresses: updatedAddresses));
      }
      await addresses.doc(id).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> editAddress({
    
    required String area,
    required String city,
    required String id,
    required String piece,
    required String title,
    required String jada,
    required String street,
    required String building,
    required String phoneNum,
    required String buildingNum,
  }) async {
     final addresses = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("addresses");
    try {
      await addresses.doc(id).update({
        "area":area,
        "city":city,
        "piece": piece,
        "boulevard": jada,
        "title": title,
        "street": street,
        "building": building,
        "appartementNum": buildingNum,
        "phoneNum": phoneNum,
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addAddress({
    required String area,
    required String city,
    required String piece,
    required String title,
    required String jada,
    required String street,
    required String building,
    required String phoneNum,
    required String buildingNum,
  }) async {
    try {
       final addresses = FirebaseFirestore.instance
      .collection("users")
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection("addresses");
      final doc = await addresses.add({
        "isExact":false,
        "area":area,
        "city":city,
        "piece": piece,
        "boulevard": jada,
        "title": title,
        "street": street,
        "building": building,
        "appartementNum": buildingNum,
        "phoneNum": phoneNum,
      });
      await addresses.doc(doc.id).update({'id': doc.id});
      return true;
    } catch (e) {
      return false;
    }
  }
}
