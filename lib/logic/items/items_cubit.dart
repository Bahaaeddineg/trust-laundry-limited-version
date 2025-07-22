import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/items.dart';

part 'items_state.dart';

class ItemsCubit extends Cubit<ItemsState> {
  ItemsCubit() : super(ItemsInitial());


Future<void> fetchItems(String sectionId) async {
    final firestore = FirebaseFirestore.instance;
    List<MyCategory> categories = [];
emit(ItemsLoading());
    try {
      // Fetch categories first
      final categorySnapshots = await firestore
          .collection('itemz')
          .doc(sectionId)
          .collection('categories')
          .get();

      final List<Future<void>> categoryFutures = [];

      for (var categoryDoc in categorySnapshots.docs) {
        categoryFutures.add(_fetchCategoryData(
            sectionId, categoryDoc, firestore, categories));
      }

      // Wait for all categories to be fetched and processed
      await Future.wait(categoryFutures);
    } catch (e) {
      
    }
    emit(ItemsSuccess(categories: categories));
  }

  Future<void> _fetchCategoryData(
      String categoryId,
      QueryDocumentSnapshot categoryDoc,
      FirebaseFirestore firestore,
      List<MyCategory> categories) async {
    final categoryData = categoryDoc.data();
    final category = MyCategory.fromMap({
      'id': categoryDoc.id,
      'titleAr': (categoryData as Map<String, dynamic>)['titleAr'],
      'titleEn': (categoryData as Map<String, dynamic>)['titleEn'],
      'items': [],
    });

    // Fetch items within each category
    final itemSnapshots = await firestore
        .collection('itemz')
        .doc(categoryId)
        .collection('categories')
        .doc(categoryDoc.id)
        .collection('items')
        .get();

    final List<Future<void>> itemFutures = [];

    for (var itemDoc in itemSnapshots.docs) {
      itemFutures.add(_fetchItemData(
          categoryId, categoryDoc.id, itemDoc, firestore, category));
    }

    await Future.wait(itemFutures);
    categories.add(category);
  }

  Future<void> _fetchItemData(
      String categoryId,
      String categoryDocId,
      QueryDocumentSnapshot itemDoc,
      FirebaseFirestore firestore,
      MyCategory category) async {
    final itemData = itemDoc.data();

    final item = Item.fromMap({
      'id': itemDoc.id,
      'image': (itemData as Map<String, dynamic>)['image'],
      'titleAr': itemData['titleAr'],
      'titleEn': itemData['titleEn'],
      'subItems': [],
    });

    // Fetch sub-items within each item
    final subItemSnapshots = await firestore
        .collection('itemz')
        .doc(categoryId)
        .collection('categories')
        .doc(categoryDocId)
        .collection('items')
        .doc(itemDoc.id)
        .collection('subItems')
        .get();

    final subItems = subItemSnapshots.docs
        .map((subItemDoc) => SubItem.fromMap(subItemDoc.data()))
        .toList();

    item.subItems = subItems;
    category.items.add(item);
  }





  // Future<List<MyCategory>> fetchItems({required String categoryId}) async {
  //   final firestore = FirebaseFirestore.instance;
  //   List<MyCategory> categories = [];

  //   try {
  //     emit(ItemsLoading());

  //     // Fetch categories first
  //     final categorySnapshots = await firestore
  //         .collection('items')
  //         .doc(categoryId)
  //         .collection('categories')
  //         .get();

  //     final List<Future<void>> categoryFutures = [];

  //     for (var categoryDoc in categorySnapshots.docs) {
  //       categoryFutures.add(
  //           _fetchCategoryData(categoryId, categoryDoc, firestore, categories));
  //     }

  //     // Wait for all categories to be fetched and processed
  //     await Future.wait(categoryFutures);

  //     emit(ItemsSuccess(categories: categories));
  //   } catch (e) {
  //     
  //   }

  //   return categories;
  // }

  // Future<void> _fetchCategoryData(
  //     String categoryId,
  //     QueryDocumentSnapshot categoryDoc,
  //     FirebaseFirestore firestore,
  //     List<MyCategory> categories) async {
  //   final categoryData = categoryDoc.data();
  //   final category = MyCategory.fromMap({
  //     'id': categoryDoc.id,
  //     'category': (categoryData as Map<String,dynamic>)['category'],
  //     'items': [],
  //   });

  //   // Fetch items within each category
  //   final itemSnapshots = await firestore
  //       .collection('items')
  //       .doc(categoryId)
  //       .collection('categories')
  //       .doc(categoryDoc.id)
  //       .collection('items')
  //       .get();

  //   final List<Future<void>> itemFutures = [];

  //   for (var itemDoc in itemSnapshots.docs) {
  //     itemFutures.add(_fetchItemData(
  //         categoryId, categoryDoc.id, itemDoc, firestore, category));
  //   }

  //   await Future.wait(itemFutures);
  //   categories.add(category);
  // }

  // Future<void> _fetchItemData(
  //     String categoryId,
  //     String categoryDocId,
  //     QueryDocumentSnapshot itemDoc,
  //     FirebaseFirestore firestore,
  //     MyCategory category) async {
  //   final itemData = itemDoc.data();

  //   final item = Item.fromMap({
  //     'id': itemDoc.id,
  //     'imagePath': (itemData as Map<String,dynamic>)['imagePath'] ,
  //     'name': itemData['name'],
  //     'subItems': [],
  //   });

  //   // Fetch sub-items within each item
  //   final subItemSnapshots = await firestore
  //       .collection('items')
  //       .doc(categoryId)
  //       .collection('categories')
  //       .doc(categoryDocId)
  //       .collection('items')
  //       .doc(itemDoc.id)
  //       .collection('subItems')
  //       .get();

  //   final subItems = subItemSnapshots.docs
  //       .map((subItemDoc) => SubItem.fromMap(subItemDoc.data()))
  //       .toList();

  //   item.subItems = subItems;
  //   category.items.add(item);
  // }

  // Future<List<Category>> fetchItems({required String categoryId}) async {
  //   final firestore = FirebaseFirestore.instance;
  //   List<Category> categories = [];

  //   try {
  //    emit(ItemsLoading());
  //     final categorySnapshots = await firestore
  //         .collection('items')
  //         .doc(categoryId)
  //         .collection('categories')
  //         .get();

  //     for (var categoryDoc in categorySnapshots.docs) {
  //       final categoryData = categoryDoc.data();
  //       final category = Category.fromMap({
  //         'id': categoryDoc.id,
  //         'category': categoryData['category'],
  //         'items': [],
  //       });

  //       // Fetch items within each category
  //       final itemSnapshots = await firestore
  //           .collection('items')
  //           .doc(categoryId)
  //           .collection('categories')
  //           .doc(categoryDoc.id)
  //           .collection('items')
  //           .get();

  //       for (var itemDoc in itemSnapshots.docs) {
  //         final itemData = itemDoc.data();
  //         final item = Item.fromMap({
  //           'id': itemDoc.id,
  //           'imagePath': itemData['imagePath'],
  //           'name': itemData['name'],
  //           'subItems': [],
  //         });

  //         // Fetch sub-items within each item
  //         final subItemSnapshots = await firestore
  //             .collection('items')
  //             .doc(categoryId)
  //             .collection('categories')
  //             .doc(categoryDoc.id)
  //             .collection('items')
  //             .doc(itemDoc.id)
  //             .collection('subItems')
  //             .get();

  //         final subItems = subItemSnapshots.docs
  //             .map((subItemDoc) => SubItem.fromMap(subItemDoc.data()))
  //             .toList();

  //         category.items.add(Item(
  //           id: item.id,
  //           imagePath: item.imagePath,
  //           name: item.name,
  //           subItems: subItems,
  //         ));
  //       }

  //       categories.add(category);

  //     }
  //   emit(ItemsSuccess(categories: categories));
  //   } catch (e) {
  //     
  //   }

  //   return categories;
  // }
}


// Future<List<Category>> fetchItems() async {
//   final firestore = FirebaseFirestore.instance;
//   List<Category> categories = [];

//   try {
//     // Fetch main categories
//     final mainCategorySnapshots = await firestore.collection('items').get();

//     for (var mainCategoryDoc in mainCategorySnapshots.docs) {
//       // Fetch categories within each main category
//       final categorySnapshots = await firestore
//           .collection('items')
//           .doc(mainCategoryDoc.id)
//           .collection('categories')
//           .get();

//       for (var categoryDoc in categorySnapshots.docs) {
//         final categoryData = categoryDoc.data();
//         final category = Category.fromMap({
//           'id': categoryDoc.id,
//           'category': categoryData['category'],
//           'items': [],
//         });

//         // Fetch items within each category
//         final itemSnapshots = await firestore
//             .collection('items')
//             .doc(mainCategoryDoc.id)
//             .collection('categories')
//             .doc(categoryDoc.id)
//             .collection('items')
//             .get();

//         for (var itemDoc in itemSnapshots.docs) {
//           final itemData = itemDoc.data();
//           final item = Item.fromMap({
//             'id': itemDoc.id,
//             'imagePath': itemData['imagePath'],
//             'name': itemData['name'],
//             'subItems': [],
//           });

//           // Fetch sub-items within each item
//           final subItemSnapshots = await firestore
//               .collection('items')
//               .doc(mainCategoryDoc.id)
//               .collection('categories')
//               .doc(categoryDoc.id)
//               .collection('items')
//               .doc(itemDoc.id)
//               .collection('subItems')
//               .get();

//           final subItems = subItemSnapshots.docs
//               .map((subItemDoc) => SubItem.fromMap(subItemDoc.data()))
//               .toList();

//           category.items.add(Item(
//             id: item.id,
//             imagePath: item.imagePath,
//             name: item.name,
//             subItems: subItems,
//           ));
//         }

//         categories.add(category);
//       }
//     }
//   } catch (e) {
//     
//   }

//   return categories;
// }