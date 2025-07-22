import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../models/items.dart';

part 'manage_items_state.dart';

class MainCategory {
  final List<MyCategory> categories;
  final String title;
  MainCategory({
    required this.categories,
    required this.title,
  });
}

class ManageItemsCubit extends Cubit<ManageItemsState> {
  ManageItemsCubit() : super(ManageItemsInitial());

  Future<List<MainCategory>> fetchItems() async {
    final firestore = FirebaseFirestore.instance;
    List<MainCategory> mainCategories = [];

    try {
      emit(ManageItemsLoading());

      // Fetch main categories in parallel
      final mainCategorySnapshots = await firestore.collection('items').get();

      // List to hold all category fetch futures
      List<Future> categoryFutures = [];

      for (var mainCategoryDoc in mainCategorySnapshots.docs) {
        // Fetch categories within each main category in parallel
        final categoryFuture = firestore
            .collection('items')
            .doc(mainCategoryDoc.id)
            .collection('categories')
            .get()
            .then((categorySnapshots) {
          List<MyCategory> categories = [];
          List<Future> itemFutures = [];

          for (var categoryDoc in categorySnapshots.docs) {
            final categoryData = categoryDoc.data();
            final category = MyCategory.fromMap({
              'id': categoryDoc.id,
              'category': categoryData['category'],
              'items': [],
            });

            // Fetch items within each category in parallel
            final itemFuture = firestore
                .collection('items')
                .doc(mainCategoryDoc.id)
                .collection('categories')
                .doc(categoryDoc.id)
                .collection('items')
                .get()
                .then((itemSnapshots) {
              List<Item> items = [];
              List<Future> subItemFutures = [];

              for (var itemDoc in itemSnapshots.docs) {
                final itemData = itemDoc.data();
                final item = Item.fromMap({
                  'id': itemDoc.id,
                  'imagePath': itemData['imagePath'],
                  'name': itemData['name'],
                  'subItems': [],
                });

                // Fetch sub-items within each item in parallel
                final subItemFuture = firestore
                    .collection('items')
                    .doc(mainCategoryDoc.id)
                    .collection('categories')
                    .doc(categoryDoc.id)
                    .collection('items')
                    .doc(itemDoc.id)
                    .collection('subItems')
                    .get()
                    .then((subItemSnapshots) {
                  final subItems = subItemSnapshots.docs
                      .map((subItemDoc) => SubItem.fromMap(subItemDoc.data()))
                      .toList();

                  item.subItems.addAll(subItems);
                });

                subItemFutures.add(subItemFuture);
                items.add(item);
              }

              return Future.wait(subItemFutures)
                  .then((_) => category.items.addAll(items));
            });

            itemFutures.add(itemFuture);
            categories.add(category);
          }

          return Future.wait(itemFutures).then((_) {
            final mainCategory = MainCategory(
              categories: categories,
              title: mainCategoryDoc.data()["title"],
            );
            mainCategories.add(mainCategory);
          });
        });

        categoryFutures.add(categoryFuture);
      }

      await Future.wait(categoryFutures);
      emit(ManageItemsSuccess(mainCategories: mainCategories));
    } catch (e) {
      
      emit(ManageItemsFailure());
    }

    return mainCategories;
  }

  // Future<List<MainCategory>> fetchItems() async {
  //   final firestore = FirebaseFirestore.instance;
  //   List<MainCategory> mainCategories = [];
  //   List<Category> categories = [];

  //   try {
  //     emit(ManageItemsLoading());
  //     // Fetch main categories
  //     final mainCategorySnapshots = await firestore.collection('items').get();

  //     for (var mainCategoryDoc in mainCategorySnapshots.docs) {
  //         categories = [];
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
  //       final mainCategory = MainCategory(
  //         categories: categories,
  //         title: mainCategoryDoc.data()["title"],
  //       );
  //       mainCategories.add(mainCategory);
  //     }
  //     emit(ManageItemsSuccess(mainCategories: mainCategories));
  //   } catch (e) {
  //     
  //   }

  //   return mainCategories;
  // }
}
