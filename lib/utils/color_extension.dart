import 'package:flutter/material.dart';
import 'package:pokedex/gen/colors.gen.dart';

extension TypeColor on String {
  Color getTypeColor() {
    switch (this) {
      case 'bug':
        return ColorName.bug;
      case 'dark':
        return ColorName.dark;
      case 'dragon':
        return ColorName.dragon;
      case 'electric':
        return ColorName.electric;
      case 'fairy':
        return ColorName.fairy;
      case 'fighting':
        return ColorName.fighting;
      case 'fire':
        return ColorName.fire;
      case 'flying':
        return ColorName.flying;
      case 'ghost':
        return ColorName.ghost;
      case 'normal':
        return ColorName.normal;
      case 'grass':
        return ColorName.grass;
      case 'ground':
        return ColorName.ground;
      case 'ice':
        return ColorName.ice;
      case 'poison':
        return ColorName.poison;
      case 'psychic':
        return ColorName.psychic;
      case 'rock':
        return ColorName.rock;
      case 'steel':
        return ColorName.steel;
      case 'water':
        return ColorName.water;
      default:
        return Colors.black;
    }
  }
}
