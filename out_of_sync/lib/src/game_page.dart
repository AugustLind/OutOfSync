part of '../main.dart';

class GamePage extends StatefulWidget {
  final Game game;
  final String playerName;

  const GamePage({super.key, required this.game, required this.playerName});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  Timer? _voteTimer;
  bool _showVoteButton = false;
  bool _readyPressed = false;
  bool _hasVoted = false;
  late final bool _isOdd;

  @override
  void initState() {
    super.initState();
    _isOdd = widget.game.players.indexOf(widget.playerName) ==
        widget.game.oddPlayerIndex;
    _voteTimer = Timer(const Duration(seconds: 10), () {
      if (!mounted) return;
      setState(() {
        _showVoteButton = true;
      });
    });
  }

  @override
  void dispose() {
    _voteTimer?.cancel();
    super.dispose();
  }

  Widget _buildGameImage() {
    final imageUrl = _isOdd 
        ? (widget.game.oddImage ?? 'https://i.pravatar.cc/300?img=2')
        : (widget.game.sameImage ?? 'https://i.pravatar.cc/300?img=1');
    
    // Check if it's a local file path or network URL
    if (imageUrl.startsWith('http')) {
      return Image.network(
        imageUrl,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
            child: const Center(
              child: CupertinoActivityIndicator(),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
            child: const Center(
              child: Icon(
                Icons.broken_image,
                size: 50,
                color: AppTheme.textSecondary,
              ),
            ),
          );
        },
      );
    } else if (imageUrl.startsWith('/')) {
      // Local file path
      return Image.file(
        File(imageUrl),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
            child: const Center(
              child: Icon(
                Icons.broken_image,
                size: 50,
                color: AppTheme.textSecondary,
              ),
            ),
          );
        },
      );
    } else {
      // Asset image
      return Image.asset(
        imageUrl,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            width: double.infinity,
            height: 250,
            decoration: BoxDecoration(
              color: AppTheme.backgroundColor,
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
            ),
            child: const Center(
              child: Icon(
                Icons.broken_image,
                size: 50,
                color: AppTheme.textSecondary,
              ),
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.game,
      builder: (context, _) {
        Widget content;
        if (widget.game.voteResult != null) {
          final winner = widget.game.voteResult!;
          final isCurrentPlayerWinner = winner == widget.playerName;
          content = IOSCard(
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: isCurrentPlayerWinner 
                          ? [AppTheme.successColor, AppTheme.primaryColor]
                          : [AppTheme.destructiveColor, AppTheme.warningColor],
                    ),
                    borderRadius: BorderRadius.circular(40),
                  ),
                  child: Icon(
                    isCurrentPlayerWinner ? Icons.emoji_events : Icons.close,
                    color: Colors.white,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  isCurrentPlayerWinner ? 'Du ble mest stemt på!' : 'Mest stemt på:',
                  style: AppTheme.headlineTextStyle,
                ),
                const SizedBox(height: 8),
                Text(
                  winner,
                  style: AppTheme.titleTextStyle.copyWith(
                    color: isCurrentPlayerWinner ? AppTheme.successColor : AppTheme.destructiveColor,
                  ),
                ),
                const SizedBox(height: 16),
                IOSButton(
                  text: 'Nytt spill',
                  onPressed: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                  isPrimary: true,
                ),
              ],
            ),
          );
        } else if (widget.game.votingStarted) {
          if (_hasVoted) {
            content = IOSCard(
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.primaryColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.hourglass_empty,
                      color: AppTheme.primaryColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Stemme avgitt!',
                    style: AppTheme.headlineTextStyle,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Venter på at andre stemmer...',
                    style: AppTheme.captionTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else {
            content = Column(
              children: [
                IOSCard(
                  child: Column(
                    children: [
                      const Icon(
                        Icons.how_to_vote,
                        color: AppTheme.primaryColor,
                        size: 40,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'Stem på en spiller',
                        style: AppTheme.headlineTextStyle,
                      ),
                      const SizedBox(height: 8),
                      const Text(
                        'Hvem skiller seg mest ut?',
                        style: AppTheme.captionTextStyle,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                ...widget.game.players.map((player) {
                  final isCurrentPlayer = player == widget.playerName;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: IOSButton(
                      text: isCurrentPlayer ? '$player (deg selv)' : player,
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        widget.game.vote(widget.playerName, player);
                        setState(() {
                          _hasVoted = true;
                        });
                      },
                      isPrimary: !isCurrentPlayer,
                      isDestructive: isCurrentPlayer,
                      isLarge: true,
                    ),
                  );
                }),
              ],
            );
          }
        } else {
          if (_readyPressed) {
            content = IOSCard(
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.successColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.check_circle_outline,
                      color: AppTheme.successColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Du er klar!',
                    style: AppTheme.headlineTextStyle,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Venter på at andre blir klare...',
                    style: AppTheme.captionTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          } else if (_showVoteButton) {
            content = IOSCard(
              child: Column(
                children: [
                  const Icon(
                    Icons.visibility,
                    color: AppTheme.primaryColor,
                    size: 40,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Studer bildet',
                    style: AppTheme.headlineTextStyle,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Se på bildet og forbered deg på å stemme',
                    style: AppTheme.captionTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  IOSButton(
                    text: 'Klar for å stemme',
                    onPressed: () {
                      HapticFeedback.mediumImpact();
                      widget.game.readyToVote(widget.playerName);
                      setState(() {
                        _readyPressed = true;
                        _showVoteButton = false;
                      });
                    },
                    isPrimary: true,
                    isLarge: true,
                  ),
                ],
              ),
            );
          } else {
            content = IOSCard(
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: AppTheme.warningColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: const Icon(
                      Icons.timer,
                      color: AppTheme.warningColor,
                      size: 30,
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Studerer bildet...',
                    style: AppTheme.headlineTextStyle,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Se nøye på bildet. Stemmeknappen kommer snart.',
                    style: AppTheme.captionTextStyle,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Spill'),
            leading: CupertinoButton(
              padding: EdgeInsets.zero,
              onPressed: () => Navigator.of(context).popUntil((route) => route.isFirst),
              child: const Icon(
                CupertinoIcons.home,
                color: AppTheme.primaryColor,
              ),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppTheme.spacing),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  IOSCard(
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                          child: Container(
                            width: double.infinity,
                            height: 250,
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: _isOdd ? AppTheme.destructiveColor : AppTheme.successColor,
                                width: 3,
                              ),
                              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                            ),
                            child: _buildGameImage(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (widget.game.sameName != null && widget.game.oddName != null) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            decoration: BoxDecoration(
                              color: AppTheme.cardColor,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: (_isOdd ? AppTheme.destructiveColor : AppTheme.successColor).withOpacity(0.3),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              _isOdd ? widget.game.oddName! : widget.game.sameName!,
                              style: AppTheme.headlineTextStyle.copyWith(
                                color: _isOdd ? AppTheme.destructiveColor : AppTheme.successColor,
                                fontSize: 18,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          const SizedBox(height: 12),
                        ],
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: (_isOdd ? AppTheme.destructiveColor : AppTheme.successColor).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            _isOdd ? 'Du er den som skiller seg ut' : 'Du er i gruppa',
                            style: TextStyle(
                              color: _isOdd ? AppTheme.destructiveColor : AppTheme.successColor,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  content,
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
