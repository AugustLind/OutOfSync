import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';

class Game extends ChangeNotifier {
  final String code;
  final String hostName;
  final List<String> players;
  int? oddPlayerIndex;
  bool started = false;

  final Set<String> readyPlayers = {};
  bool votingStarted = false;
  final Map<String, String> votes = {};
  String? voteResult;

  Game({required this.code, required this.hostName}) : players = [hostName];

  void addPlayer(String name) {
    players.add(name);
    notifyListeners();
  }

  void startGame() {
    oddPlayerIndex = Random().nextInt(players.length);
    started = true;
    readyPlayers.clear();
    votes.clear();
    votingStarted = false;
    voteResult = null;
    notifyListeners();
  }

  void readyToVote(String player) {
    readyPlayers.add(player);
    if (readyPlayers.length == players.length) {
      votingStarted = true;
    }
    notifyListeners();
  }

  void vote(String voter, String votee) {
    votes[voter] = votee;
    if (votes.length == players.length) {
      final counts = <String, int>{};
      for (final choice in votes.values) {
        counts[choice] = (counts[choice] ?? 0) + 1;
      }
      voteResult = counts.entries
          .reduce((a, b) => a.value >= b.value ? a : b)
          .key;
    }
    notifyListeners();
  }
}

class GamePage extends StatefulWidget {
  final Game game;
  final String playerName;

  const GamePage({super.key, required this.game, required this.playerName});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool _showVoteButton = false;
  bool _readyPressed = false;
  bool _hasVoted = false;
  late final bool _isOdd;
  static const _sameImage = 'https://i.pravatar.cc/300?img=1';
  static const _oddImage = 'https://i.pravatar.cc/300?img=2';

  @override
  void initState() {
    super.initState();
    _isOdd = widget.game.players.indexOf(widget.playerName) ==
        widget.game.oddPlayerIndex;
    Timer(const Duration(seconds: 10), () {
      setState(() {
        _showVoteButton = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.game,
      builder: (context, _) {
        Widget content;
        if (widget.game.voteResult != null) {
          content = Text('Most voted: ${widget.game.voteResult}');
        } else if (widget.game.votingStarted) {
          if (_hasVoted) {
            content = const Text('Waiting for others to vote...');
          } else {
            content = Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Vote for a player'),
                const SizedBox(height: 16),
                for (final player in widget.game.players)
                  ElevatedButton(
                    onPressed: () {
                      widget.game.vote(widget.playerName, player);
                      setState(() {
                        _hasVoted = true;
                      });
                    },
                    child: Text(player),
                  ),
              ],
            );
          }
        } else {
          if (_readyPressed) {
            content = const Text('Waiting for others to be ready...');
          } else if (_showVoteButton) {
            content = ElevatedButton(
              onPressed: () {
                widget.game.readyToVote(widget.playerName);
                setState(() {
                  _readyPressed = true;
                  _showVoteButton = false;
                });
              },
              child: const Text('Ready to Vote'),
            );
          } else {
            content = const SizedBox.shrink();
          }
        }

        return Scaffold(
          body: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.network(_isOdd ? _oddImage : _sameImage),
                const SizedBox(height: 32),
                content,
              ],
            ),
          ),
        );
      },
    );
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

class LobbyPage extends StatefulWidget {
  final Game game;
  final String playerName;

  const LobbyPage({super.key, required this.game, required this.playerName});

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> {
  bool _navigated = false;

  @override
  Widget build(BuildContext context) {
    final bool isHost = widget.playerName == widget.game.hostName;

    return Scaffold(
      appBar: AppBar(
        title: Text('Lobby – ${widget.game.code}'),
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: widget.game,
          builder: (context, _) {
            if (widget.game.started && !_navigated) {
              _navigated = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (_) => GamePage(
                      game: widget.game,
                      playerName: widget.playerName,
                    ),
                  ),
                );
              });
            }

            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Spillere (${widget.game.players.length})'),
                const SizedBox(height: 16),
                for (final player in widget.game.players) Text(player),
                const SizedBox(height: 32),
                if (isHost)
                  ElevatedButton(
                    onPressed: () {
                      widget.game.startGame();
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

