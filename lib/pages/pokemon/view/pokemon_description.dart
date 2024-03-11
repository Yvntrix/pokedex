import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/gen/assets.gen.dart';
import 'package:pokedex/gen/colors.gen.dart';
import 'package:pokedex/l10n/l10n.dart';
import 'package:pokedex/pages/home/widgets/loader.dart';
import 'package:pokedex/pages/pokemon/bloc/pokemon_bloc.dart';
import 'package:pokedex/pages/pokemon/models/pokemon_details.dart';
import 'package:pokedex/utils/color_extension.dart';
import 'package:pokedex/utils/string_extension.dart';
import 'package:pokedex/utils/type_extension.dart';

class PokemonDescription extends StatelessWidget {
  const PokemonDescription({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PokemonBloc, PokemonState>(
      builder: (context, state) {
        switch (state.status) {
          case PokemonStatus.failure:
            return Center(child: Text(context.l10n.failed_pokedex));
          case PokemonStatus.success:
            if (state.pokemon == null) {
              return Center(child: Text(context.l10n.empty_pokedex));
            } else {
              final pokemon = state.pokemon!;
              final color = pokemon.types.first.getTypeColor();

              return _body(context, pokemon, color);
            }
          case PokemonStatus.initial:
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
        }
      },
    );
  }

  Widget _body(BuildContext ctx, PokemonDetails pkmn, Color color) => Scaffold(
        backgroundColor: color,
        body: Stack(
          children: [
            _background(),
            _content(ctx, pkmn, color),
          ],
        ),
      );

  Widget _background() => Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: Assets.images.pokeballbg.image(
              color: ColorName.white.withOpacity(0.1),
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(8).copyWith(top: 0),
              decoration: BoxDecoration(
                color: ColorName.white,
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.all(12),
              width: double.maxFinite,
            ),
          ),
        ],
      );

  Widget _content(BuildContext ctx, PokemonDetails pkmn, Color color) => Column(
        children: [
          _appBar(pkmn),
          _image(pkmn.id),
          _types(pkmn.types),
          _sectionTitle(ctx.l10n.pokemon_about_title, color),
          _aboutContent(ctx, pkmn),
          _sectionTitle(ctx.l10n.pokemon_base_stats_title, color),
          _statsContent(pkmn.stats, color),
        ],
      );

  Widget _appBar(PokemonDetails pkmn) => AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              pkmn.name.capitalized,
              style: const TextStyle(color: Colors.white),
            ),
            Text(
              pkmn.id.toString().formattedId,
              style: const TextStyle(color: Colors.white),
            ),
          ],
        ),
      );

  Widget _types(List<String> types) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: types
            .map(_type)
            .expand(
              (widget) => [
                widget,
                const SizedBox(width: 12),
              ],
            )
            .toList()
          ..removeLast(),
      );

  Widget _sectionTitle(String title, Color color) {
    return Column(
      children: [
        const SizedBox(height: 16),
        Text(
          title,
          style: TextStyle(
            color: color,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _aboutContent(
    BuildContext context,
    PokemonDetails pokemon,
  ) =>
      IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Assets.images.weight.image(),
                    const SizedBox(width: 8),
                    Text('${pokemon.weight / 10} kg'),
                  ],
                ),
                const Spacer(),
                Text(
                  context.l10n.pokemon_weight_title,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const VerticalDivider(
              color: Colors.grey,
              thickness: 1,
            ),
            Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  children: [
                    Assets.images.straighten.image(),
                    const SizedBox(width: 8),
                    Text('${pokemon.height / 10} m'),
                  ],
                ),
                const Spacer(),
                Text(
                  context.l10n.pokemon_height_title,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
            const VerticalDivider(
              color: Colors.grey,
              thickness: 1,
            ),
            Column(
              children: [
                ...pokemon.abilities.map(
                  Text.new,
                ),
                const Spacer(),
                Text(
                  context.l10n.pokemon_abilities_title,
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            ),
          ],
        ),
      );

  Widget _statsContent(List<Map<String, String>> stats, Color color) => Column(
        children: stats
            .map(
              (stat) => _stat(stat['name']!, int.parse(stat['value']!), color),
            )
            .toList(),
      );

  Widget _stat(String stat, int value, Color color) => Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: IntrinsicHeight(
          child: Row(
            children: [
              SizedBox(
                width: 50,
                child: Text(
                  stat.getTypename(),
                  textAlign: TextAlign.center,
                  style: TextStyle(color: color, fontWeight: FontWeight.bold),
                ),
              ),
              const VerticalDivider(),
              SizedBox(
                width: 25,
                child: Text(
                  value.toString(),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: LinearProgressIndicator(
                    minHeight: 8,
                    value: value / 255,
                    borderRadius: BorderRadius.circular(8),
                    valueColor: AlwaysStoppedAnimation<Color>(color),
                    backgroundColor: color.withOpacity(0.2),
                  ),
                ),
              ),
            ],
          ),
        ),
      );

  Widget _type(String type) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: type.getTypeColor(),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          type.capitalized,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      );

  Widget _image(int id) => SizedBox(
        height: 250,
        width: 250,
        child: CachedNetworkImage(
          imageUrl:
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png',
          placeholder: (context, url) => const Loader(),
          errorWidget: (context, url, error) => const Icon(Icons.error),
        ),
      );
}
