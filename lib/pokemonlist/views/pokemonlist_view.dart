import 'package:flutter/material.dart';
import '../../pokemondetail/views/pokemondetail_view.dart';
import '../models/pokemonlist_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  State<PokemonList> createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  List<PokemonListItem> _pokemonList = [];
  String _nextPageUrl = 'https://pokeapi.co/api/v2/pokemon';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    if (_isLoading || _nextPageUrl.isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    final response = await http.get(Uri.parse(_nextPageUrl));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      setState(() {
        _pokemonList.addAll((data['results'] as List)
            .map((item) => PokemonListItem.fromJson(item))
            .toList());
        _nextPageUrl = data['next'] ?? '';
      });
    } else {
      throw Exception('Failed to load Pokémon list');
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(20),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 0.9,
              ),
              itemCount: _pokemonList.length,
              itemBuilder: (context, index) {
                final pokemon = _pokemonList[index];
                final pokemonId = index + 1;
                final imageUrl =
                    'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$pokemonId.png';

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            PokemondetailView(pokemonListItem: pokemon),
                      ),
                    );
                  },
                  child: Card(
                    color: Colors.blueGrey.shade900,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          padding: const EdgeInsets.all(20),
                          child: Image.network(imageUrl, width: 80, height: 80),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "#${pokemonId.toString().padLeft(3, '0')}",
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          pokemon.name.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          if (_nextPageUrl.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(20),
              child: ElevatedButton(
                onPressed: _isLoading ? null : loadData,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 6, 122, 12),
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                ),
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Load More'),
              ),
            ),
        ],
      ),
    );
  }
}
