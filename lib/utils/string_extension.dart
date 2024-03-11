extension StringExtension on String {
  String get capitalized => '${this[0].toUpperCase()}${substring(1)}';
  String get formattedId => '#${padLeft(3, '0')}';
}
