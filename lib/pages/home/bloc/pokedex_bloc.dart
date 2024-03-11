import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:equatable/equatable.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/pages/home/models/pokemon.dart';
import 'package:stream_transform/stream_transform.dart';

part 'pokedex_event.dart';
part 'pokedex_state.dart';

const throttleDuration = Duration(milliseconds: 1000);

EventTransformer<E> throttleDroppable<E>(Duration duration) {
  return (events, mapper) {
    return droppable<E>().call(events.throttle(duration), mapper);
  };
}

class PokedexBloc extends Bloc<PokedexEvent, PokedexState> {
  PokedexBloc({required this.httpClient}) : super(const PokedexState()) {
    on<PokedexFetched>(
      _onPokedexFetched,
      transformer: throttleDroppable(throttleDuration),
    );
  }

  final http.Client httpClient;

  Future<void> _onPokedexFetched(
    PokedexFetched event,
    Emitter<PokedexState> emit,
  ) async {
    try {
      if (state.status == PokedexStatus.initial) {
        final pokemons = await _fetchPokemon(0, 20);
        emit(
          state.copyWith(
            status: PokedexStatus.success,
            pokemons: pokemons,
          ),
        );
      } else {
        final pokemons = await _fetchPokemon(state.pokemons.length, 20);
        emit(
          state.copyWith(
            status: PokedexStatus.success,
            pokemons: List.of(state.pokemons)..addAll(pokemons),
          ),
        );
      }
    } catch (_) {
      emit(state.copyWith(status: PokedexStatus.failure));
    }
  }

  Future<List<Pokemon>> _fetchPokemon(int offset, int limit) async {
    final response = await httpClient.get(
      Uri.https('pokeapi.co', '/api/v2/pokemon', {
        'offset': '$offset',
        'limit': '$limit',
      }),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body) as Map<String, dynamic>;
      final results = data['results'] as List<dynamic>;

      return results
          .map(
            (dynamic json) => Pokemon.fromJson(json as Map<String, dynamic>),
          )
          .toList();
    } else {
      throw Exception('error fetching pokemons');
    }
  }
}
