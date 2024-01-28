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
  late Future<List<Map<String, dynamic>>> PokemonData;

  @override
  void initState() {
    super.initState();
    pokemonDataList = fetchPokemonData();
  }

  Future<List<Map<String, dynamic>>> fetchPokemonData() async {
    final response =
        await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/'));
    if (response.statusCode == 200) {
      var jsonResponse = json.decode(response.body);
      var results = jsonResponse['results'];
      return List<Map<String, dynamic>>.from(results);
    } else {
      throw Exception('Error al cargar los datos');
    }
  }

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
                        BuildContext currentContext =
                            context; // Guardar el contexto
                        final pokemonData =
                            await getPokemon(number, pokemon?['name']);
                        showModalBottomSheet(
                          context: currentContext, // Usar el contexto guardado
                          builder: (BuildContext context) {
                            return Container(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '#${pokemonData['id']} | ${pokemonData['name']}',
                                    style: TextStyle(
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 16.0),
                                  Image.memory(
                                    pokemonData['image'],
                                    width:
                                        200.0, // Ajusta el ancho según tus necesidades
                                    height:
                                        200.0, // Ajusta la altura según tus necesidades
                                  ),
                                  Text('Tipos:'),
                                  for (var type in pokemonData['types'])
                                    Text('- ${type['type']['name']}'),
                                  Text('Habilidades:'),
                                  for (var ability in pokemonData['abilities'])
                                    Text('- ${ability['ability']['name']}'),
                                ],
                              ),
                            );
                          },
                        );
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
