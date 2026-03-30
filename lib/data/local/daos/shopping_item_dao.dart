import 'package:drift/drift.dart';

import '../database.dart';
import '../tables/shopping_item_table.dart';

part 'shopping_item_dao.g.dart';

@DriftAccessor(tables: [ShoppingItems])
class ShoppingItemDao extends DatabaseAccessor<AppDatabase>
    with _$ShoppingItemDaoMixin {
  ShoppingItemDao(super.db);

  /// Watch shopping items for a week plan, ordered by section then name.
  Stream<List<ShoppingItem>> watchItemsForWeek(int weekPlanId) {
    return (select(shoppingItems)
          ..where((t) => t.weekPlanId.equals(weekPlanId))
          ..orderBy([
            (t) => OrderingTerm.asc(t.supermarketSection),
            (t) => OrderingTerm.asc(t.name),
          ]))
        .watch();
  }

  /// Insert multiple items.
  Future<void> insertAll(List<ShoppingItemsCompanion> items) {
    return batch((b) => b.insertAll(shoppingItems, items));
  }

  /// Insert a single item and return its ID.
  Future<int> insertItem(ShoppingItemsCompanion item) {
    return into(shoppingItems).insert(item);
  }

  /// Update a shopping item.
  Future<void> updateItem(ShoppingItem item) {
    return update(shoppingItems).replace(item);
  }

  /// Update checked status.
  Future<void> updateChecked(int itemId, bool isChecked) {
    return (update(shoppingItems)..where((t) => t.id.equals(itemId))).write(
      ShoppingItemsCompanion(isChecked: Value(isChecked)),
    );
  }

  /// Uncheck all items for a week plan.
  Future<void> uncheckAll(int weekPlanId) {
    return (update(shoppingItems)
          ..where((t) => t.weekPlanId.equals(weekPlanId)))
        .write(const ShoppingItemsCompanion(isChecked: Value(false)));
  }

  /// Delete a single item.
  Future<void> deleteItem(int itemId) {
    return (delete(shoppingItems)..where((t) => t.id.equals(itemId))).go();
  }

  /// Delete all generated (non-manual) items for a week plan.
  Future<void> deleteGeneratedItems(int weekPlanId) {
    return (delete(shoppingItems)
          ..where(
            (t) =>
                t.weekPlanId.equals(weekPlanId) &
                t.isManuallyAdded.equals(false),
          ))
        .go();
  }

  /// Get all generated (non-manual) items for a week plan.
  Future<List<ShoppingItem>> getGeneratedItemsForWeek(int weekPlanId) {
    return (select(shoppingItems)
          ..where(
            (t) =>
                t.weekPlanId.equals(weekPlanId) &
                t.isManuallyAdded.equals(false),
          ))
        .get();
  }

  /// Delete items by their IDs.
  Future<void> deleteItemsByIds(List<int> ids) {
    if (ids.isEmpty) return Future.value();
    return (delete(shoppingItems)..where((t) => t.id.isIn(ids))).go();
  }
}
