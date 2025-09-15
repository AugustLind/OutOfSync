import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:network_info_plus/network_info_plus.dart';
import 'package:udp/udp.dart';
import 'package:image_picker/image_picker.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:lottie/lottie.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class AppTheme {
  static bool _isDarkMode = false;

  static bool get isDarkMode => _isDarkMode;
  static void setDarkMode(bool value) => _isDarkMode = value;

  // Light theme colors
  static const _lightPrimaryColor = Color(0xFF007AFF);
  static const _lightSecondaryColor = Color(0xFF5856D6);
  static const _lightBackgroundColor = Color(0xFFF2F2F7);
  static const _lightCardColor = Color(0xFFFFFFFF);
  static const _lightTextPrimary = Color(0xFF000000);
  static const _lightTextSecondary = Color(0xFF8E8E93);

  // Dark theme colors
  static const _darkPrimaryColor = Color(0xFF0A84FF);
  static const _darkSecondaryColor = Color(0xFF5E5CE6);
  static const _darkBackgroundColor = Color(0xFF000000);
  static const _darkCardColor = Color(0xFF1C1C1E);
  static const _darkTextPrimary = Color(0xFFFFFFFF);
  static const _darkTextSecondary = Color(0xFF8E8E93);

  // Common colors
  static const destructiveColor = Color(0xFFFF3B30);
  static const successColor = Color(0xFF34C759);
  static const warningColor = Color(0xFFFF9500);

  // Dynamic colors based on theme
  static Color get primaryColor => _isDarkMode ? _darkPrimaryColor : _lightPrimaryColor;
  static Color get secondaryColor => _isDarkMode ? _darkSecondaryColor : _lightSecondaryColor;
  static Color get backgroundColor => _isDarkMode ? _darkBackgroundColor : _lightBackgroundColor;
  static Color get cardColor => _isDarkMode ? _darkCardColor : _lightCardColor;
  static Color get textPrimary => _isDarkMode ? _darkTextPrimary : _lightTextPrimary;
  static Color get textSecondary => _isDarkMode ? _darkTextSecondary : _lightTextSecondary;

  static const borderRadius = 12.0;
  static const cardElevation = 0.0;
  static const spacing = 16.0;

  static TextStyle get titleTextStyle => TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );

  static TextStyle get headlineTextStyle => TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );

  static TextStyle get bodyTextStyle => TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );

  static TextStyle get captionTextStyle => TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );
}

class SoundManager {
  static final AudioPlayer _audioPlayer = AudioPlayer();
  static bool _soundEnabled = true;

  static bool get soundEnabled => _soundEnabled;
  static void setSoundEnabled(bool value) => _soundEnabled = value;

  static Future<void> playSound(String soundName) async {
    if (!_soundEnabled) return;

    try {
      await _audioPlayer.play(AssetSource('sounds/$soundName.mp3'));
    } catch (e) {
      print('Error playing sound: $e');
    }
  }

  static Future<void> playButtonTap() => playSound('button_tap');
  static Future<void> playGameStart() => playSound('game_start');
  static Future<void> playVoteSubmit() => playSound('vote_submit');
  static Future<void> playWin() => playSound('win');
  static Future<void> playLose() => playSound('lose');
  static Future<void> playPlayerJoin() => playSound('player_join');
  static Future<void> playCountdown() => playSound('countdown');

  static void dispose() {
    _audioPlayer.dispose();
  }
}

class PlayerScore {
  final String playerName;
  int wins;
  int losses;
  int gamesPlayed;
  List<String> achievements;

  PlayerScore({
    required this.playerName,
    this.wins = 0,
    this.losses = 0,
    this.gamesPlayed = 0,
    List<String>? achievements,
  }) : achievements = achievements ?? [];

  double get winRate => gamesPlayed > 0 ? wins / gamesPlayed : 0.0;

  Map<String, dynamic> toJson() => {
    'playerName': playerName,
    'wins': wins,
    'losses': losses,
    'gamesPlayed': gamesPlayed,
    'achievements': achievements,
  };

  factory PlayerScore.fromJson(Map<String, dynamic> json) => PlayerScore(
    playerName: json['playerName'],
    wins: json['wins'] ?? 0,
    losses: json['losses'] ?? 0,
    gamesPlayed: json['gamesPlayed'] ?? 0,
    achievements: List<String>.from(json['achievements'] ?? []),
  );
}

class ScoreManager {
  static const String _scoresKey = 'player_scores';
  static Map<String, PlayerScore> _scores = {};

  static Map<String, PlayerScore> get scores => _scores;

  static Future<void> loadScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final scoresJson = prefs.getString(_scoresKey);
      if (scoresJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(scoresJson);
        _scores = decoded.map((key, value) =>
          MapEntry(key, PlayerScore.fromJson(value)));
      }
    } catch (e) {
      print('Error loading scores: $e');
    }
  }

  static Future<void> saveScores() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final scoresJson = jsonEncode(_scores.map((key, value) =>
        MapEntry(key, value.toJson())));
      await prefs.setString(_scoresKey, scoresJson);
    } catch (e) {
      print('Error saving scores: $e');
    }
  }

  static Future<void> recordWin(String playerName) async {
    _scores[playerName] ??= PlayerScore(playerName: playerName);
    _scores[playerName]!.wins++;
    _scores[playerName]!.gamesPlayed++;
    await _checkAchievements(playerName);
    await saveScores();
  }

  static Future<void> recordLoss(String playerName) async {
    _scores[playerName] ??= PlayerScore(playerName: playerName);
    _scores[playerName]!.losses++;
    _scores[playerName]!.gamesPlayed++;
    await saveScores();
  }

  static Future<void> _checkAchievements(String playerName) async {
    final score = _scores[playerName]!;
    final achievements = <String>[];

    if (score.wins >= 1 && !score.achievements.contains('First Win')) {
      achievements.add('First Win');
    }
    if (score.wins >= 5 && !score.achievements.contains('Five Wins')) {
      achievements.add('Five Wins');
    }
    if (score.wins >= 10 && !score.achievements.contains('Ten Wins')) {
      achievements.add('Ten Wins');
    }
    if (score.winRate >= 0.8 && score.gamesPlayed >= 5 && !score.achievements.contains('Master Player')) {
      achievements.add('Master Player');
    }

    score.achievements.addAll(achievements);
  }

  static PlayerScore getPlayerScore(String playerName) {
    return _scores[playerName] ?? PlayerScore(playerName: playerName);
  }
}

enum PlayerColor {
  blue(Color(0xFF007AFF), 'Blå'),
  purple(Color(0xFF5856D6), 'Lilla'),
  green(Color(0xFF34C759), 'Grønn'),
  orange(Color(0xFFFF9500), 'Oransje'),
  red(Color(0xFFFF3B30), 'Rød'),
  pink(Color(0xFFFF2D92), 'Rosa'),
  yellow(Color(0xFFFFD60A), 'Gul'),
  teal(Color(0xFF40E0D0), 'Turkis');

  const PlayerColor(this.color, this.displayName);
  final Color color;
  final String displayName;
}

class PlayerProfile {
  final String name;
  final PlayerColor color;
  final String? avatarEmoji;

  PlayerProfile({
    required this.name,
    this.color = PlayerColor.blue,
    this.avatarEmoji,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'color': color.name,
    'avatarEmoji': avatarEmoji,
  };

  factory PlayerProfile.fromJson(Map<String, dynamic> json) => PlayerProfile(
    name: json['name'],
    color: PlayerColor.values.firstWhere(
      (c) => c.name == json['color'],
      orElse: () => PlayerColor.blue,
    ),
    avatarEmoji: json['avatarEmoji'],
  );
}

class IOSButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isDestructive;
  final bool isLarge;
  final bool enableSound;
  final bool enableHaptic;

  const IOSButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
    this.isLarge = false,
    this.enableSound = true,
    this.enableHaptic = true,
  });

  @override
  State<IOSButton> createState() => _IOSButtonState();
}

class _IOSButtonState extends State<IOSButton> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 150),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTap() async {
    if (widget.onPressed == null) return;

    // Play sound and haptic feedback
    if (widget.enableSound) {
      SoundManager.playButtonTap();
    }
    if (widget.enableHaptic) {
      if (widget.isDestructive) {
        HapticFeedback.heavyImpact();
      } else if (widget.isPrimary) {
        HapticFeedback.mediumImpact();
      } else {
        HapticFeedback.lightImpact();
      }
    }

    // Animate button press
    await _animationController.forward();
    await _animationController.reverse();

    widget.onPressed!();
  }

  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;

    if (widget.isDestructive) {
      backgroundColor = AppTheme.destructiveColor;
      textColor = Colors.white;
    } else if (widget.isPrimary) {
      backgroundColor = AppTheme.primaryColor;
      textColor = Colors.white;
    } else {
      backgroundColor = AppTheme.cardColor;
      textColor = AppTheme.primaryColor;
    }

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _scaleAnimation.value,
          child: Container(
            width: widget.isLarge ? double.infinity : null,
            height: widget.isLarge ? 56 : 44,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(AppTheme.borderRadius),
              border: !widget.isPrimary && !widget.isDestructive
                  ? Border.all(color: AppTheme.primaryColor, width: 1)
                  : null,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: _handleTap,
                borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                child: Center(
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                      color: textColor,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class CountdownTimer extends StatefulWidget {
  final int seconds;
  final VoidCallback? onComplete;
  final bool showNumbers;

  const CountdownTimer({
    super.key,
    required this.seconds,
    this.onComplete,
    this.showNumbers = true,
  });

  @override
  State<CountdownTimer> createState() => _CountdownTimerState();
}

class _CountdownTimerState extends State<CountdownTimer> with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  Timer? _timer;
  int _remaining = 0;

  @override
  void initState() {
    super.initState();
    _remaining = widget.seconds;
    _controller = AnimationController(
      duration: Duration(seconds: widget.seconds),
      vsync: this,
    );
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_controller);

    _startTimer();
  }

  void _startTimer() {
    _controller.forward();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remaining--;
      });

      if (_remaining <= 3 && _remaining > 0) {
        SoundManager.playCountdown();
        HapticFeedback.mediumImpact();
      }

      if (_remaining <= 0) {
        timer.cancel();
        widget.onComplete?.call();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.showNumbers)
          Text(
            '$_remaining',
            style: TextStyle(
              fontSize: 48,
              fontWeight: FontWeight.bold,
              color: _remaining <= 3 ? AppTheme.destructiveColor : AppTheme.primaryColor,
            ),
          ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          height: 8,
          decoration: BoxDecoration(
            color: AppTheme.cardColor,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: AppTheme.textSecondary.withOpacity(0.3)),
          ),
          child: AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return FractionallySizedBox(
                alignment: Alignment.centerLeft,
                widthFactor: _animation.value,
                child: Container(
                  decoration: BoxDecoration(
                    color: _remaining <= 3 ? AppTheme.destructiveColor : AppTheme.primaryColor,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class RoundManager {
  static int _currentRound = 1;
  static int _maxRounds = 3;
  static Map<String, int> _roundWins = {};

  static int get currentRound => _currentRound;
  static int get maxRounds => _maxRounds;
  static Map<String, int> get roundWins => _roundWins;

  static void setMaxRounds(int rounds) {
    _maxRounds = rounds;
  }

  static void startNewMatch() {
    _currentRound = 1;
    _roundWins.clear();
  }

  static void recordRoundWin(String playerName) {
    _roundWins[playerName] = (_roundWins[playerName] ?? 0) + 1;
  }

  static bool nextRound() {
    _currentRound++;
    return _currentRound <= _maxRounds;
  }

  static String? getMatchWinner() {
    if (_currentRound > _maxRounds) {
      final sortedWins = _roundWins.entries.toList()
        ..sort((a, b) => b.value.compareTo(a.value));

      if (sortedWins.isNotEmpty) {
        return sortedWins.first.key;
      }
    }
    return null;
  }

  static bool isMatchComplete() {
    return _currentRound > _maxRounds;
  }
}

class IOSCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;

  const IOSCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(horizontal: AppTheme.spacing),
      padding: padding ?? const EdgeInsets.all(AppTheme.spacing),
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }
}

class IOSTextField extends StatelessWidget {
  final String label;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final bool autofocus;

  const IOSTextField({
    super.key,
    required this.label,
    this.controller,
    this.onChanged,
    this.autofocus = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: Border.all(color: const Color(0xFFE5E5EA), width: 1),
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        autofocus: autofocus,
        style: AppTheme.bodyTextStyle,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: AppTheme.captionTextStyle,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.all(AppTheme.spacing),
        ),
      ),
    );
  }
}

enum ImageCategory {
  animals('Dyr', 'assets/images/animals/'),
  objects('Objekter', 'assets/images/objects/'),
  people('Personer', 'assets/images/people/'),
  similarPeople('Like personer', 'assets/images/similar_people/'),
  colors('Farger', 'assets/images/colors/'),
  custom('Egne bilder', '');

  const ImageCategory(this.displayName, this.assetPath);
  final String displayName;
  final String assetPath;
}

class CelebrityPair {
  final int pairId;
  final String description;
  final String sameImage;
  final String oddImage;
  final String sameName;
  final String oddName;

  CelebrityPair({
    required this.pairId,
    required this.description,
    required this.sameImage,
    required this.oddImage,
    required this.sameName,
    required this.oddName,
  });

  factory CelebrityPair.fromJson(Map<String, dynamic> json) {
    return CelebrityPair(
      pairId: json['pair_id'],
      description: json['description'],
      sameImage: json['same_image'] ?? '',
      oddImage: json['odd_image'] ?? '',
      sameName: json['same_name'],
      oddName: json['odd_name'],
    );
  }
}

class ImageManager {
  static const List<String> defaultImages = [
    'https://i.pravatar.cc/300?img=1',
    'https://i.pravatar.cc/300?img=2',
    'https://i.pravatar.cc/300?img=3',
    'https://i.pravatar.cc/300?img=4',
    'https://i.pravatar.cc/300?img=5',
  ];

  static final List<CelebrityPair> _celebrityPairs = [
    CelebrityPair(
      pairId: 1,
      description: 'Matt Damon vs Mark Wahlberg - often confused actors',
      sameImage: '',
      oddImage: '',
      sameName: 'Matt Damon',
      oddName: 'Mark Wahlberg',
    ),
    CelebrityPair(
      pairId: 2,
      description: 'Keira Knightley vs Natalie Portman - similar features',
      sameImage: '',
      oddImage: '',
      sameName: 'Keira Knightley',
      oddName: 'Natalie Portman',
    ),
    CelebrityPair(
      pairId: 3,
      description: 'Ryan Gosling vs Ryan Reynolds - the Ryan confusion',
      sameImage: '',
      oddImage: '',
      sameName: 'Ryan Gosling',
      oddName: 'Ryan Reynolds',
    ),
    CelebrityPair(
      pairId: 4,
      description: 'Zooey Deschanel vs Katy Perry - twin-like resemblance',
      sameImage: '',
      oddImage: '',
      sameName: 'Zooey Deschanel',
      oddName: 'Katy Perry',
    ),
    CelebrityPair(
      pairId: 5,
      description: 'Will Ferrell vs Chad Smith - comedian vs drummer twins',
      sameImage: '',
      oddImage: '',
      sameName: 'Will Ferrell',
      oddName: 'Chad Smith',
    ),
    CelebrityPair(
      pairId: 6,
      description: 'Emma Stone vs Lindsay Lohan - similar smile and eyes',
      sameImage: '',
      oddImage: '',
      sameName: 'Emma Stone',
      oddName: 'Lindsay Lohan',
    ),
    CelebrityPair(
      pairId: 7,
      description: 'Scarlett Johansson vs Amber Heard - blonde bombshells',
      sameImage: '',
      oddImage: '',
      sameName: 'Scarlett Johansson',
      oddName: 'Amber Heard',
    ),
    CelebrityPair(
      pairId: 8,
      description: 'Elijah Wood vs Daniel Radcliffe - big eyes, similar build',
      sameImage: '',
      oddImage: '',
      sameName: 'Elijah Wood',
      oddName: 'Daniel Radcliffe',
    ),
    CelebrityPair(
      pairId: 9,
      description: 'Jake Gyllenhaal vs Tobey Maguire - boyish features',
      sameImage: '',
      oddImage: '',
      sameName: 'Jake Gyllenhaal',
      oddName: 'Tobey Maguire',
    ),
    CelebrityPair(
      pairId: 10,
      description: 'Benedict Cumberbatch vs Adam Driver - distinctive features',
      sameImage: '',
      oddImage: '',
      sameName: 'Benedict Cumberbatch',
      oddName: 'Adam Driver',
    ),
  ];

  static List<String> _customImages = [];
  static ImageCategory _selectedCategory = ImageCategory.similarPeople;

  static ImageCategory get selectedCategory => _selectedCategory;
  static void setCategory(ImageCategory category) {
    _selectedCategory = category;
  }

  static Future<List<String>> getAvailableImages() async {
    switch (_selectedCategory) {
      case ImageCategory.similarPeople:
        // Return empty list since we're focusing on names only
        return [];
      case ImageCategory.custom:
        return _customImages.isNotEmpty ? _customImages : [];
      default:
        // For other categories, return default images
        return defaultImages;
    }
  }

  static Future<Map<String, String>> getCelebrityPair() async {
    if (_selectedCategory == ImageCategory.similarPeople && _celebrityPairs.isNotEmpty) {
      final selectedPair = _celebrityPairs[Random().nextInt(_celebrityPairs.length)];
      return {
        'same': selectedPair.sameImage,
        'odd': selectedPair.oddImage,
        'same_name': selectedPair.sameName,
        'odd_name': selectedPair.oddName,
        'description': selectedPair.description,
      };
    }
    // Fallback to random selection
    final images = await getAvailableImages();
    return {
      'same': images.isNotEmpty ? getRandomImage(images) : '',
      'odd': images.isNotEmpty ? getOddImage(images, getRandomImage(images)) : '',
      'same_name': 'Person A',
      'odd_name': 'Person B',
      'description': 'Random selection',
    };
  }

  static Future<void> addCustomImage(String imagePath) async {
    if (!_customImages.contains(imagePath)) {
      _customImages.add(imagePath);
    }
  }

  static List<String> getCustomImages() => _customImages;

  static void removeCustomImage(String imagePath) {
    _customImages.remove(imagePath);
  }

  static String getRandomImage(List<String> images) {
    if (images.isEmpty) return '';
    return images[Random().nextInt(images.length)];
  }

  static String getOddImage(List<String> images, String sameImage) {
    if (images.length < 2) return '';
    String oddImage;
    do {
      oddImage = images[Random().nextInt(images.length)];
    } while (oddImage == sameImage && images.length > 1);
    return oddImage;
  }

  static List<CelebrityPair> getCelebrityPairs() => _celebrityPairs;
}

class NetworkManager {
  static const int broadcastPort = 8888;
  static const int gamePort = 8889;
  UDP? _udp;
  ServerSocket? _serverSocket;
  Socket? _clientSocket;
  Timer? _broadcastTimer;
  final Function(Map<String, dynamic>) onMessageReceived;
  final Function(String) onPlayerJoined;
  final Function(String) onPlayerLeft;
  String? _localIP;

  NetworkManager({
    required this.onMessageReceived,
    required this.onPlayerJoined,
    required this.onPlayerLeft,
  });

  Future<void> initialize() async {
    try {
      _localIP = await NetworkInfo().getWifiIP();
      if (_localIP == null) {
        throw Exception('Could not get WiFi IP address');
      }
    } catch (e) {
      print('Network initialization error: $e');
      throw Exception('Network setup failed. Make sure you are connected to WiFi.');
    }
  }

  Future<void> startHosting(String gameCode) async {
    await _startBroadcasting(gameCode);
    await _startGameServer();
  }

  Future<void> _startBroadcasting(String gameCode) async {
    _udp = await UDP.bind(Endpoint.broadcast(port: Port(broadcastPort)));
    _broadcastTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_udp != null) {
        final message = jsonEncode({
          'type': 'game_broadcast',
          'code': gameCode,
          'host_ip': _localIP,
        });
        _udp!.send(message.codeUnits, Endpoint.broadcast(port: Port(broadcastPort)));
      } else {
        timer.cancel();
      }
    });
  }

  final List<Socket> _connectedClients = [];

  Future<void> _startGameServer() async {
    _serverSocket = await ServerSocket.bind(_localIP!, gamePort);
    _serverSocket!.listen((socket) {
      _connectedClients.add(socket);
      socket.listen(
        (data) {
          final message = String.fromCharCodes(data);
          try {
            final decoded = jsonDecode(message);
            onMessageReceived(decoded);
          } catch (e) {
            print('Error decoding message: $e');
          }
        },
        onDone: () {
          _connectedClients.remove(socket);
        },
        onError: (error) {
          print('Client socket error: $error');
          _connectedClients.remove(socket);
        },
      );
    });
  }

  Future<List<GameInfo>> discoverGames() async {
    final games = <GameInfo>[];
    final udp = await UDP.bind(Endpoint.loopback(port: Port(broadcastPort)));

    final completer = Completer<List<GameInfo>>();
    Timer(const Duration(seconds: 3), () {
      udp.close();
      completer.complete(games);
    });

    udp.asStream().listen((datagram) {
      try {
        final message = String.fromCharCodes(datagram!.data);
        final decoded = jsonDecode(message);
        if (decoded['type'] == 'game_broadcast') {
          final gameInfo = GameInfo(
            code: decoded['code'],
            hostIP: decoded['host_ip'],
          );
          if (!games.any((g) => g.code == gameInfo.code)) {
            games.add(gameInfo);
          }
        }
      } catch (e) {
        print('Error parsing broadcast: $e');
      }
    });

    return completer.future;
  }

  Future<void> joinGame(String hostIP) async {
    try {
      _clientSocket = await Socket.connect(hostIP, gamePort);
      _clientSocket!.listen((data) {
        final message = String.fromCharCodes(data);
        try {
          final decoded = jsonDecode(message);
          onMessageReceived(decoded);
        } catch (e) {
          print('Error decoding message: $e');
        }
      });
    } catch (e) {
      print('Error joining game: $e');
    }
  }

  void sendMessage(Map<String, dynamic> message) {
    final encoded = jsonEncode(message);
    if (_clientSocket != null) {
      try {
        _clientSocket!.add(encoded.codeUnits);
      } catch (e) {
        print('Error sending message to server: $e');
      }
    } else if (_serverSocket != null) {
      // Broadcast to all connected clients
      for (final client in _connectedClients.toList()) {
        try {
          client.add(encoded.codeUnits);
        } catch (e) {
          print('Error sending message to client: $e');
          _connectedClients.remove(client);
        }
      }
    }
  }

  void dispose() {
    _broadcastTimer?.cancel();
    _udp?.close();
    _serverSocket?.close();
    _clientSocket?.destroy();
    for (final client in _connectedClients) {
      client.destroy();
    }
    _connectedClients.clear();
  }
}

class GameInfo {
  final String code;
  final String hostIP;

  GameInfo({required this.code, required this.hostIP});
}

class RulesPage extends StatelessWidget {
  const RulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spillregler'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IOSCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                            Icons.psychology,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 16),
                        const Expanded(
                          child: Text(
                            'Hvordan spille',
                            style: AppTheme.titleTextStyle,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      'Mål:',
                      style: AppTheme.headlineTextStyle,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Finn ut hvem som har fått et annet navn enn resten av gruppen.',
                      style: AppTheme.bodyTextStyle,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              IOSCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Spillforløp:',
                      style: AppTheme.headlineTextStyle,
                    ),
                    const SizedBox(height: 16),
                    _buildStep('1', 'Alle får tildelt et navn', 'De fleste får det samme navnet, men én person får et annet navn.'),
                    _buildStep('2', 'Studer navnet ditt', 'Du har 10 sekunder til å se på navnet du har fått.'),
                    _buildStep('3', 'Stem på hvem som skiller seg ut', 'Når alle er klare, stem på hvem du tror har det "rare" navnet.'),
                    _buildStep('4', 'Se resultatet', 'Personen som får flest stemmer vinner!'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              IOSCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Tips:',
                      style: AppTheme.headlineTextStyle,
                    ),
                    const SizedBox(height: 16),
                    _buildTip('🎭', 'Hold pokerface', 'Ikke røp hvilket navn du har fått!'),
                    _buildTip('👁️', 'Observer andre', 'Se etter ansiktsuttrykk og reaksjoner.'),
                    _buildTip('🤔', 'Tenk logisk', 'Hvem oppfører seg annerledes?'),
                    _buildTip('⏰', 'Vær rask', 'Du har begrenset tid til å bestemme deg.'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              IOSButton(
                text: 'Forstått!',
                onPressed: () => Navigator.of(context).pop(),
                isPrimary: true,
                isLarge: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStep(String number, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: AppTheme.primaryColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                number,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.bodyTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTheme.captionTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTip(String emoji, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            emoji,
            style: const TextStyle(fontSize: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTheme.bodyTextStyle.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: AppTheme.captionTextStyle,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class Game extends ChangeNotifier {
  final String code;
  final String hostName;
  final List<String> players;
  int? oddPlayerIndex;
  bool started = false;
  bool isHost;
  NetworkManager? networkManager;
  String? sameImage;
  String? oddImage;
  String? sameName;
  String? oddName;
  ImageCategory imageCategory = ImageCategory.similarPeople;

  final Set<String> readyPlayers = {};
  bool votingStarted = false;
  final Map<String, String> votes = {};
  String? voteResult;

  Game({required this.code, required this.hostName, this.isHost = false}) : players = [hostName] {
    if (isHost) {
      _initializeNetworking();
    }
  }

  void _initializeNetworking() {
    networkManager = NetworkManager(
      onMessageReceived: _handleNetworkMessage,
      onPlayerJoined: (player) {
        if (!players.contains(player)) {
          players.add(player);
          notifyListeners();
        }
      },
      onPlayerLeft: (player) {
        players.remove(player);
        // Reset game if too few players
        if (players.length < 2 && started) {
          _resetGame();
        }
        notifyListeners();
      },
    );
    networkManager!.initialize().then((_) {
      networkManager!.startHosting(code);
    }).catchError((error) {
      print('Network initialization failed: $error');
      // Could show error dialog to user here
    });
  }

  void _resetGame() {
    started = false;
    votingStarted = false;
    readyPlayers.clear();
    votes.clear();
    voteResult = null;
    oddPlayerIndex = null;
  }

  void _handleNetworkMessage(Map<String, dynamic> message) {
    switch (message['type']) {
      case 'player_joined':
        addPlayer(message['player_name']);
        break;
      case 'game_started':
        oddPlayerIndex = message['odd_player_index'];
        sameImage = message['same_image'];
        oddImage = message['odd_image'];
        sameName = message['same_name'];
        oddName = message['odd_name'];
        if (message['image_category'] != null) {
          imageCategory = ImageCategory.values.firstWhere(
            (cat) => cat.name == message['image_category'],
            orElse: () => ImageCategory.people,
          );
        }
        started = true;
        readyPlayers.clear();
        votes.clear();
        votingStarted = false;
        voteResult = null;
        notifyListeners();
        break;
      case 'player_ready':
        readyPlayers.add(message['player']);
        if (message['voting_started'] == true) {
          votingStarted = true;
        }
        notifyListeners();
        break;
      case 'player_vote':
        votes[message['voter']] = message['votee'];
        if (message['vote_result'] != null) {
          voteResult = message['vote_result'];
        }
        notifyListeners();
        break;
    }
  }

  void broadcastMessage(Map<String, dynamic> message) {
    networkManager?.sendMessage(message);
  }

  void addPlayer(String name) {
    if (!players.contains(name)) {
      players.add(name);
      if (isHost) {
        broadcastMessage({
          'type': 'player_joined',
          'player_name': name,
          'players': players,
        });
      }
      notifyListeners();
    }
  }

  Future<void> startGame() async {
    if (isHost) {
      oddPlayerIndex = Random().nextInt(players.length);

      // Generate names for this game session
      if (imageCategory == ImageCategory.similarPeople) {
        final celebrityPair = await ImageManager.getCelebrityPair();
        sameImage = celebrityPair['same']!;
        oddImage = celebrityPair['odd']!;
        sameName = celebrityPair['same_name']!;
        oddName = celebrityPair['odd_name']!;
      } else {
        final availableImages = await ImageManager.getAvailableImages();
        sameImage = availableImages.isNotEmpty ? ImageManager.getRandomImage(availableImages) : '';
        oddImage = availableImages.isNotEmpty ? ImageManager.getOddImage(availableImages, sameImage!) : '';
        sameName = 'Person A';
        oddName = 'Person B';
      }

      started = true;
      readyPlayers.clear();
      votes.clear();
      votingStarted = false;
      voteResult = null;
      broadcastMessage({
        'type': 'game_started',
        'odd_player_index': oddPlayerIndex,
        'same_image': sameImage,
        'odd_image': oddImage,
        'same_name': sameName,
        'odd_name': oddName,
        'image_category': imageCategory.name,
      });
      notifyListeners();
    }
  }

  void readyToVote(String player) {
    if (!readyPlayers.contains(player)) {
      readyPlayers.add(player);
      if (readyPlayers.length == players.length) {
        votingStarted = true;
      }
      if (isHost) {
        broadcastMessage({
          'type': 'player_ready',
          'player': player,
          'voting_started': votingStarted,
        });
      }
      notifyListeners();
    }
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
    if (isHost) {
      broadcastMessage({
        'type': 'player_vote',
        'voter': voter,
        'votee': votee,
        'vote_result': voteResult,
      });
    }
    notifyListeners();
  }

  void dispose() {
    networkManager?.dispose();
    super.dispose();
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
  bool _gameLoaded = false;
  late final bool _isOdd;

  @override
  void initState() {
    super.initState();
    _isOdd = widget.game.players.indexOf(widget.playerName) ==
        widget.game.oddPlayerIndex;

    // Mark game as loaded after a short delay
    Timer(const Duration(milliseconds: 500), () {
      if (mounted) {
        setState(() {
          _gameLoaded = true;
        });
      }
    });

    Timer(const Duration(seconds: 10), () {
      if (mounted) {
        setState(() {
          _showVoteButton = true;
        });
      }
    });
  }

  Widget _buildGameContent() {
    // Show the name that the player should see
    final displayName = _isOdd
        ? (widget.game.oddName ?? 'Person B')
        : (widget.game.sameName ?? 'Person A');

    return Container(
      width: double.infinity,
      height: 250,
      decoration: BoxDecoration(
        color: AppTheme.cardColor,
        border: Border.all(
          color: _isOdd ? AppTheme.destructiveColor : AppTheme.successColor,
          width: 3,
        ),
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person,
            size: 80,
            color: _isOdd ? AppTheme.destructiveColor : AppTheme.successColor,
          ),
          const SizedBox(height: 16),
          Text(
            displayName,
            style: AppTheme.titleTextStyle.copyWith(
              color: _isOdd ? AppTheme.destructiveColor : AppTheme.successColor,
              fontSize: 24,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
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
    );
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
                  Text(
                    'Venter på: ${widget.game.players.where((player) => !widget.game.votes.containsKey(player)).join(', ')}',
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
                  Text(
                    'Venter på: ${widget.game.players.where((player) => !widget.game.readyPlayers.contains(player)).join(', ')}',
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
                    'Studer informasjonen',
                    style: AppTheme.headlineTextStyle,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Se på informasjonen og forbered deg på å stemme',
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
                    'Studerer informasjonen...',
                    style: AppTheme.headlineTextStyle,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Se nøye på informasjonen. Stemmeknappen kommer snart.',
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
                    child: _buildGameContent(),
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

class ImageSettingsPage extends StatefulWidget {
  final Game game;

  const ImageSettingsPage({super.key, required this.game});

  @override
  State<ImageSettingsPage> createState() => _ImageSettingsPageState();
}

class _ImageSettingsPageState extends State<ImageSettingsPage> {
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spillinnstillinger'),
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppTheme.spacing),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              IOSCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Spillkategori',
                      style: AppTheme.headlineTextStyle,
                    ),
                    const SizedBox(height: 16),
                    ...ImageCategory.values.map((category) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: IOSButton(
                          text: category.displayName,
                          onPressed: () {
                            setState(() {
                              widget.game.imageCategory = category;
                              ImageManager.setCategory(category);
                            });
                          },
                          isPrimary: widget.game.imageCategory == category,
                          isLarge: true,
                        ),
                      );
                    }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              if (widget.game.imageCategory == ImageCategory.similarPeople) ...[
                IOSCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Eksempel på kjendispar',
                        style: AppTheme.headlineTextStyle,
                      ),
                      const SizedBox(height: 16),
                      Container(
                        height: 120,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: ImageManager.getCelebrityPairs().length,
                          itemBuilder: (context, index) {
                            final pair = ImageManager.getCelebrityPairs()[index];
                            return Container(
                              width: 140,
                              margin: const EdgeInsets.only(right: 12),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 45,
                                              decoration: BoxDecoration(
                                                color: AppTheme.successColor.withOpacity(0.1),
                                                border: Border.all(color: AppTheme.successColor, width: 2),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.person,
                                                  color: AppTheme.successColor,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              pair.sameName,
                                              style: AppTheme.captionTextStyle.copyWith(
                                                fontSize: 8,
                                                color: AppTheme.successColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 3),
                                      Expanded(
                                        child: Column(
                                          children: [
                                            Container(
                                              height: 45,
                                              decoration: BoxDecoration(
                                                color: AppTheme.destructiveColor.withOpacity(0.1),
                                                border: Border.all(color: AppTheme.destructiveColor, width: 2),
                                                borderRadius: BorderRadius.circular(6),
                                              ),
                                              child: Center(
                                                child: Icon(
                                                  Icons.person,
                                                  color: AppTheme.destructiveColor,
                                                  size: 20,
                                                ),
                                              ),
                                            ),
                                            const SizedBox(height: 2),
                                            Text(
                                              pair.oddName,
                                              style: AppTheme.captionTextStyle.copyWith(
                                                fontSize: 8,
                                                color: AppTheme.destructiveColor,
                                                fontWeight: FontWeight.w600,
                                              ),
                                              textAlign: TextAlign.center,
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    pair.description,
                                    style: AppTheme.captionTextStyle.copyWith(fontSize: 9),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.successColor, width: 2),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text('Gruppeperson', style: AppTheme.captionTextStyle),
                          const SizedBox(width: 16),
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              border: Border.all(color: AppTheme.destructiveColor, width: 2),
                              borderRadius: BorderRadius.circular(3),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text('«Odd one out»', style: AppTheme.captionTextStyle),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
              ],
              IOSCard(
                child: Column(
                  children: [
                    const Icon(
                      Icons.info_outline,
                      color: AppTheme.primaryColor,
                      size: 32,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Hvordan det fungerer',
                      style: AppTheme.headlineTextStyle,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.game.imageCategory == ImageCategory.similarPeople
                          ? 'Spillet velger tilfeldig et par med lignende kjendiser. Alle får samme navn, unntatt én som får det andre navnet fra paret.'
                          : 'Spillet velger tilfeldig navn fra den valgte kategorien. Én spiller får et annet navn enn resten.',
                      style: AppTheme.bodyTextStyle,
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _addCustomImage() async {
    try {
      final XFile? image = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );

      if (image != null) {
        await ImageManager.addCustomImage(image.path);
        setState(() {});
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Kunne ikke legge til bilde'),
          ),
        );
      }
    }
  }
}

Game? currentGame;
List<GameInfo> availableGames = [];

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize systems
  await ScoreManager.loadScores();

  // Load saved preferences
  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('dark_mode') ?? false;
  final soundEnabled = prefs.getBool('sound_enabled') ?? true;

  AppTheme.setDarkMode(isDarkMode);
  SoundManager.setSoundEnabled(soundEnabled);

  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    // Set preferred orientations (portrait and landscape)
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Out of Sync',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppTheme.backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: AppTheme.backgroundColor,
          foregroundColor: AppTheme.textPrimary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppTheme.headlineTextStyle,
        ),
        brightness: AppTheme.isDarkMode ? Brightness.dark : Brightness.light,
      ),
      darkTheme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppTheme.backgroundColor,
        appBarTheme: AppBarTheme(
          backgroundColor: AppTheme.backgroundColor,
          foregroundColor: AppTheme.textPrimary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppTheme.headlineTextStyle,
        ),
        brightness: Brightness.dark,
      ),
      themeMode: AppTheme.isDarkMode ? ThemeMode.dark : ThemeMode.light,
      home: const HomePage(),
    );
  }

  @override
  void dispose() {
    SoundManager.dispose();
    super.dispose();
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

  void _createGame() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showMessage('Skriv inn navn for å lage spillet');
      return;
    }
    if (name.length > 20) {
      _showMessage('Navnet er for langt (maks 20 tegn)');
      return;
    }

    try {
      final code = _generateCode();
      currentGame = Game(code: code, hostName: name, isHost: true);

      // Wait a bit to ensure network setup
      await Future.delayed(const Duration(milliseconds: 500));

      if (!mounted) return;

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
    } catch (e) {
      _showMessage('Kunne ikke opprette spill. Sjekk WiFi-forbindelsen.');
      print('Game creation error: $e');
    }
  }

  Future<void> _joinGame() async {
    final name = _nameController.text.trim();
    if (name.isEmpty) {
      _showMessage('Skriv inn navn for å bli med i spillet');
      return;
    }
    if (name.length > 20) {
      _showMessage('Navnet er for langt (maks 20 tegn)');
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
                      const SizedBox(height: 12),
                      IOSButton(
                        text: 'Innstillinger',
                        onPressed: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (_) => const SettingsPage(),
                            ),
                          );
                        },
                        isLarge: true,
                      ),
                      const SizedBox(height: 12),
                      IOSButton(
                        text: 'Statistikk',
                        onPressed: () {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (_) => const StatsPage(),
                            ),
                          );
                        },
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

class LobbyPage extends StatefulWidget {
  final Game game;
  final String playerName;

  const LobbyPage({super.key, required this.game, required this.playerName});

  @override
  State<LobbyPage> createState() => _LobbyPageState();
}

class _LobbyPageState extends State<LobbyPage> with WidgetsBindingObserver {
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    // Ensure network connection is active
    _ensureNetworkConnection();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // App came back to foreground, ensure connection
      _ensureNetworkConnection();
    }
  }

  void _ensureNetworkConnection() {
    if (widget.game.isHost && widget.game.networkManager == null) {
      // Host lost connection, reinitialize
      widget.game._initializeNetworking();
    }
  }

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
                            Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: widget.game.networkManager != null ? AppTheme.successColor : AppTheme.warningColor,
                                borderRadius: BorderRadius.circular(6),
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
                      text: 'Spillinnstillinger',
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
                      text: 'Spillregler',
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => RulesPage(),
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
                  if (!isHost) ...[
                    IOSButton(
                      text: 'Spillregler',
                      onPressed: () {
                        Navigator.of(context).push(
                          CupertinoPageRoute(
                            builder: (_) => RulesPage(),
                          ),
                        );
                      },
                      isLarge: true,
                    ),
                    const SizedBox(height: 12),
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
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Innstillinger'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(
            CupertinoIcons.back,
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
                    _buildSettingToggle(
                      'Mørk modus',
                      'Bruk mørkt tema',
                      AppTheme.isDarkMode,
                      (value) async {
                        setState(() {
                          AppTheme.setDarkMode(value);
                        });
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('dark_mode', value);
                        // Force rebuild of main app
                        if (mounted) {
                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => const MainApp()),
                          );
                        }
                      },
                    ),
                    const Divider(),
                    _buildSettingToggle(
                      'Lydeffekter',
                      'Spill av lyder for handlinger',
                      SoundManager.soundEnabled,
                      (value) async {
                        setState(() {
                          SoundManager.setSoundEnabled(value);
                        });
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('sound_enabled', value);
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              IOSCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Om appen',
                      style: AppTheme.headlineTextStyle,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Out of Sync v2.0\nEt sosialt spill der målet er å finne ut hvem som skiller seg ut.',
                      style: AppTheme.bodyTextStyle,
                    ),
                    const SizedBox(height: 16),
                    IOSButton(
                      text: 'Nullstill statistikk',
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => CupertinoAlertDialog(
                            title: const Text('Nullstill statistikk'),
                            content: const Text('Er du sikker på at du vil slette all statistikk?'),
                            actions: [
                              CupertinoDialogAction(
                                onPressed: () => Navigator.pop(context, false),
                                child: const Text('Avbryt'),
                              ),
                              CupertinoDialogAction(
                                onPressed: () => Navigator.pop(context, true),
                                isDestructiveAction: true,
                                child: const Text('Nullstill'),
                              ),
                            ],
                          ),
                        );

                        if (confirmed == true) {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.remove('player_scores');
                          ScoreManager.scores.clear();
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Statistikk nullstilt')),
                            );
                          }
                        }
                      },
                      isDestructive: true,
                      isLarge: true,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingToggle(
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppTheme.bodyTextStyle),
              Text(subtitle, style: AppTheme.captionTextStyle),
            ],
          ),
        ),
        CupertinoSwitch(
          value: value,
          onChanged: onChanged,
          activeColor: AppTheme.primaryColor,
        ),
      ],
    );
  }
}

class StatsPage extends StatelessWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistikk'),
        leading: CupertinoButton(
          padding: EdgeInsets.zero,
          onPressed: () => Navigator.of(context).pop(),
          child: Icon(
            CupertinoIcons.back,
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
              if (ScoreManager.scores.isEmpty)
                IOSCard(
                  child: Column(
                    children: [
                      Icon(
                        Icons.bar_chart,
                        size: 64,
                        color: AppTheme.textSecondary,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Ingen statistikk ennå',
                        style: AppTheme.headlineTextStyle,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Spill ditt første spill for å se statistikk her',
                        style: AppTheme.captionTextStyle,
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                )
              else
                ...ScoreManager.scores.entries.map((entry) {
                  final score = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: IOSCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: AppTheme.primaryColor,
                                radius: 24,
                                child: Text(
                                  score.playerName[0].toUpperCase(),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      score.playerName,
                                      style: AppTheme.headlineTextStyle,
                                    ),
                                    Text(
                                      '${score.gamesPlayed} spill spilt',
                                      style: AppTheme.captionTextStyle,
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppTheme.successColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${(score.winRate * 100).toInt()}%',
                                  style: TextStyle(
                                    color: AppTheme.successColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Row(
                            children: [
                              _buildStatItem('Seire', '${score.wins}', AppTheme.successColor),
                              _buildStatItem('Tap', '${score.losses}', AppTheme.destructiveColor),
                              _buildStatItem('Utmerkelser', '${score.achievements.length}', AppTheme.warningColor),
                            ],
                          ),
                          if (score.achievements.isNotEmpty) ...[
                            const SizedBox(height: 16),
                            Text(
                              'Utmerkelser:',
                              style: AppTheme.bodyTextStyle.copyWith(fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: score.achievements.map((achievement) {
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppTheme.warningColor.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(color: AppTheme.warningColor),
                                  ),
                                  child: Text(
                                    achievement,
                                    style: TextStyle(
                                      color: AppTheme.warningColor,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  );
                }),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value, Color color) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: AppTheme.captionTextStyle,
          ),
        ],
      ),
    );
  }
}