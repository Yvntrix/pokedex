// ignore_for_file: lines_longer_than_80_chars

import 'package:equatable/equatable.dart';

class PokemonDetails extends Equatable {
  const PokemonDetails({
    required this.name,
    required this.id,
    required this.height,
    required this.weight,
    required this.types,
    required this.abilities,
    required this.stats,
  });

  factory PokemonDetails.fromJson(Map<String, dynamic> json) {
    final id = json['id'] as int;
    final name = json['name'] as String;
    final height = json['height'] as int;
    final weight = json['weight'] as int;
    final types = (json['types'] as List<dynamic>)
        .map(
          (dynamic type) => ((type as Map<String, dynamic>)['type']
              as Map<String, dynamic>)['name'] as String,
        )
        .toList();
    final abilities = (json['abilities'] as List<dynamic>)
        .map(
          (dynamic ability) => ((ability as Map<String, dynamic>)['ability']
              as Map<String, dynamic>)['name'] as String,
        )
        .toList();
    final stats = (json['stats'] as List<dynamic>)
        .map(
          (dynamic stat) => {
            'name': ((stat as Map<String, dynamic>)['stat']
                as Map<String, dynamic>)['name'] as String,
            'value': (stat['base_stat'] as int).toString(),
          },
        )
        .toList();

    return PokemonDetails(
      name: name,
      id: id,
      height: height,
      weight: weight,
      types: types,
      abilities: abilities,
      stats: stats,
    );
  }

  final String name;
  final int id;
  final int height;
  final int weight;
  final List<String> types;
  final List<String> abilities;
  final List<Map<String, String>> stats;

  @override
  List<Object> get props => [name, id, height, weight, types, abilities, stats];
}
