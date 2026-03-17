import '../local/database.dart';
import '../local/daos/shopping_item_dao.dart';
import '../../features/shopping/domain/repositories/shopping_repository.dart';

class ShoppingRepositoryImpl implements ShoppingRepository {
  ShoppingRepositoryImpl(this._dao);

  final ShoppingItemDao _dao;

  @override
  Stream<List<ShoppingItem>> watchItemsForWeek(int weekPlanId) =>
      _dao.watchItemsForWeek(weekPlanId);

  @override
  Future<void> insertItems(List<ShoppingItemsCompanion> items) =>
      _dao.insertAll(items);

  @override
  Future<int> insertItem(ShoppingItemsCompanion item) => _dao.insertItem(item);

  @override
  Future<void> updateItem(ShoppingItem item) => _dao.updateItem(item);

  @override
  Future<void> updateChecked(int itemId, bool isChecked) =>
      _dao.updateChecked(itemId, isChecked);

  @override
  Future<void> uncheckAll(int weekPlanId) => _dao.uncheckAll(weekPlanId);

  @override
  Future<void> deleteItem(int itemId) => _dao.deleteItem(itemId);

  @override
  Future<void> deleteGeneratedItems(int weekPlanId) =>
      _dao.deleteGeneratedItems(weekPlanId);
}
