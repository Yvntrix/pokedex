part of 'pokedex_bloc.dart';

enum PokedexStatus { initial, success, failure }

final class PokedexState extends Equatable {
  const PokedexState({
    this.status = PokedexStatus.initial,
    this.pokemons = const <Pokemon>[],
  });

  final PokedexStatus status;
  final List<Pokemon> pokemons;

  PokedexState copyWith({
    PokedexStatus? status,
    List<Pokemon>? pokemons,
  }) {
    return PokedexState(
      status: status ?? this.status,
      pokemons: pokemons ?? this.pokemons,
    );
  }

  @override
  String toString() {
    return '''PokedexState { status: $status, pokemons: ${pokemons.length}''';
  }

  @override
  List<Object> get props => [status, pokemons];
}
