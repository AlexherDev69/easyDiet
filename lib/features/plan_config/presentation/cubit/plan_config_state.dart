import '../../../onboarding/domain/models/models.dart';

/// State for the plan configuration screen.
class PlanConfigState {
  const PlanConfigState({
    this.isLoading = true,
    this.dietType = DietType.omnivore,
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
  });

  final bool isLoading;
  final DietType dietType;
  final Set<int> freeDays;
  final DateTime? dietStartDate;
  final Set<MealType> enabledMealTypes;
  final int distinctBreakfasts;
  final int distinctLunches;
  final int distinctDinners;
  final int distinctSnacks;

  int get dietDaysPerWeek => 7 - freeDays.length;

  PlanConfigState copyWith({
    bool? isLoading,
    DietType? dietType,
    Set<int>? freeDays,
    DateTime? dietStartDate,
    Set<MealType>? enabledMealTypes,
    int? distinctBreakfasts,
    int? distinctLunches,
    int? distinctDinners,
    int? distinctSnacks,
  }) {
    return PlanConfigState(
      isLoading: isLoading ?? this.isLoading,
      dietType: dietType ?? this.dietType,
      freeDays: freeDays ?? this.freeDays,
      dietStartDate: dietStartDate ?? this.dietStartDate,
      enabledMealTypes: enabledMealTypes ?? this.enabledMealTypes,
      distinctBreakfasts: distinctBreakfasts ?? this.distinctBreakfasts,
      distinctLunches: distinctLunches ?? this.distinctLunches,
      distinctDinners: distinctDinners ?? this.distinctDinners,
      distinctSnacks: distinctSnacks ?? this.distinctSnacks,
    );
  }
}
