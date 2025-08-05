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

class AppTheme {
  static const primaryColor = Color(0xFF007AFF);
  static const secondaryColor = Color(0xFF5856D6);
  static const backgroundColor = Color(0xFFF2F2F7);
  static const cardColor = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF000000);
  static const textSecondary = Color(0xFF8E8E93);
  static const destructiveColor = Color(0xFFFF3B30);
  static const successColor = Color(0xFF34C759);
  static const warningColor = Color(0xFFFF9500);
  
  static const borderRadius = 12.0;
  static const cardElevation = 0.0;
  static const spacing = 16.0;
  
  static const titleTextStyle = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: textPrimary,
  );
  
  static const headlineTextStyle = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: textPrimary,
  );
  
  static const bodyTextStyle = TextStyle(
    fontSize: 17,
    fontWeight: FontWeight.normal,
    color: textPrimary,
  );
  
  static const captionTextStyle = TextStyle(
    fontSize: 15,
    fontWeight: FontWeight.normal,
    color: textSecondary,
  );
}

class IOSButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final bool isPrimary;
  final bool isDestructive;
  final bool isLarge;
  
  const IOSButton({
    super.key,
    required this.text,
    this.onPressed,
    this.isPrimary = false,
    this.isDestructive = false,
    this.isLarge = false,
  });
  
  @override
  Widget build(BuildContext context) {
    Color backgroundColor;
    Color textColor;
    
    if (isDestructive) {
      backgroundColor = AppTheme.destructiveColor;
      textColor = Colors.white;
    } else if (isPrimary) {
      backgroundColor = AppTheme.primaryColor;
      textColor = Colors.white;
    } else {
      backgroundColor = AppTheme.cardColor;
      textColor = AppTheme.primaryColor;
    }
    
    return Container(
      width: isLarge ? double.infinity : null,
      height: isLarge ? 56 : 44,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius),
        border: !isPrimary && !isDestructive 
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
          onTap: onPressed,
          borderRadius: BorderRadius.circular(AppTheme.borderRadius),
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
          ),
        ),
      ),
    );
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
      sameImage: json['same_image'],
      oddImage: json['odd_image'],
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
      description: 'Norske TV-profiler - lignende ansiktstrekk',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/4c/Fredrik_Solvang_2019.jpg/300px-Fredrik_Solvang_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1f/Daniel_Choi_2020.jpg/300px-Daniel_Choi_2020.jpg',
      sameName: 'Fredrik Solvang',
      oddName: 'Daniel Choi',
    ),
    CelebrityPair(
      pairId: 2,
      description: 'Hollywood skuespillere - lignende profil',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/3/3c/Matt_Damon_2019.jpg/300px-Matt_Damon_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f6/Mark_Wahlberg_2018.jpg/300px-Mark_Wahlberg_2018.jpg',
      sameName: 'Matt Damon',
      oddName: 'Mark Wahlberg',
    ),
    CelebrityPair(
      pairId: 3,
      description: 'Blonde skuespillerinner - samme hårfarge',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/28/Scarlett_Johansson_2019.jpg/300px-Scarlett_Johansson_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8d/Charlize_Theron_2019.jpg/300px-Charlize_Theron_2019.jpg',
      sameName: 'Scarlett Johansson',
      oddName: 'Charlize Theron',
    ),
    CelebrityPair(
      pairId: 4,
      description: 'Britiske skuespillere - same stil',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a7/Benedict_Cumberbatch_2019.jpg/300px-Benedict_Cumberbatch_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f0/Tom_Hiddleston_2019.jpg/300px-Tom_Hiddleston_2019.jpg',
      sameName: 'Benedict Cumberbatch',
      oddName: 'Tom Hiddleston',
    ),
    CelebrityPair(
      pairId: 5,
      description: 'Amerikanske komikere - lignende utseende',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/7/7a/Will_Ferrell_2019.jpg/300px-Will_Ferrell_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c2/Steve_Carell_2019.jpg/300px-Steve_Carell_2019.jpg',
      sameName: 'Will Ferrell',
      oddName: 'Steve Carell',
    ),
    CelebrityPair(
      pairId: 6,
      description: 'Marvel-skuespillere - helteansikt',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/25/Chris_Evans_2019.jpg/300px-Chris_Evans_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Chris_Hemsworth_2019.jpg/300px-Chris_Hemsworth_2019.jpg',
      sameName: 'Chris Evans',
      oddName: 'Chris Hemsworth',
    ),
    CelebrityPair(
      pairId: 7,
      description: 'Actionstjerner - tøffe uttrykk',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/50/Dwayne_Johnson_2019.jpg/300px-Dwayne_Johnson_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/ab/Vin_Diesel_2019.jpg/300px-Vin_Diesel_2019.jpg',
      sameName: 'Dwayne Johnson',
      oddName: 'Vin Diesel',
    ),
    CelebrityPair(
      pairId: 8,
      description: 'Pop-artister - unge stjerner',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f4/Justin_Bieber_2019.jpg/300px-Justin_Bieber_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/c/c1/Shawn_Mendes_2019.jpg/300px-Shawn_Mendes_2019.jpg',
      sameName: 'Justin Bieber',
      oddName: 'Shawn Mendes',
    ),
    CelebrityPair(
      pairId: 9,
      description: 'Kvinnelige sangere - kraftige stemmer',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/5/52/Adele_2019.jpg/300px-Adele_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/8/8b/Amy_Winehouse_2007.jpg/300px-Amy_Winehouse_2007.jpg',
      sameName: 'Adele',
      oddName: 'Amy Winehouse',
    ),
    CelebrityPair(
      pairId: 10,
      description: 'Norske artister - folkemusikk',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a9/Ari_Behn_2015.jpg/300px-Ari_Behn_2015.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b4/Lars_Winnerbäck_2018.jpg/300px-Lars_Winnerbäck_2018.jpg',
      sameName: 'Ari Behn',
      oddName: 'Lars Winnerbäck',
    ),
    CelebrityPair(
      pairId: 11,
      description: 'Fotballspillere - norske helter',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f3/Martin_Ødegaard_2021.jpg/300px-Martin_Ødegaard_2021.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/a/a1/Erling_Haaland_2021.jpg/300px-Erling_Haaland_2021.jpg',
      sameName: 'Martin Ødegaard',
      oddName: 'Erling Haaland',
    ),
    CelebrityPair(
      pairId: 12,
      description: 'Norske skuespillere - kjente ansikter',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d8/Aksel_Hennie_2019.jpg/300px-Aksel_Hennie_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/2/2f/Nikolaj_Coster-Waldau_2019.jpg/300px-Nikolaj_Coster-Waldau_2019.jpg',
      sameName: 'Aksel Hennie',
      oddName: 'Nikolaj Coster-Waldau',
    ),
    CelebrityPair(
      pairId: 13,
      description: 'Kvinnelige komikere - morsomme damer',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0a/Amy_Poehler_2019.jpg/300px-Amy_Poehler_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/fb/Tina_Fey_2019.jpg/300px-Tina_Fey_2019.jpg',
      sameName: 'Amy Poehler',
      oddName: 'Tina Fey',
    ),
    CelebrityPair(
      pairId: 14,
      description: 'Regissører - filmskapere',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0c/Steven_Spielberg_2018.jpg/300px-Steven_Spielberg_2018.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/f/f5/George_Lucas_2019.jpg/300px-George_Lucas_2019.jpg',
      sameName: 'Steven Spielberg',
      oddName: 'George Lucas',
    ),
    CelebrityPair(
      pairId: 15,
      description: 'Tech-gründere - teknologiledere',
      sameImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/18/Mark_Zuckerberg_2019.jpg/300px-Mark_Zuckerberg_2019.jpg',
      oddImage: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/49/Elon_Musk_2015.jpg/300px-Elon_Musk_2015.jpg',
      sameName: 'Mark Zuckerberg',
      oddName: 'Elon Musk',
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
        // Return all images from similar pairs for random selection
        final List<String> allImages = [];
        for (final pair in _celebrityPairs) {
          allImages.add(pair.sameImage);
          allImages.add(pair.oddImage);
        }
        return allImages;
      case ImageCategory.custom:
        return _customImages.isNotEmpty ? _customImages : defaultImages;
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
      'same': getRandomImage(images),
      'odd': getOddImage(images, getRandomImage(images)),
      'same_name': 'Ukjent',
      'odd_name': 'Ukjent',
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
    if (images.isEmpty) return defaultImages.first;
    return images[Random().nextInt(images.length)];
  }

  static String getOddImage(List<String> images, String sameImage) {
    if (images.length < 2) return defaultImages.last;
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
    _localIP = await NetworkInfo().getWifiIP();
  }

  Future<void> startHosting(String gameCode) async {
    await _startBroadcasting(gameCode);
    await _startGameServer();
  }

  Future<void> _startBroadcasting(String gameCode) async {
    _udp = await UDP.bind(Endpoint.broadcast(port: Port(broadcastPort)));
    Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_udp != null) {
        final message = jsonEncode({
          'type': 'game_broadcast',
          'code': gameCode,
          'host_ip': _localIP,
        });
        _udp!.send(message.codeUnits, Endpoint.broadcast(port: Port(broadcastPort)));
      }
    });
  }

  Future<void> _startGameServer() async {
    _serverSocket = await ServerSocket.bind(_localIP!, gamePort);
    _serverSocket!.listen((socket) {
      socket.listen((data) {
        final message = String.fromCharCodes(data);
        try {
          final decoded = jsonDecode(message);
          onMessageReceived(decoded);
        } catch (e) {
          print('Error decoding message: $e');
        }
      });
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
      _clientSocket!.add(encoded.codeUnits);
    } else if (_serverSocket != null) {
      // Broadcast to all connected clients (simplified)
    }
  }

  void dispose() {
    _udp?.close();
    _serverSocket?.close();
    _clientSocket?.destroy();
  }
}

class GameInfo {
  final String code;
  final String hostIP;

  GameInfo({required this.code, required this.hostIP});
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
        players.add(player);
        notifyListeners();
      },
      onPlayerLeft: (player) {
        players.remove(player);
        notifyListeners();
      },
    );
    networkManager!.initialize().then((_) {
      networkManager!.startHosting(code);
    });
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
        readyToVote(message['player']);
        break;
      case 'player_vote':
        vote(message['voter'], message['votee']);
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
      
      // Generate images for this game session
      if (imageCategory == ImageCategory.similarPeople) {
        final celebrityPair = await ImageManager.getCelebrityPair();
        sameImage = celebrityPair['same']!;
        oddImage = celebrityPair['odd']!;
        sameName = celebrityPair['same_name']!;
        oddName = celebrityPair['odd_name']!;
      } else {
        final availableImages = await ImageManager.getAvailableImages();
        sameImage = ImageManager.getRandomImage(availableImages);
        oddImage = ImageManager.getOddImage(availableImages, sameImage!);
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
  late final bool _isOdd;

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
        title: const Text('Bildeinnstillinger'),
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
                      'Bildekategori',
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
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(6),
                                              child: Container(
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: AppTheme.successColor, width: 2),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Image.network(
                                                  pair.sameImage,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      color: AppTheme.backgroundColor,
                                                      child: const Icon(Icons.person, color: AppTheme.textSecondary, size: 16),
                                                    );
                                                  },
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
                                            ClipRRect(
                                              borderRadius: BorderRadius.circular(6),
                                              child: Container(
                                                height: 45,
                                                decoration: BoxDecoration(
                                                  border: Border.all(color: AppTheme.destructiveColor, width: 2),
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Image.network(
                                                  pair.oddImage,
                                                  fit: BoxFit.cover,
                                                  errorBuilder: (context, error, stackTrace) {
                                                    return Container(
                                                      color: AppTheme.backgroundColor,
                                                      child: const Icon(Icons.person, color: AppTheme.textSecondary, size: 16),
                                                    );
                                                  },
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
                          const Text('Gruppebilde', style: AppTheme.captionTextStyle),
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
              if (widget.game.imageCategory == ImageCategory.custom) ...[
                IOSCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Egne bilder',
                            style: AppTheme.headlineTextStyle,
                          ),
                          CupertinoButton(
                            padding: EdgeInsets.zero,
                            onPressed: _addCustomImage,
                            child: const Icon(
                              CupertinoIcons.add_circled,
                              color: AppTheme.primaryColor,
                              size: 28,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (ImageManager.getCustomImages().isEmpty)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: AppTheme.backgroundColor,
                            borderRadius: BorderRadius.circular(AppTheme.borderRadius),
                            border: Border.all(
                              color: AppTheme.textSecondary.withOpacity(0.3),
                              style: BorderStyle.solid,
                            ),
                          ),
                          child: const Column(
                            children: [
                              Icon(
                                Icons.photo_library_outlined,
                                size: 48,
                                color: AppTheme.textSecondary,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Ingen bilder lagt til ennå',
                                style: AppTheme.captionTextStyle,
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Trykk på + for å legge til bilder',
                                style: AppTheme.captionTextStyle,
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                      else
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                          itemCount: ImageManager.getCustomImages().length,
                          itemBuilder: (context, index) {
                            final imagePath = ImageManager.getCustomImages()[index];
                            return Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.file(
                                    File(imagePath),
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                  ),
                                ),
                                Positioned(
                                  top: 4,
                                  right: 4,
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        ImageManager.removeCustomImage(imagePath);
                                      });
                                    },
                                    child: Container(
                                      width: 24,
                                      height: 24,
                                      decoration: const BoxDecoration(
                                        color: AppTheme.destructiveColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.close,
                                        color: Colors.white,
                                        size: 16,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
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
                          ? 'Spillet velger tilfeldig et par med like personer. Alle får samme bilde, unntatt én som får det andre bildet fra paret.'
                          : 'Spillet velger tilfeldig bilder fra den valgte kategorien. Én spiller får et annet bilde enn resten.',
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

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Out of Sync',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        scaffoldBackgroundColor: AppTheme.backgroundColor,
        appBarTheme: const AppBarTheme(
          backgroundColor: AppTheme.backgroundColor,
          foregroundColor: AppTheme.textPrimary,
          elevation: 0,
          centerTitle: true,
          titleTextStyle: AppTheme.headlineTextStyle,
        ),
      ),
      home: const HomePage(),
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

