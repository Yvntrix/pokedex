import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pokedex/l10n/l10n.dart';
import 'package:pokedex/pages/home/bloc/pokedex_bloc.dart';
import 'package:pokedex/pages/home/widgets/loader.dart';
import 'package:pokedex/pages/home/widgets/pokemon_tile.dart';

class PokedexList extends StatefulWidget {
  const PokedexList({super.key});

  @override
  State<PokedexList> createState() => _PokedexListState();
}

class _PokedexListState extends State<PokedexList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return BlocBuilder<PokedexBloc, PokedexState>(
      builder: (context, state) {
        switch (state.status) {
          case PokedexStatus.failure:
            return Center(child: Text(l10n.failed_pokedex));
          case PokedexStatus.success:
            if (state.pokemons.isEmpty) {
              return Center(child: Text(l10n.empty_pokedex));
            }
            return _content(state);
          case PokedexStatus.initial:
            return const Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _content(PokedexState state) => GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
        ),
        itemBuilder: (BuildContext context, int index) {
          return index >= state.pokemons.length
              ? const Loader()
              : PokemonTile(
                  state.pokemons[index],
                );
        },
        itemCount: state.pokemons.length + 1,
        controller: _scrollController,
      );

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_isBottom) context.read<PokedexBloc>().add(PokedexFetched());
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.offset;
    return currentScroll >= (maxScroll * 1);
  }
}
