import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../widgets/custom_app_bar.dart';

class PokemonListScreen extends StatefulWidget {
  @override
  _PokemonListScreenState createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  late Future<List<Map<String, dynamic>>> pokemonDataList;
  late Future<List<Map<String, dynamic>>> pokemonData;
  late ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    // _scrollController = ScrollController();
    pokemonDataList = fetchPokemonData();
    // _scrollController.addListener(_onScroll);
  }

  Future<List<Map<String, dynamic>>> fetchPokemonData() async {
    final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=100000&offset=0'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var results = jsonResponse['results'];
      return List<Map<String, dynamic>>.from(results);
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

  // Future<void> loadMorePokemon() async {
  //   try {
  //     final response = await http.get(
  //         Uri.parse('https://pokeapi.co/api/v2/pokemon?offset=20&limit=20'));

  //     if (response.statusCode == 200) {
  //       var jsonResponse = json.decode(response.body);
  //       var results = jsonResponse['results'];
  //       var morePokemonData = List<Map<String, dynamic>>.from(results);

  //       var currentPokemonDataList = await pokemonDataList;
  //       currentPokemonDataList.addAll(morePokemonData);

  //       setState(() {
  //         pokemonDataList = Future.value(currentPokemonDataList);
  //       });
  //     } else {
  //       throw Exception('Error al cargar más datos');
  //     }
  //   } catch (e) {
  //     throw Exception('Error al cargar más datos');
  //   }
  // }

  // void _onScroll() {
  //   if (_scrollController.position.pixels ==
  //       _scrollController.position.maxScrollExtent) {
  //     loadMorePokemon();
  //   }
  // }

  Future<Map<String, dynamic>> getPokemon(int id, String name) async {
    try {
      final response =
          await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$name'));

      if (response.statusCode != 200)
        throw Exception('Error al cargar los datos');

      final imageResponse = await http.get(Uri.parse(
          'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/$id.png'));

      final Map<String, dynamic> pokemonData = json.decode(response.body);
      pokemonData['image'] = imageResponse.bodyBytes;

      return pokemonData;
    } catch (e) {
      throw Exception('Error al cargar los datos');
    }
  }

  void showPokemonDetailsModal(
      BuildContext context, Map<String, dynamic> pokemonData) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20.0),
        ),
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16.0),
            width: MediaQuery.of(context).size.width * 0.9,
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center, // Centrar verticalmente
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  '#${pokemonData['id']} | ${pokemonData['name']}',
                  style: const TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16.0),
                Image.memory(
                  pokemonData['image'],
                  width: 200.0,
                  height: 200.0,
                ),
                const Text('Tipos:'),
                Wrap(
                  spacing: 8.0, // Espaciado entre los chips
                  children: [
                    for (var type in pokemonData['types'])
                      Chip(
                        label: Text(
                          getTranslatedIntoSpanish(type['type']['name']),
                          style: const TextStyle(
                            color: Colors.white, // Color del texto
                            fontWeight: FontWeight.bold, // Grosor de la fuente
                            shadows: [
                              Shadow(
                                color: Colors.black, // Color del borde
                                blurRadius: 3.0,
                              ),
                            ],
                          ),
                        ),
                        backgroundColor: getColorForType(type['type']['name']),
                      ),
                  ],
                ),
                const Text('Habilidades:'),
                for (var ability in pokemonData['abilities'])
                  Text('- ${ability['ability']['name']}'),
              ],
            ),
          ),
        );
      },
    );
  }

  Color getColorForType(String typeName) {
    switch (typeName) {
      case 'normal':
        return Colors.grey;
      case 'fire':
        return Colors.red;
      case 'water':
        return Colors.blue;
      case 'electric':
        return Colors.yellow;
      case 'ice':
        return Colors.cyan;
      case 'fighting':
        return Colors.brown;
      case 'flying':
        return const Color(0xFF81D4FA);
      case 'ground':
        return Colors.brown;
      case 'psychic':
        return Colors.pink;
      case 'bug':
        return const Color(0xFFB3BC23);
      case 'poison':
        return const Color(0xFFA55DA6);
      case 'grass':
        return const Color(0xFF7DC53F);
      case 'rock':
        return Colors.brown;
      case 'ghost':
        return const Color(0xFF705898); // Fantasma
      case 'dragon':
        return const Color(0xFF7038F8); // Dragón
      case 'dark':
        return const Color(0xFF705848); // Siniestro
      case 'steel':
        return Colors.grey;
      case 'fairy':
        return const Color(0xFFEE99AC);
      default:
        return Colors.grey;
    }
  }

  String getTranslatedIntoSpanish(String type) {
    switch (type) {
      case 'normal':
        return 'Normal';
      case 'fire':
        return 'Fuego';
      case 'water':
        return 'Agua';
      case 'electric':
        return 'Eléctrico';
      case 'flying':
        return 'Volador';
      case 'ice':
        return 'Hielo';
      case 'ground':
        return 'Tierra';
      case 'psychic':
        return 'Psíquico';
      case 'bug':
        return 'Bicho';
      case 'poison':
        return 'Veneno';
      case 'grass':
        return 'Planta';
      case 'rock':
        return 'Roca';
      case 'ghost':
        return 'Fantasma';
      case 'dragon':
        return 'Dragón';
      case 'dark':
        return 'Siniestro';
      case 'steel':
        return 'Acero';
      case 'fairy':
        return 'Hada';
      default:
        return type;
    }
  }

  // @override
  // void dispose() {
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Pokémones',
      ),
      body: Center(
        child: FutureBuilder<List<Map<String, dynamic>>>(
          future: pokemonDataList,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              final pokemonList = snapshot.data;
              return ListView.builder(
                // controller: _scrollController,
                padding: const EdgeInsets.all(16.0),
                itemCount: pokemonList?.length ?? 0,
                itemBuilder: (context, index) {
                  var number = index + 1;
                  final pokemon = pokemonList?[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text('${pokemon?['name'] ?? 'Desconocido'}'),
                      subtitle: Text('Número: ${number}'),
                      onTap: () async {
                        final pokemonData =
                            await getPokemon(number, pokemon?['name']);
                        showPokemonDetailsModal(context, pokemonData);
                      },
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
