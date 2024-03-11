import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/gen/assets.gen.dart';
import 'package:pokedex/gen/colors.gen.dart';
import 'package:pokedex/pages/home/bloc/pokedex_bloc.dart';
import 'package:pokedex/pages/home/view/pokedex_list.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorName.primary,
      appBar: _appBar(),
      body: _body(context),
    );
  }

  AppBar _appBar() => AppBar(
        backgroundColor: ColorName.primary,
        title: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Assets.images.pokeball.image(),
            const SizedBox(width: 16),
            Assets.images.logo.image(),
          ],
        ),
      );

  Widget _body(BuildContext context) => BlocProvider(
        create: (context) => PokedexBloc(
          httpClient: http.Client(),
        )..add(PokedexFetched()),
        child: Container(
          margin: const EdgeInsets.all(8).copyWith(top: 0),
          decoration: BoxDecoration(
            color: ColorName.white,
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.all(12),
          height: double.maxFinite,
          width: double.maxFinite,
          child: const PokedexList(),
        ),
      );
}
