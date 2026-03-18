import 'package:equatable/equatable.dart';

import '../../../../data/local/database.dart';

/// State for the weight log screen.
class WeightLogState extends Equatable {
  WeightLogState({
    this.allLogs = const [],
    this.totalLost = 0.0,
    this.avgLossPerWeek = 0.0,
    this.projectedGoalDate,
    this.initialProjectedDate,
    this.selectedPeriod = 0,
    this.showAddDialog = false,
    this.weightInput = '',
    this.targetWeight = 0.0,
    this.showDuplicateDialog = false,
    this.outlierWarning,
    this.isLoading = true,
    DateTime? selectedDate,
  }) : selectedDate = selectedDate ?? DateTime.now();

  /// All logs sorted by date ascending.
  final List<WeightLog> allLogs;
  final double totalLost;
  final double avgLossPerWeek;
  final DateTime? projectedGoalDate;
  final DateTime? initialProjectedDate;

  /// 0 = 4 weeks, 1 = 3 months, 2 = all.
  final int selectedPeriod;
  final bool showAddDialog;
  final String weightInput;
  final double targetWeight;
  final bool showDuplicateDialog;
  final String? outlierWarning;
  final bool isLoading;

  /// Selected date for the weight entry.
  final DateTime selectedDate;

  @override
  List<Object?> get props => [
        allLogs,
        totalLost,
        avgLossPerWeek,
        projectedGoalDate,
        initialProjectedDate,
        selectedPeriod,
        showAddDialog,
        weightInput,
        targetWeight,
        showDuplicateDialog,
        outlierWarning,
        isLoading,
        selectedDate,
      ];

  WeightLogState copyWith({
    List<WeightLog>? allLogs,
    double? totalLost,
    double? avgLossPerWeek,
    DateTime? projectedGoalDate,
    bool clearProjectedGoalDate = false,
    DateTime? initialProjectedDate,
    bool clearInitialProjectedDate = false,
    int? selectedPeriod,
    bool? showAddDialog,
    String? weightInput,
    double? targetWeight,
    bool? showDuplicateDialog,
    String? outlierWarning,
    bool clearOutlierWarning = false,
    bool? isLoading,
    DateTime? selectedDate,
  }) {
    return WeightLogState(
      allLogs: allLogs ?? this.allLogs,
      totalLost: totalLost ?? this.totalLost,
      avgLossPerWeek: avgLossPerWeek ?? this.avgLossPerWeek,
      projectedGoalDate: clearProjectedGoalDate
          ? null
          : (projectedGoalDate ?? this.projectedGoalDate),
      initialProjectedDate: clearInitialProjectedDate
          ? null
          : (initialProjectedDate ?? this.initialProjectedDate),
      selectedPeriod: selectedPeriod ?? this.selectedPeriod,
      showAddDialog: showAddDialog ?? this.showAddDialog,
      weightInput: weightInput ?? this.weightInput,
      targetWeight: targetWeight ?? this.targetWeight,
      showDuplicateDialog: showDuplicateDialog ?? this.showDuplicateDialog,
      outlierWarning:
          clearOutlierWarning ? null : (outlierWarning ?? this.outlierWarning),
      isLoading: isLoading ?? this.isLoading,
      selectedDate: selectedDate ?? this.selectedDate,
    );
  }
}
