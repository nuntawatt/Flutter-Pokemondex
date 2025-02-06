import 'package:flutter/material.dart';
import 'package:pokemondex/pokemonlist/views/pokemonlist_view.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: Colors.black87,
        scaffoldBackgroundColor: const Color.fromARGB(255, 255, 255, 255),
        fontFamily: 'Pokemon',
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Pokémon Dex',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              letterSpacing: 2.0,
            ),
          ),
          backgroundColor: const Color.fromARGB(255, 31, 50, 69),
          foregroundColor: Color(0xFFFFD700),
          centerTitle: true,
          elevation: 10,
          shadowColor: Colors.black,
        ),
        body: const PokemonList(),
      ),
    );
  }
}
