extension ExtendedString on String {
  isNullOrEmpty() => this == null || this.isEmpty;

  isNotNullOrNotEmpty() => this != null || this.isNotEmpty;
}
