import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/pages/pokemon/bloc/pokemon_bloc.dart';
import 'package:pokedex/pages/pokemon/view/pokemon_description.dart';

class PokemonPage extends StatelessWidget {
  const PokemonPage(this.id, {super.key});

  final int id;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PokemonBloc(httpClient: http.Client(), id: id)
        ..add(
          PokemonFetched(),
        ),
      child: const PokemonDescription(),
    );
  }
}
