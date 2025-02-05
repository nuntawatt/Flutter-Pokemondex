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
      appBar: AppBar(
        title: Text(widget.pokemonListItem.name.toUpperCase()),
        backgroundColor: const Color.fromARGB(255, 39, 52, 65),
        foregroundColor: const Color.fromARGB(255, 238, 238, 98),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              padding: const EdgeInsets.all(16),
              color: Colors.black,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[900],
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.5),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Image.network(
                        _pokemonData?['sprites']['other']['official-artwork']
                                ['front_default'] ??
                            '',
                        height: 200,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Type: ${_pokemonData?['types'][0]['type']['name'].toUpperCase()}',
                    style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  const SizedBox(height: 20),
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
                              padding: const EdgeInsets.symmetric(vertical: 6),
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
