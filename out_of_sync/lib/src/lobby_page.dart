part of '../main.dart';

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
        title: Column(
          children: [
            const Text('Lobby'),
            Text(
              'Kode: ${widget.game.code}',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.normal,
                color: AppTheme.textSecondary,
              ),
            ),
          ],
        ),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: const Icon(
            CupertinoIcons.back,
            color: AppTheme.primaryColor,
          ),
        ),
      ),
      body: SafeArea(
        child: AnimatedBuilder(
          animation: widget.game,
          builder: (context, _) {
            if (widget.game.started && !_navigated) {
              _navigated = true;
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.of(context).pushReplacement(
                  CupertinoPageRoute(
                    builder: (_) => GamePage(
                      game: widget.game,
                      playerName: widget.playerName,
                    ),
                  ),
                );
              });
            }

            return Padding(
              padding: const EdgeInsets.all(AppTheme.spacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  IOSCard(
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppTheme.primaryColor, AppTheme.secondaryColor],
                                ),
                                borderRadius: BorderRadius.circular(25),
                              ),
                              child: const Icon(
                                Icons.people_rounded,
                                color: Colors.white,
                                size: 24,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Spillere i lobbyen',
                                    style: AppTheme.headlineTextStyle,
                                  ),
                                  Text(
                                    '${widget.game.players.length} spillere',
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
                  const SizedBox(height: 20),
                  Expanded(
                    child: IOSCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const Text(
                            'Spillere',
                            style: AppTheme.headlineTextStyle,
                          ),
                          const SizedBox(height: 16),
                          Expanded(
                            child: ListView.separated(
                              itemCount: widget.game.players.length,
                              separatorBuilder: (context, index) => const Divider(),
                              itemBuilder: (context, index) {
                                final player = widget.game.players[index];
                                final isCurrentPlayer = player == widget.playerName;
                                final isHostPlayer = player == widget.game.hostName;
                                
                                return Container(
                                  padding: const EdgeInsets.symmetric(vertical: 12),
                                  child: Row(
                                    children: [
                                      CircleAvatar(
                                        backgroundColor: isCurrentPlayer 
                                            ? AppTheme.primaryColor 
                                            : AppTheme.textSecondary.withOpacity(0.2),
                                        radius: 20,
                                        child: Text(
                                          player[0].toUpperCase(),
                                          style: TextStyle(
                                            color: isCurrentPlayer 
                                                ? Colors.white 
                                                : AppTheme.textSecondary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Row(
                                              children: [
                                                Text(
                                                  player,
                                                  style: AppTheme.bodyTextStyle.copyWith(
                                                    fontWeight: isCurrentPlayer 
                                                        ? FontWeight.bold 
                                                        : FontWeight.normal,
                                                  ),
                                                ),
                                                if (isCurrentPlayer) ...[
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: AppTheme.primaryColor,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: const Text(
                                                      'Du',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                                if (isHostPlayer) ...[
                                                  const SizedBox(width: 8),
                                                  Container(
                                                    padding: const EdgeInsets.symmetric(
                                                        horizontal: 8, vertical: 2),
                                                    decoration: BoxDecoration(
                                                      color: AppTheme.warningColor,
                                                      borderRadius: BorderRadius.circular(10),
                                                    ),
                                                    child: const Text(
                                                      'Host',
                                                      style: TextStyle(
                                                        fontSize: 12,
                                                        color: Colors.white,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  if (isHost && widget.game.players.length >= 2) ...[
                    IOSButton(
                      text: 'Bildeinnstillinger',
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => ImageSettingsPage(
                              game: widget.game,
                            ),
                          ),
                        );
                      },
                      isLarge: true,
                    ),
                    const SizedBox(height: 12),
                    IOSButton(
                      text: 'Start spill',
                      onPressed: () async {
                        HapticFeedback.mediumImpact();
                        await widget.game.startGame();
                      },
                      isPrimary: true,
                      isLarge: true,
                    ),
                  ],
                  if (isHost && widget.game.players.length < 2)
                    IOSCard(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.info_outline,
                            color: AppTheme.warningColor,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Trenger minst 2 spillere for å starte',
                              style: AppTheme.bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (!isHost)
                    IOSCard(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.hourglass_empty,
                            color: AppTheme.primaryColor,
                          ),
                          const SizedBox(width: 12),
                          const Expanded(
                            child: Text(
                              'Venter på at host starter spillet...',
                              style: AppTheme.bodyTextStyle,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
