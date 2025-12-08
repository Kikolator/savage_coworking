import 'package:collection/collection.dart';

enum PlanCategory {
  dayPass,
  explore,
  nomad,
  fix,
}

extension PlanCategoryX on PlanCategory {
  static PlanCategory fromJson(String value) {
    return PlanCategory.values.firstWhereOrNull(
          (category) => category.name == value,
        ) ??
        PlanCategory.explore;
  }

  String get label {
    switch (this) {
      case PlanCategory.dayPass:
        return 'Daypass';
      case PlanCategory.explore:
        return 'Explore';
      case PlanCategory.nomad:
        return 'Nomad';
      case PlanCategory.fix:
        return 'Fix';
    }
  }

  String toJson() {
    switch (this) {
      case PlanCategory.dayPass:
        return 'dayPass';
      case PlanCategory.explore:
        return 'explore';
      case PlanCategory.nomad:
        return 'nomad';
      case PlanCategory.fix:
        return 'fix';
    }
  }
}

