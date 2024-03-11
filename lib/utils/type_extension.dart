extension TypeExtension on String {
  String getTypename() {
    switch (this) {
      case 'hp':
        return 'HP';
      case 'attack':
        return 'ATK';
      case 'defense':
        return 'DEF';
      case 'special-attack':
        return 'SP.ATK';
      case 'special-defense':
        return 'SP.DEF';
      case 'speed':
        return 'SPEED';

      default:
        return 'null';
    }
  }
}
