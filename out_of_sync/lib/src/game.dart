part of '../main.dart';

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
