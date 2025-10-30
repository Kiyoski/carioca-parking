
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/home_screen.dart'; // Importa a nova tela

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carioca Park',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark, // Tema escuro
        scaffoldBackgroundColor: Colors.grey[900],
        cardColor: Colors.grey[850],
      ),
      home: const HomeScreen(), // Define a HomeScreen como tela inicial
    );
  }
}
