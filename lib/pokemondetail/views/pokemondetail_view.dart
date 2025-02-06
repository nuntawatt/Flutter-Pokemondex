import 'package:flutter/material.dart';
import 'package:pokemondex/pokemonlist/models/pokemonlist_response.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PokemondetailView extends StatefulWidget {
  final PokemonListItem pokemonListItem;

  const PokemondetailView({Key? key, required this.pokemonListItem})
      : super(key: key);

  @override
  State<PokemondetailView> createState() => _PokemondetailViewState();
}

class _PokemondetailViewState extends State<PokemondetailView> {
  Map<String, dynamic>? _pokemonData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    final response = await http.get(Uri.parse(widget.pokemonListItem.url));

    if (response.statusCode == 200) {
      setState(() {
        _pokemonData = jsonDecode(response.body);
        _isLoading = false;
      });
    } else {
      throw Exception('Failed to load Pokémon details');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(widget.pokemonListItem.name.toUpperCase()),
        backgroundColor: Colors.blueGrey[900],
        foregroundColor: Colors.yellowAccent,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image Container
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blueGrey[800],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.blueAccent.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Image.network(
                      _pokemonData?['sprites']['other']['official-artwork']
                              ['front_default'] ??
                          '',
                      height: 200,
                    ),
                  ),
                  const SizedBox(height: 20),
                  // Pokémon Type
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: (_pokemonData?['types'] as List<dynamic>)
                        .map((type) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 4),
                              child: Chip(
                                label: Text(
                                  type['type']['name'].toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white),
                                ),
                                backgroundColor: Colors.purpleAccent,
                              ),
                            ))
                        .toList(),
                  ),
                  const SizedBox(height: 15),
                  // Height & Weight
                  Text(
                    "Height: ${_pokemonData?['height']}m  |  Weight: ${_pokemonData?['weight']}kg",
                    style: const TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  const SizedBox(height: 20),
                  // Base Stats
                  const Text(
                    'Base Stats',
                    style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Column(
                    children: (_pokemonData?['stats'] as List<dynamic>)
                        .map((stat) => Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 100,
                                    child: Text(
                                      stat['stat']['name'].toUpperCase(),
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white),
                                    ),
                                  ),
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: LinearProgressIndicator(
                                        value: stat['base_stat'] / 100,
                                        backgroundColor: Colors.grey[700],
                                        color: Colors.blue,
                                        minHeight: 12,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    width: 40,
                                    child: Text(
                                      stat['base_stat'].toString(),
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: Colors.white),
                                    ),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
    );
  }
}
