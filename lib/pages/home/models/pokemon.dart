import 'package:equatable/equatable.dart';

final class Pokemon extends Equatable {
  const Pokemon({
    required this.id,
    required this.name,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    final url = json['url'] as String;
    final id = int.parse(url.split('/')[6]);
    final name = json['name'] as String;
    return Pokemon(id: id, name: name);
  }

  final int id;
  final String name;

  @override
  List<Object> get props => [id, name];
}
