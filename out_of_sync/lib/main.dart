import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _createGame() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showMessage('Skriv inn navn for å lage spillet');
      return;
    }
    final code = _generateCode();
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Spill opprettet'),
        content: Text('Del denne koden med andre: $code'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          )
        ],
      ),
    );
  }

  void _joinGame() {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showMessage('Skriv inn navn for å bli med i spillet');
      return;
    }
    String code = '';
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Oppgi spillkode'),
          content: TextField(
            autofocus: true,
            onChanged: (value) => code = value.trim(),
            decoration: const InputDecoration(
              labelText: 'Kode',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Avbryt'),
            ),
            TextButton(
              onPressed: () {
                if (code.isEmpty) {
                  _showMessage('Kode kan ikke være tom');
                  return;
                }
                Navigator.of(context).pop();
                _showMessage('Bli med i spillet med kode: $code');
              },
              child: const Text('Bli med'),
            ),
          ],
        );
      },
    );
  }

  String _generateCode() {
    const chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789';
    final rand = Random();
    return List.generate(4, (_) => chars[rand.nextInt(chars.length)]).join();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Navn',
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _createGame,
                    child: const Text('Lag spill'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: _joinGame,
                    child: const Text('Bli med'),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

