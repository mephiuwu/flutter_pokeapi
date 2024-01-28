// En main.dart
import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/pokemon_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi aplicación',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(
                builder: (context) => const MyHomePage(title: 'Flutter'));
          case '/pokemon':
            return MaterialPageRoute(builder: (context) => PokemonListScreen());
          default:
            // Manejar rutas no encontradas
            return MaterialPageRoute(builder: (context) => NotFoundScreen());
        }
      },
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404 - No encontrado')),
      body: const Center(child: Text('Página no encontrada')),
    );
  }
}
