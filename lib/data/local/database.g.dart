// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $UserProfilesTable extends UserProfiles
    with TableInfo<$UserProfilesTable, UserProfile> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $UserProfilesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ageMeta = const VerificationMeta('age');
  @override
  late final GeneratedColumn<int> age = GeneratedColumn<int>(
    'age',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sexMeta = const VerificationMeta('sex');
  @override
  late final GeneratedColumn<String> sex = GeneratedColumn<String>(
    'sex',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _heightCmMeta = const VerificationMeta(
    'heightCm',
  );
  @override
  late final GeneratedColumn<int> heightCm = GeneratedColumn<int>(
    'height_cm',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _targetWeightKgMeta = const VerificationMeta(
    'targetWeightKg',
  );
  @override
  late final GeneratedColumn<double> targetWeightKg = GeneratedColumn<double>(
    'target_weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lossPaceMeta = const VerificationMeta(
    'lossPace',
  );
  @override
  late final GeneratedColumn<String> lossPace = GeneratedColumn<String>(
    'loss_pace',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activityLevelMeta = const VerificationMeta(
    'activityLevel',
  );
  @override
  late final GeneratedColumn<String> activityLevel = GeneratedColumn<String>(
    'activity_level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dietDaysPerWeekMeta = const VerificationMeta(
    'dietDaysPerWeek',
  );
  @override
  late final GeneratedColumn<int> dietDaysPerWeek = GeneratedColumn<int>(
    'diet_days_per_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _batchCookingSessionsPerWeekMeta =
      const VerificationMeta('batchCookingSessionsPerWeek');
  @override
  late final GeneratedColumn<int> batchCookingSessionsPerWeek =
      GeneratedColumn<int>(
        'batch_cooking_sessions_per_week',
        aliasedName,
        false,
        type: DriftSqlType.int,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _shoppingTripsPerWeekMeta =
      const VerificationMeta('shoppingTripsPerWeek');
  @override
  late final GeneratedColumn<int> shoppingTripsPerWeek = GeneratedColumn<int>(
    'shopping_trips_per_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dietTypeMeta = const VerificationMeta(
    'dietType',
  );
  @override
  late final GeneratedColumn<String> dietType = GeneratedColumn<String>(
    'diet_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('OMNIVORE'),
  );
  static const VerificationMeta _distinctBreakfastsMeta =
      const VerificationMeta('distinctBreakfasts');
  @override
  late final GeneratedColumn<int> distinctBreakfasts = GeneratedColumn<int>(
    'distinct_breakfasts',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _distinctLunchesMeta = const VerificationMeta(
    'distinctLunches',
  );
  @override
  late final GeneratedColumn<int> distinctLunches = GeneratedColumn<int>(
    'distinct_lunches',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _distinctDinnersMeta = const VerificationMeta(
    'distinctDinners',
  );
  @override
  late final GeneratedColumn<int> distinctDinners = GeneratedColumn<int>(
    'distinct_dinners',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(3),
  );
  static const VerificationMeta _distinctSnacksMeta = const VerificationMeta(
    'distinctSnacks',
  );
  @override
  late final GeneratedColumn<int> distinctSnacks = GeneratedColumn<int>(
    'distinct_snacks',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2),
  );
  static const VerificationMeta _allergiesMeta = const VerificationMeta(
    'allergies',
  );
  @override
  late final GeneratedColumn<String> allergies = GeneratedColumn<String>(
    'allergies',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _customAllergiesMeta = const VerificationMeta(
    'customAllergies',
  );
  @override
  late final GeneratedColumn<String> customAllergies = GeneratedColumn<String>(
    'custom_allergies',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dailyCalorieTargetMeta =
      const VerificationMeta('dailyCalorieTarget');
  @override
  late final GeneratedColumn<int> dailyCalorieTarget = GeneratedColumn<int>(
    'daily_calorie_target',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dailyWaterMlMeta = const VerificationMeta(
    'dailyWaterMl',
  );
  @override
  late final GeneratedColumn<int> dailyWaterMl = GeneratedColumn<int>(
    'daily_water_ml',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(2000),
  );
  static const VerificationMeta _enabledMealTypesMeta = const VerificationMeta(
    'enabledMealTypes',
  );
  @override
  late final GeneratedColumn<String> enabledMealTypes = GeneratedColumn<String>(
    'enabled_meal_types',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('["breakfast","lunch","dinner","snack"]'),
  );
  static const VerificationMeta _dietStartDateMeta = const VerificationMeta(
    'dietStartDate',
  );
  @override
  late final GeneratedColumn<int> dietStartDate = GeneratedColumn<int>(
    'diet_start_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _freeDaysMeta = const VerificationMeta(
    'freeDays',
  );
  @override
  late final GeneratedColumn<String> freeDays = GeneratedColumn<String>(
    'free_days',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _batchCookingBeforeDietMeta =
      const VerificationMeta('batchCookingBeforeDiet');
  @override
  late final GeneratedColumn<bool> batchCookingBeforeDiet =
      GeneratedColumn<bool>(
        'batch_cooking_before_diet',
        aliasedName,
        false,
        type: DriftSqlType.bool,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("batch_cooking_before_diet" IN (0, 1))',
        ),
        defaultValue: const Constant(true),
      );
  static const VerificationMeta _excludedMeatsMeta = const VerificationMeta(
    'excludedMeats',
  );
  @override
  late final GeneratedColumn<String> excludedMeats = GeneratedColumn<String>(
    'excluded_meats',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _economicModeMeta = const VerificationMeta(
    'economicMode',
  );
  @override
  late final GeneratedColumn<bool> economicMode = GeneratedColumn<bool>(
    'economic_mode',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("economic_mode" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _onboardingCompletedMeta =
      const VerificationMeta('onboardingCompleted');
  @override
  late final GeneratedColumn<bool> onboardingCompleted = GeneratedColumn<bool>(
    'onboarding_completed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarding_completed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    age,
    sex,
    heightCm,
    weightKg,
    targetWeightKg,
    lossPace,
    activityLevel,
    dietDaysPerWeek,
    batchCookingSessionsPerWeek,
    shoppingTripsPerWeek,
    dietType,
    distinctBreakfasts,
    distinctLunches,
    distinctDinners,
    distinctSnacks,
    allergies,
    customAllergies,
    dailyCalorieTarget,
    dailyWaterMl,
    enabledMealTypes,
    dietStartDate,
    freeDays,
    batchCookingBeforeDiet,
    excludedMeats,
    economicMode,
    onboardingCompleted,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'user_profiles';
  @override
  VerificationContext validateIntegrity(
    Insertable<UserProfile> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('age')) {
      context.handle(
        _ageMeta,
        age.isAcceptableOrUnknown(data['age']!, _ageMeta),
      );
    } else if (isInserting) {
      context.missing(_ageMeta);
    }
    if (data.containsKey('sex')) {
      context.handle(
        _sexMeta,
        sex.isAcceptableOrUnknown(data['sex']!, _sexMeta),
      );
    } else if (isInserting) {
      context.missing(_sexMeta);
    }
    if (data.containsKey('height_cm')) {
      context.handle(
        _heightCmMeta,
        heightCm.isAcceptableOrUnknown(data['height_cm']!, _heightCmMeta),
      );
    } else if (isInserting) {
      context.missing(_heightCmMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('target_weight_kg')) {
      context.handle(
        _targetWeightKgMeta,
        targetWeightKg.isAcceptableOrUnknown(
          data['target_weight_kg']!,
          _targetWeightKgMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_targetWeightKgMeta);
    }
    if (data.containsKey('loss_pace')) {
      context.handle(
        _lossPaceMeta,
        lossPace.isAcceptableOrUnknown(data['loss_pace']!, _lossPaceMeta),
      );
    } else if (isInserting) {
      context.missing(_lossPaceMeta);
    }
    if (data.containsKey('activity_level')) {
      context.handle(
        _activityLevelMeta,
        activityLevel.isAcceptableOrUnknown(
          data['activity_level']!,
          _activityLevelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_activityLevelMeta);
    }
    if (data.containsKey('diet_days_per_week')) {
      context.handle(
        _dietDaysPerWeekMeta,
        dietDaysPerWeek.isAcceptableOrUnknown(
          data['diet_days_per_week']!,
          _dietDaysPerWeekMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dietDaysPerWeekMeta);
    }
    if (data.containsKey('batch_cooking_sessions_per_week')) {
      context.handle(
        _batchCookingSessionsPerWeekMeta,
        batchCookingSessionsPerWeek.isAcceptableOrUnknown(
          data['batch_cooking_sessions_per_week']!,
          _batchCookingSessionsPerWeekMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_batchCookingSessionsPerWeekMeta);
    }
    if (data.containsKey('shopping_trips_per_week')) {
      context.handle(
        _shoppingTripsPerWeekMeta,
        shoppingTripsPerWeek.isAcceptableOrUnknown(
          data['shopping_trips_per_week']!,
          _shoppingTripsPerWeekMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_shoppingTripsPerWeekMeta);
    }
    if (data.containsKey('diet_type')) {
      context.handle(
        _dietTypeMeta,
        dietType.isAcceptableOrUnknown(data['diet_type']!, _dietTypeMeta),
      );
    }
    if (data.containsKey('distinct_breakfasts')) {
      context.handle(
        _distinctBreakfastsMeta,
        distinctBreakfasts.isAcceptableOrUnknown(
          data['distinct_breakfasts']!,
          _distinctBreakfastsMeta,
        ),
      );
    }
    if (data.containsKey('distinct_lunches')) {
      context.handle(
        _distinctLunchesMeta,
        distinctLunches.isAcceptableOrUnknown(
          data['distinct_lunches']!,
          _distinctLunchesMeta,
        ),
      );
    }
    if (data.containsKey('distinct_dinners')) {
      context.handle(
        _distinctDinnersMeta,
        distinctDinners.isAcceptableOrUnknown(
          data['distinct_dinners']!,
          _distinctDinnersMeta,
        ),
      );
    }
    if (data.containsKey('distinct_snacks')) {
      context.handle(
        _distinctSnacksMeta,
        distinctSnacks.isAcceptableOrUnknown(
          data['distinct_snacks']!,
          _distinctSnacksMeta,
        ),
      );
    }
    if (data.containsKey('allergies')) {
      context.handle(
        _allergiesMeta,
        allergies.isAcceptableOrUnknown(data['allergies']!, _allergiesMeta),
      );
    } else if (isInserting) {
      context.missing(_allergiesMeta);
    }
    if (data.containsKey('custom_allergies')) {
      context.handle(
        _customAllergiesMeta,
        customAllergies.isAcceptableOrUnknown(
          data['custom_allergies']!,
          _customAllergiesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_customAllergiesMeta);
    }
    if (data.containsKey('daily_calorie_target')) {
      context.handle(
        _dailyCalorieTargetMeta,
        dailyCalorieTarget.isAcceptableOrUnknown(
          data['daily_calorie_target']!,
          _dailyCalorieTargetMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dailyCalorieTargetMeta);
    }
    if (data.containsKey('daily_water_ml')) {
      context.handle(
        _dailyWaterMlMeta,
        dailyWaterMl.isAcceptableOrUnknown(
          data['daily_water_ml']!,
          _dailyWaterMlMeta,
        ),
      );
    }
    if (data.containsKey('enabled_meal_types')) {
      context.handle(
        _enabledMealTypesMeta,
        enabledMealTypes.isAcceptableOrUnknown(
          data['enabled_meal_types']!,
          _enabledMealTypesMeta,
        ),
      );
    }
    if (data.containsKey('diet_start_date')) {
      context.handle(
        _dietStartDateMeta,
        dietStartDate.isAcceptableOrUnknown(
          data['diet_start_date']!,
          _dietStartDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_dietStartDateMeta);
    }
    if (data.containsKey('free_days')) {
      context.handle(
        _freeDaysMeta,
        freeDays.isAcceptableOrUnknown(data['free_days']!, _freeDaysMeta),
      );
    }
    if (data.containsKey('batch_cooking_before_diet')) {
      context.handle(
        _batchCookingBeforeDietMeta,
        batchCookingBeforeDiet.isAcceptableOrUnknown(
          data['batch_cooking_before_diet']!,
          _batchCookingBeforeDietMeta,
        ),
      );
    }
    if (data.containsKey('excluded_meats')) {
      context.handle(
        _excludedMeatsMeta,
        excludedMeats.isAcceptableOrUnknown(
          data['excluded_meats']!,
          _excludedMeatsMeta,
        ),
      );
    }
    if (data.containsKey('economic_mode')) {
      context.handle(
        _economicModeMeta,
        economicMode.isAcceptableOrUnknown(
          data['economic_mode']!,
          _economicModeMeta,
        ),
      );
    }
    if (data.containsKey('onboarding_completed')) {
      context.handle(
        _onboardingCompletedMeta,
        onboardingCompleted.isAcceptableOrUnknown(
          data['onboarding_completed']!,
          _onboardingCompletedMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  UserProfile map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return UserProfile(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      age: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}age'],
      )!,
      sex: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sex'],
      )!,
      heightCm: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}height_cm'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      targetWeightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}target_weight_kg'],
      )!,
      lossPace: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}loss_pace'],
      )!,
      activityLevel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}activity_level'],
      )!,
      dietDaysPerWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diet_days_per_week'],
      )!,
      batchCookingSessionsPerWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}batch_cooking_sessions_per_week'],
      )!,
      shoppingTripsPerWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}shopping_trips_per_week'],
      )!,
      dietType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diet_type'],
      )!,
      distinctBreakfasts: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}distinct_breakfasts'],
      )!,
      distinctLunches: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}distinct_lunches'],
      )!,
      distinctDinners: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}distinct_dinners'],
      )!,
      distinctSnacks: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}distinct_snacks'],
      )!,
      allergies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergies'],
      )!,
      customAllergies: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}custom_allergies'],
      )!,
      dailyCalorieTarget: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_calorie_target'],
      )!,
      dailyWaterMl: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_water_ml'],
      )!,
      enabledMealTypes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}enabled_meal_types'],
      )!,
      dietStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}diet_start_date'],
      )!,
      freeDays: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}free_days'],
      )!,
      batchCookingBeforeDiet: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}batch_cooking_before_diet'],
      )!,
      excludedMeats: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}excluded_meats'],
      )!,
      economicMode: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}economic_mode'],
      )!,
      onboardingCompleted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarding_completed'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $UserProfilesTable createAlias(String alias) {
    return $UserProfilesTable(attachedDatabase, alias);
  }
}

class UserProfile extends DataClass implements Insertable<UserProfile> {
  final int id;
  final String name;
  final int age;
  final String sex;
  final int heightCm;
  final double weightKg;
  final double targetWeightKg;
  final String lossPace;
  final String activityLevel;
  final int dietDaysPerWeek;
  final int batchCookingSessionsPerWeek;
  final int shoppingTripsPerWeek;
  final String dietType;
  final int distinctBreakfasts;
  final int distinctLunches;
  final int distinctDinners;
  final int distinctSnacks;
  final String allergies;
  final String customAllergies;
  final int dailyCalorieTarget;
  final int dailyWaterMl;
  final String enabledMealTypes;
  final int dietStartDate;
  final String freeDays;
  final bool batchCookingBeforeDiet;
  final String excludedMeats;
  final bool economicMode;
  final bool onboardingCompleted;
  final int createdAt;
  const UserProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.sex,
    required this.heightCm,
    required this.weightKg,
    required this.targetWeightKg,
    required this.lossPace,
    required this.activityLevel,
    required this.dietDaysPerWeek,
    required this.batchCookingSessionsPerWeek,
    required this.shoppingTripsPerWeek,
    required this.dietType,
    required this.distinctBreakfasts,
    required this.distinctLunches,
    required this.distinctDinners,
    required this.distinctSnacks,
    required this.allergies,
    required this.customAllergies,
    required this.dailyCalorieTarget,
    required this.dailyWaterMl,
    required this.enabledMealTypes,
    required this.dietStartDate,
    required this.freeDays,
    required this.batchCookingBeforeDiet,
    required this.excludedMeats,
    required this.economicMode,
    required this.onboardingCompleted,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['age'] = Variable<int>(age);
    map['sex'] = Variable<String>(sex);
    map['height_cm'] = Variable<int>(heightCm);
    map['weight_kg'] = Variable<double>(weightKg);
    map['target_weight_kg'] = Variable<double>(targetWeightKg);
    map['loss_pace'] = Variable<String>(lossPace);
    map['activity_level'] = Variable<String>(activityLevel);
    map['diet_days_per_week'] = Variable<int>(dietDaysPerWeek);
    map['batch_cooking_sessions_per_week'] = Variable<int>(
      batchCookingSessionsPerWeek,
    );
    map['shopping_trips_per_week'] = Variable<int>(shoppingTripsPerWeek);
    map['diet_type'] = Variable<String>(dietType);
    map['distinct_breakfasts'] = Variable<int>(distinctBreakfasts);
    map['distinct_lunches'] = Variable<int>(distinctLunches);
    map['distinct_dinners'] = Variable<int>(distinctDinners);
    map['distinct_snacks'] = Variable<int>(distinctSnacks);
    map['allergies'] = Variable<String>(allergies);
    map['custom_allergies'] = Variable<String>(customAllergies);
    map['daily_calorie_target'] = Variable<int>(dailyCalorieTarget);
    map['daily_water_ml'] = Variable<int>(dailyWaterMl);
    map['enabled_meal_types'] = Variable<String>(enabledMealTypes);
    map['diet_start_date'] = Variable<int>(dietStartDate);
    map['free_days'] = Variable<String>(freeDays);
    map['batch_cooking_before_diet'] = Variable<bool>(batchCookingBeforeDiet);
    map['excluded_meats'] = Variable<String>(excludedMeats);
    map['economic_mode'] = Variable<bool>(economicMode);
    map['onboarding_completed'] = Variable<bool>(onboardingCompleted);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  UserProfilesCompanion toCompanion(bool nullToAbsent) {
    return UserProfilesCompanion(
      id: Value(id),
      name: Value(name),
      age: Value(age),
      sex: Value(sex),
      heightCm: Value(heightCm),
      weightKg: Value(weightKg),
      targetWeightKg: Value(targetWeightKg),
      lossPace: Value(lossPace),
      activityLevel: Value(activityLevel),
      dietDaysPerWeek: Value(dietDaysPerWeek),
      batchCookingSessionsPerWeek: Value(batchCookingSessionsPerWeek),
      shoppingTripsPerWeek: Value(shoppingTripsPerWeek),
      dietType: Value(dietType),
      distinctBreakfasts: Value(distinctBreakfasts),
      distinctLunches: Value(distinctLunches),
      distinctDinners: Value(distinctDinners),
      distinctSnacks: Value(distinctSnacks),
      allergies: Value(allergies),
      customAllergies: Value(customAllergies),
      dailyCalorieTarget: Value(dailyCalorieTarget),
      dailyWaterMl: Value(dailyWaterMl),
      enabledMealTypes: Value(enabledMealTypes),
      dietStartDate: Value(dietStartDate),
      freeDays: Value(freeDays),
      batchCookingBeforeDiet: Value(batchCookingBeforeDiet),
      excludedMeats: Value(excludedMeats),
      economicMode: Value(economicMode),
      onboardingCompleted: Value(onboardingCompleted),
      createdAt: Value(createdAt),
    );
  }

  factory UserProfile.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return UserProfile(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      age: serializer.fromJson<int>(json['age']),
      sex: serializer.fromJson<String>(json['sex']),
      heightCm: serializer.fromJson<int>(json['heightCm']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      targetWeightKg: serializer.fromJson<double>(json['targetWeightKg']),
      lossPace: serializer.fromJson<String>(json['lossPace']),
      activityLevel: serializer.fromJson<String>(json['activityLevel']),
      dietDaysPerWeek: serializer.fromJson<int>(json['dietDaysPerWeek']),
      batchCookingSessionsPerWeek: serializer.fromJson<int>(
        json['batchCookingSessionsPerWeek'],
      ),
      shoppingTripsPerWeek: serializer.fromJson<int>(
        json['shoppingTripsPerWeek'],
      ),
      dietType: serializer.fromJson<String>(json['dietType']),
      distinctBreakfasts: serializer.fromJson<int>(json['distinctBreakfasts']),
      distinctLunches: serializer.fromJson<int>(json['distinctLunches']),
      distinctDinners: serializer.fromJson<int>(json['distinctDinners']),
      distinctSnacks: serializer.fromJson<int>(json['distinctSnacks']),
      allergies: serializer.fromJson<String>(json['allergies']),
      customAllergies: serializer.fromJson<String>(json['customAllergies']),
      dailyCalorieTarget: serializer.fromJson<int>(json['dailyCalorieTarget']),
      dailyWaterMl: serializer.fromJson<int>(json['dailyWaterMl']),
      enabledMealTypes: serializer.fromJson<String>(json['enabledMealTypes']),
      dietStartDate: serializer.fromJson<int>(json['dietStartDate']),
      freeDays: serializer.fromJson<String>(json['freeDays']),
      batchCookingBeforeDiet: serializer.fromJson<bool>(
        json['batchCookingBeforeDiet'],
      ),
      excludedMeats: serializer.fromJson<String>(json['excludedMeats']),
      economicMode: serializer.fromJson<bool>(json['economicMode']),
      onboardingCompleted: serializer.fromJson<bool>(
        json['onboardingCompleted'],
      ),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'age': serializer.toJson<int>(age),
      'sex': serializer.toJson<String>(sex),
      'heightCm': serializer.toJson<int>(heightCm),
      'weightKg': serializer.toJson<double>(weightKg),
      'targetWeightKg': serializer.toJson<double>(targetWeightKg),
      'lossPace': serializer.toJson<String>(lossPace),
      'activityLevel': serializer.toJson<String>(activityLevel),
      'dietDaysPerWeek': serializer.toJson<int>(dietDaysPerWeek),
      'batchCookingSessionsPerWeek': serializer.toJson<int>(
        batchCookingSessionsPerWeek,
      ),
      'shoppingTripsPerWeek': serializer.toJson<int>(shoppingTripsPerWeek),
      'dietType': serializer.toJson<String>(dietType),
      'distinctBreakfasts': serializer.toJson<int>(distinctBreakfasts),
      'distinctLunches': serializer.toJson<int>(distinctLunches),
      'distinctDinners': serializer.toJson<int>(distinctDinners),
      'distinctSnacks': serializer.toJson<int>(distinctSnacks),
      'allergies': serializer.toJson<String>(allergies),
      'customAllergies': serializer.toJson<String>(customAllergies),
      'dailyCalorieTarget': serializer.toJson<int>(dailyCalorieTarget),
      'dailyWaterMl': serializer.toJson<int>(dailyWaterMl),
      'enabledMealTypes': serializer.toJson<String>(enabledMealTypes),
      'dietStartDate': serializer.toJson<int>(dietStartDate),
      'freeDays': serializer.toJson<String>(freeDays),
      'batchCookingBeforeDiet': serializer.toJson<bool>(batchCookingBeforeDiet),
      'excludedMeats': serializer.toJson<String>(excludedMeats),
      'economicMode': serializer.toJson<bool>(economicMode),
      'onboardingCompleted': serializer.toJson<bool>(onboardingCompleted),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  UserProfile copyWith({
    int? id,
    String? name,
    int? age,
    String? sex,
    int? heightCm,
    double? weightKg,
    double? targetWeightKg,
    String? lossPace,
    String? activityLevel,
    int? dietDaysPerWeek,
    int? batchCookingSessionsPerWeek,
    int? shoppingTripsPerWeek,
    String? dietType,
    int? distinctBreakfasts,
    int? distinctLunches,
    int? distinctDinners,
    int? distinctSnacks,
    String? allergies,
    String? customAllergies,
    int? dailyCalorieTarget,
    int? dailyWaterMl,
    String? enabledMealTypes,
    int? dietStartDate,
    String? freeDays,
    bool? batchCookingBeforeDiet,
    String? excludedMeats,
    bool? economicMode,
    bool? onboardingCompleted,
    int? createdAt,
  }) => UserProfile(
    id: id ?? this.id,
    name: name ?? this.name,
    age: age ?? this.age,
    sex: sex ?? this.sex,
    heightCm: heightCm ?? this.heightCm,
    weightKg: weightKg ?? this.weightKg,
    targetWeightKg: targetWeightKg ?? this.targetWeightKg,
    lossPace: lossPace ?? this.lossPace,
    activityLevel: activityLevel ?? this.activityLevel,
    dietDaysPerWeek: dietDaysPerWeek ?? this.dietDaysPerWeek,
    batchCookingSessionsPerWeek:
        batchCookingSessionsPerWeek ?? this.batchCookingSessionsPerWeek,
    shoppingTripsPerWeek: shoppingTripsPerWeek ?? this.shoppingTripsPerWeek,
    dietType: dietType ?? this.dietType,
    distinctBreakfasts: distinctBreakfasts ?? this.distinctBreakfasts,
    distinctLunches: distinctLunches ?? this.distinctLunches,
    distinctDinners: distinctDinners ?? this.distinctDinners,
    distinctSnacks: distinctSnacks ?? this.distinctSnacks,
    allergies: allergies ?? this.allergies,
    customAllergies: customAllergies ?? this.customAllergies,
    dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
    dailyWaterMl: dailyWaterMl ?? this.dailyWaterMl,
    enabledMealTypes: enabledMealTypes ?? this.enabledMealTypes,
    dietStartDate: dietStartDate ?? this.dietStartDate,
    freeDays: freeDays ?? this.freeDays,
    batchCookingBeforeDiet:
        batchCookingBeforeDiet ?? this.batchCookingBeforeDiet,
    excludedMeats: excludedMeats ?? this.excludedMeats,
    economicMode: economicMode ?? this.economicMode,
    onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
    createdAt: createdAt ?? this.createdAt,
  );
  UserProfile copyWithCompanion(UserProfilesCompanion data) {
    return UserProfile(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      age: data.age.present ? data.age.value : this.age,
      sex: data.sex.present ? data.sex.value : this.sex,
      heightCm: data.heightCm.present ? data.heightCm.value : this.heightCm,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      targetWeightKg: data.targetWeightKg.present
          ? data.targetWeightKg.value
          : this.targetWeightKg,
      lossPace: data.lossPace.present ? data.lossPace.value : this.lossPace,
      activityLevel: data.activityLevel.present
          ? data.activityLevel.value
          : this.activityLevel,
      dietDaysPerWeek: data.dietDaysPerWeek.present
          ? data.dietDaysPerWeek.value
          : this.dietDaysPerWeek,
      batchCookingSessionsPerWeek: data.batchCookingSessionsPerWeek.present
          ? data.batchCookingSessionsPerWeek.value
          : this.batchCookingSessionsPerWeek,
      shoppingTripsPerWeek: data.shoppingTripsPerWeek.present
          ? data.shoppingTripsPerWeek.value
          : this.shoppingTripsPerWeek,
      dietType: data.dietType.present ? data.dietType.value : this.dietType,
      distinctBreakfasts: data.distinctBreakfasts.present
          ? data.distinctBreakfasts.value
          : this.distinctBreakfasts,
      distinctLunches: data.distinctLunches.present
          ? data.distinctLunches.value
          : this.distinctLunches,
      distinctDinners: data.distinctDinners.present
          ? data.distinctDinners.value
          : this.distinctDinners,
      distinctSnacks: data.distinctSnacks.present
          ? data.distinctSnacks.value
          : this.distinctSnacks,
      allergies: data.allergies.present ? data.allergies.value : this.allergies,
      customAllergies: data.customAllergies.present
          ? data.customAllergies.value
          : this.customAllergies,
      dailyCalorieTarget: data.dailyCalorieTarget.present
          ? data.dailyCalorieTarget.value
          : this.dailyCalorieTarget,
      dailyWaterMl: data.dailyWaterMl.present
          ? data.dailyWaterMl.value
          : this.dailyWaterMl,
      enabledMealTypes: data.enabledMealTypes.present
          ? data.enabledMealTypes.value
          : this.enabledMealTypes,
      dietStartDate: data.dietStartDate.present
          ? data.dietStartDate.value
          : this.dietStartDate,
      freeDays: data.freeDays.present ? data.freeDays.value : this.freeDays,
      batchCookingBeforeDiet: data.batchCookingBeforeDiet.present
          ? data.batchCookingBeforeDiet.value
          : this.batchCookingBeforeDiet,
      excludedMeats: data.excludedMeats.present
          ? data.excludedMeats.value
          : this.excludedMeats,
      economicMode: data.economicMode.present
          ? data.economicMode.value
          : this.economicMode,
      onboardingCompleted: data.onboardingCompleted.present
          ? data.onboardingCompleted.value
          : this.onboardingCompleted,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('UserProfile(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('sex: $sex, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('lossPace: $lossPace, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('dietDaysPerWeek: $dietDaysPerWeek, ')
          ..write('batchCookingSessionsPerWeek: $batchCookingSessionsPerWeek, ')
          ..write('shoppingTripsPerWeek: $shoppingTripsPerWeek, ')
          ..write('dietType: $dietType, ')
          ..write('distinctBreakfasts: $distinctBreakfasts, ')
          ..write('distinctLunches: $distinctLunches, ')
          ..write('distinctDinners: $distinctDinners, ')
          ..write('distinctSnacks: $distinctSnacks, ')
          ..write('allergies: $allergies, ')
          ..write('customAllergies: $customAllergies, ')
          ..write('dailyCalorieTarget: $dailyCalorieTarget, ')
          ..write('dailyWaterMl: $dailyWaterMl, ')
          ..write('enabledMealTypes: $enabledMealTypes, ')
          ..write('dietStartDate: $dietStartDate, ')
          ..write('freeDays: $freeDays, ')
          ..write('batchCookingBeforeDiet: $batchCookingBeforeDiet, ')
          ..write('excludedMeats: $excludedMeats, ')
          ..write('economicMode: $economicMode, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hashAll([
    id,
    name,
    age,
    sex,
    heightCm,
    weightKg,
    targetWeightKg,
    lossPace,
    activityLevel,
    dietDaysPerWeek,
    batchCookingSessionsPerWeek,
    shoppingTripsPerWeek,
    dietType,
    distinctBreakfasts,
    distinctLunches,
    distinctDinners,
    distinctSnacks,
    allergies,
    customAllergies,
    dailyCalorieTarget,
    dailyWaterMl,
    enabledMealTypes,
    dietStartDate,
    freeDays,
    batchCookingBeforeDiet,
    excludedMeats,
    economicMode,
    onboardingCompleted,
    createdAt,
  ]);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is UserProfile &&
          other.id == this.id &&
          other.name == this.name &&
          other.age == this.age &&
          other.sex == this.sex &&
          other.heightCm == this.heightCm &&
          other.weightKg == this.weightKg &&
          other.targetWeightKg == this.targetWeightKg &&
          other.lossPace == this.lossPace &&
          other.activityLevel == this.activityLevel &&
          other.dietDaysPerWeek == this.dietDaysPerWeek &&
          other.batchCookingSessionsPerWeek ==
              this.batchCookingSessionsPerWeek &&
          other.shoppingTripsPerWeek == this.shoppingTripsPerWeek &&
          other.dietType == this.dietType &&
          other.distinctBreakfasts == this.distinctBreakfasts &&
          other.distinctLunches == this.distinctLunches &&
          other.distinctDinners == this.distinctDinners &&
          other.distinctSnacks == this.distinctSnacks &&
          other.allergies == this.allergies &&
          other.customAllergies == this.customAllergies &&
          other.dailyCalorieTarget == this.dailyCalorieTarget &&
          other.dailyWaterMl == this.dailyWaterMl &&
          other.enabledMealTypes == this.enabledMealTypes &&
          other.dietStartDate == this.dietStartDate &&
          other.freeDays == this.freeDays &&
          other.batchCookingBeforeDiet == this.batchCookingBeforeDiet &&
          other.excludedMeats == this.excludedMeats &&
          other.economicMode == this.economicMode &&
          other.onboardingCompleted == this.onboardingCompleted &&
          other.createdAt == this.createdAt);
}

class UserProfilesCompanion extends UpdateCompanion<UserProfile> {
  final Value<int> id;
  final Value<String> name;
  final Value<int> age;
  final Value<String> sex;
  final Value<int> heightCm;
  final Value<double> weightKg;
  final Value<double> targetWeightKg;
  final Value<String> lossPace;
  final Value<String> activityLevel;
  final Value<int> dietDaysPerWeek;
  final Value<int> batchCookingSessionsPerWeek;
  final Value<int> shoppingTripsPerWeek;
  final Value<String> dietType;
  final Value<int> distinctBreakfasts;
  final Value<int> distinctLunches;
  final Value<int> distinctDinners;
  final Value<int> distinctSnacks;
  final Value<String> allergies;
  final Value<String> customAllergies;
  final Value<int> dailyCalorieTarget;
  final Value<int> dailyWaterMl;
  final Value<String> enabledMealTypes;
  final Value<int> dietStartDate;
  final Value<String> freeDays;
  final Value<bool> batchCookingBeforeDiet;
  final Value<String> excludedMeats;
  final Value<bool> economicMode;
  final Value<bool> onboardingCompleted;
  final Value<int> createdAt;
  const UserProfilesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.age = const Value.absent(),
    this.sex = const Value.absent(),
    this.heightCm = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.targetWeightKg = const Value.absent(),
    this.lossPace = const Value.absent(),
    this.activityLevel = const Value.absent(),
    this.dietDaysPerWeek = const Value.absent(),
    this.batchCookingSessionsPerWeek = const Value.absent(),
    this.shoppingTripsPerWeek = const Value.absent(),
    this.dietType = const Value.absent(),
    this.distinctBreakfasts = const Value.absent(),
    this.distinctLunches = const Value.absent(),
    this.distinctDinners = const Value.absent(),
    this.distinctSnacks = const Value.absent(),
    this.allergies = const Value.absent(),
    this.customAllergies = const Value.absent(),
    this.dailyCalorieTarget = const Value.absent(),
    this.dailyWaterMl = const Value.absent(),
    this.enabledMealTypes = const Value.absent(),
    this.dietStartDate = const Value.absent(),
    this.freeDays = const Value.absent(),
    this.batchCookingBeforeDiet = const Value.absent(),
    this.excludedMeats = const Value.absent(),
    this.economicMode = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  UserProfilesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required int age,
    required String sex,
    required int heightCm,
    required double weightKg,
    required double targetWeightKg,
    required String lossPace,
    required String activityLevel,
    required int dietDaysPerWeek,
    required int batchCookingSessionsPerWeek,
    required int shoppingTripsPerWeek,
    this.dietType = const Value.absent(),
    this.distinctBreakfasts = const Value.absent(),
    this.distinctLunches = const Value.absent(),
    this.distinctDinners = const Value.absent(),
    this.distinctSnacks = const Value.absent(),
    required String allergies,
    required String customAllergies,
    required int dailyCalorieTarget,
    this.dailyWaterMl = const Value.absent(),
    this.enabledMealTypes = const Value.absent(),
    required int dietStartDate,
    this.freeDays = const Value.absent(),
    this.batchCookingBeforeDiet = const Value.absent(),
    this.excludedMeats = const Value.absent(),
    this.economicMode = const Value.absent(),
    this.onboardingCompleted = const Value.absent(),
    required int createdAt,
  }) : name = Value(name),
       age = Value(age),
       sex = Value(sex),
       heightCm = Value(heightCm),
       weightKg = Value(weightKg),
       targetWeightKg = Value(targetWeightKg),
       lossPace = Value(lossPace),
       activityLevel = Value(activityLevel),
       dietDaysPerWeek = Value(dietDaysPerWeek),
       batchCookingSessionsPerWeek = Value(batchCookingSessionsPerWeek),
       shoppingTripsPerWeek = Value(shoppingTripsPerWeek),
       allergies = Value(allergies),
       customAllergies = Value(customAllergies),
       dailyCalorieTarget = Value(dailyCalorieTarget),
       dietStartDate = Value(dietStartDate),
       createdAt = Value(createdAt);
  static Insertable<UserProfile> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<int>? age,
    Expression<String>? sex,
    Expression<int>? heightCm,
    Expression<double>? weightKg,
    Expression<double>? targetWeightKg,
    Expression<String>? lossPace,
    Expression<String>? activityLevel,
    Expression<int>? dietDaysPerWeek,
    Expression<int>? batchCookingSessionsPerWeek,
    Expression<int>? shoppingTripsPerWeek,
    Expression<String>? dietType,
    Expression<int>? distinctBreakfasts,
    Expression<int>? distinctLunches,
    Expression<int>? distinctDinners,
    Expression<int>? distinctSnacks,
    Expression<String>? allergies,
    Expression<String>? customAllergies,
    Expression<int>? dailyCalorieTarget,
    Expression<int>? dailyWaterMl,
    Expression<String>? enabledMealTypes,
    Expression<int>? dietStartDate,
    Expression<String>? freeDays,
    Expression<bool>? batchCookingBeforeDiet,
    Expression<String>? excludedMeats,
    Expression<bool>? economicMode,
    Expression<bool>? onboardingCompleted,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (age != null) 'age': age,
      if (sex != null) 'sex': sex,
      if (heightCm != null) 'height_cm': heightCm,
      if (weightKg != null) 'weight_kg': weightKg,
      if (targetWeightKg != null) 'target_weight_kg': targetWeightKg,
      if (lossPace != null) 'loss_pace': lossPace,
      if (activityLevel != null) 'activity_level': activityLevel,
      if (dietDaysPerWeek != null) 'diet_days_per_week': dietDaysPerWeek,
      if (batchCookingSessionsPerWeek != null)
        'batch_cooking_sessions_per_week': batchCookingSessionsPerWeek,
      if (shoppingTripsPerWeek != null)
        'shopping_trips_per_week': shoppingTripsPerWeek,
      if (dietType != null) 'diet_type': dietType,
      if (distinctBreakfasts != null) 'distinct_breakfasts': distinctBreakfasts,
      if (distinctLunches != null) 'distinct_lunches': distinctLunches,
      if (distinctDinners != null) 'distinct_dinners': distinctDinners,
      if (distinctSnacks != null) 'distinct_snacks': distinctSnacks,
      if (allergies != null) 'allergies': allergies,
      if (customAllergies != null) 'custom_allergies': customAllergies,
      if (dailyCalorieTarget != null)
        'daily_calorie_target': dailyCalorieTarget,
      if (dailyWaterMl != null) 'daily_water_ml': dailyWaterMl,
      if (enabledMealTypes != null) 'enabled_meal_types': enabledMealTypes,
      if (dietStartDate != null) 'diet_start_date': dietStartDate,
      if (freeDays != null) 'free_days': freeDays,
      if (batchCookingBeforeDiet != null)
        'batch_cooking_before_diet': batchCookingBeforeDiet,
      if (excludedMeats != null) 'excluded_meats': excludedMeats,
      if (economicMode != null) 'economic_mode': economicMode,
      if (onboardingCompleted != null)
        'onboarding_completed': onboardingCompleted,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  UserProfilesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<int>? age,
    Value<String>? sex,
    Value<int>? heightCm,
    Value<double>? weightKg,
    Value<double>? targetWeightKg,
    Value<String>? lossPace,
    Value<String>? activityLevel,
    Value<int>? dietDaysPerWeek,
    Value<int>? batchCookingSessionsPerWeek,
    Value<int>? shoppingTripsPerWeek,
    Value<String>? dietType,
    Value<int>? distinctBreakfasts,
    Value<int>? distinctLunches,
    Value<int>? distinctDinners,
    Value<int>? distinctSnacks,
    Value<String>? allergies,
    Value<String>? customAllergies,
    Value<int>? dailyCalorieTarget,
    Value<int>? dailyWaterMl,
    Value<String>? enabledMealTypes,
    Value<int>? dietStartDate,
    Value<String>? freeDays,
    Value<bool>? batchCookingBeforeDiet,
    Value<String>? excludedMeats,
    Value<bool>? economicMode,
    Value<bool>? onboardingCompleted,
    Value<int>? createdAt,
  }) {
    return UserProfilesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      age: age ?? this.age,
      sex: sex ?? this.sex,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      lossPace: lossPace ?? this.lossPace,
      activityLevel: activityLevel ?? this.activityLevel,
      dietDaysPerWeek: dietDaysPerWeek ?? this.dietDaysPerWeek,
      batchCookingSessionsPerWeek:
          batchCookingSessionsPerWeek ?? this.batchCookingSessionsPerWeek,
      shoppingTripsPerWeek: shoppingTripsPerWeek ?? this.shoppingTripsPerWeek,
      dietType: dietType ?? this.dietType,
      distinctBreakfasts: distinctBreakfasts ?? this.distinctBreakfasts,
      distinctLunches: distinctLunches ?? this.distinctLunches,
      distinctDinners: distinctDinners ?? this.distinctDinners,
      distinctSnacks: distinctSnacks ?? this.distinctSnacks,
      allergies: allergies ?? this.allergies,
      customAllergies: customAllergies ?? this.customAllergies,
      dailyCalorieTarget: dailyCalorieTarget ?? this.dailyCalorieTarget,
      dailyWaterMl: dailyWaterMl ?? this.dailyWaterMl,
      enabledMealTypes: enabledMealTypes ?? this.enabledMealTypes,
      dietStartDate: dietStartDate ?? this.dietStartDate,
      freeDays: freeDays ?? this.freeDays,
      batchCookingBeforeDiet:
          batchCookingBeforeDiet ?? this.batchCookingBeforeDiet,
      excludedMeats: excludedMeats ?? this.excludedMeats,
      economicMode: economicMode ?? this.economicMode,
      onboardingCompleted: onboardingCompleted ?? this.onboardingCompleted,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (age.present) {
      map['age'] = Variable<int>(age.value);
    }
    if (sex.present) {
      map['sex'] = Variable<String>(sex.value);
    }
    if (heightCm.present) {
      map['height_cm'] = Variable<int>(heightCm.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (targetWeightKg.present) {
      map['target_weight_kg'] = Variable<double>(targetWeightKg.value);
    }
    if (lossPace.present) {
      map['loss_pace'] = Variable<String>(lossPace.value);
    }
    if (activityLevel.present) {
      map['activity_level'] = Variable<String>(activityLevel.value);
    }
    if (dietDaysPerWeek.present) {
      map['diet_days_per_week'] = Variable<int>(dietDaysPerWeek.value);
    }
    if (batchCookingSessionsPerWeek.present) {
      map['batch_cooking_sessions_per_week'] = Variable<int>(
        batchCookingSessionsPerWeek.value,
      );
    }
    if (shoppingTripsPerWeek.present) {
      map['shopping_trips_per_week'] = Variable<int>(
        shoppingTripsPerWeek.value,
      );
    }
    if (dietType.present) {
      map['diet_type'] = Variable<String>(dietType.value);
    }
    if (distinctBreakfasts.present) {
      map['distinct_breakfasts'] = Variable<int>(distinctBreakfasts.value);
    }
    if (distinctLunches.present) {
      map['distinct_lunches'] = Variable<int>(distinctLunches.value);
    }
    if (distinctDinners.present) {
      map['distinct_dinners'] = Variable<int>(distinctDinners.value);
    }
    if (distinctSnacks.present) {
      map['distinct_snacks'] = Variable<int>(distinctSnacks.value);
    }
    if (allergies.present) {
      map['allergies'] = Variable<String>(allergies.value);
    }
    if (customAllergies.present) {
      map['custom_allergies'] = Variable<String>(customAllergies.value);
    }
    if (dailyCalorieTarget.present) {
      map['daily_calorie_target'] = Variable<int>(dailyCalorieTarget.value);
    }
    if (dailyWaterMl.present) {
      map['daily_water_ml'] = Variable<int>(dailyWaterMl.value);
    }
    if (enabledMealTypes.present) {
      map['enabled_meal_types'] = Variable<String>(enabledMealTypes.value);
    }
    if (dietStartDate.present) {
      map['diet_start_date'] = Variable<int>(dietStartDate.value);
    }
    if (freeDays.present) {
      map['free_days'] = Variable<String>(freeDays.value);
    }
    if (batchCookingBeforeDiet.present) {
      map['batch_cooking_before_diet'] = Variable<bool>(
        batchCookingBeforeDiet.value,
      );
    }
    if (excludedMeats.present) {
      map['excluded_meats'] = Variable<String>(excludedMeats.value);
    }
    if (economicMode.present) {
      map['economic_mode'] = Variable<bool>(economicMode.value);
    }
    if (onboardingCompleted.present) {
      map['onboarding_completed'] = Variable<bool>(onboardingCompleted.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('UserProfilesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('age: $age, ')
          ..write('sex: $sex, ')
          ..write('heightCm: $heightCm, ')
          ..write('weightKg: $weightKg, ')
          ..write('targetWeightKg: $targetWeightKg, ')
          ..write('lossPace: $lossPace, ')
          ..write('activityLevel: $activityLevel, ')
          ..write('dietDaysPerWeek: $dietDaysPerWeek, ')
          ..write('batchCookingSessionsPerWeek: $batchCookingSessionsPerWeek, ')
          ..write('shoppingTripsPerWeek: $shoppingTripsPerWeek, ')
          ..write('dietType: $dietType, ')
          ..write('distinctBreakfasts: $distinctBreakfasts, ')
          ..write('distinctLunches: $distinctLunches, ')
          ..write('distinctDinners: $distinctDinners, ')
          ..write('distinctSnacks: $distinctSnacks, ')
          ..write('allergies: $allergies, ')
          ..write('customAllergies: $customAllergies, ')
          ..write('dailyCalorieTarget: $dailyCalorieTarget, ')
          ..write('dailyWaterMl: $dailyWaterMl, ')
          ..write('enabledMealTypes: $enabledMealTypes, ')
          ..write('dietStartDate: $dietStartDate, ')
          ..write('freeDays: $freeDays, ')
          ..write('batchCookingBeforeDiet: $batchCookingBeforeDiet, ')
          ..write('excludedMeats: $excludedMeats, ')
          ..write('economicMode: $economicMode, ')
          ..write('onboardingCompleted: $onboardingCompleted, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $RecipesTable extends Recipes with TableInfo<$RecipesTable, Recipe> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryMeta = const VerificationMeta(
    'category',
  );
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
    'category',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _caloriesPerServingMeta =
      const VerificationMeta('caloriesPerServing');
  @override
  late final GeneratedColumn<int> caloriesPerServing = GeneratedColumn<int>(
    'calories_per_serving',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _proteinGramsMeta = const VerificationMeta(
    'proteinGrams',
  );
  @override
  late final GeneratedColumn<double> proteinGrams = GeneratedColumn<double>(
    'protein_grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _carbsGramsMeta = const VerificationMeta(
    'carbsGrams',
  );
  @override
  late final GeneratedColumn<double> carbsGrams = GeneratedColumn<double>(
    'carbs_grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fatGramsMeta = const VerificationMeta(
    'fatGrams',
  );
  @override
  late final GeneratedColumn<double> fatGrams = GeneratedColumn<double>(
    'fat_grams',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _servingsMeta = const VerificationMeta(
    'servings',
  );
  @override
  late final GeneratedColumn<int> servings = GeneratedColumn<int>(
    'servings',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _prepTimeMinutesMeta = const VerificationMeta(
    'prepTimeMinutes',
  );
  @override
  late final GeneratedColumn<int> prepTimeMinutes = GeneratedColumn<int>(
    'prep_time_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cookTimeMinutesMeta = const VerificationMeta(
    'cookTimeMinutes',
  );
  @override
  late final GeneratedColumn<int> cookTimeMinutes = GeneratedColumn<int>(
    'cook_time_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isBatchFriendlyMeta = const VerificationMeta(
    'isBatchFriendly',
  );
  @override
  late final GeneratedColumn<bool> isBatchFriendly = GeneratedColumn<bool>(
    'is_batch_friendly',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_batch_friendly" IN (0, 1))',
    ),
  );
  static const VerificationMeta _allergensMeta = const VerificationMeta(
    'allergens',
  );
  @override
  late final GeneratedColumn<String> allergens = GeneratedColumn<String>(
    'allergens',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<String> difficulty = GeneratedColumn<String>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('EASY'),
  );
  static const VerificationMeta _dietTypeMeta = const VerificationMeta(
    'dietType',
  );
  @override
  late final GeneratedColumn<String> dietType = GeneratedColumn<String>(
    'diet_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('OMNIVORE'),
  );
  static const VerificationMeta _meatTypesMeta = const VerificationMeta(
    'meatTypes',
  );
  @override
  late final GeneratedColumn<String> meatTypes = GeneratedColumn<String>(
    'meat_types',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    category,
    caloriesPerServing,
    proteinGrams,
    carbsGrams,
    fatGrams,
    servings,
    prepTimeMinutes,
    cookTimeMinutes,
    isBatchFriendly,
    allergens,
    difficulty,
    dietType,
    meatTypes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipes';
  @override
  VerificationContext validateIntegrity(
    Insertable<Recipe> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_descriptionMeta);
    }
    if (data.containsKey('category')) {
      context.handle(
        _categoryMeta,
        category.isAcceptableOrUnknown(data['category']!, _categoryMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryMeta);
    }
    if (data.containsKey('calories_per_serving')) {
      context.handle(
        _caloriesPerServingMeta,
        caloriesPerServing.isAcceptableOrUnknown(
          data['calories_per_serving']!,
          _caloriesPerServingMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_caloriesPerServingMeta);
    }
    if (data.containsKey('protein_grams')) {
      context.handle(
        _proteinGramsMeta,
        proteinGrams.isAcceptableOrUnknown(
          data['protein_grams']!,
          _proteinGramsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_proteinGramsMeta);
    }
    if (data.containsKey('carbs_grams')) {
      context.handle(
        _carbsGramsMeta,
        carbsGrams.isAcceptableOrUnknown(data['carbs_grams']!, _carbsGramsMeta),
      );
    } else if (isInserting) {
      context.missing(_carbsGramsMeta);
    }
    if (data.containsKey('fat_grams')) {
      context.handle(
        _fatGramsMeta,
        fatGrams.isAcceptableOrUnknown(data['fat_grams']!, _fatGramsMeta),
      );
    } else if (isInserting) {
      context.missing(_fatGramsMeta);
    }
    if (data.containsKey('servings')) {
      context.handle(
        _servingsMeta,
        servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta),
      );
    } else if (isInserting) {
      context.missing(_servingsMeta);
    }
    if (data.containsKey('prep_time_minutes')) {
      context.handle(
        _prepTimeMinutesMeta,
        prepTimeMinutes.isAcceptableOrUnknown(
          data['prep_time_minutes']!,
          _prepTimeMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_prepTimeMinutesMeta);
    }
    if (data.containsKey('cook_time_minutes')) {
      context.handle(
        _cookTimeMinutesMeta,
        cookTimeMinutes.isAcceptableOrUnknown(
          data['cook_time_minutes']!,
          _cookTimeMinutesMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_cookTimeMinutesMeta);
    }
    if (data.containsKey('is_batch_friendly')) {
      context.handle(
        _isBatchFriendlyMeta,
        isBatchFriendly.isAcceptableOrUnknown(
          data['is_batch_friendly']!,
          _isBatchFriendlyMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_isBatchFriendlyMeta);
    }
    if (data.containsKey('allergens')) {
      context.handle(
        _allergensMeta,
        allergens.isAcceptableOrUnknown(data['allergens']!, _allergensMeta),
      );
    } else if (isInserting) {
      context.missing(_allergensMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('diet_type')) {
      context.handle(
        _dietTypeMeta,
        dietType.isAcceptableOrUnknown(data['diet_type']!, _dietTypeMeta),
      );
    }
    if (data.containsKey('meat_types')) {
      context.handle(
        _meatTypesMeta,
        meatTypes.isAcceptableOrUnknown(data['meat_types']!, _meatTypesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Recipe map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Recipe(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      category: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category'],
      )!,
      caloriesPerServing: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}calories_per_serving'],
      )!,
      proteinGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}protein_grams'],
      )!,
      carbsGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}carbs_grams'],
      )!,
      fatGrams: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}fat_grams'],
      )!,
      servings: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}servings'],
      )!,
      prepTimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}prep_time_minutes'],
      )!,
      cookTimeMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cook_time_minutes'],
      )!,
      isBatchFriendly: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_batch_friendly'],
      )!,
      allergens: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}allergens'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}difficulty'],
      )!,
      dietType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}diet_type'],
      )!,
      meatTypes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meat_types'],
      )!,
    );
  }

  @override
  $RecipesTable createAlias(String alias) {
    return $RecipesTable(attachedDatabase, alias);
  }
}

class Recipe extends DataClass implements Insertable<Recipe> {
  final int id;
  final String name;
  final String description;
  final String category;
  final int caloriesPerServing;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final int servings;
  final int prepTimeMinutes;
  final int cookTimeMinutes;
  final bool isBatchFriendly;
  final String allergens;
  final String difficulty;
  final String dietType;
  final String meatTypes;
  const Recipe({
    required this.id,
    required this.name,
    required this.description,
    required this.category,
    required this.caloriesPerServing,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.servings,
    required this.prepTimeMinutes,
    required this.cookTimeMinutes,
    required this.isBatchFriendly,
    required this.allergens,
    required this.difficulty,
    required this.dietType,
    required this.meatTypes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['description'] = Variable<String>(description);
    map['category'] = Variable<String>(category);
    map['calories_per_serving'] = Variable<int>(caloriesPerServing);
    map['protein_grams'] = Variable<double>(proteinGrams);
    map['carbs_grams'] = Variable<double>(carbsGrams);
    map['fat_grams'] = Variable<double>(fatGrams);
    map['servings'] = Variable<int>(servings);
    map['prep_time_minutes'] = Variable<int>(prepTimeMinutes);
    map['cook_time_minutes'] = Variable<int>(cookTimeMinutes);
    map['is_batch_friendly'] = Variable<bool>(isBatchFriendly);
    map['allergens'] = Variable<String>(allergens);
    map['difficulty'] = Variable<String>(difficulty);
    map['diet_type'] = Variable<String>(dietType);
    map['meat_types'] = Variable<String>(meatTypes);
    return map;
  }

  RecipesCompanion toCompanion(bool nullToAbsent) {
    return RecipesCompanion(
      id: Value(id),
      name: Value(name),
      description: Value(description),
      category: Value(category),
      caloriesPerServing: Value(caloriesPerServing),
      proteinGrams: Value(proteinGrams),
      carbsGrams: Value(carbsGrams),
      fatGrams: Value(fatGrams),
      servings: Value(servings),
      prepTimeMinutes: Value(prepTimeMinutes),
      cookTimeMinutes: Value(cookTimeMinutes),
      isBatchFriendly: Value(isBatchFriendly),
      allergens: Value(allergens),
      difficulty: Value(difficulty),
      dietType: Value(dietType),
      meatTypes: Value(meatTypes),
    );
  }

  factory Recipe.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Recipe(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String>(json['description']),
      category: serializer.fromJson<String>(json['category']),
      caloriesPerServing: serializer.fromJson<int>(json['caloriesPerServing']),
      proteinGrams: serializer.fromJson<double>(json['proteinGrams']),
      carbsGrams: serializer.fromJson<double>(json['carbsGrams']),
      fatGrams: serializer.fromJson<double>(json['fatGrams']),
      servings: serializer.fromJson<int>(json['servings']),
      prepTimeMinutes: serializer.fromJson<int>(json['prepTimeMinutes']),
      cookTimeMinutes: serializer.fromJson<int>(json['cookTimeMinutes']),
      isBatchFriendly: serializer.fromJson<bool>(json['isBatchFriendly']),
      allergens: serializer.fromJson<String>(json['allergens']),
      difficulty: serializer.fromJson<String>(json['difficulty']),
      dietType: serializer.fromJson<String>(json['dietType']),
      meatTypes: serializer.fromJson<String>(json['meatTypes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String>(description),
      'category': serializer.toJson<String>(category),
      'caloriesPerServing': serializer.toJson<int>(caloriesPerServing),
      'proteinGrams': serializer.toJson<double>(proteinGrams),
      'carbsGrams': serializer.toJson<double>(carbsGrams),
      'fatGrams': serializer.toJson<double>(fatGrams),
      'servings': serializer.toJson<int>(servings),
      'prepTimeMinutes': serializer.toJson<int>(prepTimeMinutes),
      'cookTimeMinutes': serializer.toJson<int>(cookTimeMinutes),
      'isBatchFriendly': serializer.toJson<bool>(isBatchFriendly),
      'allergens': serializer.toJson<String>(allergens),
      'difficulty': serializer.toJson<String>(difficulty),
      'dietType': serializer.toJson<String>(dietType),
      'meatTypes': serializer.toJson<String>(meatTypes),
    };
  }

  Recipe copyWith({
    int? id,
    String? name,
    String? description,
    String? category,
    int? caloriesPerServing,
    double? proteinGrams,
    double? carbsGrams,
    double? fatGrams,
    int? servings,
    int? prepTimeMinutes,
    int? cookTimeMinutes,
    bool? isBatchFriendly,
    String? allergens,
    String? difficulty,
    String? dietType,
    String? meatTypes,
  }) => Recipe(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description ?? this.description,
    category: category ?? this.category,
    caloriesPerServing: caloriesPerServing ?? this.caloriesPerServing,
    proteinGrams: proteinGrams ?? this.proteinGrams,
    carbsGrams: carbsGrams ?? this.carbsGrams,
    fatGrams: fatGrams ?? this.fatGrams,
    servings: servings ?? this.servings,
    prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
    cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
    isBatchFriendly: isBatchFriendly ?? this.isBatchFriendly,
    allergens: allergens ?? this.allergens,
    difficulty: difficulty ?? this.difficulty,
    dietType: dietType ?? this.dietType,
    meatTypes: meatTypes ?? this.meatTypes,
  );
  Recipe copyWithCompanion(RecipesCompanion data) {
    return Recipe(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      category: data.category.present ? data.category.value : this.category,
      caloriesPerServing: data.caloriesPerServing.present
          ? data.caloriesPerServing.value
          : this.caloriesPerServing,
      proteinGrams: data.proteinGrams.present
          ? data.proteinGrams.value
          : this.proteinGrams,
      carbsGrams: data.carbsGrams.present
          ? data.carbsGrams.value
          : this.carbsGrams,
      fatGrams: data.fatGrams.present ? data.fatGrams.value : this.fatGrams,
      servings: data.servings.present ? data.servings.value : this.servings,
      prepTimeMinutes: data.prepTimeMinutes.present
          ? data.prepTimeMinutes.value
          : this.prepTimeMinutes,
      cookTimeMinutes: data.cookTimeMinutes.present
          ? data.cookTimeMinutes.value
          : this.cookTimeMinutes,
      isBatchFriendly: data.isBatchFriendly.present
          ? data.isBatchFriendly.value
          : this.isBatchFriendly,
      allergens: data.allergens.present ? data.allergens.value : this.allergens,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      dietType: data.dietType.present ? data.dietType.value : this.dietType,
      meatTypes: data.meatTypes.present ? data.meatTypes.value : this.meatTypes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Recipe(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('caloriesPerServing: $caloriesPerServing, ')
          ..write('proteinGrams: $proteinGrams, ')
          ..write('carbsGrams: $carbsGrams, ')
          ..write('fatGrams: $fatGrams, ')
          ..write('servings: $servings, ')
          ..write('prepTimeMinutes: $prepTimeMinutes, ')
          ..write('cookTimeMinutes: $cookTimeMinutes, ')
          ..write('isBatchFriendly: $isBatchFriendly, ')
          ..write('allergens: $allergens, ')
          ..write('difficulty: $difficulty, ')
          ..write('dietType: $dietType, ')
          ..write('meatTypes: $meatTypes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    description,
    category,
    caloriesPerServing,
    proteinGrams,
    carbsGrams,
    fatGrams,
    servings,
    prepTimeMinutes,
    cookTimeMinutes,
    isBatchFriendly,
    allergens,
    difficulty,
    dietType,
    meatTypes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Recipe &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.category == this.category &&
          other.caloriesPerServing == this.caloriesPerServing &&
          other.proteinGrams == this.proteinGrams &&
          other.carbsGrams == this.carbsGrams &&
          other.fatGrams == this.fatGrams &&
          other.servings == this.servings &&
          other.prepTimeMinutes == this.prepTimeMinutes &&
          other.cookTimeMinutes == this.cookTimeMinutes &&
          other.isBatchFriendly == this.isBatchFriendly &&
          other.allergens == this.allergens &&
          other.difficulty == this.difficulty &&
          other.dietType == this.dietType &&
          other.meatTypes == this.meatTypes);
}

class RecipesCompanion extends UpdateCompanion<Recipe> {
  final Value<int> id;
  final Value<String> name;
  final Value<String> description;
  final Value<String> category;
  final Value<int> caloriesPerServing;
  final Value<double> proteinGrams;
  final Value<double> carbsGrams;
  final Value<double> fatGrams;
  final Value<int> servings;
  final Value<int> prepTimeMinutes;
  final Value<int> cookTimeMinutes;
  final Value<bool> isBatchFriendly;
  final Value<String> allergens;
  final Value<String> difficulty;
  final Value<String> dietType;
  final Value<String> meatTypes;
  const RecipesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.category = const Value.absent(),
    this.caloriesPerServing = const Value.absent(),
    this.proteinGrams = const Value.absent(),
    this.carbsGrams = const Value.absent(),
    this.fatGrams = const Value.absent(),
    this.servings = const Value.absent(),
    this.prepTimeMinutes = const Value.absent(),
    this.cookTimeMinutes = const Value.absent(),
    this.isBatchFriendly = const Value.absent(),
    this.allergens = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.dietType = const Value.absent(),
    this.meatTypes = const Value.absent(),
  });
  RecipesCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required String description,
    required String category,
    required int caloriesPerServing,
    required double proteinGrams,
    required double carbsGrams,
    required double fatGrams,
    required int servings,
    required int prepTimeMinutes,
    required int cookTimeMinutes,
    required bool isBatchFriendly,
    required String allergens,
    this.difficulty = const Value.absent(),
    this.dietType = const Value.absent(),
    this.meatTypes = const Value.absent(),
  }) : name = Value(name),
       description = Value(description),
       category = Value(category),
       caloriesPerServing = Value(caloriesPerServing),
       proteinGrams = Value(proteinGrams),
       carbsGrams = Value(carbsGrams),
       fatGrams = Value(fatGrams),
       servings = Value(servings),
       prepTimeMinutes = Value(prepTimeMinutes),
       cookTimeMinutes = Value(cookTimeMinutes),
       isBatchFriendly = Value(isBatchFriendly),
       allergens = Value(allergens);
  static Insertable<Recipe> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? category,
    Expression<int>? caloriesPerServing,
    Expression<double>? proteinGrams,
    Expression<double>? carbsGrams,
    Expression<double>? fatGrams,
    Expression<int>? servings,
    Expression<int>? prepTimeMinutes,
    Expression<int>? cookTimeMinutes,
    Expression<bool>? isBatchFriendly,
    Expression<String>? allergens,
    Expression<String>? difficulty,
    Expression<String>? dietType,
    Expression<String>? meatTypes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (category != null) 'category': category,
      if (caloriesPerServing != null)
        'calories_per_serving': caloriesPerServing,
      if (proteinGrams != null) 'protein_grams': proteinGrams,
      if (carbsGrams != null) 'carbs_grams': carbsGrams,
      if (fatGrams != null) 'fat_grams': fatGrams,
      if (servings != null) 'servings': servings,
      if (prepTimeMinutes != null) 'prep_time_minutes': prepTimeMinutes,
      if (cookTimeMinutes != null) 'cook_time_minutes': cookTimeMinutes,
      if (isBatchFriendly != null) 'is_batch_friendly': isBatchFriendly,
      if (allergens != null) 'allergens': allergens,
      if (difficulty != null) 'difficulty': difficulty,
      if (dietType != null) 'diet_type': dietType,
      if (meatTypes != null) 'meat_types': meatTypes,
    });
  }

  RecipesCompanion copyWith({
    Value<int>? id,
    Value<String>? name,
    Value<String>? description,
    Value<String>? category,
    Value<int>? caloriesPerServing,
    Value<double>? proteinGrams,
    Value<double>? carbsGrams,
    Value<double>? fatGrams,
    Value<int>? servings,
    Value<int>? prepTimeMinutes,
    Value<int>? cookTimeMinutes,
    Value<bool>? isBatchFriendly,
    Value<String>? allergens,
    Value<String>? difficulty,
    Value<String>? dietType,
    Value<String>? meatTypes,
  }) {
    return RecipesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      caloriesPerServing: caloriesPerServing ?? this.caloriesPerServing,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatGrams: fatGrams ?? this.fatGrams,
      servings: servings ?? this.servings,
      prepTimeMinutes: prepTimeMinutes ?? this.prepTimeMinutes,
      cookTimeMinutes: cookTimeMinutes ?? this.cookTimeMinutes,
      isBatchFriendly: isBatchFriendly ?? this.isBatchFriendly,
      allergens: allergens ?? this.allergens,
      difficulty: difficulty ?? this.difficulty,
      dietType: dietType ?? this.dietType,
      meatTypes: meatTypes ?? this.meatTypes,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (caloriesPerServing.present) {
      map['calories_per_serving'] = Variable<int>(caloriesPerServing.value);
    }
    if (proteinGrams.present) {
      map['protein_grams'] = Variable<double>(proteinGrams.value);
    }
    if (carbsGrams.present) {
      map['carbs_grams'] = Variable<double>(carbsGrams.value);
    }
    if (fatGrams.present) {
      map['fat_grams'] = Variable<double>(fatGrams.value);
    }
    if (servings.present) {
      map['servings'] = Variable<int>(servings.value);
    }
    if (prepTimeMinutes.present) {
      map['prep_time_minutes'] = Variable<int>(prepTimeMinutes.value);
    }
    if (cookTimeMinutes.present) {
      map['cook_time_minutes'] = Variable<int>(cookTimeMinutes.value);
    }
    if (isBatchFriendly.present) {
      map['is_batch_friendly'] = Variable<bool>(isBatchFriendly.value);
    }
    if (allergens.present) {
      map['allergens'] = Variable<String>(allergens.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<String>(difficulty.value);
    }
    if (dietType.present) {
      map['diet_type'] = Variable<String>(dietType.value);
    }
    if (meatTypes.present) {
      map['meat_types'] = Variable<String>(meatTypes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('category: $category, ')
          ..write('caloriesPerServing: $caloriesPerServing, ')
          ..write('proteinGrams: $proteinGrams, ')
          ..write('carbsGrams: $carbsGrams, ')
          ..write('fatGrams: $fatGrams, ')
          ..write('servings: $servings, ')
          ..write('prepTimeMinutes: $prepTimeMinutes, ')
          ..write('cookTimeMinutes: $cookTimeMinutes, ')
          ..write('isBatchFriendly: $isBatchFriendly, ')
          ..write('allergens: $allergens, ')
          ..write('difficulty: $difficulty, ')
          ..write('dietType: $dietType, ')
          ..write('meatTypes: $meatTypes')
          ..write(')'))
        .toString();
  }
}

class $RecipeStepsTable extends RecipeSteps
    with TableInfo<$RecipeStepsTable, RecipeStep> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecipeStepsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _stepNumberMeta = const VerificationMeta(
    'stepNumber',
  );
  @override
  late final GeneratedColumn<int> stepNumber = GeneratedColumn<int>(
    'step_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _instructionMeta = const VerificationMeta(
    'instruction',
  );
  @override
  late final GeneratedColumn<String> instruction = GeneratedColumn<String>(
    'instruction',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timerSecondsMeta = const VerificationMeta(
    'timerSeconds',
  );
  @override
  late final GeneratedColumn<int> timerSeconds = GeneratedColumn<int>(
    'timer_seconds',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    stepNumber,
    instruction,
    timerSeconds,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'recipe_steps';
  @override
  VerificationContext validateIntegrity(
    Insertable<RecipeStep> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('step_number')) {
      context.handle(
        _stepNumberMeta,
        stepNumber.isAcceptableOrUnknown(data['step_number']!, _stepNumberMeta),
      );
    } else if (isInserting) {
      context.missing(_stepNumberMeta);
    }
    if (data.containsKey('instruction')) {
      context.handle(
        _instructionMeta,
        instruction.isAcceptableOrUnknown(
          data['instruction']!,
          _instructionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_instructionMeta);
    }
    if (data.containsKey('timer_seconds')) {
      context.handle(
        _timerSecondsMeta,
        timerSeconds.isAcceptableOrUnknown(
          data['timer_seconds']!,
          _timerSecondsMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  RecipeStep map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return RecipeStep(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      )!,
      stepNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step_number'],
      )!,
      instruction: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}instruction'],
      )!,
      timerSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}timer_seconds'],
      ),
    );
  }

  @override
  $RecipeStepsTable createAlias(String alias) {
    return $RecipeStepsTable(attachedDatabase, alias);
  }
}

class RecipeStep extends DataClass implements Insertable<RecipeStep> {
  final int id;
  final int recipeId;
  final int stepNumber;
  final String instruction;
  final int? timerSeconds;
  const RecipeStep({
    required this.id,
    required this.recipeId,
    required this.stepNumber,
    required this.instruction,
    this.timerSeconds,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<int>(recipeId);
    map['step_number'] = Variable<int>(stepNumber);
    map['instruction'] = Variable<String>(instruction);
    if (!nullToAbsent || timerSeconds != null) {
      map['timer_seconds'] = Variable<int>(timerSeconds);
    }
    return map;
  }

  RecipeStepsCompanion toCompanion(bool nullToAbsent) {
    return RecipeStepsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      stepNumber: Value(stepNumber),
      instruction: Value(instruction),
      timerSeconds: timerSeconds == null && nullToAbsent
          ? const Value.absent()
          : Value(timerSeconds),
    );
  }

  factory RecipeStep.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return RecipeStep(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
      stepNumber: serializer.fromJson<int>(json['stepNumber']),
      instruction: serializer.fromJson<String>(json['instruction']),
      timerSeconds: serializer.fromJson<int?>(json['timerSeconds']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<int>(recipeId),
      'stepNumber': serializer.toJson<int>(stepNumber),
      'instruction': serializer.toJson<String>(instruction),
      'timerSeconds': serializer.toJson<int?>(timerSeconds),
    };
  }

  RecipeStep copyWith({
    int? id,
    int? recipeId,
    int? stepNumber,
    String? instruction,
    Value<int?> timerSeconds = const Value.absent(),
  }) => RecipeStep(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    stepNumber: stepNumber ?? this.stepNumber,
    instruction: instruction ?? this.instruction,
    timerSeconds: timerSeconds.present ? timerSeconds.value : this.timerSeconds,
  );
  RecipeStep copyWithCompanion(RecipeStepsCompanion data) {
    return RecipeStep(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      stepNumber: data.stepNumber.present
          ? data.stepNumber.value
          : this.stepNumber,
      instruction: data.instruction.present
          ? data.instruction.value
          : this.instruction,
      timerSeconds: data.timerSeconds.present
          ? data.timerSeconds.value
          : this.timerSeconds,
    );
  }

  @override
  String toString() {
    return (StringBuffer('RecipeStep(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('stepNumber: $stepNumber, ')
          ..write('instruction: $instruction, ')
          ..write('timerSeconds: $timerSeconds')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, recipeId, stepNumber, instruction, timerSeconds);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is RecipeStep &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.stepNumber == this.stepNumber &&
          other.instruction == this.instruction &&
          other.timerSeconds == this.timerSeconds);
}

class RecipeStepsCompanion extends UpdateCompanion<RecipeStep> {
  final Value<int> id;
  final Value<int> recipeId;
  final Value<int> stepNumber;
  final Value<String> instruction;
  final Value<int?> timerSeconds;
  const RecipeStepsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.stepNumber = const Value.absent(),
    this.instruction = const Value.absent(),
    this.timerSeconds = const Value.absent(),
  });
  RecipeStepsCompanion.insert({
    this.id = const Value.absent(),
    required int recipeId,
    required int stepNumber,
    required String instruction,
    this.timerSeconds = const Value.absent(),
  }) : recipeId = Value(recipeId),
       stepNumber = Value(stepNumber),
       instruction = Value(instruction);
  static Insertable<RecipeStep> custom({
    Expression<int>? id,
    Expression<int>? recipeId,
    Expression<int>? stepNumber,
    Expression<String>? instruction,
    Expression<int>? timerSeconds,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (stepNumber != null) 'step_number': stepNumber,
      if (instruction != null) 'instruction': instruction,
      if (timerSeconds != null) 'timer_seconds': timerSeconds,
    });
  }

  RecipeStepsCompanion copyWith({
    Value<int>? id,
    Value<int>? recipeId,
    Value<int>? stepNumber,
    Value<String>? instruction,
    Value<int?>? timerSeconds,
  }) {
    return RecipeStepsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      stepNumber: stepNumber ?? this.stepNumber,
      instruction: instruction ?? this.instruction,
      timerSeconds: timerSeconds ?? this.timerSeconds,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (stepNumber.present) {
      map['step_number'] = Variable<int>(stepNumber.value);
    }
    if (instruction.present) {
      map['instruction'] = Variable<String>(instruction.value);
    }
    if (timerSeconds.present) {
      map['timer_seconds'] = Variable<int>(timerSeconds.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecipeStepsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('stepNumber: $stepNumber, ')
          ..write('instruction: $instruction, ')
          ..write('timerSeconds: $timerSeconds')
          ..write(')'))
        .toString();
  }
}

class $IngredientsTable extends Ingredients
    with TableInfo<$IngredientsTable, Ingredient> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IngredientsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supermarketSectionMeta =
      const VerificationMeta('supermarketSection');
  @override
  late final GeneratedColumn<String> supermarketSection =
      GeneratedColumn<String>(
        'supermarket_section',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    recipeId,
    name,
    quantity,
    unit,
    supermarketSection,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'ingredients';
  @override
  VerificationContext validateIntegrity(
    Insertable<Ingredient> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('supermarket_section')) {
      context.handle(
        _supermarketSectionMeta,
        supermarketSection.isAcceptableOrUnknown(
          data['supermarket_section']!,
          _supermarketSectionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_supermarketSectionMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Ingredient map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Ingredient(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      supermarketSection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supermarket_section'],
      )!,
    );
  }

  @override
  $IngredientsTable createAlias(String alias) {
    return $IngredientsTable(attachedDatabase, alias);
  }
}

class Ingredient extends DataClass implements Insertable<Ingredient> {
  final int id;
  final int recipeId;
  final String name;
  final double quantity;
  final String unit;
  final String supermarketSection;
  const Ingredient({
    required this.id,
    required this.recipeId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.supermarketSection,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['recipe_id'] = Variable<int>(recipeId);
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    map['supermarket_section'] = Variable<String>(supermarketSection);
    return map;
  }

  IngredientsCompanion toCompanion(bool nullToAbsent) {
    return IngredientsCompanion(
      id: Value(id),
      recipeId: Value(recipeId),
      name: Value(name),
      quantity: Value(quantity),
      unit: Value(unit),
      supermarketSection: Value(supermarketSection),
    );
  }

  factory Ingredient.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Ingredient(
      id: serializer.fromJson<int>(json['id']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      supermarketSection: serializer.fromJson<String>(
        json['supermarketSection'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'recipeId': serializer.toJson<int>(recipeId),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'supermarketSection': serializer.toJson<String>(supermarketSection),
    };
  }

  Ingredient copyWith({
    int? id,
    int? recipeId,
    String? name,
    double? quantity,
    String? unit,
    String? supermarketSection,
  }) => Ingredient(
    id: id ?? this.id,
    recipeId: recipeId ?? this.recipeId,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    supermarketSection: supermarketSection ?? this.supermarketSection,
  );
  Ingredient copyWithCompanion(IngredientsCompanion data) {
    return Ingredient(
      id: data.id.present ? data.id.value : this.id,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      supermarketSection: data.supermarketSection.present
          ? data.supermarketSection.value
          : this.supermarketSection,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Ingredient(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('supermarketSection: $supermarketSection')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, recipeId, name, quantity, unit, supermarketSection);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ingredient &&
          other.id == this.id &&
          other.recipeId == this.recipeId &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.supermarketSection == this.supermarketSection);
}

class IngredientsCompanion extends UpdateCompanion<Ingredient> {
  final Value<int> id;
  final Value<int> recipeId;
  final Value<String> name;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<String> supermarketSection;
  const IngredientsCompanion({
    this.id = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.supermarketSection = const Value.absent(),
  });
  IngredientsCompanion.insert({
    this.id = const Value.absent(),
    required int recipeId,
    required String name,
    required double quantity,
    required String unit,
    required String supermarketSection,
  }) : recipeId = Value(recipeId),
       name = Value(name),
       quantity = Value(quantity),
       unit = Value(unit),
       supermarketSection = Value(supermarketSection);
  static Insertable<Ingredient> custom({
    Expression<int>? id,
    Expression<int>? recipeId,
    Expression<String>? name,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<String>? supermarketSection,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (recipeId != null) 'recipe_id': recipeId,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (supermarketSection != null) 'supermarket_section': supermarketSection,
    });
  }

  IngredientsCompanion copyWith({
    Value<int>? id,
    Value<int>? recipeId,
    Value<String>? name,
    Value<double>? quantity,
    Value<String>? unit,
    Value<String>? supermarketSection,
  }) {
    return IngredientsCompanion(
      id: id ?? this.id,
      recipeId: recipeId ?? this.recipeId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      supermarketSection: supermarketSection ?? this.supermarketSection,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (supermarketSection.present) {
      map['supermarket_section'] = Variable<String>(supermarketSection.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IngredientsCompanion(')
          ..write('id: $id, ')
          ..write('recipeId: $recipeId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('supermarketSection: $supermarketSection')
          ..write(')'))
        .toString();
  }
}

class $WeekPlansTable extends WeekPlans
    with TableInfo<$WeekPlansTable, WeekPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeekPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _weekStartDateMeta = const VerificationMeta(
    'weekStartDate',
  );
  @override
  late final GeneratedColumn<int> weekStartDate = GeneratedColumn<int>(
    'week_start_date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, weekStartDate, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'week_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeekPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('week_start_date')) {
      context.handle(
        _weekStartDateMeta,
        weekStartDate.isAcceptableOrUnknown(
          data['week_start_date']!,
          _weekStartDateMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weekStartDateMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeekPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeekPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      weekStartDate: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_start_date'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WeekPlansTable createAlias(String alias) {
    return $WeekPlansTable(attachedDatabase, alias);
  }
}

class WeekPlan extends DataClass implements Insertable<WeekPlan> {
  final int id;
  final int weekStartDate;
  final int createdAt;
  const WeekPlan({
    required this.id,
    required this.weekStartDate,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['week_start_date'] = Variable<int>(weekStartDate);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  WeekPlansCompanion toCompanion(bool nullToAbsent) {
    return WeekPlansCompanion(
      id: Value(id),
      weekStartDate: Value(weekStartDate),
      createdAt: Value(createdAt),
    );
  }

  factory WeekPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeekPlan(
      id: serializer.fromJson<int>(json['id']),
      weekStartDate: serializer.fromJson<int>(json['weekStartDate']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weekStartDate': serializer.toJson<int>(weekStartDate),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  WeekPlan copyWith({int? id, int? weekStartDate, int? createdAt}) => WeekPlan(
    id: id ?? this.id,
    weekStartDate: weekStartDate ?? this.weekStartDate,
    createdAt: createdAt ?? this.createdAt,
  );
  WeekPlan copyWithCompanion(WeekPlansCompanion data) {
    return WeekPlan(
      id: data.id.present ? data.id.value : this.id,
      weekStartDate: data.weekStartDate.present
          ? data.weekStartDate.value
          : this.weekStartDate,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeekPlan(')
          ..write('id: $id, ')
          ..write('weekStartDate: $weekStartDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, weekStartDate, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeekPlan &&
          other.id == this.id &&
          other.weekStartDate == this.weekStartDate &&
          other.createdAt == this.createdAt);
}

class WeekPlansCompanion extends UpdateCompanion<WeekPlan> {
  final Value<int> id;
  final Value<int> weekStartDate;
  final Value<int> createdAt;
  const WeekPlansCompanion({
    this.id = const Value.absent(),
    this.weekStartDate = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WeekPlansCompanion.insert({
    this.id = const Value.absent(),
    required int weekStartDate,
    required int createdAt,
  }) : weekStartDate = Value(weekStartDate),
       createdAt = Value(createdAt);
  static Insertable<WeekPlan> custom({
    Expression<int>? id,
    Expression<int>? weekStartDate,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weekStartDate != null) 'week_start_date': weekStartDate,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WeekPlansCompanion copyWith({
    Value<int>? id,
    Value<int>? weekStartDate,
    Value<int>? createdAt,
  }) {
    return WeekPlansCompanion(
      id: id ?? this.id,
      weekStartDate: weekStartDate ?? this.weekStartDate,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weekStartDate.present) {
      map['week_start_date'] = Variable<int>(weekStartDate.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeekPlansCompanion(')
          ..write('id: $id, ')
          ..write('weekStartDate: $weekStartDate, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

class $DayPlansTable extends DayPlans with TableInfo<$DayPlansTable, DayPlan> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DayPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _weekPlanIdMeta = const VerificationMeta(
    'weekPlanId',
  );
  @override
  late final GeneratedColumn<int> weekPlanId = GeneratedColumn<int>(
    'week_plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES week_plans (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dayOfWeekMeta = const VerificationMeta(
    'dayOfWeek',
  );
  @override
  late final GeneratedColumn<int> dayOfWeek = GeneratedColumn<int>(
    'day_of_week',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isFreeDayMeta = const VerificationMeta(
    'isFreeDay',
  );
  @override
  late final GeneratedColumn<bool> isFreeDay = GeneratedColumn<bool>(
    'is_free_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_free_day" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _batchCookingSessionMeta =
      const VerificationMeta('batchCookingSession');
  @override
  late final GeneratedColumn<int> batchCookingSession = GeneratedColumn<int>(
    'batch_cooking_session',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    weekPlanId,
    date,
    dayOfWeek,
    isFreeDay,
    batchCookingSession,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'day_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<DayPlan> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('week_plan_id')) {
      context.handle(
        _weekPlanIdMeta,
        weekPlanId.isAcceptableOrUnknown(
          data['week_plan_id']!,
          _weekPlanIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weekPlanIdMeta);
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('day_of_week')) {
      context.handle(
        _dayOfWeekMeta,
        dayOfWeek.isAcceptableOrUnknown(data['day_of_week']!, _dayOfWeekMeta),
      );
    } else if (isInserting) {
      context.missing(_dayOfWeekMeta);
    }
    if (data.containsKey('is_free_day')) {
      context.handle(
        _isFreeDayMeta,
        isFreeDay.isAcceptableOrUnknown(data['is_free_day']!, _isFreeDayMeta),
      );
    }
    if (data.containsKey('batch_cooking_session')) {
      context.handle(
        _batchCookingSessionMeta,
        batchCookingSession.isAcceptableOrUnknown(
          data['batch_cooking_session']!,
          _batchCookingSessionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DayPlan map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DayPlan(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      weekPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_plan_id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      dayOfWeek: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_of_week'],
      )!,
      isFreeDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_free_day'],
      )!,
      batchCookingSession: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}batch_cooking_session'],
      ),
    );
  }

  @override
  $DayPlansTable createAlias(String alias) {
    return $DayPlansTable(attachedDatabase, alias);
  }
}

class DayPlan extends DataClass implements Insertable<DayPlan> {
  final int id;
  final int weekPlanId;
  final int date;
  final int dayOfWeek;
  final bool isFreeDay;
  final int? batchCookingSession;
  const DayPlan({
    required this.id,
    required this.weekPlanId,
    required this.date,
    required this.dayOfWeek,
    required this.isFreeDay,
    this.batchCookingSession,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['week_plan_id'] = Variable<int>(weekPlanId);
    map['date'] = Variable<int>(date);
    map['day_of_week'] = Variable<int>(dayOfWeek);
    map['is_free_day'] = Variable<bool>(isFreeDay);
    if (!nullToAbsent || batchCookingSession != null) {
      map['batch_cooking_session'] = Variable<int>(batchCookingSession);
    }
    return map;
  }

  DayPlansCompanion toCompanion(bool nullToAbsent) {
    return DayPlansCompanion(
      id: Value(id),
      weekPlanId: Value(weekPlanId),
      date: Value(date),
      dayOfWeek: Value(dayOfWeek),
      isFreeDay: Value(isFreeDay),
      batchCookingSession: batchCookingSession == null && nullToAbsent
          ? const Value.absent()
          : Value(batchCookingSession),
    );
  }

  factory DayPlan.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DayPlan(
      id: serializer.fromJson<int>(json['id']),
      weekPlanId: serializer.fromJson<int>(json['weekPlanId']),
      date: serializer.fromJson<int>(json['date']),
      dayOfWeek: serializer.fromJson<int>(json['dayOfWeek']),
      isFreeDay: serializer.fromJson<bool>(json['isFreeDay']),
      batchCookingSession: serializer.fromJson<int?>(
        json['batchCookingSession'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weekPlanId': serializer.toJson<int>(weekPlanId),
      'date': serializer.toJson<int>(date),
      'dayOfWeek': serializer.toJson<int>(dayOfWeek),
      'isFreeDay': serializer.toJson<bool>(isFreeDay),
      'batchCookingSession': serializer.toJson<int?>(batchCookingSession),
    };
  }

  DayPlan copyWith({
    int? id,
    int? weekPlanId,
    int? date,
    int? dayOfWeek,
    bool? isFreeDay,
    Value<int?> batchCookingSession = const Value.absent(),
  }) => DayPlan(
    id: id ?? this.id,
    weekPlanId: weekPlanId ?? this.weekPlanId,
    date: date ?? this.date,
    dayOfWeek: dayOfWeek ?? this.dayOfWeek,
    isFreeDay: isFreeDay ?? this.isFreeDay,
    batchCookingSession: batchCookingSession.present
        ? batchCookingSession.value
        : this.batchCookingSession,
  );
  DayPlan copyWithCompanion(DayPlansCompanion data) {
    return DayPlan(
      id: data.id.present ? data.id.value : this.id,
      weekPlanId: data.weekPlanId.present
          ? data.weekPlanId.value
          : this.weekPlanId,
      date: data.date.present ? data.date.value : this.date,
      dayOfWeek: data.dayOfWeek.present ? data.dayOfWeek.value : this.dayOfWeek,
      isFreeDay: data.isFreeDay.present ? data.isFreeDay.value : this.isFreeDay,
      batchCookingSession: data.batchCookingSession.present
          ? data.batchCookingSession.value
          : this.batchCookingSession,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DayPlan(')
          ..write('id: $id, ')
          ..write('weekPlanId: $weekPlanId, ')
          ..write('date: $date, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('isFreeDay: $isFreeDay, ')
          ..write('batchCookingSession: $batchCookingSession')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    weekPlanId,
    date,
    dayOfWeek,
    isFreeDay,
    batchCookingSession,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DayPlan &&
          other.id == this.id &&
          other.weekPlanId == this.weekPlanId &&
          other.date == this.date &&
          other.dayOfWeek == this.dayOfWeek &&
          other.isFreeDay == this.isFreeDay &&
          other.batchCookingSession == this.batchCookingSession);
}

class DayPlansCompanion extends UpdateCompanion<DayPlan> {
  final Value<int> id;
  final Value<int> weekPlanId;
  final Value<int> date;
  final Value<int> dayOfWeek;
  final Value<bool> isFreeDay;
  final Value<int?> batchCookingSession;
  const DayPlansCompanion({
    this.id = const Value.absent(),
    this.weekPlanId = const Value.absent(),
    this.date = const Value.absent(),
    this.dayOfWeek = const Value.absent(),
    this.isFreeDay = const Value.absent(),
    this.batchCookingSession = const Value.absent(),
  });
  DayPlansCompanion.insert({
    this.id = const Value.absent(),
    required int weekPlanId,
    required int date,
    required int dayOfWeek,
    this.isFreeDay = const Value.absent(),
    this.batchCookingSession = const Value.absent(),
  }) : weekPlanId = Value(weekPlanId),
       date = Value(date),
       dayOfWeek = Value(dayOfWeek);
  static Insertable<DayPlan> custom({
    Expression<int>? id,
    Expression<int>? weekPlanId,
    Expression<int>? date,
    Expression<int>? dayOfWeek,
    Expression<bool>? isFreeDay,
    Expression<int>? batchCookingSession,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weekPlanId != null) 'week_plan_id': weekPlanId,
      if (date != null) 'date': date,
      if (dayOfWeek != null) 'day_of_week': dayOfWeek,
      if (isFreeDay != null) 'is_free_day': isFreeDay,
      if (batchCookingSession != null)
        'batch_cooking_session': batchCookingSession,
    });
  }

  DayPlansCompanion copyWith({
    Value<int>? id,
    Value<int>? weekPlanId,
    Value<int>? date,
    Value<int>? dayOfWeek,
    Value<bool>? isFreeDay,
    Value<int?>? batchCookingSession,
  }) {
    return DayPlansCompanion(
      id: id ?? this.id,
      weekPlanId: weekPlanId ?? this.weekPlanId,
      date: date ?? this.date,
      dayOfWeek: dayOfWeek ?? this.dayOfWeek,
      isFreeDay: isFreeDay ?? this.isFreeDay,
      batchCookingSession: batchCookingSession ?? this.batchCookingSession,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weekPlanId.present) {
      map['week_plan_id'] = Variable<int>(weekPlanId.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (dayOfWeek.present) {
      map['day_of_week'] = Variable<int>(dayOfWeek.value);
    }
    if (isFreeDay.present) {
      map['is_free_day'] = Variable<bool>(isFreeDay.value);
    }
    if (batchCookingSession.present) {
      map['batch_cooking_session'] = Variable<int>(batchCookingSession.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DayPlansCompanion(')
          ..write('id: $id, ')
          ..write('weekPlanId: $weekPlanId, ')
          ..write('date: $date, ')
          ..write('dayOfWeek: $dayOfWeek, ')
          ..write('isFreeDay: $isFreeDay, ')
          ..write('batchCookingSession: $batchCookingSession')
          ..write(')'))
        .toString();
  }
}

class $MealsTable extends Meals with TableInfo<$MealsTable, Meal> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MealsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dayPlanIdMeta = const VerificationMeta(
    'dayPlanId',
  );
  @override
  late final GeneratedColumn<int> dayPlanId = GeneratedColumn<int>(
    'day_plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES day_plans (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _mealTypeMeta = const VerificationMeta(
    'mealType',
  );
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
    'meal_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recipeIdMeta = const VerificationMeta(
    'recipeId',
  );
  @override
  late final GeneratedColumn<int> recipeId = GeneratedColumn<int>(
    'recipe_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES recipes (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _servingsMeta = const VerificationMeta(
    'servings',
  );
  @override
  late final GeneratedColumn<double> servings = GeneratedColumn<double>(
    'servings',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
    defaultValue: const Constant(1.0),
  );
  static const VerificationMeta _isConsumedMeta = const VerificationMeta(
    'isConsumed',
  );
  @override
  late final GeneratedColumn<bool> isConsumed = GeneratedColumn<bool>(
    'is_consumed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_consumed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    dayPlanId,
    mealType,
    recipeId,
    servings,
    isConsumed,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meals';
  @override
  VerificationContext validateIntegrity(
    Insertable<Meal> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('day_plan_id')) {
      context.handle(
        _dayPlanIdMeta,
        dayPlanId.isAcceptableOrUnknown(data['day_plan_id']!, _dayPlanIdMeta),
      );
    } else if (isInserting) {
      context.missing(_dayPlanIdMeta);
    }
    if (data.containsKey('meal_type')) {
      context.handle(
        _mealTypeMeta,
        mealType.isAcceptableOrUnknown(data['meal_type']!, _mealTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('recipe_id')) {
      context.handle(
        _recipeIdMeta,
        recipeId.isAcceptableOrUnknown(data['recipe_id']!, _recipeIdMeta),
      );
    } else if (isInserting) {
      context.missing(_recipeIdMeta);
    }
    if (data.containsKey('servings')) {
      context.handle(
        _servingsMeta,
        servings.isAcceptableOrUnknown(data['servings']!, _servingsMeta),
      );
    }
    if (data.containsKey('is_consumed')) {
      context.handle(
        _isConsumedMeta,
        isConsumed.isAcceptableOrUnknown(data['is_consumed']!, _isConsumedMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Meal map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Meal(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      dayPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}day_plan_id'],
      )!,
      mealType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meal_type'],
      )!,
      recipeId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}recipe_id'],
      )!,
      servings: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}servings'],
      )!,
      isConsumed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_consumed'],
      )!,
    );
  }

  @override
  $MealsTable createAlias(String alias) {
    return $MealsTable(attachedDatabase, alias);
  }
}

class Meal extends DataClass implements Insertable<Meal> {
  final int id;
  final int dayPlanId;
  final String mealType;
  final int recipeId;
  final double servings;
  final bool isConsumed;
  const Meal({
    required this.id,
    required this.dayPlanId,
    required this.mealType,
    required this.recipeId,
    required this.servings,
    required this.isConsumed,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['day_plan_id'] = Variable<int>(dayPlanId);
    map['meal_type'] = Variable<String>(mealType);
    map['recipe_id'] = Variable<int>(recipeId);
    map['servings'] = Variable<double>(servings);
    map['is_consumed'] = Variable<bool>(isConsumed);
    return map;
  }

  MealsCompanion toCompanion(bool nullToAbsent) {
    return MealsCompanion(
      id: Value(id),
      dayPlanId: Value(dayPlanId),
      mealType: Value(mealType),
      recipeId: Value(recipeId),
      servings: Value(servings),
      isConsumed: Value(isConsumed),
    );
  }

  factory Meal.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Meal(
      id: serializer.fromJson<int>(json['id']),
      dayPlanId: serializer.fromJson<int>(json['dayPlanId']),
      mealType: serializer.fromJson<String>(json['mealType']),
      recipeId: serializer.fromJson<int>(json['recipeId']),
      servings: serializer.fromJson<double>(json['servings']),
      isConsumed: serializer.fromJson<bool>(json['isConsumed']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'dayPlanId': serializer.toJson<int>(dayPlanId),
      'mealType': serializer.toJson<String>(mealType),
      'recipeId': serializer.toJson<int>(recipeId),
      'servings': serializer.toJson<double>(servings),
      'isConsumed': serializer.toJson<bool>(isConsumed),
    };
  }

  Meal copyWith({
    int? id,
    int? dayPlanId,
    String? mealType,
    int? recipeId,
    double? servings,
    bool? isConsumed,
  }) => Meal(
    id: id ?? this.id,
    dayPlanId: dayPlanId ?? this.dayPlanId,
    mealType: mealType ?? this.mealType,
    recipeId: recipeId ?? this.recipeId,
    servings: servings ?? this.servings,
    isConsumed: isConsumed ?? this.isConsumed,
  );
  Meal copyWithCompanion(MealsCompanion data) {
    return Meal(
      id: data.id.present ? data.id.value : this.id,
      dayPlanId: data.dayPlanId.present ? data.dayPlanId.value : this.dayPlanId,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      recipeId: data.recipeId.present ? data.recipeId.value : this.recipeId,
      servings: data.servings.present ? data.servings.value : this.servings,
      isConsumed: data.isConsumed.present
          ? data.isConsumed.value
          : this.isConsumed,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Meal(')
          ..write('id: $id, ')
          ..write('dayPlanId: $dayPlanId, ')
          ..write('mealType: $mealType, ')
          ..write('recipeId: $recipeId, ')
          ..write('servings: $servings, ')
          ..write('isConsumed: $isConsumed')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, dayPlanId, mealType, recipeId, servings, isConsumed);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Meal &&
          other.id == this.id &&
          other.dayPlanId == this.dayPlanId &&
          other.mealType == this.mealType &&
          other.recipeId == this.recipeId &&
          other.servings == this.servings &&
          other.isConsumed == this.isConsumed);
}

class MealsCompanion extends UpdateCompanion<Meal> {
  final Value<int> id;
  final Value<int> dayPlanId;
  final Value<String> mealType;
  final Value<int> recipeId;
  final Value<double> servings;
  final Value<bool> isConsumed;
  const MealsCompanion({
    this.id = const Value.absent(),
    this.dayPlanId = const Value.absent(),
    this.mealType = const Value.absent(),
    this.recipeId = const Value.absent(),
    this.servings = const Value.absent(),
    this.isConsumed = const Value.absent(),
  });
  MealsCompanion.insert({
    this.id = const Value.absent(),
    required int dayPlanId,
    required String mealType,
    required int recipeId,
    this.servings = const Value.absent(),
    this.isConsumed = const Value.absent(),
  }) : dayPlanId = Value(dayPlanId),
       mealType = Value(mealType),
       recipeId = Value(recipeId);
  static Insertable<Meal> custom({
    Expression<int>? id,
    Expression<int>? dayPlanId,
    Expression<String>? mealType,
    Expression<int>? recipeId,
    Expression<double>? servings,
    Expression<bool>? isConsumed,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (dayPlanId != null) 'day_plan_id': dayPlanId,
      if (mealType != null) 'meal_type': mealType,
      if (recipeId != null) 'recipe_id': recipeId,
      if (servings != null) 'servings': servings,
      if (isConsumed != null) 'is_consumed': isConsumed,
    });
  }

  MealsCompanion copyWith({
    Value<int>? id,
    Value<int>? dayPlanId,
    Value<String>? mealType,
    Value<int>? recipeId,
    Value<double>? servings,
    Value<bool>? isConsumed,
  }) {
    return MealsCompanion(
      id: id ?? this.id,
      dayPlanId: dayPlanId ?? this.dayPlanId,
      mealType: mealType ?? this.mealType,
      recipeId: recipeId ?? this.recipeId,
      servings: servings ?? this.servings,
      isConsumed: isConsumed ?? this.isConsumed,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (dayPlanId.present) {
      map['day_plan_id'] = Variable<int>(dayPlanId.value);
    }
    if (mealType.present) {
      map['meal_type'] = Variable<String>(mealType.value);
    }
    if (recipeId.present) {
      map['recipe_id'] = Variable<int>(recipeId.value);
    }
    if (servings.present) {
      map['servings'] = Variable<double>(servings.value);
    }
    if (isConsumed.present) {
      map['is_consumed'] = Variable<bool>(isConsumed.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MealsCompanion(')
          ..write('id: $id, ')
          ..write('dayPlanId: $dayPlanId, ')
          ..write('mealType: $mealType, ')
          ..write('recipeId: $recipeId, ')
          ..write('servings: $servings, ')
          ..write('isConsumed: $isConsumed')
          ..write(')'))
        .toString();
  }
}

class $ShoppingItemsTable extends ShoppingItems
    with TableInfo<$ShoppingItemsTable, ShoppingItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _weekPlanIdMeta = const VerificationMeta(
    'weekPlanId',
  );
  @override
  late final GeneratedColumn<int> weekPlanId = GeneratedColumn<int>(
    'week_plan_id',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES week_plans (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _quantityMeta = const VerificationMeta(
    'quantity',
  );
  @override
  late final GeneratedColumn<double> quantity = GeneratedColumn<double>(
    'quantity',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _unitMeta = const VerificationMeta('unit');
  @override
  late final GeneratedColumn<String> unit = GeneratedColumn<String>(
    'unit',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _supermarketSectionMeta =
      const VerificationMeta('supermarketSection');
  @override
  late final GeneratedColumn<String> supermarketSection =
      GeneratedColumn<String>(
        'supermarket_section',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _isCheckedMeta = const VerificationMeta(
    'isChecked',
  );
  @override
  late final GeneratedColumn<bool> isChecked = GeneratedColumn<bool>(
    'is_checked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_checked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isManuallyAddedMeta = const VerificationMeta(
    'isManuallyAdded',
  );
  @override
  late final GeneratedColumn<bool> isManuallyAdded = GeneratedColumn<bool>(
    'is_manually_added',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_manually_added" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sourceDetailsMeta = const VerificationMeta(
    'sourceDetails',
  );
  @override
  late final GeneratedColumn<String> sourceDetails = GeneratedColumn<String>(
    'source_details',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _tripNumberMeta = const VerificationMeta(
    'tripNumber',
  );
  @override
  late final GeneratedColumn<int> tripNumber = GeneratedColumn<int>(
    'trip_number',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    weekPlanId,
    name,
    quantity,
    unit,
    supermarketSection,
    isChecked,
    isManuallyAdded,
    sourceDetails,
    tripNumber,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<ShoppingItem> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('week_plan_id')) {
      context.handle(
        _weekPlanIdMeta,
        weekPlanId.isAcceptableOrUnknown(
          data['week_plan_id']!,
          _weekPlanIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_weekPlanIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(
        _quantityMeta,
        quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta),
      );
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('unit')) {
      context.handle(
        _unitMeta,
        unit.isAcceptableOrUnknown(data['unit']!, _unitMeta),
      );
    } else if (isInserting) {
      context.missing(_unitMeta);
    }
    if (data.containsKey('supermarket_section')) {
      context.handle(
        _supermarketSectionMeta,
        supermarketSection.isAcceptableOrUnknown(
          data['supermarket_section']!,
          _supermarketSectionMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_supermarketSectionMeta);
    }
    if (data.containsKey('is_checked')) {
      context.handle(
        _isCheckedMeta,
        isChecked.isAcceptableOrUnknown(data['is_checked']!, _isCheckedMeta),
      );
    }
    if (data.containsKey('is_manually_added')) {
      context.handle(
        _isManuallyAddedMeta,
        isManuallyAdded.isAcceptableOrUnknown(
          data['is_manually_added']!,
          _isManuallyAddedMeta,
        ),
      );
    }
    if (data.containsKey('source_details')) {
      context.handle(
        _sourceDetailsMeta,
        sourceDetails.isAcceptableOrUnknown(
          data['source_details']!,
          _sourceDetailsMeta,
        ),
      );
    }
    if (data.containsKey('trip_number')) {
      context.handle(
        _tripNumberMeta,
        tripNumber.isAcceptableOrUnknown(data['trip_number']!, _tripNumberMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingItem(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      weekPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}week_plan_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      quantity: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}quantity'],
      )!,
      unit: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}unit'],
      )!,
      supermarketSection: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}supermarket_section'],
      )!,
      isChecked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_checked'],
      )!,
      isManuallyAdded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_manually_added'],
      )!,
      sourceDetails: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}source_details'],
      )!,
      tripNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}trip_number'],
      )!,
    );
  }

  @override
  $ShoppingItemsTable createAlias(String alias) {
    return $ShoppingItemsTable(attachedDatabase, alias);
  }
}

class ShoppingItem extends DataClass implements Insertable<ShoppingItem> {
  final int id;
  final int weekPlanId;
  final String name;
  final double quantity;
  final String unit;
  final String supermarketSection;
  final bool isChecked;
  final bool isManuallyAdded;
  final String sourceDetails;
  final int tripNumber;
  const ShoppingItem({
    required this.id,
    required this.weekPlanId,
    required this.name,
    required this.quantity,
    required this.unit,
    required this.supermarketSection,
    required this.isChecked,
    required this.isManuallyAdded,
    required this.sourceDetails,
    required this.tripNumber,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['week_plan_id'] = Variable<int>(weekPlanId);
    map['name'] = Variable<String>(name);
    map['quantity'] = Variable<double>(quantity);
    map['unit'] = Variable<String>(unit);
    map['supermarket_section'] = Variable<String>(supermarketSection);
    map['is_checked'] = Variable<bool>(isChecked);
    map['is_manually_added'] = Variable<bool>(isManuallyAdded);
    map['source_details'] = Variable<String>(sourceDetails);
    map['trip_number'] = Variable<int>(tripNumber);
    return map;
  }

  ShoppingItemsCompanion toCompanion(bool nullToAbsent) {
    return ShoppingItemsCompanion(
      id: Value(id),
      weekPlanId: Value(weekPlanId),
      name: Value(name),
      quantity: Value(quantity),
      unit: Value(unit),
      supermarketSection: Value(supermarketSection),
      isChecked: Value(isChecked),
      isManuallyAdded: Value(isManuallyAdded),
      sourceDetails: Value(sourceDetails),
      tripNumber: Value(tripNumber),
    );
  }

  factory ShoppingItem.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingItem(
      id: serializer.fromJson<int>(json['id']),
      weekPlanId: serializer.fromJson<int>(json['weekPlanId']),
      name: serializer.fromJson<String>(json['name']),
      quantity: serializer.fromJson<double>(json['quantity']),
      unit: serializer.fromJson<String>(json['unit']),
      supermarketSection: serializer.fromJson<String>(
        json['supermarketSection'],
      ),
      isChecked: serializer.fromJson<bool>(json['isChecked']),
      isManuallyAdded: serializer.fromJson<bool>(json['isManuallyAdded']),
      sourceDetails: serializer.fromJson<String>(json['sourceDetails']),
      tripNumber: serializer.fromJson<int>(json['tripNumber']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'weekPlanId': serializer.toJson<int>(weekPlanId),
      'name': serializer.toJson<String>(name),
      'quantity': serializer.toJson<double>(quantity),
      'unit': serializer.toJson<String>(unit),
      'supermarketSection': serializer.toJson<String>(supermarketSection),
      'isChecked': serializer.toJson<bool>(isChecked),
      'isManuallyAdded': serializer.toJson<bool>(isManuallyAdded),
      'sourceDetails': serializer.toJson<String>(sourceDetails),
      'tripNumber': serializer.toJson<int>(tripNumber),
    };
  }

  ShoppingItem copyWith({
    int? id,
    int? weekPlanId,
    String? name,
    double? quantity,
    String? unit,
    String? supermarketSection,
    bool? isChecked,
    bool? isManuallyAdded,
    String? sourceDetails,
    int? tripNumber,
  }) => ShoppingItem(
    id: id ?? this.id,
    weekPlanId: weekPlanId ?? this.weekPlanId,
    name: name ?? this.name,
    quantity: quantity ?? this.quantity,
    unit: unit ?? this.unit,
    supermarketSection: supermarketSection ?? this.supermarketSection,
    isChecked: isChecked ?? this.isChecked,
    isManuallyAdded: isManuallyAdded ?? this.isManuallyAdded,
    sourceDetails: sourceDetails ?? this.sourceDetails,
    tripNumber: tripNumber ?? this.tripNumber,
  );
  ShoppingItem copyWithCompanion(ShoppingItemsCompanion data) {
    return ShoppingItem(
      id: data.id.present ? data.id.value : this.id,
      weekPlanId: data.weekPlanId.present
          ? data.weekPlanId.value
          : this.weekPlanId,
      name: data.name.present ? data.name.value : this.name,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      unit: data.unit.present ? data.unit.value : this.unit,
      supermarketSection: data.supermarketSection.present
          ? data.supermarketSection.value
          : this.supermarketSection,
      isChecked: data.isChecked.present ? data.isChecked.value : this.isChecked,
      isManuallyAdded: data.isManuallyAdded.present
          ? data.isManuallyAdded.value
          : this.isManuallyAdded,
      sourceDetails: data.sourceDetails.present
          ? data.sourceDetails.value
          : this.sourceDetails,
      tripNumber: data.tripNumber.present
          ? data.tripNumber.value
          : this.tripNumber,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItem(')
          ..write('id: $id, ')
          ..write('weekPlanId: $weekPlanId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('supermarketSection: $supermarketSection, ')
          ..write('isChecked: $isChecked, ')
          ..write('isManuallyAdded: $isManuallyAdded, ')
          ..write('sourceDetails: $sourceDetails, ')
          ..write('tripNumber: $tripNumber')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    weekPlanId,
    name,
    quantity,
    unit,
    supermarketSection,
    isChecked,
    isManuallyAdded,
    sourceDetails,
    tripNumber,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingItem &&
          other.id == this.id &&
          other.weekPlanId == this.weekPlanId &&
          other.name == this.name &&
          other.quantity == this.quantity &&
          other.unit == this.unit &&
          other.supermarketSection == this.supermarketSection &&
          other.isChecked == this.isChecked &&
          other.isManuallyAdded == this.isManuallyAdded &&
          other.sourceDetails == this.sourceDetails &&
          other.tripNumber == this.tripNumber);
}

class ShoppingItemsCompanion extends UpdateCompanion<ShoppingItem> {
  final Value<int> id;
  final Value<int> weekPlanId;
  final Value<String> name;
  final Value<double> quantity;
  final Value<String> unit;
  final Value<String> supermarketSection;
  final Value<bool> isChecked;
  final Value<bool> isManuallyAdded;
  final Value<String> sourceDetails;
  final Value<int> tripNumber;
  const ShoppingItemsCompanion({
    this.id = const Value.absent(),
    this.weekPlanId = const Value.absent(),
    this.name = const Value.absent(),
    this.quantity = const Value.absent(),
    this.unit = const Value.absent(),
    this.supermarketSection = const Value.absent(),
    this.isChecked = const Value.absent(),
    this.isManuallyAdded = const Value.absent(),
    this.sourceDetails = const Value.absent(),
    this.tripNumber = const Value.absent(),
  });
  ShoppingItemsCompanion.insert({
    this.id = const Value.absent(),
    required int weekPlanId,
    required String name,
    required double quantity,
    required String unit,
    required String supermarketSection,
    this.isChecked = const Value.absent(),
    this.isManuallyAdded = const Value.absent(),
    this.sourceDetails = const Value.absent(),
    this.tripNumber = const Value.absent(),
  }) : weekPlanId = Value(weekPlanId),
       name = Value(name),
       quantity = Value(quantity),
       unit = Value(unit),
       supermarketSection = Value(supermarketSection);
  static Insertable<ShoppingItem> custom({
    Expression<int>? id,
    Expression<int>? weekPlanId,
    Expression<String>? name,
    Expression<double>? quantity,
    Expression<String>? unit,
    Expression<String>? supermarketSection,
    Expression<bool>? isChecked,
    Expression<bool>? isManuallyAdded,
    Expression<String>? sourceDetails,
    Expression<int>? tripNumber,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (weekPlanId != null) 'week_plan_id': weekPlanId,
      if (name != null) 'name': name,
      if (quantity != null) 'quantity': quantity,
      if (unit != null) 'unit': unit,
      if (supermarketSection != null) 'supermarket_section': supermarketSection,
      if (isChecked != null) 'is_checked': isChecked,
      if (isManuallyAdded != null) 'is_manually_added': isManuallyAdded,
      if (sourceDetails != null) 'source_details': sourceDetails,
      if (tripNumber != null) 'trip_number': tripNumber,
    });
  }

  ShoppingItemsCompanion copyWith({
    Value<int>? id,
    Value<int>? weekPlanId,
    Value<String>? name,
    Value<double>? quantity,
    Value<String>? unit,
    Value<String>? supermarketSection,
    Value<bool>? isChecked,
    Value<bool>? isManuallyAdded,
    Value<String>? sourceDetails,
    Value<int>? tripNumber,
  }) {
    return ShoppingItemsCompanion(
      id: id ?? this.id,
      weekPlanId: weekPlanId ?? this.weekPlanId,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      supermarketSection: supermarketSection ?? this.supermarketSection,
      isChecked: isChecked ?? this.isChecked,
      isManuallyAdded: isManuallyAdded ?? this.isManuallyAdded,
      sourceDetails: sourceDetails ?? this.sourceDetails,
      tripNumber: tripNumber ?? this.tripNumber,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (weekPlanId.present) {
      map['week_plan_id'] = Variable<int>(weekPlanId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<double>(quantity.value);
    }
    if (unit.present) {
      map['unit'] = Variable<String>(unit.value);
    }
    if (supermarketSection.present) {
      map['supermarket_section'] = Variable<String>(supermarketSection.value);
    }
    if (isChecked.present) {
      map['is_checked'] = Variable<bool>(isChecked.value);
    }
    if (isManuallyAdded.present) {
      map['is_manually_added'] = Variable<bool>(isManuallyAdded.value);
    }
    if (sourceDetails.present) {
      map['source_details'] = Variable<String>(sourceDetails.value);
    }
    if (tripNumber.present) {
      map['trip_number'] = Variable<int>(tripNumber.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingItemsCompanion(')
          ..write('id: $id, ')
          ..write('weekPlanId: $weekPlanId, ')
          ..write('name: $name, ')
          ..write('quantity: $quantity, ')
          ..write('unit: $unit, ')
          ..write('supermarketSection: $supermarketSection, ')
          ..write('isChecked: $isChecked, ')
          ..write('isManuallyAdded: $isManuallyAdded, ')
          ..write('sourceDetails: $sourceDetails, ')
          ..write('tripNumber: $tripNumber')
          ..write(')'))
        .toString();
  }
}

class $WeightLogsTable extends WeightLogs
    with TableInfo<$WeightLogsTable, WeightLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WeightLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<int> date = GeneratedColumn<int>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways('UNIQUE'),
  );
  static const VerificationMeta _weightKgMeta = const VerificationMeta(
    'weightKg',
  );
  @override
  late final GeneratedColumn<double> weightKg = GeneratedColumn<double>(
    'weight_kg',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<int> createdAt = GeneratedColumn<int>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, date, weightKg, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'weight_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<WeightLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('weight_kg')) {
      context.handle(
        _weightKgMeta,
        weightKg.isAcceptableOrUnknown(data['weight_kg']!, _weightKgMeta),
      );
    } else if (isInserting) {
      context.missing(_weightKgMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  WeightLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WeightLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}date'],
      )!,
      weightKg: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}weight_kg'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $WeightLogsTable createAlias(String alias) {
    return $WeightLogsTable(attachedDatabase, alias);
  }
}

class WeightLog extends DataClass implements Insertable<WeightLog> {
  final int id;
  final int date;
  final double weightKg;
  final int createdAt;
  const WeightLog({
    required this.id,
    required this.date,
    required this.weightKg,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['date'] = Variable<int>(date);
    map['weight_kg'] = Variable<double>(weightKg);
    map['created_at'] = Variable<int>(createdAt);
    return map;
  }

  WeightLogsCompanion toCompanion(bool nullToAbsent) {
    return WeightLogsCompanion(
      id: Value(id),
      date: Value(date),
      weightKg: Value(weightKg),
      createdAt: Value(createdAt),
    );
  }

  factory WeightLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WeightLog(
      id: serializer.fromJson<int>(json['id']),
      date: serializer.fromJson<int>(json['date']),
      weightKg: serializer.fromJson<double>(json['weightKg']),
      createdAt: serializer.fromJson<int>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'date': serializer.toJson<int>(date),
      'weightKg': serializer.toJson<double>(weightKg),
      'createdAt': serializer.toJson<int>(createdAt),
    };
  }

  WeightLog copyWith({int? id, int? date, double? weightKg, int? createdAt}) =>
      WeightLog(
        id: id ?? this.id,
        date: date ?? this.date,
        weightKg: weightKg ?? this.weightKg,
        createdAt: createdAt ?? this.createdAt,
      );
  WeightLog copyWithCompanion(WeightLogsCompanion data) {
    return WeightLog(
      id: data.id.present ? data.id.value : this.id,
      date: data.date.present ? data.date.value : this.date,
      weightKg: data.weightKg.present ? data.weightKg.value : this.weightKg,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WeightLog(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, date, weightKg, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WeightLog &&
          other.id == this.id &&
          other.date == this.date &&
          other.weightKg == this.weightKg &&
          other.createdAt == this.createdAt);
}

class WeightLogsCompanion extends UpdateCompanion<WeightLog> {
  final Value<int> id;
  final Value<int> date;
  final Value<double> weightKg;
  final Value<int> createdAt;
  const WeightLogsCompanion({
    this.id = const Value.absent(),
    this.date = const Value.absent(),
    this.weightKg = const Value.absent(),
    this.createdAt = const Value.absent(),
  });
  WeightLogsCompanion.insert({
    this.id = const Value.absent(),
    required int date,
    required double weightKg,
    required int createdAt,
  }) : date = Value(date),
       weightKg = Value(weightKg),
       createdAt = Value(createdAt);
  static Insertable<WeightLog> custom({
    Expression<int>? id,
    Expression<int>? date,
    Expression<double>? weightKg,
    Expression<int>? createdAt,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (date != null) 'date': date,
      if (weightKg != null) 'weight_kg': weightKg,
      if (createdAt != null) 'created_at': createdAt,
    });
  }

  WeightLogsCompanion copyWith({
    Value<int>? id,
    Value<int>? date,
    Value<double>? weightKg,
    Value<int>? createdAt,
  }) {
    return WeightLogsCompanion(
      id: id ?? this.id,
      date: date ?? this.date,
      weightKg: weightKg ?? this.weightKg,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (date.present) {
      map['date'] = Variable<int>(date.value);
    }
    if (weightKg.present) {
      map['weight_kg'] = Variable<double>(weightKg.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<int>(createdAt.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WeightLogsCompanion(')
          ..write('id: $id, ')
          ..write('date: $date, ')
          ..write('weightKg: $weightKg, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $UserProfilesTable userProfiles = $UserProfilesTable(this);
  late final $RecipesTable recipes = $RecipesTable(this);
  late final $RecipeStepsTable recipeSteps = $RecipeStepsTable(this);
  late final $IngredientsTable ingredients = $IngredientsTable(this);
  late final $WeekPlansTable weekPlans = $WeekPlansTable(this);
  late final $DayPlansTable dayPlans = $DayPlansTable(this);
  late final $MealsTable meals = $MealsTable(this);
  late final $ShoppingItemsTable shoppingItems = $ShoppingItemsTable(this);
  late final $WeightLogsTable weightLogs = $WeightLogsTable(this);
  late final Index idxRecipeStepsRecipe = Index(
    'idx_recipe_steps_recipe',
    'CREATE INDEX idx_recipe_steps_recipe ON recipe_steps (recipe_id)',
  );
  late final Index idxIngredientsRecipe = Index(
    'idx_ingredients_recipe',
    'CREATE INDEX idx_ingredients_recipe ON ingredients (recipe_id)',
  );
  late final Index idxDayPlansWeekDate = Index(
    'idx_day_plans_week_date',
    'CREATE INDEX idx_day_plans_week_date ON day_plans (week_plan_id, date)',
  );
  late final Index idxMealsDayPlan = Index(
    'idx_meals_day_plan',
    'CREATE INDEX idx_meals_day_plan ON meals (day_plan_id)',
  );
  late final Index idxShoppingItemsWeek = Index(
    'idx_shopping_items_week',
    'CREATE INDEX idx_shopping_items_week ON shopping_items (week_plan_id)',
  );
  late final UserProfileDao userProfileDao = UserProfileDao(
    this as AppDatabase,
  );
  late final RecipeDao recipeDao = RecipeDao(this as AppDatabase);
  late final WeekPlanDao weekPlanDao = WeekPlanDao(this as AppDatabase);
  late final DayPlanDao dayPlanDao = DayPlanDao(this as AppDatabase);
  late final MealDao mealDao = MealDao(this as AppDatabase);
  late final ShoppingItemDao shoppingItemDao = ShoppingItemDao(
    this as AppDatabase,
  );
  late final WeightLogDao weightLogDao = WeightLogDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    userProfiles,
    recipes,
    recipeSteps,
    ingredients,
    weekPlans,
    dayPlans,
    meals,
    shoppingItems,
    weightLogs,
    idxRecipeStepsRecipe,
    idxIngredientsRecipe,
    idxDayPlansWeekDate,
    idxMealsDayPlan,
    idxShoppingItemsWeek,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recipes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('recipe_steps', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recipes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('ingredients', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'week_plans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('day_plans', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'day_plans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('meals', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'recipes',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('meals', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'week_plans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('shopping_items', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$UserProfilesTableCreateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      required String name,
      required int age,
      required String sex,
      required int heightCm,
      required double weightKg,
      required double targetWeightKg,
      required String lossPace,
      required String activityLevel,
      required int dietDaysPerWeek,
      required int batchCookingSessionsPerWeek,
      required int shoppingTripsPerWeek,
      Value<String> dietType,
      Value<int> distinctBreakfasts,
      Value<int> distinctLunches,
      Value<int> distinctDinners,
      Value<int> distinctSnacks,
      required String allergies,
      required String customAllergies,
      required int dailyCalorieTarget,
      Value<int> dailyWaterMl,
      Value<String> enabledMealTypes,
      required int dietStartDate,
      Value<String> freeDays,
      Value<bool> batchCookingBeforeDiet,
      Value<String> excludedMeats,
      Value<bool> economicMode,
      Value<bool> onboardingCompleted,
      required int createdAt,
    });
typedef $$UserProfilesTableUpdateCompanionBuilder =
    UserProfilesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<int> age,
      Value<String> sex,
      Value<int> heightCm,
      Value<double> weightKg,
      Value<double> targetWeightKg,
      Value<String> lossPace,
      Value<String> activityLevel,
      Value<int> dietDaysPerWeek,
      Value<int> batchCookingSessionsPerWeek,
      Value<int> shoppingTripsPerWeek,
      Value<String> dietType,
      Value<int> distinctBreakfasts,
      Value<int> distinctLunches,
      Value<int> distinctDinners,
      Value<int> distinctSnacks,
      Value<String> allergies,
      Value<String> customAllergies,
      Value<int> dailyCalorieTarget,
      Value<int> dailyWaterMl,
      Value<String> enabledMealTypes,
      Value<int> dietStartDate,
      Value<String> freeDays,
      Value<bool> batchCookingBeforeDiet,
      Value<String> excludedMeats,
      Value<bool> economicMode,
      Value<bool> onboardingCompleted,
      Value<int> createdAt,
    });

class $$UserProfilesTableFilterComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get lossPace => $composableBuilder(
    column: $table.lossPace,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dietDaysPerWeek => $composableBuilder(
    column: $table.dietDaysPerWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get batchCookingSessionsPerWeek => $composableBuilder(
    column: $table.batchCookingSessionsPerWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get shoppingTripsPerWeek => $composableBuilder(
    column: $table.shoppingTripsPerWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dietType => $composableBuilder(
    column: $table.dietType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get distinctBreakfasts => $composableBuilder(
    column: $table.distinctBreakfasts,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get distinctLunches => $composableBuilder(
    column: $table.distinctLunches,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get distinctDinners => $composableBuilder(
    column: $table.distinctDinners,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get distinctSnacks => $composableBuilder(
    column: $table.distinctSnacks,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get customAllergies => $composableBuilder(
    column: $table.customAllergies,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyCalorieTarget => $composableBuilder(
    column: $table.dailyCalorieTarget,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyWaterMl => $composableBuilder(
    column: $table.dailyWaterMl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get enabledMealTypes => $composableBuilder(
    column: $table.enabledMealTypes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dietStartDate => $composableBuilder(
    column: $table.dietStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get freeDays => $composableBuilder(
    column: $table.freeDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get batchCookingBeforeDiet => $composableBuilder(
    column: $table.batchCookingBeforeDiet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get excludedMeats => $composableBuilder(
    column: $table.excludedMeats,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get economicMode => $composableBuilder(
    column: $table.economicMode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$UserProfilesTableOrderingComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get age => $composableBuilder(
    column: $table.age,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sex => $composableBuilder(
    column: $table.sex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get heightCm => $composableBuilder(
    column: $table.heightCm,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get lossPace => $composableBuilder(
    column: $table.lossPace,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dietDaysPerWeek => $composableBuilder(
    column: $table.dietDaysPerWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get batchCookingSessionsPerWeek => $composableBuilder(
    column: $table.batchCookingSessionsPerWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get shoppingTripsPerWeek => $composableBuilder(
    column: $table.shoppingTripsPerWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dietType => $composableBuilder(
    column: $table.dietType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get distinctBreakfasts => $composableBuilder(
    column: $table.distinctBreakfasts,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get distinctLunches => $composableBuilder(
    column: $table.distinctLunches,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get distinctDinners => $composableBuilder(
    column: $table.distinctDinners,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get distinctSnacks => $composableBuilder(
    column: $table.distinctSnacks,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergies => $composableBuilder(
    column: $table.allergies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get customAllergies => $composableBuilder(
    column: $table.customAllergies,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyCalorieTarget => $composableBuilder(
    column: $table.dailyCalorieTarget,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyWaterMl => $composableBuilder(
    column: $table.dailyWaterMl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get enabledMealTypes => $composableBuilder(
    column: $table.enabledMealTypes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dietStartDate => $composableBuilder(
    column: $table.dietStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get freeDays => $composableBuilder(
    column: $table.freeDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get batchCookingBeforeDiet => $composableBuilder(
    column: $table.batchCookingBeforeDiet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get excludedMeats => $composableBuilder(
    column: $table.excludedMeats,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get economicMode => $composableBuilder(
    column: $table.economicMode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$UserProfilesTableAnnotationComposer
    extends Composer<_$AppDatabase, $UserProfilesTable> {
  $$UserProfilesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get age =>
      $composableBuilder(column: $table.age, builder: (column) => column);

  GeneratedColumn<String> get sex =>
      $composableBuilder(column: $table.sex, builder: (column) => column);

  GeneratedColumn<int> get heightCm =>
      $composableBuilder(column: $table.heightCm, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<double> get targetWeightKg => $composableBuilder(
    column: $table.targetWeightKg,
    builder: (column) => column,
  );

  GeneratedColumn<String> get lossPace =>
      $composableBuilder(column: $table.lossPace, builder: (column) => column);

  GeneratedColumn<String> get activityLevel => $composableBuilder(
    column: $table.activityLevel,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dietDaysPerWeek => $composableBuilder(
    column: $table.dietDaysPerWeek,
    builder: (column) => column,
  );

  GeneratedColumn<int> get batchCookingSessionsPerWeek => $composableBuilder(
    column: $table.batchCookingSessionsPerWeek,
    builder: (column) => column,
  );

  GeneratedColumn<int> get shoppingTripsPerWeek => $composableBuilder(
    column: $table.shoppingTripsPerWeek,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dietType =>
      $composableBuilder(column: $table.dietType, builder: (column) => column);

  GeneratedColumn<int> get distinctBreakfasts => $composableBuilder(
    column: $table.distinctBreakfasts,
    builder: (column) => column,
  );

  GeneratedColumn<int> get distinctLunches => $composableBuilder(
    column: $table.distinctLunches,
    builder: (column) => column,
  );

  GeneratedColumn<int> get distinctDinners => $composableBuilder(
    column: $table.distinctDinners,
    builder: (column) => column,
  );

  GeneratedColumn<int> get distinctSnacks => $composableBuilder(
    column: $table.distinctSnacks,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allergies =>
      $composableBuilder(column: $table.allergies, builder: (column) => column);

  GeneratedColumn<String> get customAllergies => $composableBuilder(
    column: $table.customAllergies,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyCalorieTarget => $composableBuilder(
    column: $table.dailyCalorieTarget,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyWaterMl => $composableBuilder(
    column: $table.dailyWaterMl,
    builder: (column) => column,
  );

  GeneratedColumn<String> get enabledMealTypes => $composableBuilder(
    column: $table.enabledMealTypes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dietStartDate => $composableBuilder(
    column: $table.dietStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<String> get freeDays =>
      $composableBuilder(column: $table.freeDays, builder: (column) => column);

  GeneratedColumn<bool> get batchCookingBeforeDiet => $composableBuilder(
    column: $table.batchCookingBeforeDiet,
    builder: (column) => column,
  );

  GeneratedColumn<String> get excludedMeats => $composableBuilder(
    column: $table.excludedMeats,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get economicMode => $composableBuilder(
    column: $table.economicMode,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboardingCompleted => $composableBuilder(
    column: $table.onboardingCompleted,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$UserProfilesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $UserProfilesTable,
          UserProfile,
          $$UserProfilesTableFilterComposer,
          $$UserProfilesTableOrderingComposer,
          $$UserProfilesTableAnnotationComposer,
          $$UserProfilesTableCreateCompanionBuilder,
          $$UserProfilesTableUpdateCompanionBuilder,
          (
            UserProfile,
            BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
          ),
          UserProfile,
          PrefetchHooks Function()
        > {
  $$UserProfilesTableTableManager(_$AppDatabase db, $UserProfilesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$UserProfilesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$UserProfilesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$UserProfilesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> age = const Value.absent(),
                Value<String> sex = const Value.absent(),
                Value<int> heightCm = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<double> targetWeightKg = const Value.absent(),
                Value<String> lossPace = const Value.absent(),
                Value<String> activityLevel = const Value.absent(),
                Value<int> dietDaysPerWeek = const Value.absent(),
                Value<int> batchCookingSessionsPerWeek = const Value.absent(),
                Value<int> shoppingTripsPerWeek = const Value.absent(),
                Value<String> dietType = const Value.absent(),
                Value<int> distinctBreakfasts = const Value.absent(),
                Value<int> distinctLunches = const Value.absent(),
                Value<int> distinctDinners = const Value.absent(),
                Value<int> distinctSnacks = const Value.absent(),
                Value<String> allergies = const Value.absent(),
                Value<String> customAllergies = const Value.absent(),
                Value<int> dailyCalorieTarget = const Value.absent(),
                Value<int> dailyWaterMl = const Value.absent(),
                Value<String> enabledMealTypes = const Value.absent(),
                Value<int> dietStartDate = const Value.absent(),
                Value<String> freeDays = const Value.absent(),
                Value<bool> batchCookingBeforeDiet = const Value.absent(),
                Value<String> excludedMeats = const Value.absent(),
                Value<bool> economicMode = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => UserProfilesCompanion(
                id: id,
                name: name,
                age: age,
                sex: sex,
                heightCm: heightCm,
                weightKg: weightKg,
                targetWeightKg: targetWeightKg,
                lossPace: lossPace,
                activityLevel: activityLevel,
                dietDaysPerWeek: dietDaysPerWeek,
                batchCookingSessionsPerWeek: batchCookingSessionsPerWeek,
                shoppingTripsPerWeek: shoppingTripsPerWeek,
                dietType: dietType,
                distinctBreakfasts: distinctBreakfasts,
                distinctLunches: distinctLunches,
                distinctDinners: distinctDinners,
                distinctSnacks: distinctSnacks,
                allergies: allergies,
                customAllergies: customAllergies,
                dailyCalorieTarget: dailyCalorieTarget,
                dailyWaterMl: dailyWaterMl,
                enabledMealTypes: enabledMealTypes,
                dietStartDate: dietStartDate,
                freeDays: freeDays,
                batchCookingBeforeDiet: batchCookingBeforeDiet,
                excludedMeats: excludedMeats,
                economicMode: economicMode,
                onboardingCompleted: onboardingCompleted,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required int age,
                required String sex,
                required int heightCm,
                required double weightKg,
                required double targetWeightKg,
                required String lossPace,
                required String activityLevel,
                required int dietDaysPerWeek,
                required int batchCookingSessionsPerWeek,
                required int shoppingTripsPerWeek,
                Value<String> dietType = const Value.absent(),
                Value<int> distinctBreakfasts = const Value.absent(),
                Value<int> distinctLunches = const Value.absent(),
                Value<int> distinctDinners = const Value.absent(),
                Value<int> distinctSnacks = const Value.absent(),
                required String allergies,
                required String customAllergies,
                required int dailyCalorieTarget,
                Value<int> dailyWaterMl = const Value.absent(),
                Value<String> enabledMealTypes = const Value.absent(),
                required int dietStartDate,
                Value<String> freeDays = const Value.absent(),
                Value<bool> batchCookingBeforeDiet = const Value.absent(),
                Value<String> excludedMeats = const Value.absent(),
                Value<bool> economicMode = const Value.absent(),
                Value<bool> onboardingCompleted = const Value.absent(),
                required int createdAt,
              }) => UserProfilesCompanion.insert(
                id: id,
                name: name,
                age: age,
                sex: sex,
                heightCm: heightCm,
                weightKg: weightKg,
                targetWeightKg: targetWeightKg,
                lossPace: lossPace,
                activityLevel: activityLevel,
                dietDaysPerWeek: dietDaysPerWeek,
                batchCookingSessionsPerWeek: batchCookingSessionsPerWeek,
                shoppingTripsPerWeek: shoppingTripsPerWeek,
                dietType: dietType,
                distinctBreakfasts: distinctBreakfasts,
                distinctLunches: distinctLunches,
                distinctDinners: distinctDinners,
                distinctSnacks: distinctSnacks,
                allergies: allergies,
                customAllergies: customAllergies,
                dailyCalorieTarget: dailyCalorieTarget,
                dailyWaterMl: dailyWaterMl,
                enabledMealTypes: enabledMealTypes,
                dietStartDate: dietStartDate,
                freeDays: freeDays,
                batchCookingBeforeDiet: batchCookingBeforeDiet,
                excludedMeats: excludedMeats,
                economicMode: economicMode,
                onboardingCompleted: onboardingCompleted,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$UserProfilesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $UserProfilesTable,
      UserProfile,
      $$UserProfilesTableFilterComposer,
      $$UserProfilesTableOrderingComposer,
      $$UserProfilesTableAnnotationComposer,
      $$UserProfilesTableCreateCompanionBuilder,
      $$UserProfilesTableUpdateCompanionBuilder,
      (
        UserProfile,
        BaseReferences<_$AppDatabase, $UserProfilesTable, UserProfile>,
      ),
      UserProfile,
      PrefetchHooks Function()
    >;
typedef $$RecipesTableCreateCompanionBuilder =
    RecipesCompanion Function({
      Value<int> id,
      required String name,
      required String description,
      required String category,
      required int caloriesPerServing,
      required double proteinGrams,
      required double carbsGrams,
      required double fatGrams,
      required int servings,
      required int prepTimeMinutes,
      required int cookTimeMinutes,
      required bool isBatchFriendly,
      required String allergens,
      Value<String> difficulty,
      Value<String> dietType,
      Value<String> meatTypes,
    });
typedef $$RecipesTableUpdateCompanionBuilder =
    RecipesCompanion Function({
      Value<int> id,
      Value<String> name,
      Value<String> description,
      Value<String> category,
      Value<int> caloriesPerServing,
      Value<double> proteinGrams,
      Value<double> carbsGrams,
      Value<double> fatGrams,
      Value<int> servings,
      Value<int> prepTimeMinutes,
      Value<int> cookTimeMinutes,
      Value<bool> isBatchFriendly,
      Value<String> allergens,
      Value<String> difficulty,
      Value<String> dietType,
      Value<String> meatTypes,
    });

final class $$RecipesTableReferences
    extends BaseReferences<_$AppDatabase, $RecipesTable, Recipe> {
  $$RecipesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$RecipeStepsTable, List<RecipeStep>>
  _recipeStepsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recipeSteps,
    aliasName: $_aliasNameGenerator(db.recipes.id, db.recipeSteps.recipeId),
  );

  $$RecipeStepsTableProcessedTableManager get recipeStepsRefs {
    final manager = $$RecipeStepsTableTableManager(
      $_db,
      $_db.recipeSteps,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_recipeStepsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IngredientsTable, List<Ingredient>>
  _ingredientsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.ingredients,
    aliasName: $_aliasNameGenerator(db.recipes.id, db.ingredients.recipeId),
  );

  $$IngredientsTableProcessedTableManager get ingredientsRefs {
    final manager = $$IngredientsTableTableManager(
      $_db,
      $_db.ingredients,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_ingredientsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$MealsTable, List<Meal>> _mealsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.meals,
    aliasName: $_aliasNameGenerator(db.recipes.id, db.meals.recipeId),
  );

  $$MealsTableProcessedTableManager get mealsRefs {
    final manager = $$MealsTableTableManager(
      $_db,
      $_db.meals,
    ).filter((f) => f.recipeId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecipesTableFilterComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get caloriesPerServing => $composableBuilder(
    column: $table.caloriesPerServing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get fatGrams => $composableBuilder(
    column: $table.fatGrams,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get prepTimeMinutes => $composableBuilder(
    column: $table.prepTimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get cookTimeMinutes => $composableBuilder(
    column: $table.cookTimeMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isBatchFriendly => $composableBuilder(
    column: $table.isBatchFriendly,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get allergens => $composableBuilder(
    column: $table.allergens,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get dietType => $composableBuilder(
    column: $table.dietType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meatTypes => $composableBuilder(
    column: $table.meatTypes,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> recipeStepsRefs(
    Expression<bool> Function($$RecipeStepsTableFilterComposer f) f,
  ) {
    final $$RecipeStepsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeSteps,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeStepsTableFilterComposer(
            $db: $db,
            $table: $db.recipeSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> ingredientsRefs(
    Expression<bool> Function($$IngredientsTableFilterComposer f) f,
  ) {
    final $$IngredientsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableFilterComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> mealsRefs(
    Expression<bool> Function($$MealsTableFilterComposer f) f,
  ) {
    final $$MealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableFilterComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get category => $composableBuilder(
    column: $table.category,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get caloriesPerServing => $composableBuilder(
    column: $table.caloriesPerServing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get fatGrams => $composableBuilder(
    column: $table.fatGrams,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get prepTimeMinutes => $composableBuilder(
    column: $table.prepTimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get cookTimeMinutes => $composableBuilder(
    column: $table.cookTimeMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isBatchFriendly => $composableBuilder(
    column: $table.isBatchFriendly,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get allergens => $composableBuilder(
    column: $table.allergens,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get dietType => $composableBuilder(
    column: $table.dietType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meatTypes => $composableBuilder(
    column: $table.meatTypes,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$RecipesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipesTable> {
  $$RecipesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<int> get caloriesPerServing => $composableBuilder(
    column: $table.caloriesPerServing,
    builder: (column) => column,
  );

  GeneratedColumn<double> get proteinGrams => $composableBuilder(
    column: $table.proteinGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get carbsGrams => $composableBuilder(
    column: $table.carbsGrams,
    builder: (column) => column,
  );

  GeneratedColumn<double> get fatGrams =>
      $composableBuilder(column: $table.fatGrams, builder: (column) => column);

  GeneratedColumn<int> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<int> get prepTimeMinutes => $composableBuilder(
    column: $table.prepTimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<int> get cookTimeMinutes => $composableBuilder(
    column: $table.cookTimeMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isBatchFriendly => $composableBuilder(
    column: $table.isBatchFriendly,
    builder: (column) => column,
  );

  GeneratedColumn<String> get allergens =>
      $composableBuilder(column: $table.allergens, builder: (column) => column);

  GeneratedColumn<String> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get dietType =>
      $composableBuilder(column: $table.dietType, builder: (column) => column);

  GeneratedColumn<String> get meatTypes =>
      $composableBuilder(column: $table.meatTypes, builder: (column) => column);

  Expression<T> recipeStepsRefs<T extends Object>(
    Expression<T> Function($$RecipeStepsTableAnnotationComposer a) f,
  ) {
    final $$RecipeStepsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recipeSteps,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipeStepsTableAnnotationComposer(
            $db: $db,
            $table: $db.recipeSteps,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> ingredientsRefs<T extends Object>(
    Expression<T> Function($$IngredientsTableAnnotationComposer a) f,
  ) {
    final $$IngredientsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.ingredients,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IngredientsTableAnnotationComposer(
            $db: $db,
            $table: $db.ingredients,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> mealsRefs<T extends Object>(
    Expression<T> Function($$MealsTableAnnotationComposer a) f,
  ) {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.recipeId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableAnnotationComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecipesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipesTable,
          Recipe,
          $$RecipesTableFilterComposer,
          $$RecipesTableOrderingComposer,
          $$RecipesTableAnnotationComposer,
          $$RecipesTableCreateCompanionBuilder,
          $$RecipesTableUpdateCompanionBuilder,
          (Recipe, $$RecipesTableReferences),
          Recipe,
          PrefetchHooks Function({
            bool recipeStepsRefs,
            bool ingredientsRefs,
            bool mealsRefs,
          })
        > {
  $$RecipesTableTableManager(_$AppDatabase db, $RecipesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String> category = const Value.absent(),
                Value<int> caloriesPerServing = const Value.absent(),
                Value<double> proteinGrams = const Value.absent(),
                Value<double> carbsGrams = const Value.absent(),
                Value<double> fatGrams = const Value.absent(),
                Value<int> servings = const Value.absent(),
                Value<int> prepTimeMinutes = const Value.absent(),
                Value<int> cookTimeMinutes = const Value.absent(),
                Value<bool> isBatchFriendly = const Value.absent(),
                Value<String> allergens = const Value.absent(),
                Value<String> difficulty = const Value.absent(),
                Value<String> dietType = const Value.absent(),
                Value<String> meatTypes = const Value.absent(),
              }) => RecipesCompanion(
                id: id,
                name: name,
                description: description,
                category: category,
                caloriesPerServing: caloriesPerServing,
                proteinGrams: proteinGrams,
                carbsGrams: carbsGrams,
                fatGrams: fatGrams,
                servings: servings,
                prepTimeMinutes: prepTimeMinutes,
                cookTimeMinutes: cookTimeMinutes,
                isBatchFriendly: isBatchFriendly,
                allergens: allergens,
                difficulty: difficulty,
                dietType: dietType,
                meatTypes: meatTypes,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required String name,
                required String description,
                required String category,
                required int caloriesPerServing,
                required double proteinGrams,
                required double carbsGrams,
                required double fatGrams,
                required int servings,
                required int prepTimeMinutes,
                required int cookTimeMinutes,
                required bool isBatchFriendly,
                required String allergens,
                Value<String> difficulty = const Value.absent(),
                Value<String> dietType = const Value.absent(),
                Value<String> meatTypes = const Value.absent(),
              }) => RecipesCompanion.insert(
                id: id,
                name: name,
                description: description,
                category: category,
                caloriesPerServing: caloriesPerServing,
                proteinGrams: proteinGrams,
                carbsGrams: carbsGrams,
                fatGrams: fatGrams,
                servings: servings,
                prepTimeMinutes: prepTimeMinutes,
                cookTimeMinutes: cookTimeMinutes,
                isBatchFriendly: isBatchFriendly,
                allergens: allergens,
                difficulty: difficulty,
                dietType: dietType,
                meatTypes: meatTypes,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                recipeStepsRefs = false,
                ingredientsRefs = false,
                mealsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recipeStepsRefs) db.recipeSteps,
                    if (ingredientsRefs) db.ingredients,
                    if (mealsRefs) db.meals,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recipeStepsRefs)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          RecipeStep
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._recipeStepsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).recipeStepsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (ingredientsRefs)
                        await $_getPrefetchedData<
                          Recipe,
                          $RecipesTable,
                          Ingredient
                        >(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._ingredientsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(
                                db,
                                table,
                                p0,
                              ).ingredientsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (mealsRefs)
                        await $_getPrefetchedData<Recipe, $RecipesTable, Meal>(
                          currentTable: table,
                          referencedTable: $$RecipesTableReferences
                              ._mealsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecipesTableReferences(db, table, p0).mealsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recipeId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecipesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipesTable,
      Recipe,
      $$RecipesTableFilterComposer,
      $$RecipesTableOrderingComposer,
      $$RecipesTableAnnotationComposer,
      $$RecipesTableCreateCompanionBuilder,
      $$RecipesTableUpdateCompanionBuilder,
      (Recipe, $$RecipesTableReferences),
      Recipe,
      PrefetchHooks Function({
        bool recipeStepsRefs,
        bool ingredientsRefs,
        bool mealsRefs,
      })
    >;
typedef $$RecipeStepsTableCreateCompanionBuilder =
    RecipeStepsCompanion Function({
      Value<int> id,
      required int recipeId,
      required int stepNumber,
      required String instruction,
      Value<int?> timerSeconds,
    });
typedef $$RecipeStepsTableUpdateCompanionBuilder =
    RecipeStepsCompanion Function({
      Value<int> id,
      Value<int> recipeId,
      Value<int> stepNumber,
      Value<String> instruction,
      Value<int?> timerSeconds,
    });

final class $$RecipeStepsTableReferences
    extends BaseReferences<_$AppDatabase, $RecipeStepsTable, RecipeStep> {
  $$RecipeStepsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias(
        $_aliasNameGenerator(db.recipeSteps.recipeId, db.recipes.id),
      );

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$RecipeStepsTableFilterComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get stepNumber => $composableBuilder(
    column: $table.stepNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get instruction => $composableBuilder(
    column: $table.instruction,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get timerSeconds => $composableBuilder(
    column: $table.timerSeconds,
    builder: (column) => ColumnFilters(column),
  );

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeStepsTableOrderingComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get stepNumber => $composableBuilder(
    column: $table.stepNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get instruction => $composableBuilder(
    column: $table.instruction,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get timerSeconds => $composableBuilder(
    column: $table.timerSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeStepsTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecipeStepsTable> {
  $$RecipeStepsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get stepNumber => $composableBuilder(
    column: $table.stepNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get instruction => $composableBuilder(
    column: $table.instruction,
    builder: (column) => column,
  );

  GeneratedColumn<int> get timerSeconds => $composableBuilder(
    column: $table.timerSeconds,
    builder: (column) => column,
  );

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecipeStepsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecipeStepsTable,
          RecipeStep,
          $$RecipeStepsTableFilterComposer,
          $$RecipeStepsTableOrderingComposer,
          $$RecipeStepsTableAnnotationComposer,
          $$RecipeStepsTableCreateCompanionBuilder,
          $$RecipeStepsTableUpdateCompanionBuilder,
          (RecipeStep, $$RecipeStepsTableReferences),
          RecipeStep,
          PrefetchHooks Function({bool recipeId})
        > {
  $$RecipeStepsTableTableManager(_$AppDatabase db, $RecipeStepsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecipeStepsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecipeStepsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecipeStepsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> recipeId = const Value.absent(),
                Value<int> stepNumber = const Value.absent(),
                Value<String> instruction = const Value.absent(),
                Value<int?> timerSeconds = const Value.absent(),
              }) => RecipeStepsCompanion(
                id: id,
                recipeId: recipeId,
                stepNumber: stepNumber,
                instruction: instruction,
                timerSeconds: timerSeconds,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int recipeId,
                required int stepNumber,
                required String instruction,
                Value<int?> timerSeconds = const Value.absent(),
              }) => RecipeStepsCompanion.insert(
                id: id,
                recipeId: recipeId,
                stepNumber: stepNumber,
                instruction: instruction,
                timerSeconds: timerSeconds,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecipeStepsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recipeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.recipeId,
                                referencedTable: $$RecipeStepsTableReferences
                                    ._recipeIdTable(db),
                                referencedColumn: $$RecipeStepsTableReferences
                                    ._recipeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$RecipeStepsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecipeStepsTable,
      RecipeStep,
      $$RecipeStepsTableFilterComposer,
      $$RecipeStepsTableOrderingComposer,
      $$RecipeStepsTableAnnotationComposer,
      $$RecipeStepsTableCreateCompanionBuilder,
      $$RecipeStepsTableUpdateCompanionBuilder,
      (RecipeStep, $$RecipeStepsTableReferences),
      RecipeStep,
      PrefetchHooks Function({bool recipeId})
    >;
typedef $$IngredientsTableCreateCompanionBuilder =
    IngredientsCompanion Function({
      Value<int> id,
      required int recipeId,
      required String name,
      required double quantity,
      required String unit,
      required String supermarketSection,
    });
typedef $$IngredientsTableUpdateCompanionBuilder =
    IngredientsCompanion Function({
      Value<int> id,
      Value<int> recipeId,
      Value<String> name,
      Value<double> quantity,
      Value<String> unit,
      Value<String> supermarketSection,
    });

final class $$IngredientsTableReferences
    extends BaseReferences<_$AppDatabase, $IngredientsTable, Ingredient> {
  $$IngredientsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $RecipesTable _recipeIdTable(_$AppDatabase db) =>
      db.recipes.createAlias(
        $_aliasNameGenerator(db.ingredients.recipeId, db.recipes.id),
      );

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IngredientsTableFilterComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supermarketSection => $composableBuilder(
    column: $table.supermarketSection,
    builder: (column) => ColumnFilters(column),
  );

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientsTableOrderingComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supermarketSection => $composableBuilder(
    column: $table.supermarketSection,
    builder: (column) => ColumnOrderings(column),
  );

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientsTableAnnotationComposer
    extends Composer<_$AppDatabase, $IngredientsTable> {
  $$IngredientsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get supermarketSection => $composableBuilder(
    column: $table.supermarketSection,
    builder: (column) => column,
  );

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IngredientsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IngredientsTable,
          Ingredient,
          $$IngredientsTableFilterComposer,
          $$IngredientsTableOrderingComposer,
          $$IngredientsTableAnnotationComposer,
          $$IngredientsTableCreateCompanionBuilder,
          $$IngredientsTableUpdateCompanionBuilder,
          (Ingredient, $$IngredientsTableReferences),
          Ingredient,
          PrefetchHooks Function({bool recipeId})
        > {
  $$IngredientsTableTableManager(_$AppDatabase db, $IngredientsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IngredientsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IngredientsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IngredientsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> recipeId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> supermarketSection = const Value.absent(),
              }) => IngredientsCompanion(
                id: id,
                recipeId: recipeId,
                name: name,
                quantity: quantity,
                unit: unit,
                supermarketSection: supermarketSection,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int recipeId,
                required String name,
                required double quantity,
                required String unit,
                required String supermarketSection,
              }) => IngredientsCompanion.insert(
                id: id,
                recipeId: recipeId,
                name: name,
                quantity: quantity,
                unit: unit,
                supermarketSection: supermarketSection,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IngredientsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (recipeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.recipeId,
                                referencedTable: $$IngredientsTableReferences
                                    ._recipeIdTable(db),
                                referencedColumn: $$IngredientsTableReferences
                                    ._recipeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$IngredientsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IngredientsTable,
      Ingredient,
      $$IngredientsTableFilterComposer,
      $$IngredientsTableOrderingComposer,
      $$IngredientsTableAnnotationComposer,
      $$IngredientsTableCreateCompanionBuilder,
      $$IngredientsTableUpdateCompanionBuilder,
      (Ingredient, $$IngredientsTableReferences),
      Ingredient,
      PrefetchHooks Function({bool recipeId})
    >;
typedef $$WeekPlansTableCreateCompanionBuilder =
    WeekPlansCompanion Function({
      Value<int> id,
      required int weekStartDate,
      required int createdAt,
    });
typedef $$WeekPlansTableUpdateCompanionBuilder =
    WeekPlansCompanion Function({
      Value<int> id,
      Value<int> weekStartDate,
      Value<int> createdAt,
    });

final class $$WeekPlansTableReferences
    extends BaseReferences<_$AppDatabase, $WeekPlansTable, WeekPlan> {
  $$WeekPlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$DayPlansTable, List<DayPlan>> _dayPlansRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.dayPlans,
    aliasName: $_aliasNameGenerator(db.weekPlans.id, db.dayPlans.weekPlanId),
  );

  $$DayPlansTableProcessedTableManager get dayPlansRefs {
    final manager = $$DayPlansTableTableManager(
      $_db,
      $_db.dayPlans,
    ).filter((f) => f.weekPlanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_dayPlansRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ShoppingItemsTable, List<ShoppingItem>>
  _shoppingItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.shoppingItems,
    aliasName: $_aliasNameGenerator(
      db.weekPlans.id,
      db.shoppingItems.weekPlanId,
    ),
  );

  $$ShoppingItemsTableProcessedTableManager get shoppingItemsRefs {
    final manager = $$ShoppingItemsTableTableManager(
      $_db,
      $_db.shoppingItems,
    ).filter((f) => f.weekPlanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_shoppingItemsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$WeekPlansTableFilterComposer
    extends Composer<_$AppDatabase, $WeekPlansTable> {
  $$WeekPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weekStartDate => $composableBuilder(
    column: $table.weekStartDate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> dayPlansRefs(
    Expression<bool> Function($$DayPlansTableFilterComposer f) f,
  ) {
    final $$DayPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dayPlans,
      getReferencedColumn: (t) => t.weekPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPlansTableFilterComposer(
            $db: $db,
            $table: $db.dayPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> shoppingItemsRefs(
    Expression<bool> Function($$ShoppingItemsTableFilterComposer f) f,
  ) {
    final $$ShoppingItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingItems,
      getReferencedColumn: (t) => t.weekPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingItemsTableFilterComposer(
            $db: $db,
            $table: $db.shoppingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WeekPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $WeekPlansTable> {
  $$WeekPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weekStartDate => $composableBuilder(
    column: $table.weekStartDate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeekPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeekPlansTable> {
  $$WeekPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get weekStartDate => $composableBuilder(
    column: $table.weekStartDate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  Expression<T> dayPlansRefs<T extends Object>(
    Expression<T> Function($$DayPlansTableAnnotationComposer a) f,
  ) {
    final $$DayPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.dayPlans,
      getReferencedColumn: (t) => t.weekPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.dayPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> shoppingItemsRefs<T extends Object>(
    Expression<T> Function($$ShoppingItemsTableAnnotationComposer a) f,
  ) {
    final $$ShoppingItemsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.shoppingItems,
      getReferencedColumn: (t) => t.weekPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ShoppingItemsTableAnnotationComposer(
            $db: $db,
            $table: $db.shoppingItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$WeekPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeekPlansTable,
          WeekPlan,
          $$WeekPlansTableFilterComposer,
          $$WeekPlansTableOrderingComposer,
          $$WeekPlansTableAnnotationComposer,
          $$WeekPlansTableCreateCompanionBuilder,
          $$WeekPlansTableUpdateCompanionBuilder,
          (WeekPlan, $$WeekPlansTableReferences),
          WeekPlan,
          PrefetchHooks Function({bool dayPlansRefs, bool shoppingItemsRefs})
        > {
  $$WeekPlansTableTableManager(_$AppDatabase db, $WeekPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeekPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeekPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeekPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> weekStartDate = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => WeekPlansCompanion(
                id: id,
                weekStartDate: weekStartDate,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int weekStartDate,
                required int createdAt,
              }) => WeekPlansCompanion.insert(
                id: id,
                weekStartDate: weekStartDate,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$WeekPlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({dayPlansRefs = false, shoppingItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (dayPlansRefs) db.dayPlans,
                    if (shoppingItemsRefs) db.shoppingItems,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (dayPlansRefs)
                        await $_getPrefetchedData<
                          WeekPlan,
                          $WeekPlansTable,
                          DayPlan
                        >(
                          currentTable: table,
                          referencedTable: $$WeekPlansTableReferences
                              ._dayPlansRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WeekPlansTableReferences(
                                db,
                                table,
                                p0,
                              ).dayPlansRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.weekPlanId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (shoppingItemsRefs)
                        await $_getPrefetchedData<
                          WeekPlan,
                          $WeekPlansTable,
                          ShoppingItem
                        >(
                          currentTable: table,
                          referencedTable: $$WeekPlansTableReferences
                              ._shoppingItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$WeekPlansTableReferences(
                                db,
                                table,
                                p0,
                              ).shoppingItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.weekPlanId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$WeekPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeekPlansTable,
      WeekPlan,
      $$WeekPlansTableFilterComposer,
      $$WeekPlansTableOrderingComposer,
      $$WeekPlansTableAnnotationComposer,
      $$WeekPlansTableCreateCompanionBuilder,
      $$WeekPlansTableUpdateCompanionBuilder,
      (WeekPlan, $$WeekPlansTableReferences),
      WeekPlan,
      PrefetchHooks Function({bool dayPlansRefs, bool shoppingItemsRefs})
    >;
typedef $$DayPlansTableCreateCompanionBuilder =
    DayPlansCompanion Function({
      Value<int> id,
      required int weekPlanId,
      required int date,
      required int dayOfWeek,
      Value<bool> isFreeDay,
      Value<int?> batchCookingSession,
    });
typedef $$DayPlansTableUpdateCompanionBuilder =
    DayPlansCompanion Function({
      Value<int> id,
      Value<int> weekPlanId,
      Value<int> date,
      Value<int> dayOfWeek,
      Value<bool> isFreeDay,
      Value<int?> batchCookingSession,
    });

final class $$DayPlansTableReferences
    extends BaseReferences<_$AppDatabase, $DayPlansTable, DayPlan> {
  $$DayPlansTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $WeekPlansTable _weekPlanIdTable(_$AppDatabase db) =>
      db.weekPlans.createAlias(
        $_aliasNameGenerator(db.dayPlans.weekPlanId, db.weekPlans.id),
      );

  $$WeekPlansTableProcessedTableManager get weekPlanId {
    final $_column = $_itemColumn<int>('week_plan_id')!;

    final manager = $$WeekPlansTableTableManager(
      $_db,
      $_db.weekPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_weekPlanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$MealsTable, List<Meal>> _mealsRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.meals,
    aliasName: $_aliasNameGenerator(db.dayPlans.id, db.meals.dayPlanId),
  );

  $$MealsTableProcessedTableManager get mealsRefs {
    final manager = $$MealsTableTableManager(
      $_db,
      $_db.meals,
    ).filter((f) => f.dayPlanId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_mealsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$DayPlansTableFilterComposer
    extends Composer<_$AppDatabase, $DayPlansTable> {
  $$DayPlansTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFreeDay => $composableBuilder(
    column: $table.isFreeDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get batchCookingSession => $composableBuilder(
    column: $table.batchCookingSession,
    builder: (column) => ColumnFilters(column),
  );

  $$WeekPlansTableFilterComposer get weekPlanId {
    final $$WeekPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weekPlanId,
      referencedTable: $db.weekPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeekPlansTableFilterComposer(
            $db: $db,
            $table: $db.weekPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> mealsRefs(
    Expression<bool> Function($$MealsTableFilterComposer f) f,
  ) {
    final $$MealsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.dayPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableFilterComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DayPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $DayPlansTable> {
  $$DayPlansTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dayOfWeek => $composableBuilder(
    column: $table.dayOfWeek,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFreeDay => $composableBuilder(
    column: $table.isFreeDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get batchCookingSession => $composableBuilder(
    column: $table.batchCookingSession,
    builder: (column) => ColumnOrderings(column),
  );

  $$WeekPlansTableOrderingComposer get weekPlanId {
    final $$WeekPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weekPlanId,
      referencedTable: $db.weekPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeekPlansTableOrderingComposer(
            $db: $db,
            $table: $db.weekPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$DayPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $DayPlansTable> {
  $$DayPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get dayOfWeek =>
      $composableBuilder(column: $table.dayOfWeek, builder: (column) => column);

  GeneratedColumn<bool> get isFreeDay =>
      $composableBuilder(column: $table.isFreeDay, builder: (column) => column);

  GeneratedColumn<int> get batchCookingSession => $composableBuilder(
    column: $table.batchCookingSession,
    builder: (column) => column,
  );

  $$WeekPlansTableAnnotationComposer get weekPlanId {
    final $$WeekPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weekPlanId,
      referencedTable: $db.weekPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeekPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.weekPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> mealsRefs<T extends Object>(
    Expression<T> Function($$MealsTableAnnotationComposer a) f,
  ) {
    final $$MealsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.meals,
      getReferencedColumn: (t) => t.dayPlanId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$MealsTableAnnotationComposer(
            $db: $db,
            $table: $db.meals,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$DayPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DayPlansTable,
          DayPlan,
          $$DayPlansTableFilterComposer,
          $$DayPlansTableOrderingComposer,
          $$DayPlansTableAnnotationComposer,
          $$DayPlansTableCreateCompanionBuilder,
          $$DayPlansTableUpdateCompanionBuilder,
          (DayPlan, $$DayPlansTableReferences),
          DayPlan,
          PrefetchHooks Function({bool weekPlanId, bool mealsRefs})
        > {
  $$DayPlansTableTableManager(_$AppDatabase db, $DayPlansTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DayPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DayPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DayPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> weekPlanId = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<int> dayOfWeek = const Value.absent(),
                Value<bool> isFreeDay = const Value.absent(),
                Value<int?> batchCookingSession = const Value.absent(),
              }) => DayPlansCompanion(
                id: id,
                weekPlanId: weekPlanId,
                date: date,
                dayOfWeek: dayOfWeek,
                isFreeDay: isFreeDay,
                batchCookingSession: batchCookingSession,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int weekPlanId,
                required int date,
                required int dayOfWeek,
                Value<bool> isFreeDay = const Value.absent(),
                Value<int?> batchCookingSession = const Value.absent(),
              }) => DayPlansCompanion.insert(
                id: id,
                weekPlanId: weekPlanId,
                date: date,
                dayOfWeek: dayOfWeek,
                isFreeDay: isFreeDay,
                batchCookingSession: batchCookingSession,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$DayPlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({weekPlanId = false, mealsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (mealsRefs) db.meals],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (weekPlanId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.weekPlanId,
                                referencedTable: $$DayPlansTableReferences
                                    ._weekPlanIdTable(db),
                                referencedColumn: $$DayPlansTableReferences
                                    ._weekPlanIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (mealsRefs)
                    await $_getPrefetchedData<DayPlan, $DayPlansTable, Meal>(
                      currentTable: table,
                      referencedTable: $$DayPlansTableReferences
                          ._mealsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$DayPlansTableReferences(db, table, p0).mealsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.dayPlanId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$DayPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DayPlansTable,
      DayPlan,
      $$DayPlansTableFilterComposer,
      $$DayPlansTableOrderingComposer,
      $$DayPlansTableAnnotationComposer,
      $$DayPlansTableCreateCompanionBuilder,
      $$DayPlansTableUpdateCompanionBuilder,
      (DayPlan, $$DayPlansTableReferences),
      DayPlan,
      PrefetchHooks Function({bool weekPlanId, bool mealsRefs})
    >;
typedef $$MealsTableCreateCompanionBuilder =
    MealsCompanion Function({
      Value<int> id,
      required int dayPlanId,
      required String mealType,
      required int recipeId,
      Value<double> servings,
      Value<bool> isConsumed,
    });
typedef $$MealsTableUpdateCompanionBuilder =
    MealsCompanion Function({
      Value<int> id,
      Value<int> dayPlanId,
      Value<String> mealType,
      Value<int> recipeId,
      Value<double> servings,
      Value<bool> isConsumed,
    });

final class $$MealsTableReferences
    extends BaseReferences<_$AppDatabase, $MealsTable, Meal> {
  $$MealsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $DayPlansTable _dayPlanIdTable(_$AppDatabase db) => db.dayPlans
      .createAlias($_aliasNameGenerator(db.meals.dayPlanId, db.dayPlans.id));

  $$DayPlansTableProcessedTableManager get dayPlanId {
    final $_column = $_itemColumn<int>('day_plan_id')!;

    final manager = $$DayPlansTableTableManager(
      $_db,
      $_db.dayPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_dayPlanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RecipesTable _recipeIdTable(_$AppDatabase db) => db.recipes
      .createAlias($_aliasNameGenerator(db.meals.recipeId, db.recipes.id));

  $$RecipesTableProcessedTableManager get recipeId {
    final $_column = $_itemColumn<int>('recipe_id')!;

    final manager = $$RecipesTableTableManager(
      $_db,
      $_db.recipes,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recipeIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$MealsTableFilterComposer extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isConsumed => $composableBuilder(
    column: $table.isConsumed,
    builder: (column) => ColumnFilters(column),
  );

  $$DayPlansTableFilterComposer get dayPlanId {
    final $$DayPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dayPlanId,
      referencedTable: $db.dayPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPlansTableFilterComposer(
            $db: $db,
            $table: $db.dayPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableFilterComposer get recipeId {
    final $$RecipesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableFilterComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealsTableOrderingComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mealType => $composableBuilder(
    column: $table.mealType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get servings => $composableBuilder(
    column: $table.servings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isConsumed => $composableBuilder(
    column: $table.isConsumed,
    builder: (column) => ColumnOrderings(column),
  );

  $$DayPlansTableOrderingComposer get dayPlanId {
    final $$DayPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dayPlanId,
      referencedTable: $db.dayPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPlansTableOrderingComposer(
            $db: $db,
            $table: $db.dayPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableOrderingComposer get recipeId {
    final $$RecipesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableOrderingComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MealsTable> {
  $$MealsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<double> get servings =>
      $composableBuilder(column: $table.servings, builder: (column) => column);

  GeneratedColumn<bool> get isConsumed => $composableBuilder(
    column: $table.isConsumed,
    builder: (column) => column,
  );

  $$DayPlansTableAnnotationComposer get dayPlanId {
    final $$DayPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.dayPlanId,
      referencedTable: $db.dayPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$DayPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.dayPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecipesTableAnnotationComposer get recipeId {
    final $$RecipesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recipeId,
      referencedTable: $db.recipes,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecipesTableAnnotationComposer(
            $db: $db,
            $table: $db.recipes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$MealsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MealsTable,
          Meal,
          $$MealsTableFilterComposer,
          $$MealsTableOrderingComposer,
          $$MealsTableAnnotationComposer,
          $$MealsTableCreateCompanionBuilder,
          $$MealsTableUpdateCompanionBuilder,
          (Meal, $$MealsTableReferences),
          Meal,
          PrefetchHooks Function({bool dayPlanId, bool recipeId})
        > {
  $$MealsTableTableManager(_$AppDatabase db, $MealsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MealsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MealsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MealsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> dayPlanId = const Value.absent(),
                Value<String> mealType = const Value.absent(),
                Value<int> recipeId = const Value.absent(),
                Value<double> servings = const Value.absent(),
                Value<bool> isConsumed = const Value.absent(),
              }) => MealsCompanion(
                id: id,
                dayPlanId: dayPlanId,
                mealType: mealType,
                recipeId: recipeId,
                servings: servings,
                isConsumed: isConsumed,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int dayPlanId,
                required String mealType,
                required int recipeId,
                Value<double> servings = const Value.absent(),
                Value<bool> isConsumed = const Value.absent(),
              }) => MealsCompanion.insert(
                id: id,
                dayPlanId: dayPlanId,
                mealType: mealType,
                recipeId: recipeId,
                servings: servings,
                isConsumed: isConsumed,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$MealsTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback: ({dayPlanId = false, recipeId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (dayPlanId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.dayPlanId,
                                referencedTable: $$MealsTableReferences
                                    ._dayPlanIdTable(db),
                                referencedColumn: $$MealsTableReferences
                                    ._dayPlanIdTable(db)
                                    .id,
                              )
                              as T;
                    }
                    if (recipeId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.recipeId,
                                referencedTable: $$MealsTableReferences
                                    ._recipeIdTable(db),
                                referencedColumn: $$MealsTableReferences
                                    ._recipeIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$MealsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MealsTable,
      Meal,
      $$MealsTableFilterComposer,
      $$MealsTableOrderingComposer,
      $$MealsTableAnnotationComposer,
      $$MealsTableCreateCompanionBuilder,
      $$MealsTableUpdateCompanionBuilder,
      (Meal, $$MealsTableReferences),
      Meal,
      PrefetchHooks Function({bool dayPlanId, bool recipeId})
    >;
typedef $$ShoppingItemsTableCreateCompanionBuilder =
    ShoppingItemsCompanion Function({
      Value<int> id,
      required int weekPlanId,
      required String name,
      required double quantity,
      required String unit,
      required String supermarketSection,
      Value<bool> isChecked,
      Value<bool> isManuallyAdded,
      Value<String> sourceDetails,
      Value<int> tripNumber,
    });
typedef $$ShoppingItemsTableUpdateCompanionBuilder =
    ShoppingItemsCompanion Function({
      Value<int> id,
      Value<int> weekPlanId,
      Value<String> name,
      Value<double> quantity,
      Value<String> unit,
      Value<String> supermarketSection,
      Value<bool> isChecked,
      Value<bool> isManuallyAdded,
      Value<String> sourceDetails,
      Value<int> tripNumber,
    });

final class $$ShoppingItemsTableReferences
    extends BaseReferences<_$AppDatabase, $ShoppingItemsTable, ShoppingItem> {
  $$ShoppingItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $WeekPlansTable _weekPlanIdTable(_$AppDatabase db) =>
      db.weekPlans.createAlias(
        $_aliasNameGenerator(db.shoppingItems.weekPlanId, db.weekPlans.id),
      );

  $$WeekPlansTableProcessedTableManager get weekPlanId {
    final $_column = $_itemColumn<int>('week_plan_id')!;

    final manager = $$WeekPlansTableTableManager(
      $_db,
      $_db.weekPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_weekPlanIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ShoppingItemsTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get supermarketSection => $composableBuilder(
    column: $table.supermarketSection,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isChecked => $composableBuilder(
    column: $table.isChecked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isManuallyAdded => $composableBuilder(
    column: $table.isManuallyAdded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sourceDetails => $composableBuilder(
    column: $table.sourceDetails,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get tripNumber => $composableBuilder(
    column: $table.tripNumber,
    builder: (column) => ColumnFilters(column),
  );

  $$WeekPlansTableFilterComposer get weekPlanId {
    final $$WeekPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weekPlanId,
      referencedTable: $db.weekPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeekPlansTableFilterComposer(
            $db: $db,
            $table: $db.weekPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get quantity => $composableBuilder(
    column: $table.quantity,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get unit => $composableBuilder(
    column: $table.unit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get supermarketSection => $composableBuilder(
    column: $table.supermarketSection,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isChecked => $composableBuilder(
    column: $table.isChecked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isManuallyAdded => $composableBuilder(
    column: $table.isManuallyAdded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sourceDetails => $composableBuilder(
    column: $table.sourceDetails,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get tripNumber => $composableBuilder(
    column: $table.tripNumber,
    builder: (column) => ColumnOrderings(column),
  );

  $$WeekPlansTableOrderingComposer get weekPlanId {
    final $$WeekPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weekPlanId,
      referencedTable: $db.weekPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeekPlansTableOrderingComposer(
            $db: $db,
            $table: $db.weekPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingItemsTable> {
  $$ShoppingItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<String> get unit =>
      $composableBuilder(column: $table.unit, builder: (column) => column);

  GeneratedColumn<String> get supermarketSection => $composableBuilder(
    column: $table.supermarketSection,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isChecked =>
      $composableBuilder(column: $table.isChecked, builder: (column) => column);

  GeneratedColumn<bool> get isManuallyAdded => $composableBuilder(
    column: $table.isManuallyAdded,
    builder: (column) => column,
  );

  GeneratedColumn<String> get sourceDetails => $composableBuilder(
    column: $table.sourceDetails,
    builder: (column) => column,
  );

  GeneratedColumn<int> get tripNumber => $composableBuilder(
    column: $table.tripNumber,
    builder: (column) => column,
  );

  $$WeekPlansTableAnnotationComposer get weekPlanId {
    final $$WeekPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.weekPlanId,
      referencedTable: $db.weekPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$WeekPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.weekPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ShoppingItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ShoppingItemsTable,
          ShoppingItem,
          $$ShoppingItemsTableFilterComposer,
          $$ShoppingItemsTableOrderingComposer,
          $$ShoppingItemsTableAnnotationComposer,
          $$ShoppingItemsTableCreateCompanionBuilder,
          $$ShoppingItemsTableUpdateCompanionBuilder,
          (ShoppingItem, $$ShoppingItemsTableReferences),
          ShoppingItem,
          PrefetchHooks Function({bool weekPlanId})
        > {
  $$ShoppingItemsTableTableManager(_$AppDatabase db, $ShoppingItemsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> weekPlanId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<double> quantity = const Value.absent(),
                Value<String> unit = const Value.absent(),
                Value<String> supermarketSection = const Value.absent(),
                Value<bool> isChecked = const Value.absent(),
                Value<bool> isManuallyAdded = const Value.absent(),
                Value<String> sourceDetails = const Value.absent(),
                Value<int> tripNumber = const Value.absent(),
              }) => ShoppingItemsCompanion(
                id: id,
                weekPlanId: weekPlanId,
                name: name,
                quantity: quantity,
                unit: unit,
                supermarketSection: supermarketSection,
                isChecked: isChecked,
                isManuallyAdded: isManuallyAdded,
                sourceDetails: sourceDetails,
                tripNumber: tripNumber,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int weekPlanId,
                required String name,
                required double quantity,
                required String unit,
                required String supermarketSection,
                Value<bool> isChecked = const Value.absent(),
                Value<bool> isManuallyAdded = const Value.absent(),
                Value<String> sourceDetails = const Value.absent(),
                Value<int> tripNumber = const Value.absent(),
              }) => ShoppingItemsCompanion.insert(
                id: id,
                weekPlanId: weekPlanId,
                name: name,
                quantity: quantity,
                unit: unit,
                supermarketSection: supermarketSection,
                isChecked: isChecked,
                isManuallyAdded: isManuallyAdded,
                sourceDetails: sourceDetails,
                tripNumber: tripNumber,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ShoppingItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({weekPlanId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (weekPlanId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.weekPlanId,
                                referencedTable: $$ShoppingItemsTableReferences
                                    ._weekPlanIdTable(db),
                                referencedColumn: $$ShoppingItemsTableReferences
                                    ._weekPlanIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ShoppingItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ShoppingItemsTable,
      ShoppingItem,
      $$ShoppingItemsTableFilterComposer,
      $$ShoppingItemsTableOrderingComposer,
      $$ShoppingItemsTableAnnotationComposer,
      $$ShoppingItemsTableCreateCompanionBuilder,
      $$ShoppingItemsTableUpdateCompanionBuilder,
      (ShoppingItem, $$ShoppingItemsTableReferences),
      ShoppingItem,
      PrefetchHooks Function({bool weekPlanId})
    >;
typedef $$WeightLogsTableCreateCompanionBuilder =
    WeightLogsCompanion Function({
      Value<int> id,
      required int date,
      required double weightKg,
      required int createdAt,
    });
typedef $$WeightLogsTableUpdateCompanionBuilder =
    WeightLogsCompanion Function({
      Value<int> id,
      Value<int> date,
      Value<double> weightKg,
      Value<int> createdAt,
    });

class $$WeightLogsTableFilterComposer
    extends Composer<_$AppDatabase, $WeightLogsTable> {
  $$WeightLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WeightLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $WeightLogsTable> {
  $$WeightLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get weightKg => $composableBuilder(
    column: $table.weightKg,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WeightLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WeightLogsTable> {
  $$WeightLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<double> get weightKg =>
      $composableBuilder(column: $table.weightKg, builder: (column) => column);

  GeneratedColumn<int> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$WeightLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WeightLogsTable,
          WeightLog,
          $$WeightLogsTableFilterComposer,
          $$WeightLogsTableOrderingComposer,
          $$WeightLogsTableAnnotationComposer,
          $$WeightLogsTableCreateCompanionBuilder,
          $$WeightLogsTableUpdateCompanionBuilder,
          (
            WeightLog,
            BaseReferences<_$AppDatabase, $WeightLogsTable, WeightLog>,
          ),
          WeightLog,
          PrefetchHooks Function()
        > {
  $$WeightLogsTableTableManager(_$AppDatabase db, $WeightLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WeightLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WeightLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WeightLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                Value<int> date = const Value.absent(),
                Value<double> weightKg = const Value.absent(),
                Value<int> createdAt = const Value.absent(),
              }) => WeightLogsCompanion(
                id: id,
                date: date,
                weightKg: weightKg,
                createdAt: createdAt,
              ),
          createCompanionCallback:
              ({
                Value<int> id = const Value.absent(),
                required int date,
                required double weightKg,
                required int createdAt,
              }) => WeightLogsCompanion.insert(
                id: id,
                date: date,
                weightKg: weightKg,
                createdAt: createdAt,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WeightLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WeightLogsTable,
      WeightLog,
      $$WeightLogsTableFilterComposer,
      $$WeightLogsTableOrderingComposer,
      $$WeightLogsTableAnnotationComposer,
      $$WeightLogsTableCreateCompanionBuilder,
      $$WeightLogsTableUpdateCompanionBuilder,
      (WeightLog, BaseReferences<_$AppDatabase, $WeightLogsTable, WeightLog>),
      WeightLog,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$UserProfilesTableTableManager get userProfiles =>
      $$UserProfilesTableTableManager(_db, _db.userProfiles);
  $$RecipesTableTableManager get recipes =>
      $$RecipesTableTableManager(_db, _db.recipes);
  $$RecipeStepsTableTableManager get recipeSteps =>
      $$RecipeStepsTableTableManager(_db, _db.recipeSteps);
  $$IngredientsTableTableManager get ingredients =>
      $$IngredientsTableTableManager(_db, _db.ingredients);
  $$WeekPlansTableTableManager get weekPlans =>
      $$WeekPlansTableTableManager(_db, _db.weekPlans);
  $$DayPlansTableTableManager get dayPlans =>
      $$DayPlansTableTableManager(_db, _db.dayPlans);
  $$MealsTableTableManager get meals =>
      $$MealsTableTableManager(_db, _db.meals);
  $$ShoppingItemsTableTableManager get shoppingItems =>
      $$ShoppingItemsTableTableManager(_db, _db.shoppingItems);
  $$WeightLogsTableTableManager get weightLogs =>
      $$WeightLogsTableTableManager(_db, _db.weightLogs);
}
