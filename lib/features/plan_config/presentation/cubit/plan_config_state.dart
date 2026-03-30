import 'package:equatable/equatable.dart';

import '../../../onboarding/domain/models/models.dart';

/// State for the plan configuration screen.
class PlanConfigState extends Equatable {
  const PlanConfigState({
    this.isLoading = true,
    this.dietType = DietType.omnivore,
    this.selectedAllergies = const {},
    this.excludedMeats = const {},
    this.freeDays = const {},
    this.dietStartDate,
    this.enabledMealTypes = const {
      MealType.breakfast,
      MealType.lunch,
      MealType.dinner,
      MealType.snack,
    },
    this.distinctBreakfasts = 2,
    this.distinctLunches = 3,
    this.distinctDinners = 3,
    this.distinctSnacks = 2,
    this.economicMode = false,
    this.errorMessage,
  });

  final bool isLoading;
  final DietType dietType;
  final Set<Allergy> selectedAllergies;
  final Set<ExcludedMeat> excludedMeats;
  final Set<int> freeDays;
  final DateTime? dietStartDate;
  final Set<MealType> enabledMealTypes;
  final int distinctBreakfasts;
  final int distinctLunches;
  final int distinctDinners;
  final int distinctSnacks;
  final bool economicMode;
  final String? errorMessage;

  @override
  List<Object?> get props => [
        isLoading,
        dietType,
        selectedAllergies,
        excludedMeats,
        freeDays,
        dietStartDate,
        enabledMealTypes,
        distinctBreakfasts,
        distinctLunches,
        distinctDinners,
        distinctSnacks,
        economicMode,
        errorMessage,
      ];

  int get dietDaysPerWeek => 7 - freeDays.length;

  PlanConfigState copyWith({
    bool? isLoading,
    DietType? dietType,
    Set<Allergy>? selectedAllergies,
    Set<ExcludedMeat>? excludedMeats,
    Set<int>? freeDays,
    DateTime? dietStartDate,
    Set<MealType>? enabledMealTypes,
    int? distinctBreakfasts,
    int? distinctLunches,
    int? distinctDinners,
    int? distinctSnacks,
    bool? economicMode,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return PlanConfigState(
      isLoading: isLoading ?? this.isLoading,
      dietType: dietType ?? this.dietType,
      selectedAllergies: selectedAllergies ?? this.selectedAllergies,
      excludedMeats: excludedMeats ?? this.excludedMeats,
      freeDays: freeDays ?? this.freeDays,
      dietStartDate: dietStartDate ?? this.dietStartDate,
      enabledMealTypes: enabledMealTypes ?? this.enabledMealTypes,
      distinctBreakfasts: distinctBreakfasts ?? this.distinctBreakfasts,
      distinctLunches: distinctLunches ?? this.distinctLunches,
      distinctDinners: distinctDinners ?? this.distinctDinners,
      distinctSnacks: distinctSnacks ?? this.distinctSnacks,
      economicMode: economicMode ?? this.economicMode,
      errorMessage:
          clearErrorMessage ? null : (errorMessage ?? this.errorMessage),
    );
  }
}
