import '../../../../data/local/database.dart';

/// Interface for shopping list persistence.
abstract class ShoppingRepository {
  Stream<List<ShoppingItem>> watchItemsForWeek(int weekPlanId);
  Future<void> insertItems(List<ShoppingItemsCompanion> items);
  Future<int> insertItem(ShoppingItemsCompanion item);
  Future<void> updateItem(ShoppingItem item);
  Future<void> updateChecked(int itemId, bool isChecked);
  Future<void> uncheckAll(int weekPlanId);
  Future<void> deleteItem(int itemId);
  Future<void> deleteGeneratedItems(int weekPlanId);
}
