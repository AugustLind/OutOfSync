part of '../main.dart';

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
    currentGame = Game(code: code, hostName: name, isHost: true);
    showDialog(
      context: context,
      builder: (_) => CupertinoAlertDialog(
        title: const Text(
          'Spill opprettet!',
          style: AppTheme.headlineTextStyle,
        ),
        content: Padding(
          padding: const EdgeInsets.only(top: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Andre kan nå bli med i spillet ditt via WiFi!',
                style: AppTheme.bodyTextStyle,
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: AppTheme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Spillkode: $code',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.primaryColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          CupertinoDialogAction(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (_) => LobbyPage(
                    game: currentGame!,
                    playerName: name,
                  ),
                ),
              );
            },
            child: const Text(
              'Start lobby',
              style: TextStyle(color: AppTheme.primaryColor),
            ),
          )
        ],
      ),
    );
  }

  Future<void> _joinGame() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showMessage('Skriv inn navn for å bli med i spillet');
      return;
    }

    _showMessage('Søker etter spill på WiFi...');
    
    final networkManager = NetworkManager(
      onMessageReceived: (message) {},
      onPlayerJoined: (player) {},
      onPlayerLeft: (player) {},
    );
    
    await networkManager.initialize();
    availableGames = await networkManager.discoverGames();
    networkManager.dispose();

    if (availableGames.isEmpty) {
      _showMessage('Fant ingen tilgjengelige spill på WiFi');
      return;
    }

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text(
            'Tilgjengelige spill',
            style: AppTheme.headlineTextStyle,
          ),
          content: Container(
            width: double.maxFinite,
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: availableGames.length,
              separatorBuilder: (context, index) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final game = availableGames[index];
                return CupertinoButton(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  onPressed: () async {
                    Navigator.of(context).pop();
                    await _joinNetworkGame(game, name);
                  },
                  child: Column(
                    children: [
                      Text(
                        'Spill: ${game.code}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.textPrimary,
                        ),
                      ),
                      Text(
                        'Host: ${game.hostIP}',
                        style: AppTheme.captionTextStyle,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: [
            CupertinoDialogAction(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'Avbryt',
                style: TextStyle(color: AppTheme.textSecondary),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _joinNetworkGame(GameInfo gameInfo, String playerName) async {
    currentGame = Game(code: gameInfo.code, hostName: 'Host', isHost: false);
    
    final networkManager = NetworkManager(
      onMessageReceived: currentGame!._handleNetworkMessage,
      onPlayerJoined: (player) {},
      onPlayerLeft: (player) {},
    );
    
    currentGame!.networkManager = networkManager;
    await networkManager.initialize();
    await networkManager.joinGame(gameInfo.hostIP);
    
    networkManager.sendMessage({
      'type': 'player_joined',
      'player_name': playerName,
    });
    
    if (!mounted) return;
    Navigator.of(context).push(
      CupertinoPageRoute(
        builder: (_) => LobbyPage(
          game: currentGame!,
          playerName: playerName,
        ),
      ),
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
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(AppTheme.spacing),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 60),
                Center(
                  child: Column(
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppTheme.primaryColor.withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.people_alt_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Out of Sync',
                        style: AppTheme.titleTextStyle,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Finn ut hvem som skiller seg ut',
                        style: AppTheme.captionTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 60),
                IOSCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Skriv inn ditt navn',
                        style: AppTheme.headlineTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      IOSTextField(
                        label: 'Navn',
                        controller: _nameController,
                      ),
                      const SizedBox(height: 24),
                      IOSButton(
                        text: 'Lag nytt spill',
                        onPressed: _createGame,
                        isPrimary: true,
                        isLarge: true,
                      ),
                      const SizedBox(height: 12),
                      IOSButton(
                        text: 'Bli med i spill',
                        onPressed: _joinGame,
                        isLarge: true,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                IOSCard(
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              color: AppTheme.successColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Icon(
                              Icons.wifi_rounded,
                              color: AppTheme.successColor,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'WiFi-basert multiplayer',
                                  style: AppTheme.bodyTextStyle,
                                ),
                                Text(
                                  'Koble til samme WiFi-nettverk',
                                  style: AppTheme.captionTextStyle,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
