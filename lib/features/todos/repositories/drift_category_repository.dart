import 'dart:ui';

import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purple_task/core/database/app_database.dart' as db;
import 'package:purple_task/core/helpers.dart';
import 'package:purple_task/features/todos/daos/category_dao.dart';
import 'package:purple_task/features/todos/models/category.dart';
import 'package:purple_task/features/todos/repositories/base_category_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'drift_category_repository.g.dart';

class DriftCategoryRepository implements BaseCategoryRepository {
  DriftCategoryRepository({required this.categoryDao});

  final CategoryDao categoryDao;

  @override
  Future<int> add({required Category category}) async =>
      categoryDao.addCategory(
        db.CategoriesCompanion(
          name: Value(category.name),
          color: Value(category.color.intValue),
          icon: Value(category.icon),
        ),
      );

  @override
  Future<List<Category>> getCategories() async {
    final categories = await categoryDao.getAllCategories();

    return categories
        .map(
          (e) => Category(
            id: e.id,
            name: e.name,
            color: Color(e.color),
            icon: e.icon,
            position: e.position,
          ),
        )
        .toList();
  }

  @override
  Future<void> remove({required int categoryId}) =>
      categoryDao.deleteCategory(categoryId);

  @override
  Future<void> reorder({required List<Category> categories}) async {
    final companions = categories
        .map(
          (category) => db.CategoriesCompanion(
            id: Value(category.id),
            name: Value(category.name),
            color: Value(category.color.intValue),
            icon: Value(category.icon),
            position: Value(category.position),
          ),
        )
        .toList();
    await categoryDao.updateCategoriesList(companions);
  }

  @override
  Future<void> update({required Category category}) async {
    await categoryDao.updateCategory(
      db.CategoriesCompanion(
        id: Value(category.id),
        name: Value(category.name),
        color: Value(category.color.intValue),
        icon: Value(category.icon),
      ),
    );
  }
}

@riverpod
CategoryDao categoryDao(Ref ref) {
  final database = ref.watch(db.appDatabaseProvider);
  return CategoryDao(database);
}

@riverpod
BaseCategoryRepository categoryRepository(Ref ref) {
  final dao = ref.watch(categoryDaoProvider);
  return DriftCategoryRepository(categoryDao: dao);
}
