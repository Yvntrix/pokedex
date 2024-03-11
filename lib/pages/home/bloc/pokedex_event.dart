part of 'pokedex_bloc.dart';

sealed class PokedexEvent extends Equatable {
  const PokedexEvent();

  @override
  List<Object> get props => [];
}

final class PokedexFetched extends PokedexEvent {}
