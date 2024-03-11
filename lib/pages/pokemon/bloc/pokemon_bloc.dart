import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/pages/pokemon/models/pokemon_details.dart';

part 'pokemon_event.dart';
part 'pokemon_state.dart';

class PokemonBloc extends Bloc<PokemonEvent, PokemonState> {
  PokemonBloc({
    required this.httpClient,
    required this.id,
  }) : super(
          const PokemonState(),
        ) {
    on<PokemonFetched>(_onPokemonFetched);
  }

  final http.Client httpClient;
  final int id;

  Future<void> _onPokemonFetched(
    PokemonFetched event,
    Emitter<PokemonState> emit,
  ) async {
    try {
      final pokemon = await _fetchPokemonDetails();
      emit(state.copyWith(status: PokemonStatus.success, pokemon: pokemon));
    } catch (e) {
      emit(state.copyWith(status: PokemonStatus.failure));
    }
  }

  Future<PokemonDetails> _fetchPokemonDetails() async {
    final response = await httpClient.get(
      Uri.parse('https://pokeapi.co/api/v2/pokemon/$id'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;

      return PokemonDetails.fromJson(data);
    } else {
      throw Exception('error fetching pokemon details');
    }
  }
}
