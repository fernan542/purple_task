import 'package:hive/hive.dart';

import '../../constants/constants.dart';
import '../../entities/entities.dart';
import '../../models/models.dart';
import 'base_category_repository.dart';

class CategoryRepository extends BaseCategoryRepository {
  final _categoryBox = Hive.box<CategoryEntity>(categoryBox);
  final _categoriesOrderBox = Hive.box<List<String>>(categoriesListOrderBox);

  @override
  Future<Category> add({required Category category}) async {
    await _categoryBox.add(category.toEntity());
    final categoryListOrder = _categoriesOrderBox.get(categoriesListOrderKey);
    categoryListOrder?.add(category.id.toString());
    return category;
  }

  @override
  Future<Category> update({required Category category}) async {
    final key = _categoryBox.values
        .firstWhere((element) => element.id == category.id)
        .key;
    await _categoryBox.put(key, category.toEntity());
    return category;
  }

  @override
  Future<Category> remove({required Category category}) async {
    _categoriesOrderBox
        .get(categoriesListOrderKey)
        ?.remove(category.id.toString());
    await _categoryBox.values
        .firstWhere((element) => element.id == category.id)
        .delete();
    return category;
  }

  @override
  List<Category> getCategories() {
    final categoriesOrder = _categoriesOrderBox.get(categoriesListOrderKey);

    if (categoriesOrder == null || categoriesOrder.isEmpty) {
      _categoriesOrderBox.put(
        categoriesListOrderKey,
        _categoryBox.values.map((e) => e.id.toString()).toList(),
      );
    }

    return _categoryBox.values.map(Category.fromEntity).toList()
      ..sort(
        (a, b) {
          final order = _categoriesOrderBox.get(categoriesListOrderKey);

          if (order == null) {
            return a.id.compareTo(b.id);
          }

          return order
              .indexOf(a.id.toString())
              .compareTo(order.indexOf(b.id.toString()));
        },
      );
  }

  @override
  void reorder({
    required int oldIndex,
    required int newIndex,
  }) {
    final categoriesOrder =
        _categoriesOrderBox.get(categoriesListOrderKey, defaultValue: []);

    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final item = categoriesOrder!.removeAt(oldIndex);
    categoriesOrder.insert(newIndex, item);

    _categoriesOrderBox.put(categoriesListOrderKey, categoriesOrder);
  }
}
