import 'package:equatable/equatable.dart';

import '../../../../data/local/database.dart';
import '../../domain/models/ingredient_source.dart';

/// UI state for the shopping list screen.
class ShoppingState extends Equatable {
  const ShoppingState({
    this.allItems = const [],
    this.items = const [],
    this.weekPlanId,
    this.isLoading = true,
    this.estimatedWeight = 0,
    this.selectedItemName,
    this.selectedItemQuantity,
    this.selectedItemSources,
    this.totalTrips = 1,
    this.selectedTrip = 1,
    this.tripDaySummaries = const {},
    this.collapsedSections = const {},
  });

  final List<ShoppingItem> allItems;
  final List<ShoppingItem> items;
  final int? weekPlanId;
  final bool isLoading;
  final double estimatedWeight;
  final String? selectedItemName;
  final String? selectedItemQuantity;
  final List<IngredientSource>? selectedItemSources;
  final int totalTrips;
  final int selectedTrip;
  final Map<int, String> tripDaySummaries;
  final Set<String> collapsedSections;

  @override
  List<Object?> get props => [
        allItems,
        items,
        weekPlanId,
        isLoading,
        estimatedWeight,
        selectedItemName,
        selectedItemQuantity,
        selectedItemSources,
        totalTrips,
        selectedTrip,
        tripDaySummaries,
        collapsedSections,
      ];

  ShoppingState copyWith({
    List<ShoppingItem>? allItems,
    List<ShoppingItem>? items,
    int? weekPlanId,
    bool? isLoading,
    double? estimatedWeight,
    String? selectedItemName,
    String? selectedItemQuantity,
    List<IngredientSource>? selectedItemSources,
    int? totalTrips,
    int? selectedTrip,
    Map<int, String>? tripDaySummaries,
    Set<String>? collapsedSections,
    bool clearItemDetail = false,
  }) {
    return ShoppingState(
      allItems: allItems ?? this.allItems,
      items: items ?? this.items,
      weekPlanId: weekPlanId ?? this.weekPlanId,
      isLoading: isLoading ?? this.isLoading,
      estimatedWeight: estimatedWeight ?? this.estimatedWeight,
      selectedItemName:
          clearItemDetail ? null : (selectedItemName ?? this.selectedItemName),
      selectedItemQuantity: clearItemDetail
          ? null
          : (selectedItemQuantity ?? this.selectedItemQuantity),
      selectedItemSources: clearItemDetail
          ? null
          : (selectedItemSources ?? this.selectedItemSources),
      totalTrips: totalTrips ?? this.totalTrips,
      selectedTrip: selectedTrip ?? this.selectedTrip,
      tripDaySummaries: tripDaySummaries ?? this.tripDaySummaries,
      collapsedSections: collapsedSections ?? this.collapsedSections,
    );
  }
}
