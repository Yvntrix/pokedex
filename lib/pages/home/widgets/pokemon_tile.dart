import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:pokedex/gen/colors.gen.dart';
import 'package:pokedex/pages/home/models/pokemon.dart';
import 'package:pokedex/pages/home/widgets/loader.dart';
import 'package:pokedex/pages/pokemon/view/pokemon_page.dart';
import 'package:pokedex/utils/string_extension.dart';

class PokemonTile extends StatelessWidget {
  const PokemonTile(this.pokemon, {super.key});

  final Pokemon pokemon;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute<Widget>(
              builder: (context) => PokemonPage(pokemon.id),
            ),
          );
        },
        child: Container(
          margin: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: ColorName.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 3,
              ),
            ],
          ),
          child: Stack(
            children: [
              _background(),
              _pokemonImage(),
              _pokemonName(),
              _pokemonId(),
            ],
          ),
        ),
      );

  Widget _background() => Align(
        alignment: Alignment.bottomCenter,
        child: FractionallySizedBox(
          heightFactor: 0.35,
          widthFactor: 1,
          child: Container(
            decoration: BoxDecoration(
              color: ColorName.background,
              borderRadius: BorderRadius.circular(8),
            ),
          ),
        ),
      );

  Widget _pokemonImage() => Align(
        child: FractionallySizedBox(
          heightFactor: 0.65,
          widthFactor: 0.65,
          child: _image(),
        ),
      );

  Widget _pokemonName() => Align(
        alignment: Alignment.bottomCenter,
        child: Text(pokemon.name.capitalized),
      );

  Widget _pokemonId() => Positioned(
        top: 2,
        right: 6,
        child: Text(pokemon.id.toString().formattedId),
      );

  Widget _image() => CachedNetworkImage(
        imageUrl:
            'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${pokemon.id}.png',
        placeholder: (context, url) => const Loader(),
        errorWidget: (context, url, error) => const Icon(Icons.error),
      );
}
