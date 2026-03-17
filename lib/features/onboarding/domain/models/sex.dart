enum Sex {
  male,
  female;

  String get displayName {
    switch (this) {
      case Sex.male:
        return 'Homme';
      case Sex.female:
        return 'Femme';
    }
  }
}
