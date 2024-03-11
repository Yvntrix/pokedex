part of 'pokemon_bloc.dart';

enum PokemonStatus { initial, success, failure }

final class PokemonState extends Equatable {
  const PokemonState({
    this.status = PokemonStatus.initial,
    this.pokemon,
  });

  final PokemonStatus status;
  final PokemonDetails? pokemon;

  @override
  List<Object?> get props => [status, pokemon];

  PokemonState copyWith({
    PokemonStatus? status,
    PokemonDetails? pokemon,
  }) {
    return PokemonState(
      status: status ?? this.status,
      pokemon: pokemon ?? this.pokemon,
    );
  }
}
