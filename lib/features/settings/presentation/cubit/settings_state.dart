import 'package:equatable/equatable.dart';

import '../../../onboarding/domain/models/models.dart';

/// State for the settings screen — port of SettingsUiState.
class SettingsState extends Equatable {
  const SettingsState({
    this.name = '',
    this.age = '',
    this.sex = Sex.male,
    this.heightCm = '',
    this.weightKg = '',
    this.targetWeightKg = '',
    this.lossPace = LossPace.moderate,
    this.activityLevel = ActivityLevel.sedentary,
    this.dietType = DietType.omnivore,
    this.freeDays = const {},
    this.batchCookingSessions = 1,
    this.shoppingTrips = 1,
    this.distinctBreakfasts = 2,
    this.distinctLunches = 3,
    this.distinctDinners = 3,
    this.distinctSnacks = 2,
    this.enabledMealTypes = const {
      MealType.breakfast,
      MealType.lunch,
      MealType.dinner,
      MealType.snack,
    },
    this.dietStartDate,
    this.batchCookingBeforeDiet = true,
    this.selectedAllergies = const {},
    this.excludedMeats = const {},
    this.customAllergies = '',
    this.economicMode = false,
    this.calculatedCalories = 0,
    this.calculatedWaterMl = 0,
    this.targetWeightError,
    this.showResetDialog = false,
    this.showRegenerateDialog = false,
    this.isSaved = false,
    this.isLoading = true,
  });

  final String name;
  final String age;
  final Sex sex;
  final String heightCm;
  final String weightKg;
  final String targetWeightKg;
  final LossPace lossPace;
  final ActivityLevel activityLevel;
  final DietType dietType;
  final Set<int> freeDays;
  final int batchCookingSessions;
  final int shoppingTrips;
  final int distinctBreakfasts;
  final int distinctLunches;
  final int distinctDinners;
  final int distinctSnacks;
  final Set<MealType> enabledMealTypes;
  final DateTime? dietStartDate;
  final bool batchCookingBeforeDiet;
  final Set<Allergy> selectedAllergies;
  final Set<ExcludedMeat> excludedMeats;
  final String customAllergies;
  final bool economicMode;
  final int calculatedCalories;
  final int calculatedWaterMl;
  final String? targetWeightError;
  final bool showResetDialog;
  final bool showRegenerateDialog;
  final bool isSaved;
  final bool isLoading;

  @override
  List<Object?> get props => [
        name,
        age,
        sex,
        heightCm,
        weightKg,
        targetWeightKg,
        lossPace,
        activityLevel,
        dietType,
        freeDays,
        batchCookingSessions,
        shoppingTrips,
        distinctBreakfasts,
        distinctLunches,
        distinctDinners,
        distinctSnacks,
        enabledMealTypes,
        dietStartDate,
        batchCookingBeforeDiet,
        selectedAllergies,
        excludedMeats,
        customAllergies,
        economicMode,
        calculatedCalories,
        calculatedWaterMl,
        targetWeightError,
        showResetDialog,
        showRegenerateDialog,
        isSaved,
        isLoading,
      ];

  int get dietDaysPerWeek => 7 - freeDays.length;

  SettingsState copyWith({
    String? name,
    String? age,
    Sex? sex,
    String? heightCm,
    String? weightKg,
    String? targetWeightKg,
    LossPace? lossPace,
    ActivityLevel? activityLevel,
    DietType? dietType,
    Set<int>? freeDays,
    int? batchCookingSessions,
    int? shoppingTrips,
    int? distinctBreakfasts,
    int? distinctLunches,
    int? distinctDinners,
    int? distinctSnacks,
    Set<MealType>? enabledMealTypes,
    DateTime? dietStartDate,
    bool? batchCookingBeforeDiet,
    Set<Allergy>? selectedAllergies,
    Set<ExcludedMeat>? excludedMeats,
    String? customAllergies,
    bool? economicMode,
    int? calculatedCalories,
    int? calculatedWaterMl,
    String? targetWeightError,
    bool clearTargetWeightError = false,
    bool? showResetDialog,
    bool? showRegenerateDialog,
    bool? isSaved,
    bool? isLoading,
  }) {
    return SettingsState(
      name: name ?? this.name,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      lossPace: lossPace ?? this.lossPace,
      activityLevel: activityLevel ?? this.activityLevel,
      dietType: dietType ?? this.dietType,
      freeDays: freeDays ?? this.freeDays,
      batchCookingSessions: batchCookingSessions ?? this.batchCookingSessions,
      shoppingTrips: shoppingTrips ?? this.shoppingTrips,
      distinctBreakfasts: distinctBreakfasts ?? this.distinctBreakfasts,
      distinctLunches: distinctLunches ?? this.distinctLunches,
      distinctDinners: distinctDinners ?? this.distinctDinners,
      distinctSnacks: distinctSnacks ?? this.distinctSnacks,
      enabledMealTypes: enabledMealTypes ?? this.enabledMealTypes,
      dietStartDate: dietStartDate ?? this.dietStartDate,
      batchCookingBeforeDiet:
          batchCookingBeforeDiet ?? this.batchCookingBeforeDiet,
      selectedAllergies: selectedAllergies ?? this.selectedAllergies,
      excludedMeats: excludedMeats ?? this.excludedMeats,
      customAllergies: customAllergies ?? this.customAllergies,
      economicMode: economicMode ?? this.economicMode,
      calculatedCalories: calculatedCalories ?? this.calculatedCalories,
      calculatedWaterMl: calculatedWaterMl ?? this.calculatedWaterMl,
      targetWeightError: clearTargetWeightError
          ? null
          : (targetWeightError ?? this.targetWeightError),
      showResetDialog: showResetDialog ?? this.showResetDialog,
      showRegenerateDialog:
          showRegenerateDialog ?? this.showRegenerateDialog,
      isSaved: isSaved ?? this.isSaved,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Tracks diet-related fields to detect changes requiring plan regeneration.
class DietFields extends Equatable {
  const DietFields({
    required this.dietType,
    required this.freeDays,
    required this.enabledMealTypes,
    required this.distinctBreakfasts,
    required this.distinctLunches,
    required this.distinctDinners,
    required this.distinctSnacks,
    required this.batchCookingSessions,
    required this.batchCookingBeforeDiet,
    required this.dietStartDate,
    required this.selectedAllergies,
    required this.excludedMeats,
    required this.customAllergies,
    required this.shoppingTrips,
    required this.economicMode,
  });

  final DietType dietType;
  final Set<int> freeDays;
  final Set<MealType> enabledMealTypes;
  final int distinctBreakfasts;
  final int distinctLunches;
  final int distinctDinners;
  final int distinctSnacks;
  final int batchCookingSessions;
  final bool batchCookingBeforeDiet;
  final DateTime? dietStartDate;
  final Set<Allergy> selectedAllergies;
  final Set<ExcludedMeat> excludedMeats;
  final String customAllergies;
  final int shoppingTrips;
  final bool economicMode;

  @override
  List<Object?> get props => [
        dietType,
        freeDays,
        enabledMealTypes,
        distinctBreakfasts,
        distinctLunches,
        distinctDinners,
        distinctSnacks,
        batchCookingSessions,
        batchCookingBeforeDiet,
        dietStartDate,
        selectedAllergies,
        excludedMeats,
        customAllergies,
        shoppingTrips,
        economicMode,
      ];
}

/// Extract diet fields from settings state for change detection.
DietFields extractDietFields(SettingsState state) => DietFields(
      dietType: state.dietType,
      freeDays: state.freeDays,
      enabledMealTypes: state.enabledMealTypes,
      distinctBreakfasts: state.distinctBreakfasts,
      distinctLunches: state.distinctLunches,
      distinctDinners: state.distinctDinners,
      distinctSnacks: state.distinctSnacks,
      batchCookingSessions: state.batchCookingSessions,
      batchCookingBeforeDiet: state.batchCookingBeforeDiet,
      dietStartDate: state.dietStartDate,
      selectedAllergies: state.selectedAllergies,
      excludedMeats: state.excludedMeats,
      customAllergies: state.customAllergies,
      shoppingTrips: state.shoppingTrips,
      economicMode: state.economicMode,
    );
