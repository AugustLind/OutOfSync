import 'dart:math';
import 'package:flutter/material.dart';

class Game extends ChangeNotifier {
  final String code;
  final String hostName;
  final List<String> players;

  Game({required this.code, required this.hostName}) : players = [hostName];

  void addPlayer(String name) {
    players.add(name);
    notifyListeners();
  }
}

Game? currentGame;

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
    currentGame = Game(code: code, hostName: name);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Spill opprettet'),
        content: Text('Del denne koden med andre: $code'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => LobbyPage(
                    game: currentGame!,
                    playerName: name,
                  ),
                ),
              );
            },
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
                if (currentGame == null || currentGame!.code != code) {
                  Navigator.of(context).pop();
                  _showMessage('Fant ikke spill med kode: $code');
                  return;
                }
                currentGame!.addPlayer(name);
                Navigator.of(context).pop();
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => LobbyPage(
                      game: currentGame!,
                      playerName: name,
                    ),
                  ),
                );
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

class LobbyPage extends StatelessWidget {
  final Game game;
  final String playerName;

  const LobbyPage({super.key, required this.game, required this.playerName});

  @override
  Widget build(BuildContext context) {
    final bool isHost = playerName == game.hostName;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lobby – ${game.code}'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: game,
          builder: (context, _) {
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Spillere (${game.players.length})'),
                const SizedBox(height: 16),
                for (final player in game.players) Text(player),
                const SizedBox(height: 32),
                if (isHost)
                  ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Spill startet')),
                      );
                    },
                    child: const Text('Start spill'),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

